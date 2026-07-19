# TESTING.md - Supri POS Testing Strategy

## 1. Unit Testing
* Tests focused on core business logic (BLoCs, Use Cases).
* Utilize `mocktail` to stub and verify repository method invocations.
* Use `bloc_test` package for testing BLoC events and state assertions.

```dart
// Example test definition
blocTest<AuthBloc, AuthState>(
  'emits [AuthLoading, AuthAuthenticated] when login succeeds',
  build: () => AuthBloc(repository: mockAuthRepository),
  act: (bloc) => bloc.add(const LoginEvent(email: 'demo@supri.id', password: '123')),
  expect: () => [AuthLoading(), AuthAuthenticated()],
);
```

## 2. Widget Testing
* Tests checking specific UI state configurations and user interactions.
* Setup dependency injections before pumping test widgets:
  ```dart
  setUp(() async {
    await di.initDependencies();
  });
  ```
* Check for component presence (e.g. `expect(find.text('LOGIN'), findsOneWidget)`).

## 3. Execution Commands
* **Run all tests:**
  ```bash
  flutter test
  ```
* **Run specific test file:**
  ```bash
  flutter test test/widget_test.dart
  ```
