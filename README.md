# Pet Adoption App 🐾

A beautiful and user-friendly Flutter application that helps users find and adopt their perfect pet companion. The app integrates with the Petfinder API to display real pets available for adoption.

## Features 🌟

- **Browse Pets**: View a grid of available pets with their images, names, ages, and adoption fees
- **Search**: Find specific pets using the search functionality
- **Pet Details**: View detailed information about each pet
- **Adoption**: Mark pets as adopted with a celebratory confetti animation
- **Favorites**: Save your favorite pets for later viewing
- **Image Viewer**: View pet images in full screen with zoom capability
- **Dark Mode**: Supports both light and dark themes
- **Offline Support**: Caches images for better performance
- **State Persistence**: Saves adopted and favorite states across app restarts

## Getting Started 🚀

### Prerequisites

- Flutter SDK (latest version)
- Android Studio / VS Code
- Android SDK
- iOS development tools (for iOS development)

### Installation

1. Clone the repository:

```bash
git clone https://github.com/AshishGupta18/pet_adoption
cd pet_adoption
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the app:

```bash
flutter run
```

## Building the App 🏗️

### Android APK

The pre-built APK is available in the `/apk` folder in the root directory. You can also build it yourself:

```bash
flutter build apk
```

The APK will be generated at: `build/app/outputs/flutter-apk/app-release.apk`

### iOS Build

For iOS, you'll need a Mac with Xcode installed:

```bash
flutter build ios
```

## Architecture 🏛️

The app follows a clean architecture pattern with the following layers:

- **Presentation**: UI components and state management using BLoC pattern
- **Domain**: Business logic and entities
- **Data**: API integration and local storage

## Dependencies 📦

- `flutter_bloc`: State management
- `http`: API calls
- `shared_preferences`: Local storage
- `cached_network_image`: Image caching
- `photo_view`: Image zooming
- `confetti`: Celebration animations
