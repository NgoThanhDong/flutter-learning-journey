# Lesson 6: Practice Projects 🚀

## Mục Tiêu

- Tổng hợp kiến thức đã học
- Xây dựng mini projects
- Áp dụng Clean Architecture thực tế

---

## Project 1: Notes App

### Yêu Cầu

Ứng dụng ghi chú với:
- CRUD operations (Create, Read, Update, Delete)
- Local storage (SharedPreferences)
- Clean Architecture structure
- Error handling với Either

### Cấu Trúc

```
lib/
├── core/
│   ├── failure.dart
│   └── usecase.dart
│
├── features/notes/
│   ├── data/
│   │   ├── datasources/note_local_datasource.dart
│   │   ├── models/note_model.dart
│   │   └── repositories/note_repository_impl.dart
│   │
│   ├── domain/
│   │   ├── entities/note.dart
│   │   ├── repositories/note_repository.dart
│   │   └── usecases/
│   │       ├── get_all_notes.dart
│   │       ├── add_note.dart
│   │       └── delete_note.dart
│   │
│   └── presentation/
│       ├── pages/notes_page.dart
│       └── viewmodels/notes_viewmodel.dart
│
└── injection_container.dart
```

### Key Components

#### Entity
```dart
class Note extends Equatable {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  
  const Note({...});
  
  @override
  List<Object?> get props => [id, title, content, createdAt];
}
```

#### Use Case
```dart
class AddNoteUseCase {
  final NoteRepository repository;
  
  Future<Either<Failure, Note>> call(AddNoteParams params) {
    return repository.addNote(params.title, params.content);
  }
}
```

#### ViewModel
```dart
class NotesViewModel extends ChangeNotifier {
  final GetAllNotesUseCase getAllNotes;
  final AddNoteUseCase addNote;
  final DeleteNoteUseCase deleteNote;
  
  // State management với Either
}
```

---

## Project 2: User Profile CRUD

### Yêu Cầu

Ứng dụng quản lý user với:
- Fetch users từ JSONPlaceholder API
- Display user list
- View user detail
- Create new user (mock)
- Clean Architecture với DI

### Cấu Trúc

```
lib/
├── core/
│   ├── network/dio_client.dart
│   ├── error/failures.dart
│   └── usecases/usecase.dart
│
├── features/users/
│   ├── data/
│   │   ├── datasources/user_remote_datasource.dart
│   │   ├── models/user_model.dart
│   │   └── repositories/user_repository_impl.dart
│   │
│   ├── domain/
│   │   ├── entities/user.dart
│   │   ├── repositories/user_repository.dart
│   │   └── usecases/
│   │       ├── get_users.dart
│   │       └── get_user_detail.dart
│   │
│   └── presentation/
│       ├── pages/
│       │   ├── user_list_page.dart
│       │   └── user_detail_page.dart
│       └── viewmodels/
│           ├── user_list_viewmodel.dart
│           └── user_detail_viewmodel.dart
│
└── injection_container.dart
```

### API Endpoints

```
GET  /users      → List all users
GET  /users/:id  → Get user by ID
POST /users      → Create user (mock)
```

---

## Checklist Hoàn Thành

### SOLID Principles
- [ ] Classes có single responsibility
- [ ] Mở rộng qua interface, không sửa code cũ
- [ ] Subclass thay thế được base class
- [ ] Interface nhỏ gọn, chuyên biệt
- [ ] Phụ thuộc abstraction (interface)

### Dependency Injection
- [ ] Setup get_it container
- [ ] Register all dependencies
- [ ] No direct instantiation trong widgets

### Repository Pattern
- [ ] Abstract repository trong Domain
- [ ] Data sources tách biệt
- [ ] Repository implementation trong Data

### Layer Separation
- [ ] Entity trong Domain (no serialization)
- [ ] Model trong Data (with serialization)
- [ ] Use Cases cho business logic
- [ ] ViewModel cho UI state

### Error Handling
- [ ] Either pattern cho return types
- [ ] Custom Failure classes
- [ ] User-friendly error messages

---

## Tips Thực Hành

### 1. Bắt đầu từ Domain
```
1. Define Entity (business object)
2. Define Repository interface
3. Create Use Cases
```

### 2. Sau đó Data layer
```
1. Create Model (with JSON)
2. Implement Data Sources
3. Implement Repository
```

### 3. Cuối cùng Presentation
```
1. Create ViewModel
2. Build UI Widgets
3. Connect với DI
```

### 4. Testing
```dart
// Mock repository
class MockUserRepository implements UserRepository {
  @override
  Future<Either<Failure, User>> getUserById(int id) async {
    return Right(User(id: 1, name: 'Test', email: 'test@test.com'));
  }
}

// Test use case
test('should return user from repository', () async {
  final useCase = GetUserUseCase(MockUserRepository());
  final result = await useCase(1);
  
  expect(result.isRight(), true);
});
```

---

## Bài Tập Thực Hành

- `ex17_notes_app_clean.dart` - Notes App với Clean Architecture
- `ex18_user_profile_clean.dart` - User Profile với API

---

## Kết Thúc Phase 6

Sau khi hoàn thành Phase 6, bạn đã có khả năng:

| Kỹ năng | Mức độ |
|---------|--------|
| SOLID Principles | ⭐⭐⭐ |
| Dependency Injection | ⭐⭐⭐ |
| Repository Pattern | ⭐⭐⭐ |
| Clean Architecture | ⭐⭐⭐ |
| Error Handling | ⭐⭐⭐ |

---

## Tiếp Theo

➡️ **Phase 7: BLoC Pattern** - State management nâng cao
