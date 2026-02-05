# Lesson 02: Notes App - Ứng Dụng Ghi Chú Hoàn Chỉnh

> 📝 Xây dựng ứng dụng ghi chú với đầy đủ tính năng CRUD

---

## 🎯 Mục Tiêu

Trong bài này, bạn sẽ xây dựng một ứng dụng Notes hoàn chỉnh với:

- ✅ **Thêm** note mới (Create)
- ✅ **Xem** danh sách notes (Read)
- ✅ **Sửa** note (Update)
- ✅ **Xóa** note (Delete)
- ✅ **Tìm kiếm** notes
- ✅ **Màu sắc** cho mỗi note
- ✅ **Lưu trữ local** với SharedPreferences

---

## 🏗️ Kiến Trúc Ứng Dụng

```
┌─────────────────────────────────────────────────────────────┐
│                         UI LAYER                            │
│                                                              │
│   NotesListScreen          NoteEditorScreen                 │
│        │                         │                          │
│        └───────────┬─────────────┘                          │
│                    │                                        │
│                    ▼                                        │
│              NotesCubit (State Management)                  │
│                    │                                        │
└────────────────────┼────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                       DATA LAYER                            │
│                                                              │
│   NotesRepository → SharedPreferences (Local Storage)       │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 📝 Exercises

### Ex01: Note Model (`ex01_note_model.dart`)

**Học được gì:**
- Thiết kế data model với Dart
- Sử dụng `Equatable` cho comparison
- `copyWith` pattern cho immutability
- `toJson` / `fromJson` cho serialization

```dart
class Note extends Equatable {
  final String id;        // Unique identifier
  final String title;     // Tiêu đề
  final String content;   // Nội dung
  final int colorIndex;   // Index màu (0-7)
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

---

### Ex02: Notes Cubit (`ex02_notes_cubit.dart`)

**Học được gì:**
- Cubit pattern với complex state
- CRUD operations trong state
- Search/Filter functionality
- Local storage integration

**States:**
```dart
sealed class NotesState extends Equatable {}

class NotesInitial extends NotesState {}
class NotesLoading extends NotesState {}
class NotesLoaded extends NotesState {
  final List<Note> notes;
  final List<Note> filteredNotes;
  final String searchQuery;
}
class NotesError extends NotesState {
  final String message;
}
```

**Methods:**
```dart
class NotesCubit extends Cubit<NotesState> {
  void loadNotes();           // Load từ storage
  void addNote(Note note);    // Thêm note mới
  void updateNote(Note note); // Cập nhật note
  void deleteNote(String id); // Xóa note
  void searchNotes(String query); // Tìm kiếm
}
```

---

### Ex03: Notes List Screen (`ex03_notes_list_screen.dart`)

**Học được gì:**
- StaggeredGridView cho layout notes
- Search bar implementation
- Empty state handling
- Navigation đến editor

**UI Components:**
```
┌─────────────────────────────────────┐
│  🔍 Search notes...                 │  ← Search Bar
├─────────────────────────────────────┤
│                                     │
│  ┌─────────┐  ┌─────────┐          │  ← StaggeredGrid
│  │ Note 1  │  │ Note 2  │          │
│  │ ...     │  │ ...     │          │
│  └─────────┘  │ ...     │          │
│  ┌─────────┐  └─────────┘          │
│  │ Note 3  │  ┌─────────┐          │
│  └─────────┘  │ Note 4  │          │
│               └─────────┘          │
│                                     │
├─────────────────────────────────────┤
│                              [+]    │  ← FAB
└─────────────────────────────────────┘
```

---

### Ex04: Note Editor Screen (`ex04_note_editor_screen.dart`)

**Học được gì:**
- Form handling với TextEditingController
- Color picker UI
- Create vs Edit mode
- Unsaved changes warning

**UI Components:**
```
┌─────────────────────────────────────┐
│  ←  Edit Note            💾  🗑️   │  ← AppBar với actions
├─────────────────────────────────────┤
│                                     │
│  Title                              │  ← TextField
│  ──────────────────────             │
│                                     │
│  Content                            │  ← TextField (multiline)
│  ──────────────────────             │
│  ──────────────────────             │
│  ──────────────────────             │
│                                     │
│  Color:                             │
│  🟡 🟢 🔵 🟣 🟠 🔴 ⚪ ⚫           │  ← Color picker
│                                     │
└─────────────────────────────────────┘
```

---

### Ex05: Notes App Complete (`ex05_notes_app_complete.dart`)

**Học được gì:**
- Ghép tất cả components lại
- Dependency Injection setup
- App initialization
- Navigation flow

**Flow hoàn chỉnh:**
```
App Start
    │
    ▼
main() → setupDependencies() → runApp()
    │
    ▼
NotesApp (MaterialApp)
    │
    ▼
BlocProvider<NotesCubit>
    │
    ▼
NotesListScreen
    │
    ├──[Tap FAB]──→ NoteEditorScreen (Create)
    │                        │
    │                        └──[Save]──→ Back to List
    │
    └──[Tap Note]──→ NoteEditorScreen (Edit)
                             │
                             └──[Save/Delete]──→ Back to List
```

---

## 🎨 Color Palette

Notes App sử dụng 8 màu pastel:

| Index | Color | Mã màu |
|-------|-------|--------|
| 0 | 🟡 Yellow | `#FFF59D` |
| 1 | 🟢 Green | `#C5E1A5` |
| 2 | 🔵 Blue | `#90CAF9` |
| 3 | 🟣 Purple | `#CE93D8` |
| 4 | 🟠 Orange | `#FFCC80` |
| 5 | 🔴 Pink | `#F48FB1` |
| 6 | ⚪ White | `#FFFFFF` |
| 7 | ⚫ Grey | `#CFD8DC` |

---

## 📦 Packages Sử Dụng

| Package | Mục đích |
|---------|----------|
| `flutter_bloc` | State management với Cubit |
| `equatable` | So sánh objects |
| `shared_preferences` | Lưu trữ local |
| `uuid` | Generate unique ID cho notes |
| `flutter_staggered_grid_view` | Layout grid không đều |
| `intl` | Format ngày tháng |

---

## 💡 Tips & Best Practices

### 1. Immutable State
```dart
// ❌ Sai: Mutate state trực tiếp
state.notes.add(newNote);

// ✅ Đúng: Tạo state mới
emit(NotesLoaded(notes: [...state.notes, newNote]));
```

### 2. Search Debounce
```dart
// Tránh search mỗi ký tự, chờ user dừng gõ
Timer? _debounce;

void _onSearchChanged(String query) {
  _debounce?.cancel();
  _debounce = Timer(Duration(milliseconds: 300), () {
    cubit.searchNotes(query);
  });
}
```

### 3. Empty State
```dart
// Luôn hiển thị UI phù hợp khi không có data
if (notes.isEmpty) {
  return EmptyStateWidget(
    icon: Icons.note_add,
    message: 'Chưa có ghi chú nào',
    actionLabel: 'Tạo ghi chú đầu tiên',
    onAction: () => _navigateToEditor(),
  );
}
```

### 4. Unsaved Changes Warning
```dart
// Cảnh báo khi user back mà chưa save
Future<bool> _onWillPop() async {
  if (_hasUnsavedChanges) {
    return await showDialog(...);
  }
  return true;
}
```

---

## 🚀 Chạy Notes App

```bash
cd 08_real_projects/projects_app
flutter run -d chrome
```

Sau đó chọn **"📝 Notes App"** từ menu.

---

## ▶️ Bước Tiếp Theo

Sau khi hoàn thành Notes App, tiếp tục với:

➡️ [Lesson 03: Weather App](./lesson_03_weather_app.md)

---

## 📋 Checklist

- [ ] Hiểu data model với Equatable
- [ ] Hiểu Cubit pattern cho CRUD
- [ ] Tạo được UI với StaggeredGrid
- [ ] Implement được search functionality
- [ ] Lưu data với SharedPreferences
- [ ] Xử lý empty states và loading states
