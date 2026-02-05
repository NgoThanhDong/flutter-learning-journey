# 📸 Screenshots - Phase 6: Clean Architecture

Thư mục này chứa screenshots minh họa cho các bài tập trong Phase 6.

---

## 🏗️ Các Chủ Đề

### 1. SOLID Principles (Ex01-05)
Các ví dụ minh họa 5 nguyên lý SOLID trong Flutter:
- **Single Responsibility**: Tách logic UI và calculation
- **Open/Closed**: Mở rộng tính năng không sửa core
- **Liskov Substitution**: Thay thế implementation không lỗi
- **Interface Segregation**: Chia nhỏ interface
- **Dependency Inversion**: Phụ thuộc abstraction

### 2. Dependency Injection (Ex06-08)
Minh họa cách quản lý dependencies:
- Manual DI (Constructor Injection)
- Service Locator với `get_it`
- Lazy Singleton vs Factory

### 3. Repository Pattern (Ex09-11)
Tách biệt Data access logic:
- Repository Interface
- Local vs Remote Datasources
- Repository Implementation

### 4. Layers Architecture (Ex12-14)
Phân chia ứng dụng thành 3 lớp:
- **Domain Layer**: Entities & Use Cases (Business Logic)
- **Data Layer**: Repositories & Models (Data Handling)
- **Presentation Layer**: UI & ViewModel (State Management)

### 5. Error Handling (Ex15-16)
Xử lý lỗi chuẩn Clean Arch:
- **Either Result**: Functional Error Handling
- **Failure Classes**: Typed Exceptions

### 6. Practice Projects (Ex17-18)
Ứng dụng hoàn chỉnh áp dụng Clean Architecture:
- **Notes App Clean**: Note management
- **User Profile**: Fetch user data

---

## 🚀 Cách Chụp Screenshot

```bash
# Chạy app
cd clean_app
flutter run -d chrome

# Chọn exercise muốn chụp từ màn hình chính
```

---

## 📁 Cấu Trúc

```
screenshots/
├── solid/
│   ├── srp_before_after.png
│   ├── ocp_extension.png
│   ├── lsp_shapes.png
│   ├── isp_interfaces.png
│   └── dip_switch.png
├── di/
│   ├── manual_di.png
│   └── get_it.png
├── repository/
│   ├── data_sources.png
│   └── repo_pattern.png
├── layers/
│   ├── domain_entities.png
│   ├── use_cases.png
│   └── presentation_vm.png
└── practice/
    ├── notes_clean.png
    └── user_profile.png
```
