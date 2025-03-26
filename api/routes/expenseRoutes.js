const express = require('express');
const router = express.Router();
const expenseController = require('../controllers/expenseController');
const { protect } = require('../middlewares/auth');

router
    .route('/')
    .get(protect, expenseController.getExpenses)
    .post(protect, expenseController.addExpense);

router.get('/summary', protect, expenseController.getSummary);
router.delete('/:id', protect, expenseController.deleteExpense);

module.exports = router;