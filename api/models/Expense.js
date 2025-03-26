const mongoose = require('mongoose');

const expenseSchema = new mongoose.Schema({
    amount: {
        type: Number,
        required: [true, 'Please provide the expense amount'],
        min: [0, 'Amount cannot be negative'],
    },
    category: {
        type: String,
        required: [true, 'Please provide a category'],
        enum: [
            'Food',
            'Transport',
            'Gift',
            'Entertainment',
            'Utilities',
            'Shopping',
            'Healthcare',
            'Education',
            'Other',
        ],
        default: 'Other',
    },
    description: {
        type: String,
        trim: true,
        maxlength: [100, 'Description cannot exceed 100 characters'],
    },
    date: {
        type: Date,
        required: [true, 'Please provide the expense date'],
        default: Date.now,
    },
    user: {
        type: mongoose.Schema.ObjectId,
        ref: 'User',
        required: true,
    },
    createdAt: {
        type: Date,
        default: Date.now,
    },
});

const Expense = mongoose.model('Expense', expenseSchema);
module.exports = Expense;