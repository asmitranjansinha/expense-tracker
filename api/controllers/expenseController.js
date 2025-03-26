const Expense = require('../models/Expense');
const AppError = require('../utils/errorHandler');

// @desc    Add new expense
// @route   POST /api/expenses
// @access  Private
exports.addExpense = async (req, res, next) => {
    try {
        const { amount, category, description, date } = req.body;

        const expense = await Expense.create({
            amount,
            category,
            description,
            date: date || Date.now(),
            user: req.user._id,
        });

        res.status(201).json({
            success: true,
            data: expense,
        });
    } catch (err) {
        next(err);
    }
};

// @desc    Get all expenses for a user
// @route   GET /api/expenses
// @access  Private
exports.getExpenses = async (req, res, next) => {
    try {
        const expenses = await Expense.find({ user: req.user._id }).sort('-date');

        res.status(200).json({
            success: true,
            count: expenses.length,
            data: expenses,
        });
    } catch (err) {
        next(err);
    }
};

// @desc    Get expense summary
// @route   GET /api/expenses/summary
// @access  Private
exports.getSummary = async (req, res, next) => {
    try {
        const { period = 'monthly' } = req.query;

        const date = new Date();
        let groupBy = {};

        if (period === 'daily') {
            date.setDate(date.getDate() - 1);
            groupBy = {
                year: { $year: '$date' },
                month: { $month: '$date' },
                day: { $dayOfMonth: '$date' },
            };
        } else if (period === 'weekly') {
            date.setDate(date.getDate() - 7);
            groupBy = {
                year: { $year: '$date' },
                week: { $week: '$date' },
            };
        } else { // monthly
            date.setMonth(date.getMonth() - 1);
            groupBy = {
                year: { $year: '$date' },
                month: { $month: '$date' },
            };
        }

        const summary = await Expense.aggregate([
            {
                $match: {
                    user: req.user._id,
                    date: { $gte: date },
                },
            },
            {
                $group: {
                    _id: {
                        ...groupBy,
                        category: '$category',
                    },
                    totalAmount: { $sum: '$amount' },
                    count: { $sum: 1 },
                },
            },
            {
                $sort: { '_id.year': -1, '_id.month': -1, '_id.day': -1 },
            },
        ]);

        res.status(200).json({
            success: true,
            data: summary,
        });
    } catch (err) {
        next(err);
    }
};

// @desc    Delete an expense
// @route   DELETE /api/expenses/:id
// @access  Private
exports.deleteExpense = async (req, res, next) => {
    try {
        const expense = await Expense.findById(req.params.id);

        if (!expense) {
            return next(new AppError('Expense not found', 404));
        }

        // Make sure user owns the expense
        if (expense.user.toString() !== req.user._id.toString()) {
            return next(new AppError('Not authorized to delete this expense', 401));
        }

        await expense.remove();

        res.status(200).json({
            success: true,
            data: {},
        });
    } catch (err) {
        next(err);
    }
};