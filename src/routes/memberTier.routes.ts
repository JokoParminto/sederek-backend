import { Router } from 'express'
import { authenticate } from '../middleware/auth'
import { getRules, createRule, updateRule, deleteRule, setRuleProducts } from '../controllers/memberTierController'

const router = Router()

router.get('/', getRules)
router.post('/', authenticate, createRule)
router.put('/:id', authenticate, updateRule)
router.delete('/:id', authenticate, deleteRule)
router.post('/:id/products', authenticate, setRuleProducts)

export default router
