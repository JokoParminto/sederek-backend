import type { Pool, PoolClient } from "pg";
import { AppError } from "../middleware/errorHandler";

export type PricingDatabase = Pool | PoolClient;
export type PricingDiscountType = "amount" | "percentage";

export interface PricingAddOnInput {
  addOnId: string;
  quantity?: number;
}

export interface PricingItemInput {
  client_line_id?: string;
  lineId?: string;
  product_id: string;
  quantity: number;
  discount_amount?: number;
  discount_type?: PricingDiscountType;
  notes?: string;
  addOns?: PricingAddOnInput[];
}

export interface MemberPricingQuoteRequest {
  customer_id?: string | null;
  items: PricingItemInput[];
  discount_global?: number;
  discount_global_type?: PricingDiscountType;
}

export interface QuotedAddOn {
  addOnId: string;
  addOnName: string;
  quantity: number;
  price: number;
  subtotal: number;
}

export interface QuotedPricingItem {
  client_line_id: string | null;
  product_id: string;
  product_name: string;
  category_name: string | null;
  quantity: number;
  original_unit_price: number;
  member_unit_price: number | null;
  member_priced_quantity: number;
  regular_quantity: number;
  effective_unit_price: number;
  product_subtotal: number;
  add_ons_subtotal: number;
  gross_subtotal: number;
  discount_amount: number;
  discount_type: PricingDiscountType;
  calculated_discount: number;
  total: number;
  is_member_price: boolean;
  member_savings: number;
  member_rule_id: string | null;
  member_rule_label: string | null;
  notes?: string;
  addOns: QuotedAddOn[];
}

export interface MemberPricingQuote {
  customer_id: string | null;
  customer_is_member: boolean;
  member_type: "umum" | "akamsi" | "vip" | null;
  quota: {
    daily_limit: number | null;
    used_before: number;
    allocated: number;
    remaining_after: number | null;
  };
  items: QuotedPricingItem[];
  gross_subtotal: number;
  discount_items: number;
  subtotal_after_item_discounts: number;
  discount_global_value: number;
  discount_global_type: PricingDiscountType;
  discount_global_amount: number;
  total_member_savings: number;
  total: number;
}

interface ProductRow {
  id: string;
  name: string;
  price: string | number;
  stock: string | number;
  status: string;
  category_name: string | null;
}

interface RuleRow {
  id: string;
  label: string;
  rule_type: "amount" | "percentage" | "discount_amount" | "fixed_price";
  scope: "all" | "non_food" | "specific";
  min_price: string | number | null;
  discount_amount: string | number | null;
  fixed_price: string | number | null;
  product_ids: string[] | null;
}

const asNumber = (value: unknown, fallback = 0): number => {
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed : fallback;
};

const calculateDiscount = (
  base: number,
  value: number,
  type: PricingDiscountType,
): number => {
  if (value < 0) {
    throw new AppError("VALIDATION_ERROR", "Diskon tidak boleh negatif", 400);
  }
  if (type === "percentage" && value > 100) {
    throw new AppError("VALIDATION_ERROR", "Diskon persentase maksimal 100%", 400);
  }

  const amount = type === "percentage"
    ? Math.round((base * value) / 100)
    : Math.round(value);

  if (amount > base) {
    throw new AppError("VALIDATION_ERROR", "Diskon melebihi nominal item", 400);
  }
  return amount;
};

const selectRulePrice = (
  product: ProductRow,
  rules: RuleRow[],
): { price: number; ruleId: string | null; ruleLabel: string | null } => {
  const regularPrice = asNumber(product.price);
  const isFood = product.category_name?.trim().toLowerCase() === "food";
  let bestDiscount = 0;
  let bestRule: RuleRow | null = null;
  let fixedPrice: number | null = null;
  let fixedRule: RuleRow | null = null;

  for (const rule of rules) {
    if (rule.scope === "non_food" && isFood) continue;
    if (rule.scope === "specific" && !rule.product_ids?.includes(product.id)) continue;
    if (rule.min_price !== null && regularPrice < asNumber(rule.min_price)) continue;

    if (rule.rule_type === "fixed_price" && rule.fixed_price !== null) {
      fixedPrice = asNumber(rule.fixed_price);
      fixedRule = rule;
      continue;
    }

    if (rule.rule_type === "discount_amount" && rule.discount_amount !== null) {
      const discount = asNumber(rule.discount_amount);
      if (discount > bestDiscount) {
        bestDiscount = discount;
        bestRule = rule;
      }
    }
  }

  if (fixedPrice !== null && fixedPrice < regularPrice) {
    return {
      price: Math.max(0, fixedPrice),
      ruleId: fixedRule?.id ?? null,
      ruleLabel: fixedRule?.label ?? null,
    };
  }

  if (bestDiscount > 0) {
    return {
      price: Math.max(0, regularPrice - bestDiscount),
      ruleId: bestRule?.id ?? null,
      ruleLabel: bestRule?.label ?? null,
    };
  }

  return { price: regularPrice, ruleId: null, ruleLabel: null };
};

