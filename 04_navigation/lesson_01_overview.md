# Lesson 01: Navigation Overview 🧭

## 1. Bản chất của Navigation trong Flutter

Trong Flutter, màn hình (screen) hay trang (page) thực chất chỉ là các **Widgets**.
Navigation là việc **thay thế Widget này bằng Widget khác** để người dùng cảm thấy như họ đang di chuyển giữa các màn hình.

Flutter quản lý các màn hình này bằng một cấu trúc dữ liệu gọi là **Stack** (Ngăn xếp), với Widget quản lý chính là `Navigator`.

## 2. Navigation Stack

Hãy tưởng tượng một chồng đĩa:
- **Push**: Bạn đặt một chiếc đĩa mới lên trên cùng -> Màn hình mới hiện ra.
- **Pop**: Bạn lấy chiếc đĩa trên cùng ra -> Quay lại màn hình cũ.

```
[Screen C]  <- Top (Đang hiển thị)
[Screen B]
[Screen A]  <- Bottom (Màn hình gốc)
```

### Các hành động chính:
1. **Push**: Thêm màn hình vào stack.
2. **Pop**: Gỡ màn hình khỏi stack.
3. **Replace**: Thay thế màn hình hiện tại bằng màn hình mới.
4. **RemoveUntil**: Gỡ bỏ các màn hình bên dưới cho đến khi gặp điều kiện dừng (thường dùng cho Logout).

## 3. Imperative vs Declarative Navigation

### Imperative (Mệnh lệnh) - Navigator 1.0
- Phong cách cũ, đơn giản cho app nhỏ.
- Bạn ra lệnh trực tiếp: "Hãy mở màn hình X", "Hãy quay lại".
- Code: `Navigator.push(...)`, `Navigator.pop(...)`.
- **Nhược điểm**: Khó quản lý state phức tạp, deep linking (mở app từ URL), và web URL sync.

### Declarative (Khai báo) - Router API (Navigator 2.0)
- Phong cách hiện đại, khuyến nghị cho app lớn và Web.
- Bạn khai báo trạng thái của app (vd: `user = null` hay `user = loggedIn`), và Router tự quyết định hiển thị màn hình nào.
- Thư viện nổi tiếng: **go_router**.
- **Ưu điểm**: Hỗ trợ tốt Web URL, deep linking, nested routes, redirects.

## 4. Tại sao chúng ta sẽ học cả hai?

- **Navigator 1.0**: Vẫn rất phổ biến, dùng cho các dialog, bottom sheet, hoặc các luồng đơn giản (A -> B -> C).
- **go_router**: Tiêu chuẩn mới cho routing toàn bộ app, đặc biệt là auth flow và deep linking.

---

**Tiếp theo:** Chúng ta sẽ bắt đầu thực hành với **Navigator 1.0** trong Lesson 02.
