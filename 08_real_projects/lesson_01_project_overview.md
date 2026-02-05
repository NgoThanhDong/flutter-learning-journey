# Lesson 01: Project Overview - Cách Tổ Chức Dự Án Flutter

> 📐 Học cách **thiết kế và tổ chức** một dự án Flutter chuyên nghiệp

---

## 🎯 Mục Tiêu Bài Học

Trước khi bắt tay vào code, bạn cần hiểu:

1. **Tại sao cần tổ chức code?** - Lợi ích của clean architecture
2. **Folder structure** - Cách đặt file/folder
3. **Layer architecture** - Phân tầng ứng dụng
4. **Naming conventions** - Quy tắc đặt tên
5. **Project planning** - Lập kế hoạch trước khi code

---

## 📁 Folder Structure Chuẩn

### Cấu trúc cơ bản cho Flutter project:

```
lib/
├── main.dart                    # Entry point
│
├── core/                        # Code dùng chung
│   ├── constants/               # Hằng số (colors, sizes, strings)
│   ├── theme/                   # ThemeData, TextStyles
│   ├── utils/                   # Helper functions
│   └── widgets/                 # Shared widgets
│
├── features/                    # Các tính năng (module)
│   ├── notes/                   # Feature: Notes
│   │   ├── data/                # Data layer
│   │   │   ├── models/          # Data models
│   │   │   ├── repositories/    # Repository implementations
│   │   │   └── datasources/     # Local/Remote data sources
│   │   │
│   │   ├── presentation/        # UI layer
│   │   │   ├── bloc/            # BLoC/Cubit
│   │   │   ├── screens/         # Screen widgets
│   │   │   └── widgets/         # Feature-specific widgets
│   │   │
│   │   └── domain/              # Business logic (optional)
│   │       ├── entities/        # Business entities
│   │       └── usecases/        # Use cases
│   │
│   └── weather/                 # Feature: Weather
│       ├── data/
│       ├── presentation/
│       └── domain/
│
└── injection.dart               # Dependency injection setup
```

### Giải thích từng folder:

| Folder | Mục đích | Ví dụ file |
|--------|----------|------------|
| `core/constants` | Giá trị không đổi | `app_colors.dart`, `app_sizes.dart` |
| `core/theme` | Theme configuration | `app_theme.dart`, `text_styles.dart` |
| `core/utils` | Functions tiện ích | `date_formatter.dart`, `validators.dart` |
| `core/widgets` | Widget dùng chung | `custom_button.dart`, `loading_widget.dart` |
| `features/*/data` | Data access layer | `note_model.dart`, `note_repository.dart` |
| `features/*/presentation` | UI layer | `notes_screen.dart`, `notes_cubit.dart` |

---

## 🏗️ Layer Architecture

### 3 Layers cơ bản:

```
┌─────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                       │
│                                                              │
│   Widgets    ←──→    BLoC/Cubit    ←──→    States           │
│   (UI)              (Logic)               (Data)             │
│                                                              │
│   • Không chứa business logic                                │
│   • Chỉ gọi methods từ BLoC                                  │
│   • Rebuild dựa trên State                                   │
└────────────────────────────┬────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────┐
│                      DOMAIN LAYER                            │
│                                                              │
│   Use Cases    ←──→    Entities    ←──→    Repository        │
│   (Actions)           (Business)          (Interface)        │
│                                                              │
│   • Business logic thuần túy                                 │
│   • Không phụ thuộc framework                                │
│   • Dễ test                                                  │
└────────────────────────────┬────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────┐
│                       DATA LAYER                             │
│                                                              │
│   Repository    ←──→    DataSource    ←──→    Models        │
│   (Impl)               (API/Local)           (JSON)          │
│                                                              │
│   • Tương tác với API, Database                              │
│   • Parse JSON → Model                                       │
│   • Implement Repository interface                            │
└─────────────────────────────────────────────────────────────┘
```

### Luồng dữ liệu:

