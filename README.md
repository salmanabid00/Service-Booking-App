# ProService - Advanced Service Booking Application

ProService is a production-ready, full-stack service booking platform built with **Flutter** and **Firebase**. It features a robust role-based access control system, real-time data synchronization, and a premium UI/UX designed for scalability and professional deployment.

## 🚀 Key Features

### 👤 For Users
- **Secure Authentication**: Email/Password login and signup via Firebase Auth.
- **Service Discovery**: Browse a beautifully categorized list of available services with real-time pricing.
- **Instant Booking**: One-tap booking flow with automated scheduling and status tracking.
- **Booking History**: Track the lifecycle of requests (Pending, Approved, Completed).

### 🛠️ For Admins
- **Unified Dashboard**: Oversight of all system bookings with real-time status updates.
- **Dynamic Management**: Approve, reject, or mark bookings as completed with instant user notifications.
- **Service Control**: Manage the service catalog (Add/Edit/Delete services).
- **Business Analytics**: Quick-glance stats for total and pending bookings.

## 🛠 Tech Stack
- **Frontend**: Flutter (Mobile & Web Support)
- **Backend**: Firebase (Authentication, Cloud Firestore)
- **State Management**: GetX (Dependency Injection & Reactive State)
- **Architecture**: Clean Architecture (Feature-First Structure)
- **UI Design**: Material 3, Google Fonts (Plus Jakarta Sans)

## 🏗 Project Structure (Clean Architecture)
```text
lib/
├── core/               # Shared services, constants, and utilities
├── features/
│   ├── admin/          # Admin-specific modules and dashboards
│   ├── auth/           # Authentication logic, entities, and UI
│   ├── bookings/       # Booking lifecycle and repository logic
│   └── services/       # Service catalog and display logic
└── main.dart           # App entry and global configuration
```

## 🔐 Security & Roles
The system implements strict **Firestore Security Rules** to ensure data integrity:
- Users can only view and manage their own bookings.
- Admins have read/write access to all collections based on a verified `role` field in the user document.
- Status updates are protected to prevent unauthorized manual approvals by users.

## 🚦 Getting Started

### Prerequisites
- Flutter SDK (^3.9.2)
- Firebase Account & Project

### Installation
1. **Clone the repository**:
   ```bash
   git clone https://github.com/salmanabid00/service_booking_app.git
   ```
2. **Install dependencies**:
   ```bash
   flutter pub get
   ```
3. **Firebase Setup**:
   - Place your `google-services.json` in `android/app/`.
   - Enable Email/Password Auth in the Firebase Console.
   - Deploy the provided `firestore.rules` to your project.
4. **Run the application**:
   ```bash
   flutter run
   ```

## 🎨 UI/UX Philosophy
ProService follows modern design trends:
- **Soft Shadows & Large Radii**: For a premium, mobile-first feel.
- **Visual Hierarchy**: Clear calls to action (CTAs) and purposeful use of whitespace.
- **Responsive Feedback**: Custom snackbars and loading states for a seamless user experience.

---
*Developed with ❤️ as a high-performance solution for service-based businesses.*
