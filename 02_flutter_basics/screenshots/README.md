# Screenshots - Hình Mẫu UI

Thư mục này chứa ảnh mẫu UI để bạn tham khảo khi làm bài tập.

---

## 📁 Danh Sách Screenshots

| Exercise | File | Mô tả |
|----------|------|-------|
| Ex 02 | [ex02_counter_app.png](ex02_counter_app.png) | Counter App với nút +/- |
| Ex 05 | [ex05_profile_card.png](ex05_profile_card.png) | Profile Card với avatar |
| Ex 06 | [ex06_product_card.png](ex06_product_card.png) | Product Card e-commerce |
| Ex 12 | [ex12_contact_list.png](ex12_contact_list.png) | Contact List với avatar |
| Ex 15 | [ex15_login_form.png](ex15_login_form.png) | Login Form với validation |
| Ex 20 | [ex20_login_screen.png](ex20_login_screen.png) | Complete Login Screen |

---

## 🎯 Cách Sử Dụng

### 1. Xem ảnh mẫu TRƯỚC khi code
Mở ảnh tương ứng với bài tập bạn đang làm để hiểu:
- Bố cục (layout) tổng thể
- Các thành phần (components) cần tạo
- Màu sắc và style

### 2. Phân tích UI thành code
Ví dụ với Profile Card:
```
Card
└── Column
    ├── CircleAvatar ← Avatar
    ├── Text (bold) ← Tên
    ├── Text (gray) ← Bio
    └── Row ← Location
        ├── Icon (location)
        └── Text
```

### 3. Code theo từng phần
Bắt đầu từ ngoài vào trong:
1. Scaffold → AppBar
2. Body → Card
3. Card → Column
4. Từng widget con

---

## 📝 Lưu Trữ Kết Quả

Khi hoàn thành bài tập, tự chụp screenshot để so sánh và làm portfolio:

### Trên Chrome (Flutter Web)
1. Nhấn `F12` để mở DevTools
2. Nhấn `Ctrl + Shift + P`
3. Gõ "screenshot"
4. Chọn "Capture screenshot"
5. Lưu vào thư mục này với tên: `my_ex02_counter.png`

---

## 💡 Tips

- So sánh kết quả của bạn với ảnh mẫu
- Không cần giống 100%, quan trọng là hiểu cách xây dựng UI
- Thử customize màu sắc, font chữ theo ý bạn sau khi hoàn thành
