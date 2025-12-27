# 📏 Coding Conventions & Best Practices

## Project: LexiScan

---

## 1. File Structure (Feature-First)

We follow a **Feature-First** architecture. Each feature is a self-contained module containing its own UI, state, and domain logic.

```
lib/
├── main.dart                 # Entry point
├── app.dart                  # App configuration (ShadcnApp, Routing)
├── src/
│   ├── common_widgets/       # Reusable UI components (shadcn wrappers)
│   ├── constants/            # App-wide constants (colors, strings)
│   ├── exceptions/           # Custom error handling
│   ├── utils/                # Helper functions (date formatting, string manip)
│   └── features/
│       ├── scan/             # Feature: Scanning & OCR
│       │   ├── data/         # Repositories & DTOs
│       │   ├── domain/       # Entities & Models
│       │   ├── presentation/ # Widgets & Controllers
│       │   │   ├── scan_screen.dart
│       │   │   └── scan_controller.dart
│       ├── dictionary/       # Feature: Dictionary Lookup
│       └── settings/         # Feature: User Settings
```

---

## 2. Naming Conventions

- **Classes**: `PascalCase` (e.g., `WordEntry`, `ScanController`)
- **Variables/Functions**: `camelCase` (e.g., `fetchDefinition`, `isLoading`)
- **Files**: `snake_case` (e.g., `scan_screen.dart`, `word_repository.dart`)
- **Constants**: `kPascalCase` or `SCREAMING_SNAKE_CASE` (e.g., `kMaxRetryCount`, `API_KEY`)
- **MobX Stores**: `PascalCase` ending with `Store` (e.g., `DictionaryStore`, `ScanStore`)

---

## 3. UI Development (shadcn_ui)

### 3.1 Component Usage
- **Strictly prefer `shadcn_ui` widgets** over standard Material widgets to maintain design consistency.
- **Imports**: Use specific imports or a barrel file to avoid naming conflicts if mixing Material/Cupertino.
  ```dart
  import 'package:shadcn_ui/shadcn_ui.dart';
  ```

### 3.2 Widget Structure
- Keep `build` methods clean. Extract complex sub-trees into separate stateless widgets (e.g., `_WordHighlightOverlay`).
- **One Widget Per File**: Every new widget (especially stateful ones or those used in multiple places) must be in its own file. Do not stack multiple widget classes in a single file unless they are strictly private helpers.
- Use `const` constructors wherever possible.

### 3.3 Responsive Design
- Use `LayoutBuilder` or `MediaQuery` sparingly; prefer flexible layouts (`Flex`, `Expanded`) that adapt to screen sizes.

---

## 4. State Management (MobX)

### 4.1 Stores

- Use **MobX Stores** for managing state.
- Classes should use the `@store` annotation (or mixin) and be generated using `mobx_codegen`.
- State variables should be marked with `@observable`.
- Methods modifying state should be marked with `@action`.
- Derived state should be marked with `@computed`.

### 4.2 UI Integration

- Use the `Observer` widget from `flutter_mobx` to wrap parts of the UI that depend on observable state.
- Keep the `Observer` as granular as possible to minimize re-builds.

```dart
// Good
Observer(
  builder: (_) {
    if (store.isLoading) return CircularProgressIndicator();
    return Text(store.data);
  }
)
```

### 4.3 Dependency Injection

- Stores can be instantiated as global singletons or passed via a service locator (like `get_it`) or simple constructor injection.
- Ensure stores are testable by allowing dependency injection in constructors.

```dart
// Example Store
class ScanStore = _ScanStore with _$ScanStore;

abstract class _ScanStore with Store {
  @observable
  bool isLoading = false;

  @action
  Future<void> scanImage() async {
    // ...
  }
}
```

---

## 5. Error Handling

- Use `AsyncValue` to handle UI states (`loading`, `error`, `data`) gracefully.
- Catch errors at the Repository layer and convert them to Domain Exceptions (e.g., `WordNotFoundException`) before passing to the UI.

---

## 6. Code Style & Lints

- **Linter**: `flutter_lints` (default) with strict rules enabled in `analysis_options.yaml`.
- **Formatting**: Run `dart format .` before committing.
- **Comments**:
  - Use `///` for documentation comments on public APIs.
  - Use `//` for implementation details.

---

## 7. Version Control

- **Commits**: Conventional Commits style.
  - `feat: add camera scanning`
  - `fix: crash on rotation`
  - `chore: update dependencies`
  - `docs: update PRD`

---

## 8. Testing

- **Unit Tests**: Required for Domain and Data layers (Repositories, Parsers).
- **Widget Tests**: Required for critical UI flows (Scan results).
- **Integration Tests**: Optional for MVP.