export const quoteMemberPricing = async (
  db: PricingDatabase,
  input: MemberPricingQuoteRequest,
  options: { lockCustomer?: boolean } = {},
): Promise<MemberPricingQuote> => {
  if (!Array.isArray(input.items) || input.items.length === 0) {
    throw new AppError("VALIDATION_ERROR", "Items tidak boleh kosong", 400);
  }

  const customerId = input.customer_id || null;
  let customerIsMember = false;
  let memberType: "umum" | "akamsi" | "vip" | null = null;

  if (customerId) {
    const lockClause = options.lockCustomer ? " FOR UPDATE" : "";
    const customerResult = await db.query(
      `SELECT id, is_member, member_type, member_status
       FROM customers WHERE id = $1${lockClause}`,
      [customerId],
    );
    if (customerResult.rows.length === 0) {
      throw new AppError("NOT_FOUND", "Customer tidak ditemukan", 404);
    }
    const customer = customerResult.rows[0];
    customerIsMember = customer.is_member === true
      && customer.member_status === "active"
      && customer.member_type !== null;
    memberType = customerIsMember ? customer.member_type : null;
  }

  const productIds = [...new Set(input.items.map((item) => item.product_id))];
  const productResult = await db.query<ProductRow>(
    `SELECT p.id, p.name, p.price, p.stock, p.status, c.name AS category_name
     FROM products p
     LEFT JOIN categories c ON c.id = p.category_id
     WHERE p.id = ANY($1::uuid[])`,
    [productIds],
  );
  const products = new Map(productResult.rows.map((product) => [product.id, product]));

  if (products.size !== productIds.length) {
    throw new AppError("NOT_FOUND", "Salah satu produk tidak ditemukan", 404);
  }

  const requestedQuantityByProduct = new Map<string, number>();
  for (const item of input.items) {
    const quantity = Math.max(1, Math.floor(asNumber(item.quantity, 1)));
    requestedQuantityByProduct.set(
      item.product_id,
      (requestedQuantityByProduct.get(item.product_id) ?? 0) + quantity,
    );
  }
  for (const [productId, requestedQuantity] of requestedQuantityByProduct) {
    const product = products.get(productId)!;
    const stock = asNumber(product.stock);
    if (product.status !== "active") {
      throw new AppError("NOT_FOUND", `Produk ${product.name} tidak aktif`, 404);
    }
    if (stock < requestedQuantity) {
      throw new AppError(
        "OUT_OF_STOCK",
        `Stok ${product.name} tidak cukup. Stok tersisa: ${stock}`,
        400,
      );
    }
  }

  let rules: RuleRow[] = [];
  let dailyLimit: number | null = null;
  let usedBefore = 0;

  if (customerIsMember && memberType) {
    const rulesResult = await db.query<RuleRow>(
      `SELECT r.id, r.label, r.rule_type, r.scope, r.min_price,
              r.discount_amount, r.fixed_price,
              COALESCE(array_agg(rp.product_id)
                FILTER (WHERE rp.product_id IS NOT NULL), ARRAY[]::uuid[]) AS product_ids
       FROM member_tier_rules r
       LEFT JOIN member_tier_rule_products rp ON rp.rule_id = r.id
       WHERE r.tier = $1 AND r.is_active = true
       GROUP BY r.id
       ORDER BY r.sort_order, r.created_at, r.id`,
      [memberType],
    );
    rules = rulesResult.rows;

    const limitResult = await db.query(
      `SELECT MIN(daily_limit)::int AS daily_limit
       FROM member_tier_rules
       WHERE tier = $1 AND is_active = true AND daily_limit IS NOT NULL`,
      [memberType],
    );
    dailyLimit = limitResult.rows[0]?.daily_limit ?? null;

    if (dailyLimit !== null) {
      const usedResult = await db.query(
        `SELECT COALESCE(SUM(
           CASE
             WHEN ti.member_priced_quantity > 0 THEN ti.member_priced_quantity
             WHEN ti.is_member_price = true THEN ti.quantity
             ELSE 0
           END
         ), 0)::int AS used
         FROM transactions t
         JOIN transaction_items ti ON ti.transaction_id = t.id
         WHERE t.customer_id = $1
           AND t.status = 'paid'
           AND (t.created_at + INTERVAL '7 hours')::date =
               (NOW() + INTERVAL '7 hours')::date`,
        [customerId],
      );
      usedBefore = asNumber(usedResult.rows[0]?.used);
    }
  }

  const addOnIds = [...new Set(
    input.items.flatMap((item) => (item.addOns ?? []).map((addOn) => addOn.addOnId)),
  )];
  const addOnResult = addOnIds.length > 0
    ? await db.query(
      `SELECT id, name, price FROM add_ons
       WHERE id = ANY($1::uuid[]) AND status = 'active'`,
      [addOnIds],
    )
    : { rows: [] as Array<{ id: string; name: string; price: string | number }> };
  const addOns = new Map(addOnResult.rows.map((addOn) => [addOn.id, addOn]));

  if (addOns.size !== addOnIds.length) {
    throw new AppError("NOT_FOUND", "Salah satu add-on tidak ditemukan atau tidak aktif", 404);
  }

  let remainingQuota = dailyLimit === null
    ? Number.POSITIVE_INFINITY
    : Math.max(0, dailyLimit - usedBefore);
  let allocated = 0;
  const quotedItems: QuotedPricingItem[] = [];

  for (const item of input.items) {
    const product = products.get(item.product_id)!;
    const quantity = Math.max(1, Math.floor(asNumber(item.quantity, 1)));
    const stock = asNumber(product.stock);
    if (product.status !== "active") {
      throw new AppError("NOT_FOUND", `Produk ${product.name} tidak aktif`, 404);
    }
    if (stock < quantity) {
      throw new AppError(
        "OUT_OF_STOCK",
        `Stok ${product.name} tidak cukup. Stok tersisa: ${stock}`,
        400,
      );
    }

    const regularPrice = asNumber(product.price);
    const selectedRule = customerIsMember
      ? selectRulePrice(product, rules)
      : { price: regularPrice, ruleId: null, ruleLabel: null };
    const hasMemberPrice = selectedRule.price < regularPrice;
    const memberQuantity = hasMemberPrice
      ? Math.min(quantity, Number.isFinite(remainingQuota) ? remainingQuota : quantity)
      : 0;
    const regularQuantity = quantity - memberQuantity;
    allocated += memberQuantity;
    remainingQuota -= memberQuantity;

    const productSubtotal = Math.round(
      selectedRule.price * memberQuantity + regularPrice * regularQuantity,
    );
    const quotedAddOns: QuotedAddOn[] = (item.addOns ?? []).map((requested) => {
      const addOn = addOns.get(requested.addOnId)!;
      const addOnQuantity = Math.max(1, Math.floor(asNumber(requested.quantity, 1)));
      const price = asNumber(addOn.price);
      return {
        addOnId: addOn.id,
        addOnName: addOn.name,
        quantity: addOnQuantity,
        price,
        subtotal: price * addOnQuantity,
      };
    });
    const addOnsSubtotal = quotedAddOns.reduce((sum, addOn) => sum + addOn.subtotal, 0);
    const grossSubtotal = productSubtotal + addOnsSubtotal;
    const discountType: PricingDiscountType = item.discount_type === "percentage"
      ? "percentage"
      : "amount";
    const discountValue = asNumber(item.discount_amount);
    const calculatedDiscount = calculateDiscount(grossSubtotal, discountValue, discountType);
    const total = grossSubtotal - calculatedDiscount;
    const memberSavings = (regularPrice - selectedRule.price) * memberQuantity;

    quotedItems.push({
      client_line_id: item.client_line_id ?? item.lineId ?? null,
      product_id: product.id,
      product_name: product.name,
      category_name: product.category_name,
      quantity,
      original_unit_price: regularPrice,
      member_unit_price: memberQuantity > 0 ? selectedRule.price : null,
      member_priced_quantity: memberQuantity,
      regular_quantity: regularQuantity,
      effective_unit_price: productSubtotal / quantity,
      product_subtotal: productSubtotal,
      add_ons_subtotal: addOnsSubtotal,
      gross_subtotal: grossSubtotal,
      discount_amount: discountValue,
      discount_type: discountType,
      calculated_discount: calculatedDiscount,
      total,
      is_member_price: memberQuantity > 0,
      member_savings: memberSavings,
      member_rule_id: memberQuantity > 0 ? selectedRule.ruleId : null,
      member_rule_label: memberQuantity > 0 ? selectedRule.ruleLabel : null,
      notes: item.notes,
      addOns: quotedAddOns,
    });
  }

  const grossSubtotal = quotedItems.reduce((sum, item) => sum + item.gross_subtotal, 0);
  const itemDiscounts = quotedItems.reduce((sum, item) => sum + item.calculated_discount, 0);
  const subtotalAfterItemDiscounts = quotedItems.reduce((sum, item) => sum + item.total, 0);
  const globalDiscountType: PricingDiscountType = input.discount_global_type === "percentage"
    ? "percentage"
    : "amount";
  const globalDiscountValue = asNumber(input.discount_global);
  const globalDiscountAmount = calculateDiscount(
    subtotalAfterItemDiscounts,
    globalDiscountValue,
    globalDiscountType,
  );
  const totalMemberSavings = quotedItems.reduce((sum, item) => sum + item.member_savings, 0);

  return {
    customer_id: customerId,
    customer_is_member: customerIsMember,
    member_type: memberType,
    quota: {
      daily_limit: dailyLimit,
      used_before: usedBefore,
      allocated,
      remaining_after: dailyLimit === null
        ? null
        : Math.max(0, dailyLimit - usedBefore - allocated),
    },
    items: quotedItems,
    gross_subtotal: grossSubtotal,
    discount_items: itemDiscounts,
    subtotal_after_item_discounts: subtotalAfterItemDiscounts,
    discount_global_value: globalDiscountValue,
    discount_global_type: globalDiscountType,
    discount_global_amount: globalDiscountAmount,
    total_member_savings: totalMemberSavings,
    total: Math.max(0, subtotalAfterItemDiscounts - globalDiscountAmount),
  };
};
