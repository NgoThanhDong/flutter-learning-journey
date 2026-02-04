# Lesson 7: Practice Projects 🎯

## Mục tiêu

Áp dụng tất cả kiến thức đã học vào các project thực tế.

---

## Project 1: Weather App 🌤️

### Yêu cầu:
- Lấy thời tiết từ Open-Meteo API (miễn phí, không cần key)
- Hiển thị nhiệt độ, độ ẩm, gió
- Loading states đầy đủ
- Cache kết quả

### API:
```
GET https://api.open-meteo.com/v1/forecast?latitude=21.03&longitude=105.85&current_weather=true
```

### Kỹ thuật:
- `http` hoặc `dio` cho API calls
- Model class cho Weather
- FutureBuilder cho UI
- SharedPreferences cho cache

### File: `ex15_weather_app.dart`

---

## Project 2: Todo CRUD App ✅

### Yêu cầu:
- CRUD với JSONPlaceholder API
- Hiển thị danh sách todos
- Thêm todo mới (POST)
- Xóa todo (DELETE)
- Toggle complete status

### API Endpoints:
```
GET    /todos          - Lấy danh sách
POST   /todos          - Tạo mới
PATCH  /todos/:id      - Cập nhật
DELETE /todos/:id      - Xóa
```

### Kỹ thuật:
- Dio với interceptors
- Todo model
- State management với setState
- Error handling

### File: `ex16_todo_api.dart`

---

## Checklist Đánh Giá

### HTTP & API
- [ ] Gọi GET request thành công
- [ ] Gọi POST với body
- [ ] Xử lý status codes
- [ ] Parse JSON response

### Models
- [ ] Tạo model với fromJson
- [ ] Implement toJson
- [ ] Handle nullable fields
- [ ] Parse nested objects

### UI States
- [ ] Loading indicator
- [ ] Error message với retry
- [ ] Empty state
- [ ] Success với data

### Storage
- [ ] Lưu dữ liệu vào local
- [ ] Đọc dữ liệu từ local
- [ ] Cache API responses
- [ ] Clear cache

---

## Tips

1. **Luôn test offline** - Tắt mạng để test error handling
2. **Console logging** - Print response để debug
3. **Modular code** - Tách logic vào services
4. **User feedback** - Luôn có loading/error states

---

---

## Bài Tập Thực Hành

- `ex15_weather_app.dart` - Ứng dụng xem thời tiết (Open-Meteo API)
- `ex16_todo_api.dart` - Ứng dụng Todo List (CRUD với JSONPlaceholder)

---

## Kết Thúc Phase 5

Sau khi hoàn thành Phase 5, bạn đã có khả năng:

✅ Gọi REST APIs  
✅ Parse JSON thành Dart objects  
✅ Xử lý các trạng thái UI  
✅ Lưu trữ dữ liệu offline  
✅ Implement caching  

---

## Phase Tiếp Theo

➡️ **Phase 6: Clean Architecture** - Tổ chức code chuyên nghiệp
