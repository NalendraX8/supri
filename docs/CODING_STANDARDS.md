# CODING_STANDARDS.md - Supri POS Coding Standards

## 1. Principles
* **SOLID:** Keep classes single-responsibility. Inject dependencies through constructors.
* **DRY (Don't Repeat Yourself):** Share common UI components inside `lib/core/widgets` and helper models inside `lib/core/utils`.
* **KISS (Keep It Simple, Stupid):** Write code for readability first, avoid premature complex abstraction layers.

## 2. Naming Standards
* **Classes & Extensions:** PascalCase (e.g., `AppButton`, `LoginState`).
* **Variables & Functions:** camelCase (e.g., `calculateTotalAmount()`).
* **Files & Folders:** snake_case (e.g., `app_colors.dart`).
* **Constants:** lowerCamelCase (e.g., `shortAnimationDuration`).

## 3. Clean Architecture Directives
* **No UI in Domain:** The Domain folder must contain zero imports containing `package:flutter/material.dart`.
* **Use DTO/Model separation:** Network payloads and database objects must use a `Model` class suffix and extend domain `Entity` classes.
* **Always Dispose:** Clean up controllers, subscription streams, and focus nodes inside the `dispose()` hooks of Statefully managed widgets.
