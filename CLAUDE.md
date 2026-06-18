# Supri POS

Point of Sale mobile application - a clone of Zales/Finto POS built with Flutter.

## Features

- **Multi-outlet Support** - Operate multiple outlets with single app
- **Sales Management** - Product grid, categories, search, cart
- **Transaction History** - Daily transactions with sync status
- **QRIS Payment** - Integrated QRIS payment support
- **Cloud Data** - Sync data across devices
- **Offline Capable** - Works without internet connection

## Brand

- **Name:** Supri
- **Tagline:** Usaha Mulia, Transaksi Bahagia
- **Primary Color:** Red (#E53935)

## Tech Stack

- **Framework:** Flutter
- **State Management:** flutter_bloc
- **Architecture:** Clean Architecture
- **Navigation:** go_router
- **DI:** get_it

## Project Structure

```
lib/
├── core/                     # Shared utilities
│   ├── constants/           # App constants
│   ├── error/              # Failures & exceptions
│   ├── theme/              # App theme & colors
│   ├── utils/              # Utilities
│   └── widgets/            # Reusable widgets
├── features/                # Feature modules
│   ├── auth/               # Authentication
│   ├── sales/              # POS/Sales
│   ├── transaction/        # Transaction history
│   └── settings/           # App settings
├── injection_container.dart # Dependency injection
└── main.dart              # App entry point
```

## Getting Started

```bash
flutter pub get
flutter run
```

## Development

### Clean Architecture

Each feature follows Clean Architecture:
- `domain/` - Entities, repositories (abstract), use cases
- `data/` - Models, data sources, repository implementations
- `presentation/` - BLoC, pages, widgets

### Adding New Features

1. Create feature folder under `lib/features/`
2. Mirror the architecture structure
3. Register dependencies in `injection_container.dart`

## UI Reference

See `.temp_ui/` for Zales app screenshots used as UI reference.
