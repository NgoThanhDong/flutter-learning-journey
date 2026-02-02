# Lesson 07: Practice Projects Overview 🎯

Để thành thạo Navigation, chúng ta sẽ thực hành qua các bài tập sau:

## 1. Bottom Navigation với ShellRoute (Ex15)
- Xây dựng layout app chuẩn với thanh điều hướng bên dưới.
- Giữ trạng thái của các tab khi chuyển đổi.
- Sử dụng `go_router` với `StatefulShellRoute`.

## 2. Authentication Flow (Ex16)
- Xây dựng luồng đăng nhập hoàn chỉnh.
- Bảo vệ các route private bằng `redirect`.
- Tự động chuyển trang khi trạng thái login thay đổi (dùng Riverpod/Provider kết hợp).

## 3. E-commerce Navigation (Ex17)
- Mô phỏng app bán hàng.
- List sản phẩm -> Chi tiết sản phẩm (Dynamic Route với ID).
- Giỏ hàng (Cart).
- Xử lý Deep Link để share link sản phẩm.

## Lời khuyên khi làm bài tập:
- Đọc kỹ yêu cầu và comment trong code.
- Thử sửa URL trên trình duyệt để xem app phản ứng thế nào.
- Thử dùng nút Back của trình duyệt.
- Debug bằng cách đặt breakpoint trong hàm `redirect` để hiểu luồng đi.
