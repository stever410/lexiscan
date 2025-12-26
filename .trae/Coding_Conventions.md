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
- **Riverpod Providers**: `camelCase` ending with `Provider` (e.g., `dictionaryRepositoryProvider`, `scanResultsProvider`)

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
- Use `const` constructors wherever possible.

### 3.3 Responsive Design
- Use `LayoutBuilder` or `MediaQuery` sparingly; prefer flexible layouts (`Flex`, `Expanded`) that adapt to screen sizes.

---

## 4. State Management (Riverpod)

### 4.1 Controllers

- Use `AsyncNotifier` for async state (loading, error, data).
- **Avoid** `StateProvider` for complex logic; use `Notifier` or `AsyncNotifier`.

### 4.2 Dependency Injection

- All repositories and services must be accessed via providers.
- **Do not** create instances of repositories directly in widgets.

```dart
// Good
final repo = ref.watch(dictionaryRepositoryProvider);

// Bad
final repo = DictionaryRepository();
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
