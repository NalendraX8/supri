# ARCHITECTURE.md - Supri POS System Architecture

## 1. Clean Architecture Design
We employ **Clean Architecture** to ensure that the business logic remains fully decoupled from the UI, databases, and network clients. This architecture guarantees testability, flexibility (e.g., swapping local databases), and maintainability.

### Presentation Layer (BLoC + UI)
* Enforces a strict unidirectional data flow (`Event` -> `State`). This prevents UI components from modifying state directly, ensuring predictable offline/online state handling.
* Coordinates widgets scaling dynamically using `flutter_screenutil`.

### Domain Layer (Pure Dart)
* Focuses purely on enterprise business rules.
* Contains Use Cases (e.g., `GetProductCatalog`, `CheckoutSale`), Domain Entities, and abstract Repository Interfaces.
* Zero external dependencies on specific UI or database packages.

### Data Layer (Repositories & Data Sources)
* Implements Repository Interfaces defined by the Domain.
* Manages local caching (`LocalDataSource`) and remote API calls (`RemoteDataSource`).
* Handles functional mapping from raw JSON/Database structures to pure domain objects.

---

## 2. Dependency Injection Strategy
Dependencies are registered in `injection_container.dart` in dependency order using `get_it`:
1. **Core / External Dependencies:** Connectivity trackers, Database clients, Secure Storage.
2. **Data Sources:** Registered as `lazySingletons`.
3. **Repositories:** Concrete implementations bound to domain interfaces as `lazySingletons`.
4. **Use Cases:** Core business use cases as `lazySingletons`.
5. **BLoCs:** UI state engines registered as `factory` instances so they are disposed when their widget is unmounted.

---

## 3. Error Handling Strategy
Instead of using `try-catch` blocks that bubble up and risk crashing the app, we use functional error handling with the **Either** type from `dartz`:

```dart
// Repository returns a Failure on the left side, or a List of Products on the right
Future<Either<Failure, List<ProductEntity>>> getProducts();
```
* **Exceptions** are caught in the Data Source layer (e.g., `SocketException`, `ServerException`) and mapped to **Failures** (e.g., `NetworkFailure`, `ServerFailure`) inside the Repository Implementation before reaching the presentation layer.
