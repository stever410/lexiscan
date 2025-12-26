
# 📘 Product Requirements Document (PRD)
## Product Name: LexiScan
## Platform: Flutter (Android & iOS)
## Version: MVP v1.0
## Mode: Offline-first

---

## 1. Product Overview

LexiScan is an offline-first visual dictionary mobile application that allows users to scan images, detect multiple words, and instantly view dictionary-grade definitions by tapping any detected word.

The app is designed to be lightweight, cross-platform, and scalable to support additional languages through downloadable word packs.

---

## 2. Goals & Objectives

### Primary Goals
- Enable instant dictionary lookup from images
- Work fully offline after initial setup
- Support multi-word scanning
- Keep app size minimal
- Scale to new languages without refactoring

### Success Metrics
- OCR processing < 1.5s
- Word lookup < 150ms
- App size (core) < 25MB
- Offline success rate = 100%
- App Store rating ≥ 4.5

---

## 3. Target Users

- Students
- Language learners
- Researchers
- Travelers
- Readers (books, PDFs, signage)

---

## 4. Core User Flows

### 4.1 Scan & Lookup Flow
1. User opens app
2. User opens camera or uploads image
3. OCR detects all words
4. Words are highlighted
5. User taps any word
6. Definition panel opens
7. User taps another word without rescanning

### 4.2 Offline Flow
- OCR runs on-device
- Dictionary lookup from local database
- No internet required

---

## 5. Core Features (MVP)

### 5.1 Image Input
- Camera capture
- Image upload
- Crop & rotate
- Supports scanning multiple words per image

### 5.2 OCR (Offline, Multi-Word)
- On-device OCR only
- Word-level bounding boxes
- Highlight all detected words
- Tap-to-select interaction

### 5.3 Word Normalization
- Lowercasing
- Punctuation removal
- Lemmatization (plural → singular)
- Possessive handling

### 5.4 Offline Dictionary Engine
- Local SQLite database
- Indexed word lookup
- Supports:
  - Word
  - IPA pronunciation
  - Part of speech
  - Definitions
  - Example sentences

### 5.5 Definition UI
- Bottom sheet or modal
- Displays:
  1. Word
  2. Pronunciation
  3. Part of speech
  4. Definitions
  5. Examples
- Swipe or tap to switch words

### 5.6 Word Packs (Downloadable)
- Language-specific dictionary packs
- Downloaded separately from core app
- Versioned and updatable

---

## 6. Offline-First Strategy

| Feature | Offline |
|------|------|
| OCR | Yes |
| Dictionary | Yes |
| History | Yes |
| Favorites | Yes |
| Audio | No (future) |

---

## 7. Scalability & Language Support

### MVP
- English only

### Future Languages
- Japanese
- Chinese
- Vietnamese
- Korean

### Architecture
Language packs are modular and isolated:

```
/word_packs
 ├── en/
 │   ├── dictionary.db
 │   └── metadata.json
 ├── ja/
 └── zh/
```

---

## 8. Technical Architecture

### Flutter App Layers
- UI Layer
- OCR Abstraction Layer
- Word Processing Layer
- Dictionary Engine
- Word Pack Manager
- Update Manager

### OCR Implementation
- Unified Flutter plugin
- Platform-specific native OCR:
  - Android: ML Kit
  - iOS: Vision Framework

---

## 9. Performance Requirements

| Metric | Target |
|------|------|
| OCR processing | < 1.5s |
| Word lookup | < 150ms |
| App launch | < 2s |

---

## 10. Security & Privacy

- Images processed locally
- No image storage by default
- No cloud OCR unless user opts in
- GDPR compliant

---

## 11. App Size Strategy

- Minimal core app
- Lazy-loaded word packs
- No bundled unused languages
- Deferred Flutter loading

---

## 12. MVP Scope

### Included
- Offline OCR
- Multi-word scan
- English dictionary
- Downloadable word packs

### Excluded
- Phrase-level lookup
- Grammar analysis
- Cloud translation
- Audio pronunciation

---

## 13. Risks & Mitigations

| Risk | Mitigation |
|----|----|
| App size growth | Modular packs |
| OCR accuracy | Confidence filtering |
| CJK complexity | Language isolation |

---

## 14. Open Questions

1. Dictionary data source licensing?
2. Max acceptable app size?
3. Update frequency of word packs?
4. Paid vs free language packs?

---

## 15. Future Enhancements

- Phrase selection
- Live AR scanning
- Vocabulary learning mode
- Audio pronunciation
- Cloud fallback OCR

---
