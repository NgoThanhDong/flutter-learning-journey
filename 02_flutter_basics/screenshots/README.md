# 📸 Screenshots & Demo Guide
Đây là thư mục mô tả các màn hình (Screens) bạn sẽ thấy khi chạy ứng dụng Flutter.
Vì đây là hướng dẫn text, tôi sẽ mô tả chi tiết những gì bạn sẽ thấy và tương tác được ở mỗi bài tập.
---
## 🏠 Main Menu (`main.dart`)
Màn hình đầu tiên khi mở app.
- **Giao diện**: Một danh sách cuộn dọc, chia thành 8 nhóm bài học (Lesson 1 -> 8).
- **Tương tác**: Bấm vào bất kỳ dòng nào (Ví dụ: "Ex 01: Hello Flutter") để mở bài tập đó. Bấm nút Back trên AppBar (hoặc nút Back của điện thoại) để quay lại Menu.
---
## 📝 Lesson 1: Introduction
### `Ex 01: Hello Flutter`
- **UI**: Một màn hình trắng đơn giản. AppBar có title "My First App". Ở giữa màn hình có dòng chữ "Hello, [Tên]!" to và đậm.
- **Tương tác**: Bấm vào icon Settings trên góc phải AppBar -> Hiện thông báo "Settings clicked!".
---
## 🧩 Lesson 2: Widget Fundamentals
### `Ex 02: Counter App`
- **UI**: Số 0 khổ lồ ở giữa. Hai nút tròn to bên dưới: (-) và (+).
- **Tương tác**:
    - Bấm (+) -> Số tăng lên.
    - Bấm (-) -> Số giảm xuống.
    - Nếu số là 0 mà bấm (-) -> Hiện thông báo "Counter is not negative!".
    - Bấm nút Refresh (góc phải dưới) -> Reset về 0.
### `Ex 03: Toggle Theme`
- **UI**: Màn hình đổi màu khi bấm nút.
- **Tương tác**: Bấm nút "Toggle":
    - Chế độ Sáng: Nền trắng, Icon Mặt trời cam.
    - Chế độ Tối: Nền đen, Icon Mặt trăng vàng.
### `Ex 04: Like Button`
- **UI**: Một nút Trái tim kèm số lượng Like (99 Likes).
- **Tương tác**: Bấm vào Trái tim:
    - Chưa like -> Tim đỏ ❤️, số like nhảy lên 100.
    - Đã like -> Tim xám ♡, số like giảm về 99.
