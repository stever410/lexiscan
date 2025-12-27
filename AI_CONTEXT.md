# AI Context & Coding Standards for LexiScan

This document provides context for AI assistants to understand the project structure, technology stack, and coding conventions.

## 1. Project Overview
**LexiScan** is an offline-first visual dictionary app built with Flutter. It uses OCR (ML Kit) to detect words in images and provides instant dictionary lookups.

## 2. Technology Stack
- **Framework**: Flutter (Latest Stable)
- **State Management**: `mobx`, `flutter_mobx`, `provider`/`get_it` (Service Locator)
- **UI Library**: `shadcn_ui` (Zinc theme), `flutter_lucide` (Icons)
- **Animations**: `flutter_animate`
- **Navigation**: `go_router`
- **OCR**: `google_mlkit_text_recognition`
- **Local Data**: `drift` (SQLite), `shared_preferences`

## 3. Architecture
The project follows a **Feature-First Layered Architecture**.

### Structure
```
lib/src/
  ├── features/           # Feature-based modules
  │   ├── scan/           # "Scan" feature
  │   │   ├── application/ # State management (MobX Stores)
  │   │   ├── data/        # Repositories & Services
  │   │   ├── presentation/# Widgets & Screens
  │   │   └── scan.dart    # Barrel file for the feature
  ├── routing/            # App routing configuration
  ├── shared/             # Shared logic (Theme, Utils)
  └── locator.dart        # Dependency Injection (GetIt)
```

## 4. Coding Conventions

### General
- **Barrel Files**: Use `feature_name.dart` barrel files to export public members of a feature.
- **Imports**: Prefer relative imports within a feature, and package imports (`package:lexiscan/...`) for external features.

### UI & Widgets
- **One Widget Per File**: Every new widget must be in its own file.
- **Composition**: Break down complex UI into smaller, reusable widgets.
- **Shadcn UI**: Use `ShadTheme.of(context)` for styling. Use `ShadButton`, `ShadInput`, etc.
- **Animations**: Use `flutter_animate` for declarative animations (e.g., `.animate().fadeIn()`).

### State Management (MobX)
- Use `Store` classes for feature state.
- Use `Observer` widgets to react to state changes.
- Keep stores decoupled from UI logic where possible.

### File Naming
- **Widgets**: `snake_case.dart` (e.g., `word_definition_card.dart`)
- **Stores**: `*_store.dart` (e.g., `scan_store.dart`)
- **Services**: `*_service.dart` (e.g., `ocr_service.dart`)

## 5. Key Features Implementation Status
- **OCR**: Implemented using ML Kit.
- **Scan Result**:
  - Image Overlay with `InteractiveViewer` (Zoom/Pan).
  - Tap-to-select word bounding boxes.
  - Swipeable `PageView` for word definitions (`WordDefinitionCard`).
  - Animated entry for definitions.

## 6. Common Tasks Reference
- **Adding a new feature**: Create a new folder in `features/`, set up `application`, `data`, `presentation` layers.
- **Styling**: Refer to `shadcn_ui` docs. Use `theme.colorScheme` for consistent colors.
