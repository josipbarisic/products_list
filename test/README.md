# Testing Strategy

This directory contains tests for the application, organized by test type.

## Test Structure

- `unit/`: Contains unit tests for individual components and business logic
- `utils/`: Contains testing utilities and helpers
- `widget_test.dart`: Example of a Flutter widget test (auto-generated)

## Unit Tests

Unit tests focus on testing individual components in isolation:

- `product_filter_notifier_test.dart`: Tests for the filter state management
- `paginated_products_provider_test.dart`: Tests for the product pagination and filtering logic

## Running Tests

To run all tests:

```bash
flutter test

To run a specific test file:

flutter test test/unit/product_filter_notifier_test.dart
```

## Test Utilities

The `test_utils.dart` file provides common utilities for testing:

- `createContainer()`: Creates a Riverpod ProviderContainer for isolated testing

## Testing Principles

1. **Isolated testing**: Each test should be independent and not affect other tests
2. **Clear test names**: Test names should clearly describe what behavior is being tested
3. **Arrange-Act-Assert**: Tests follow the pattern of setting up the test, performing an action, and verifying the result
4. **Mocking dependencies**: External dependencies are mocked for reliable testing

## Coverage

To generate test coverage reports:

Make sure you have lcov installed. If not, run:
```bash
brew install lcov
```

Then run the following commands:

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

Then open `coverage/html/index.html` in a browser to view the report.

## Areas for Future Testing

1. Widget tests for UI components
2. Integration tests for end-to-end user flows
3. Repository tests for data fetching and error handling 