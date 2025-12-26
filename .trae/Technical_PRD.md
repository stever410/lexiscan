# 🛠️ Technical Product Requirements Document (Tech PRD)

## Project: LexiScan

## Version: MVP v1.0

---

## 1. Technology Stack

### 1.1 Core Framework

- **Framework**: Flutter (Latest Stable)
- **Language**: Dart 3.x (Leveraging Records, Patterns, Class Modifiers)

### 1.2 UI & Design System

- **Library**: `shadcn_ui` (Primary UI Component Library)
- **Theme**: Shadcn "Zinc" Theme (Zinc/Slate color palette preferred for readability)
- **Icons**: `lucide_icons` (Standard for shadcn) or `flutter_lucide`
- **Fonts**: Inter or Geist (Clean sans-serif for dictionary text)

### 1.3 State Management & Architecture

- **State Management**: `flutter_riverpod` (v2.x with Code Generation)
- **Routing**: `go_router` (Type-safe routing)
- **Architecture**: Feature-First Layered Architecture
  - `Presentation` (UI, Controllers)
  - `Domain` (Models, Entities)
  - `Data` (Repositories, Data Sources, DTOs)

### 1.4 Local Data & Offline Engine

- **Database**: `drift` (Reactive SQLite wrapper) or `sqflite`
  - _Reasoning_: Drift provides type-safe SQL queries and easy migration handling.
- **Key-Value Storage**: `shared_preferences` (for user settings like theme, last language)
- **File System**: `path_provider` (To store downloadable word packs)

### 1.5 OCR & Image Processing

- **OCR Engine**: `google_mlkit_text_recognition`
  - _Fallback_: `flutter_tesseract_ocr` (Only if ML Kit fails on specific devices, but ML Kit is primary)
- **Image Picker**: `image_picker` (Camera & Gallery)
- **Image Manipulation**: `image_editor` or `image_cropper` (Crop/Rotate before OCR)

---

## 2. Technical Architecture

### 2.1 High-Level Diagram

```mermaid
graph TD
    User[User Interaction] --> UI[UI Layer (shadcn_flutter)]
    UI --> Controller[Riverpod Controllers]
    Controller --> Service[Application Services]
    Service --> OCR[OCR Service (ML Kit)]
    Service --> Repo[Dictionary Repository]
    Repo --> LocalDB[(SQLite / Drift)]
    Repo --> FileSys[File System (Word Packs)]
```

### 2.2 Data Models (Core)

**WordEntry**

- `id`: int (Primary Key)
- `word`: String (Indexed)
- `phonetic`: String?
- `partOfSpeech`: String
- `definition`: String
- `examples`: List<String> (JSON encoded)

**LanguagePack**

- `code`: String (e.g., "en", "es")
- `version`: int
- `localPath`: String
- `isDownloaded`: bool

### 2.3 Modular Word Packs

- **Format**: SQLite (`.db`) files or Compressed JSON.
- **Storage Strategy**:
  - App ships with minimal `en_core.db`.
  - Additional languages are downloaded as `.zip`, extracted to `ApplicationDocumentsDirectory/word_packs/{lang_code}/`.
  - The `DatabaseService` dynamically opens the connection to the specific language DB.

---

## 3. UI/UX Implementation Strategy (shadcn_flutter)

### 3.1 Components Mapping

| Feature           | Native/Material             | shadcn_ui Component                             |
| :---------------- | :-------------------------- | :---------------------------------------------- |
| Primary Actions   | `ElevatedButton`            | `ShadButton` (variant: primary)                 |
| Secondary Actions | `OutlinedButton`            | `ShadButton.outline`                            |
| Input Fields      | `TextField`                 | `ShadInput`                                     |
| Dialogs           | `AlertDialog`               | `ShadDialog`                                    |
| Toasts            | `SnackBar`                  | `ShadToast`                                     |
| Definition Sheet  | `BottomSheet`               | `ShadSheet`                                     |
| Loading           | `CircularProgressIndicator` | `CircularProgress` (Custom or library provided) |

### 3.2 Theming

- Use `ShadApp` instead of `MaterialApp` (or wrap `MaterialApp` if interop is needed).
- Define `ShadThemeData` focusing on high contrast for text readability (critical for dictionary apps).

---

## 4. Performance Constraints & Optimization

### 4.1 OCR Performance

- **Target**: < 1.5s per image.
- **Strategy**: Resize images to max 1080p width before processing to speed up ML Kit without losing accuracy on text.
- **Thread**: Run OCR parsing in `compute()` isolate if heavy post-processing is needed (e.g., coordinate mapping).

### 4.2 Database Lookup

- **Target**: < 150ms.
- **Strategy**: Ensure `word` column is INDEXED in SQLite. Use `COLLATE NOCASE` for case-insensitive lookups.

### 4.3 App Size

- **Core**: Keep under 25MB.
- **Assets**: No bundled heavy fonts or images.
- **Split A/B**: Use Android App Bundle (.aab) to deliver architecture-specific binaries (arm64-v8a vs armeabi-v7a).

---

## 5. Security & Privacy

- **Local Processing**: Ensure `google_mlkit_text_recognition` is configured for "on-device" mode (default).
- **Permissions**: Request Camera and Storage permissions only when needed.

---

## 6. MVP Development Phases

1.  **Phase 1: Project Setup**: Init Flutter, Shadcn, Riverpod setup.
2.  **Phase 2: Camera & OCR**: Implement Image Picker and ML Kit extraction.
3.  **Phase 3: Dictionary Engine**: Setup SQLite (Drift) and seed with sample English data.
4.  **Phase 4: UI Integration**: Build "Scan Screen" and "Result Sheet" using `shadcn_flutter`.
5.  **Phase 5: Packaging**: Polish and release build.
