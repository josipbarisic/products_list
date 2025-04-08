# Test assignment E-commerce Product App

A modern Flutter e-commerce application showcasing product browsing, filtering, and search
capabilities using Riverpod for state management.

![Flutter Version](https://img.shields.io/badge/flutter-%3E%3D3.0.0-blue.svg)
![Dart Version](https://img.shields.io/badge/dart-%3E%3D3.0.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## Features

- **Product Grid Display**: Browse products in a responsive grid layout
- **Advanced Filtering**: Filter products by brand, category, gender, and price range
- **Search Functionality**: Search products with debounced input
- **Lazy Loading**: Pagination with infinite scrolling for better performance
- **Responsive Design**: Adapts to different screen sizes and orientations

## Architecture

This application follows a structured architecture separating concerns:

### Data Layer

- **Models**: Strongly typed data models with Freezed
- **Repositories**: Data access abstraction
- **Data Sources**: Remote/local data providers

### Logic Layer

- **Providers**: Riverpod-powered state management
- **Services**: Business logic and processing

### Presentation Layer

- **Pages**: Main application screens
- **Widgets**: Reusable UI components
- **State Management**: Reactive UI with Riverpod code-gen

## Project Structure

```
lib/
├── data/
│   ├── models/           # Data models
│   ├── repositories/     # Data access layer
│   └── services/         # API services and data processing
├── logic/
│   └── errors/           # Error handling
├── presentation/
│   ├── home/             # Home page and related components
│   │   ├── providers/    # Home-specific providers
│   │   └── widgets/      # Home-specific widgets
│   └── shared/           # Shared widgets
└── main.dart             # Application entry point
```

## Providers

The app uses Riverpod for state management with the following key providers:

- **productsProvider**: Fetches the complete product catalog
- **productFilterNotifierProvider**: Manages filter state with debounce for search
- **paginatedProductsProvider**: Handles pagination and applies filters to products

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)

### Installation

1. Clone the repository
   ```bash
   git clone https://github.com/josipbarisic/product_list.git
   cd product_list
   ```

2. Install dependencies
   ```bash
   flutter pub get
   ```

3. Run the app
   ```bash
   flutter run
   ```

## Testing

The application includes comprehensive testing:

- **Unit Tests**: Test core business logic and provider functionality
- **Widget Tests**: Verify UI component behavior (planned)
- **Integration Tests**: End-to-end testing (planned)

Run tests with:

```bash
flutter test
```

See the [testing documentation](test/README.md) for more details.

## Code Style and Best Practices

- **Riverpod code-generation** used for cleaner provider definitions
- **Stateless widgets** preferred where possible for better performance
- **Consistent naming** following Flutter/Dart conventions
- **Documentation comments** on all public APIs and complex functions

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details

## Acknowledgements

- [Flutter](https://flutter.dev/)
- [Riverpod](https://riverpod.dev/)
- [Freezed](https://pub.dev/packages/freezed) for immutable models
