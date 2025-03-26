const { verifyToken } = require('../config/jwt');
const User = require('../models/User');
const AppError = require('../utils/errorHandler');

const protect = async (req, res, next) => {
    try {
        let token;
        if (
            req.headers.authorization &&
            req.headers.authorization.startsWith('Bearer')
        ) {
            token = req.headers.authorization.split(' ')[1];
        }

        if (!token) {
            return next(new AppError('Not authorized to access this route', 401));
        }

        const decoded = verifyToken(token);
        const currentUser = await User.findById(decoded.userId);

        if (!currentUser) {
            return next(new AppError('User no longer exists', 401));
        }

        req.user = currentUser;
        next();
    } catch (err) {
        next(err);
    }
};

module.exports = { protect };