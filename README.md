# Flutter POS Application

A modern Point of Sale (POS) mobile application built with Flutter, implementing Clean Architecture and BLoC state management. The app features barcode scanning for quick product lookup.

## 🏗️ Architecture

This project follows **Clean Architecture** principles with three main layers:

- **Domain Layer**: Business logic, entities, and repository interfaces
- **Data Layer**: API clients, data sources, and repository implementations
- **Presentation Layer**: UI components, pages, and BLoC state management

## 🚀 Features

### Authentication
- ✅ User login with JWT token management
- ✅ User registration
- ✅ Secure token storage using FlutterSecureStorage
- ✅ Auto-login on app restart

### Product Management
- ✅ View all products
- ✅ Product details with profit margin calculation
- ✅ Search products by barcode (primary feature)
- ✅ CRUD operations for products
- ✅ Pull-to-refresh product list

### Barcode Scanner
- ✅ Real-time barcode scanning using camera
- ✅ Custom scanner overlay UI
- ✅ Torch/flashlight control
- ✅ Camera switching (front/back)
- ✅ Automatic product search on scan
- ✅ Error handling for not found products

## 📦 Tech Stack

- **Flutter SDK**: Latest stable version
- **State Management**: flutter_bloc ^8.1.6
- **Networking**: dio ^5.4.0, retrofit ^4.1.0
- **Dependency Injection**: get_it ^7.6.7
- **Barcode Scanner**: mobile_scanner ^5.1.1
- **Secure Storage**: flutter_secure_storage ^9.0.0
- **Code Generation**: freezed, json_serializable, retrofit_generator

## 🔧 Configuration

### API Base URL

The API base URL can be easily configured in `lib/core/config/app_config.dart`:

```dart
static const String baseUrl = 'http://10.0.2.2:8085/api/v1';
```

**Important**: Change this based on your testing environment:
- **Android Emulator**: `http://10.0.2.2:8085/api/v1`
- **iOS Simulator**: `http://localhost:8085/api/v1`
- **Physical Device**: `http://YOUR_COMPUTER_IP:8085/api/v1` (e.g., `http://192.168.1.100:8085/api/v1`)

### API Authentication

The app automatically handles API authentication with:
- Custom API key generation: `MD5(signatureKey + timestamp)`
- Headers: `x-api-key` and `x-request-at`
- JWT token for authenticated endpoints

## 📱 Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Android SDK / Xcode (for iOS)

### Installation

1. **Clone the repository**
   ```bash
   cd frontend-pos
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code** (already done, but if you make changes)
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Configure API URL**
   - Open `lib/core/config/app_config.dart`
   - Update `baseUrl` with your backend server address

5. **Run the app**
   ```bash
   flutter run
   ```

## 🔑 API Endpoints Used

- `POST /auth/login` - User login
- `POST /auth/register` - User registration
- `GET /auth` - Get current user
- `GET /products` - Get all products
- `GET /products/code/{code}` - **Get product by barcode**
- `POST /products` - Create product
- `PUT /products/{uuid}` - Update product
- `DELETE /products/{uuid}` - Delete product

## 📂 Project Structure

```
lib/
├── core/
│   ├── config/          # App configuration (base URL, constants)
│   ├── constants/       # API constants
│   ├── error/          # Error handling (failures, exceptions)
│   ├── network/        # Dio client, interceptors
│   ├── theme/          # App theme
│   ├── usecases/       # Base use case
│   └── utils/          # Utilities (API key generator)
├── features/
│   ├── auth/
│   │   ├── data/       # Models, data sources, repositories
│   │   ├── domain/     # Entities, repository interfaces, use cases
│   │   └── presentation/ # BLoC, pages, widgets
│   └── product/
│       ├── data/
│       ├── domain/
│       └── presentation/
├── injection_container.dart  # Dependency injection setup
└── main.dart           # App entry point
```

## 🎨 UI Screens

1. **Login Page** - User authentication
2. **Register Page** - New user registration
3. **Product List Page** - Display all products with pull-to-refresh
4. **Product Detail Page** - Show detailed product information
5. **Barcode Scanner Page** - Scan barcodes to search products

## 🧪 Testing

### Manual Testing Checklist

1. **Authentication**
   - [ ] Login with valid credentials
   - [ ] Login with invalid credentials
   - [ ] Register new user
   - [ ] Auto-login on app restart
   - [ ] Logout functionality

2. **Products**
   - [ ] View all products
   - [ ] View product details
   - [ ] Pull to refresh products

3. **Barcode Scanner**
   - [ ] Open scanner
   - [ ] Scan valid product barcode
   - [ ] Scan invalid barcode
   - [ ] Toggle torch/flashlight
   - [ ] Switch camera

4. **Error Handling**
   - [ ] No internet connection
   - [ ] Server error (500)
   - [ ] Unauthorized (401)
   - [ ] Not found (404)
   - [ ] Validation errors (422)

## 🐛 Troubleshooting

### Cannot connect to backend
- Ensure your backend server is running
- Check the `baseUrl` in `app_config.dart`
- For physical devices, use your computer's local IP address
- Ensure your device and computer are on the same network

### Camera permission denied
- Check `AndroidManifest.xml` has camera permission
- For iOS, ensure `Info.plist` has camera usage description

### Build errors after code changes
- Run code generation: `flutter pub run build_runner build --delete-conflicting-outputs`
- Clean and rebuild: `flutter clean && flutter pub get`

## 📄 License

This project is for educational purposes.

## 👨‍💻 Developer Notes

- The app uses **Freezed** for immutable state management
- **Dartz** is used for functional error handling with `Either<Failure, Success>`
- All network requests automatically include API key and JWT token headers
- The barcode scanner uses `mobile_scanner` which is actively maintained
- Material 3 design is used throughout the app