```
User Tap Button
      │
      ▼
Widget gọi cubit.loadNotes()
      │
      ▼
Cubit gọi repository.getNotes()
      │
      ▼
Repository gọi dataSource.fetchNotes()
      │
      ▼
DataSource gọi API hoặc đọc local storage
      │
      ▼
Trả về data → Repository → Cubit emit State → Widget rebuild
```

---

## 📝 Naming Conventions

### 1. File names: `snake_case`
```
note_model.dart
notes_cubit.dart
notes_list_screen.dart
```

### 2. Class names: `PascalCase`
```dart
class NoteModel { }
class NotesCubit extends Cubit<NotesState> { }
class NotesListScreen extends StatelessWidget { }
```

### 3. Variables & functions: `camelCase`
```dart
final noteTitle = 'Hello';
void loadNotes() { }
```

### 4. Constants: `lowerCamelCase` hoặc `SCREAMING_SNAKE_CASE`
```dart
const primaryColor = Colors.blue;    // Cách 1 (Flutter style)
const PRIMARY_COLOR = Colors.blue;   // Cách 2 (ít dùng)
```

### 5. State classes: `Feature + State suffix`
```dart
// States cho NotesCubit
sealed class NotesState { }
class NotesInitial extends NotesState { }
class NotesLoading extends NotesState { }
class NotesLoaded extends NotesState { final List<Note> notes; }
class NotesError extends NotesState { final String message; }
```

### 6. Event classes: `Feature + Event + Action`
```dart
// Events cho NotesBloc
sealed class NotesEvent { }
class NotesLoadRequested extends NotesEvent { }
class NoteAddRequested extends NotesEvent { final Note note; }
class NoteDeleteRequested extends NotesEvent { final String id; }
```

---

## 🔧 Project Planning Checklist

Trước khi code bất kỳ project nào, hãy trả lời các câu hỏi sau:

### 1. 📋 Features List
> Ứng dụng có những tính năng gì?

```
✅ Notes App:
   - Xem danh sách notes
   - Tạo note mới
   - Sửa note
   - Xóa note
   - Tìm kiếm notes
   - Phân loại theo màu
```

### 2. 📊 Data Models
> Cần những data models nào?

```dart
// Notes App cần:
class Note {
  final String id;
  final String title;
  final String content;
  final Color color;
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

### 3. 🎨 Screens
> Ứng dụng có những màn hình nào?

```
Notes App:
├── NotesListScreen (danh sách)
├── NoteEditorScreen (tạo/sửa)
└── NoteDetailScreen (xem chi tiết - optional)
```

### 4. 🔄 State Management
> Cần quản lý những state nào?

```dart
// Notes App States:
- NotesInitial: Chưa load
- NotesLoading: Đang load
- NotesLoaded: Có data
- NotesError: Có lỗi
```

### 5. 📡 Data Sources
> Lấy data từ đâu?

```
- Local: SharedPreferences, Hive, SQLite
- Remote: REST API, GraphQL, Firebase
```

---

## 💻 Exercises Trong Phase 8

Phase 8 có **4 projects** với tổng cộng **20 exercises**:

| Project | Exercises | Focus chính |
|---------|-----------|-------------|
| Notes App | Ex01-05 | CRUD, Local Storage |
| Weather App | Ex06-10 | API Integration, BLoC |
| Shopping App | Ex11-15 | Cart Management, UI |
| Portfolio App | Ex16-20 | Navigation, Responsive |

Mỗi project được chia thành 5 exercises:
1. **Model** - Định nghĩa data
2. **State/BLoC** - Logic và state
3. **Screen 1** - Màn hình chính
4. **Screen 2** - Màn hình phụ
5. **Complete App** - Ghép tất cả lại

---

## ▶️ Bước Tiếp Theo

Bây giờ bạn đã hiểu cách tổ chức project, hãy bắt đầu với project đầu tiên:

➡️ [Lesson 02: Notes App](./lesson_02_notes_app.md)

---

## 🔑 Key Takeaways

1. **Tổ chức folder** theo features, không theo type
2. **3 layers**: Presentation → Domain → Data
3. **Naming conventions** nhất quán
4. **Planning trước** khi code
5. **Chia nhỏ project** thành các phần dễ quản lý
