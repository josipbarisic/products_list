import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Creates a [ProviderContainer] for testing purposes.
///
/// This utility function provides a clean container for each test,
/// with optional overrides for mocking dependencies.
ProviderContainer createContainer({
  List<Override> overrides = const [],
}) {
  final container = ProviderContainer(
    overrides: overrides,
  );

  // Add a tear-down callback to dispose the container when the test is complete
  addTearDown(container.dispose);

  return container;
}

/// Utility extension to simplify testing of Provider state.
extension ProviderContainerExtension on ProviderContainer {
  /// Listens to the provider and returns a list of all emitted values.
  List<T> getAllEmittedValues<T>(ProviderListenable<T> provider) {
    final values = <T>[];
    final subscription = listen<T>(
      provider,
      (_, value) => values.add(value),
    );
    addTearDown(subscription.close);
    return values;
  }
}
