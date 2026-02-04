# Lesson 1: API Overview 🌐

## Mục tiêu

- Hiểu REST API là gì
- Nắm vững HTTP methods
- Hiểu cấu trúc JSON
- Biết các status codes quan trọng

---

## 1. REST API là gì?

**REST** (Representational State Transfer) là một kiến trúc thiết kế API phổ biến nhất hiện nay.

### Đặc điểm:
- **Stateless**: Server không lưu trạng thái client
- **Resource-based**: Mọi thứ là resource (user, post, comment...)
- **URL = Resource**: `/users`, `/posts/1`
- **HTTP Methods = Actions**: GET, POST, PUT, DELETE

---

## 2. HTTP Methods

| Method | Mục đích | Ví dụ |
|--------|----------|-------|
| **GET** | Lấy dữ liệu | `GET /users` → Lấy danh sách users |
| **POST** | Tạo mới | `POST /users` → Tạo user mới |
| **PUT** | Cập nhật toàn bộ | `PUT /users/1` → Update toàn bộ user 1 |
| **PATCH** | Cập nhật một phần | `PATCH /users/1` → Update một field |
| **DELETE** | Xóa | `DELETE /users/1` → Xóa user 1 |

### GET Request Flow
```
[Flutter App] --GET /users--> [Server]
              <--JSON response--
```

### POST Request Flow
```
[Flutter App] --POST /users + body--> [Server]
              <--Created user JSON--
```

---

## 3. JSON - JavaScript Object Notation

JSON là định dạng dữ liệu phổ biến nhất để truyền giữa client và server.

### Ví dụ JSON:
```json
{
  "id": 1,
  "name": "John Doe",
  "email": "john@example.com",
  "isActive": true,
  "tags": ["developer", "flutter"],
  "address": {
    "city": "Hanoi",
    "country": "Vietnam"
  }
}
```

### Kiểu dữ liệu trong JSON:
| JSON | Dart |
|------|------|
| `"string"` | `String` |
| `123` | `int` |
| `12.5` | `double` |
| `true/false` | `bool` |
| `[...]` | `List` |
| `{...}` | `Map<String, dynamic>` |
| `null` | `null` |

---

## 4. HTTP Status Codes

| Code | Ý nghĩa | Khi nào gặp |
|------|---------|-------------|
| **200** | OK | Request thành công |
| **201** | Created | Tạo resource thành công |
| **204** | No Content | Xóa thành công |
| **400** | Bad Request | Dữ liệu gửi lên sai |
| **401** | Unauthorized | Chưa đăng nhập |
| **403** | Forbidden | Không có quyền |
| **404** | Not Found | Resource không tồn tại |
| **500** | Server Error | Lỗi server |

### Code Groups:
- **2xx**: Thành công ✅
- **3xx**: Redirect ↩️
- **4xx**: Lỗi client (do bạn gây ra) ❌
- **5xx**: Lỗi server (do server) 💥

---

## 5. Headers

Headers chứa thông tin bổ sung cho request/response.

### Headers quan trọng:
| Header | Ý nghĩa | Ví dụ |
|--------|---------|-------|
| `Content-Type` | Định dạng body | `application/json` |
| `Authorization` | Token xác thực | `Bearer xyz123` |
| `Accept` | Định dạng mong muốn | `application/json` |

---

## 6. Request & Response Structure

### Request:
```
POST /api/users HTTP/1.1
Host: example.com
Content-Type: application/json
Authorization: Bearer token123

{
  "name": "John",
  "email": "john@example.com"
}
```

### Response:
```
HTTP/1.1 201 Created
Content-Type: application/json

{
  "id": 1,
  "name": "John",
  "email": "john@example.com",
  "createdAt": "2024-01-01T00:00:00Z"
}
```

---

## 7. Free APIs để Practice

| API | URL | Dữ liệu |
|-----|-----|---------|
| JSONPlaceholder | `jsonplaceholder.typicode.com` | Users, Posts, Comments |
| Open-Meteo | `open-meteo.com` | Weather |
| Random User | `randomuser.me` | Fake users |

### Ví dụ API Endpoint:
```
GET https://jsonplaceholder.typicode.com/users
GET https://jsonplaceholder.typicode.com/users/1
GET https://jsonplaceholder.typicode.com/posts?userId=1
```

---

## 8. Flutter HTTP Flow

```
┌─────────────────┐
│   Flutter UI    │
└────────┬────────┘
         │ User action (button tap)
         ▼
┌─────────────────┐
│  HTTP Request   │  ← Gửi request
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│    Internet     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│     Server      │  ← Xử lý request
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  JSON Response  │  ← Trả về JSON
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Parse to Dart  │  ← Convert JSON → Dart object
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Update UI     │  ← Hiển thị dữ liệu
└─────────────────┘
```

---

## Tóm Tắt

1. **REST API** = Giao tiếp qua HTTP với resources
2. **GET** = Lấy, **POST** = Tạo, **PUT/PATCH** = Sửa, **DELETE** = Xóa
3. **JSON** = Định dạng dữ liệu phổ biến nhất
4. **Status codes** = Cho biết kết quả request
5. **Headers** = Metadata cho request/response

---

---

## Bài Tập Liên Quan

- `ex01_simple_get.dart` - Xem trước cách gọi GET request

---

## Bài Tiếp Theo

➡️ [Lesson 2: http Package](lesson_02_http_package.md) - Bắt đầu code!