---
## 🧱 Lesson 3: Basic Widgets
### `Ex 05: Profile Card`
- **UI**: Một thẻ card nổi (có bóng đổ) ở giữa màn hình.
- **Nội dung**: Ảnh avatar tròn, tên "John Doe" đậm, dòng mô tả nghề nghiệp và địa điểm có icon check-in.
### `Ex 06: Product Card`
- **UI**: Thẻ sản phẩm giống Shopee/Lazada.
- **Nội dung**: Ảnh tai nghe, tag "Sale" (nếu có), sao đánh giá vàng ⭐, giá tiền $129.00 xanh dương và nút giỏ hàng.
### `Ex 07: Social Post Card`
- **UI**: Mô phỏng 1 bài đăng Facebook.
- **Nội dung**: Header (Avatar + Tên + Giờ), Nội dung status text, Ảnh bài đăng to ở giữa, Footer có 3 nút: Like, Comment, Share.
---
## 📐 Lesson 4: Layout
### `Ex 08: Navigation Bar`
- **UI**: Thanh công cụ nằm sát đáy màn hình.
- **Nội dung**: 4 Icon (Home, Search, Favorite, Profile). Icon "Home" đang sáng màu xanh (Active), các icon khác màu xám.
### `Ex 09: Price Row`
- **UI**: Danh sách 3 món hàng kiểu giỏ hàng.
- **Layout**: Tên hàng (bên trái) --- Số lượng (ở giữa) --- Giá tổng (bên phải). Layout dùng `Row` và `Expanded` để căn chỉnh thẳng hàng đẹp mắt.
### `Ex 10: Profile Header`
- **UI**: Giao diện trang cá nhân.
- **Layout**: Ảnh bìa chữ nhật ở trên cùng. Avatar tròn nằm đè lên ranh giới giữa ảnh bìa và phần trắng bên dưới (dùng `Stack`). Tên người dùng bên dưới avatar.
### `Ex 11: Grid Layout`
- **UI**: Bảng thống kê (Dashboard) dạng lưới 2x2.
- **Nội dung**: 4 thẻ màu sắc khác nhau (Users, Orders, Revenue, Rating) xếp thành 2 hàng, 2 cột.
---
## 📜 Lesson 5: Scrollable
### `Ex 12: Contact List`
- **UI**: Danh sách dọc dài 20 người.
- **Nội dung**: Mỗi dòng có Avatar (chữ cái đầu), Tên, Số điện thoại và nút gọi xanh lá. Có đường kẻ mờ phân cách giữa các dòng.
- **Tương tác**: Cuộn mượt mà.
### `Ex 13: Product Grid`
- **UI**: Lưới sản phẩm 2 cột.
- **Nội dung**: 20 sản phẩm giả lập. Mỗi ô có hình ảnh và giá tiền. Cuộn dọc.
### `Ex 14: Horizontal Categories`
- **UI**: Một hàng các nút Category (All, Fashion, Shoes...) chạy ngang.
- **Tương tác**: Có thể vuốt ngang để xem thêm. Bấm vào nút nào nút đó đổi màu xanh dương (Selected).
---
## 📝 Lesson 6: Input & Forms
### `Ex 15: Login Form`
- **UI**: Form đăng nhập chuẩn.
- **Field**: Email (có kiểm tra @), Password (có nút mắt để ẩn/hiện mật khẩu), Checkbox "Remember me".
- **Tương tác**: Bấm LOGIN nếu để trống sẽ báo lỗi đỏ.
### `Ex 16: Registration Form`
- **UI**: Form đăng ký dài.
- **Field**: Tên, Email, Giới tính (Chọn 1 trong 2: Male/Female), Điều khoản (Checkbox).
- **Tương tác**: Phải tick chọn "Agree to Terms" mới được Register.
### `Ex 17: Settings Page`
- **UI**: Trang cài đặt giống Android/iOS.
- **Nội dung**:
    - Switch bật/tắt Thông báo.
    - Switch bật/tắt Dark Mode.
    - Dropdown chọn Ngôn ngữ (English/Vietnamese).
    - Nút Logout màu đỏ.
- **Tương tác**: Bấm Logout hiện hộp thoại (Dialog) hỏi "Are you sure?".
---
## 🎨 Lesson 7: Styling
### `Ex 18: App Theme`
- **UI**: Demo màu sắc chủ đạo (Primary Color) màu Tím (DeepPurple).
- **Nội dung**: Các nút bấm và chữ tiêu đề đều ăn theo màu tím này một cách tự động nhờ `ThemeData`.
### `Ex 19: Dark Mode Toggle`
- **UI**: Công tắc chuyển đổi giao diện Sáng/Tối toàn diện.
- **Hiệu ứng**: Khi bật Dark Mode, nền chuyển xám đen, chữ chuyển trắng, thẻ card chuyển màu tương ứng.
---
## 🏆 Lesson 8: Practice Projects
### `Ex 20: Login Screen (Complete)`
- **UI**: Màn hình đăng nhập đẹp, hiện đại (Professional UI).
- **Chi tiết**: Logo to, Login form, Social Login (Google, Facebook), Sign up link. Thiết kế chỉn chu, có khoảng trắng hợp lý (Padding).
### `Ex 21: E-commerce Home`
- **UI**: Trang chủ app bán hàng hoàn chỉnh.
- **Structure**:
    1. Search bar trên cùng.
    2. Banner quảng cáo to.
    3. Danh sách danh mục (cuộn ngang).
    4. Lưới sản phẩm bán chạy (Popular).
    5. Bottom Tab Bar giả lập.
### `Ex 22: Chat UI`
- **UI**: Màn hình nhắn tin chi tiết.
- **Nội dung**:
    - List tin nhắn: Tin nhắn của mình màu xanh (bên phải), của người khác màu xám (bên trái).
    - Thanh nhập liệu: Có nút gửi và attach file ở dưới cùng.
- **Tương tác**: Nhập tin nhắn bấm Gửi -> Tin nhắn mới hiện ra ngay lập tức ở dưới cùng.
---
**Chúc bạn code vui và tạo ra những giao diện tuyệt đẹp!** 🚀
