# Expense Tracker Application

A full-stack personal finance management application with Flutter frontend and Node.js/Express backend.

## Features

- **User Authentication**: Secure register/login with JWT
- **Expense Management**: Add, view (activity, analytics) expenses
- **Visual Analytics**: Charts for spending patterns
- **Data Export**: Share expense reports
- **Cross-platform**: Works on Android, iOS, and web

## Tech Stack

### Frontend

- Flutter (v3.6.1)
- State Management: Provider
- HTTP Client: http package
- Secure Storage: flutter_secure_storage
- Charts: fl_chart

### Backend

- Node.js + Express
- MongoDB (via Mongoose)
- JWT Authentication
- Bcrypt for password hashing

## Setup Instructions

### Prerequisites

- Node.js v18+
- Flutter SDK v3.6+
- MongoDB Atlas account or local MongoDB
- Git

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/expense-tracker.git
   cd expense-tracker
   ```
2. **Install dependencies**:

   ```bash
   Copy
   npm run install:all
   ```

3. **Backend Setup**:
   Create .env file in api/ directory:

   ```
   PORT=3000
   MONGODB_URI=your_mongodb_connection_string
   JWT_SECRET=your_jwt_secret_key
   JWT_EXPIRE=30d
   ```

   Start development server:

   ```bash
   npm run dev:api
   ```

4. **Frontend Setup**:

   Update API base URL in frontend/lib/services/api_service.dart

   Run the app:

   ```bash
   npm run dev:frontend
   ```
