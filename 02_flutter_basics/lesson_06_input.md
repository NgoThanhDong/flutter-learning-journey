# Bài 6: Input Widgets - TextField, Button, Form

## 🎯 Mục tiêu
- Thành thạo TextField và TextEditingController
- Sử dụng các loại Button
- Tạo Form với validation

---

## 1. TextField - Ô Nhập Liệu

### 1.1 Cơ bản

```dart
// TextField là widget để nhập liệu
TextField(
  decoration: InputDecoration( // InputDecoration là widget để trang trí TextField
    labelText: 'Username', // Label text
    hintText: 'Enter your username', // Hint text
  ),
)
```

### 1.2 TextEditingController - Lấy giá trị

```dart
class _MyFormState extends State<MyForm> {
  // Khai báo controller
  // TextEditingController là widget để quản lý nội dung của TextField
  final TextEditingController _nameController = TextEditingController();
  
  @override
  void dispose() {
    _nameController.dispose(); // QUAN TRỌNG: Dispose! vì nếu không dispose thì sẽ bị rò rỉ bộ nhớ
    super.dispose();
  }
  
  // Hàm submit để lấy giá trị của TextField
  void _submit() {
    String name = _nameController.text; // Lấy giá trị của TextField
    print('Name: $name');
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField( // TextField là widget để nhập liệu
          controller: _nameController, // TextEditingController là widget để quản lý nội dung của TextField
          decoration: InputDecoration(labelText: 'Name'), // InputDecoration là widget để trang trí TextField
        ),
        ElevatedButton( // ElevatedButton là widget để tạo nút bấm
          onPressed: _submit, // Hàm submit để lấy giá trị của TextField
          child: Text('Submit'), // Text là widget để hiển thị chữ
        ),
      ],
    );
  }
}
```

### 1.3 InputDecoration đầy đủ

```dart
TextField(
  controller: _controller, // TextEditingController là widget để quản lý nội dung của TextField
  
  decoration: InputDecoration( // InputDecoration là widget để trang trí TextField
    // Label
    labelText: 'Email', // Label text là text hiển thị trên TextField
    labelStyle: TextStyle(color: Colors.grey), // Label style là style của label text
    
    // Hint
    hintText: 'example@email.com', // Hint text là text hiển thị khi chưa nhập gì
    hintStyle: TextStyle(color: Colors.grey[400]), // Hint style là style của hint text
    
    // Helper text
    helperText: 'Enter a valid email', // Helper text là text hiển thị dưới TextField
    
    // Error text
    errorText: _hasError ? 'Invalid email' : null, // Error text là text hiển thị khi có lỗi
    
    // Prefix
    prefixIcon: Icon(Icons.email), // Prefix icon là icon ở đầu TextField
    prefixText: '+84 ', // Prefix text là text ở đầu TextField
    
    // Suffix
    suffixIcon: IconButton( // Suffix icon là icon ở cuối TextField
      icon: Icon(Icons.clear), // Clear icon
      onPressed: () => _controller.clear(), // Clear text
    ),
    
    // Counter
    counterText: '${_controller.text.length}/50', // Counter text là text hiển thị số ký tự
    
    // Border
    border: OutlineInputBorder( // Border là viền của TextField
      borderRadius: BorderRadius.circular(12), // Border radius là bo góc của TextField
    ),
    
    // Focused border
    focusedBorder: OutlineInputBorder( // Focused border là viền của TextField khi được focus
      borderRadius: BorderRadius.circular(12), // Border radius là bo góc của TextField
      borderSide: BorderSide(color: Colors.blue, width: 2), // Border side là viền của TextField
    ),
    
    // Enabled border
    enabledBorder: OutlineInputBorder( // Enabled border là viền của TextField khi được enable
      borderRadius: BorderRadius.circular(12), // Border radius là bo góc của TextField
      borderSide: BorderSide(color: Colors.grey), // Border side là viền của TextField
    ),
    
    // Error border
    errorBorder: OutlineInputBorder( // Error border là viền của TextField khi có lỗi
      borderRadius: BorderRadius.circular(12), // Border radius là bo góc của TextField
      borderSide: BorderSide(color: Colors.red), // Border side là viền của TextField
    ),
    
    // Filled
    filled: true, // Filled là true khi TextField được filled (điền đầy nội dung)
    fillColor: Colors.grey[100], // Fill color là màu nền của TextField
    
    // Content padding là khoảng cách giữa nội dung và viền của TextField
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12), 
  ),
)
```

### 1.4 TextField Properties

```dart
TextField(
  controller: _controller, // TextEditingController là widget để quản lý nội dung của TextField
  
  // Keyboard type
  keyboardType: TextInputType.emailAddress, // TextInputType là widget để xác định loại bàn phím
  // TextInputType.text, number, phone, url, multiline
  
  // Text input action (nút trên keyboard)
  textInputAction: TextInputAction.next, // TextInputAction là widget để xác định hành động của nút trên keyboard
  // TextInputAction.done, search, send, go
  
  // Max lines
  maxLines: 1,         // Single line
  // maxLines: null,   // Unlimited (multiline)
  // maxLines: 5,      // Max 5 lines
  
  // Max length
  maxLength: 100,
  
  // Obscure text (password)
  obscureText: true, // Obscure text là true khi TextField được obscure (ẩn nội dung)
  
  // Auto focus
  autofocus: true, // Auto focus là true khi TextField được focus
  
  // Enabled/Disabled
  enabled: true, // Enabled là true khi TextField được enable
  
  // Read only
  readOnly: false, // Read only là true khi TextField được read only
  
  // Text capitalization
  textCapitalization: TextCapitalization.words, // Text capitalization là widget để xác định cách viết hoa của text
  // TextCapitalization.sentences, characters, none
  
  // Callbacks
  onChanged: (value) { // On changed là callback được gọi khi nội dung của TextField thay đổi
    print('Changed: $value');
  },
  onSubmitted: (value) { // On submitted là callback được gọi khi nội dung của TextField được submit
    print('Submitted: $value');
  },
  onTap: () { // On Tap là callback được gọi khi nội dung của TextField được tap (click) 
    print('Tapped');
  },
)
```

### 1.5 Password Field với Toggle

```dart
class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true; // _obscureText là biến để xác định nội dung của TextField có được ẩn hay không
  final _controller = TextEditingController(); // _controller là TextEditingController để quản lý nội dung của TextField
  
  @override
  Widget build(BuildContext context) { // Build là phương thức để xây dựng giao diện của widget
    return TextField( // TextField là widget để nhập văn bản
      controller: _controller, // Controller là widget để quản lý nội dung của TextField
      obscureText: _obscureText, // Obscure text là true khi TextField được obscure (ẩn nội dung)
      decoration: InputDecoration( // InputDecoration là widget để trang trí TextField
        labelText: 'Password', // Label text là text hiển thị trên TextField
        prefixIcon: Icon(Icons.lock), // Prefix icon là icon ở đầu TextField
        suffixIcon: IconButton( // Suffix icon là icon ở cuối TextField
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () { // On pressed là callback được gọi khi icon được tap (click)
            setState(() { // Set state là phương thức để cập nhật trạng thái của widget
              _obscureText = !_obscureText; // _obscureText được cập nhật
            });
          },
        ),
      ),
    );
  }
}
```

---

## 2. Button Widgets

### 2.1 ElevatedButton (Primary) - Nút chính (Primary action) - Có nền + đổ bóng

```dart
ElevatedButton(
  onPressed: () { // On pressed là callback được gọi khi nút được tap (click)
    print('Pressed!'); // Print là phương thức để in ra nội dung
  },
  child: Text('Submit'), // Child là widget con của ElevatedButton
)

// Disabled
ElevatedButton(
  onPressed: null, // null = disabled
  child: Text('Disabled'),
)

// Styled
ElevatedButton(
  onPressed: () {}, // On pressed là callback được gọi khi nút được tap (click)
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue, // Background color là màu nền của ElevatedButton
    foregroundColor: Colors.white, // Foreground color là màu chữ của ElevatedButton
    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16), // Padding là khoảng cách giữa nội dung và viền của ElevatedButton
    shape: RoundedRectangleBorder( // Shape là widget để tạo hình dạng của ElevatedButton
      borderRadius: BorderRadius.circular(12), // Border radius là góc bo tròn của ElevatedButton
    ),
    elevation: 4, // Elevation là độ cao của ElevatedButton
  ),
  child: Text('Styled Button'), // Child là widget con của ElevatedButton
)
```

### 2.2 TextButton (Flat) - Nút phụ / hành động nhẹ - Không nền, không viền

```dart
TextButton(
  onPressed: () {},
  child: Text('Text Button'),
)

TextButton(
  onPressed: () {}, // On pressed là callback được gọi khi nút được tap (click)
  style: TextButton.styleFrom( // Style là widget để tạo kiểu cho TextButton
    foregroundColor: Colors.blue, // Foreground color là màu chữ của TextButton
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding là khoảng cách giữa nội dung và viền của TextButton
  ),
  child: Text('Cancel'), // Child là widget con của TextButton
)
```

### 2.3 OutlinedButton - Nút trung gian - Có viền, không nền

```dart
OutlinedButton(
  onPressed: () {},
  child: Text('Outlined'),
)

OutlinedButton(
  onPressed: () {},
  style: OutlinedButton.styleFrom( // Style là widget để tạo kiểu cho OutlinedButton
    foregroundColor: Colors.blue, // Foreground color là màu chữ của OutlinedButton
    side: BorderSide(color: Colors.blue, width: 2), // Side là viền của OutlinedButton
    shape: RoundedRectangleBorder( // Shape là widget để tạo hình dạng của OutlinedButton
      borderRadius: BorderRadius.circular(12), // Border radius là góc bo tròn của OutlinedButton
    ),
  ),
  child: Text('Outlined'),
)
```

### 2.4 IconButton - Nút chỉ có icon

```dart
IconButton(
  icon: Icon(Icons.favorite), // Icon là widget để hiển thị icon
  iconSize: 30, // Icon size là kích thước của icon
  color: Colors.red, // Color là màu của icon
  onPressed: () {}, // On pressed là callback được gọi khi nút được tap (click)
)
```

### 2.5 FloatingActionButton - Hành động nổi bật nhất toàn màn hình
Nút tròn, nổi trên UI. Thường chỉ 1 FAB / screen

```dart
FloatingActionButton(
  onPressed: () {},
  child: Icon(Icons.add),
)

// Extended
FloatingActionButton.extended(
  onPressed: () {},
  icon: Icon(Icons.add),
  label: Text('Add Item'),
)
```

### 2.6 Button với Icon

```dart
ElevatedButton.icon(
  onPressed: () {},
  icon: Icon(Icons.send),
  label: Text('Send'),
)

TextButton.icon(
  onPressed: () {},
  icon: Icon(Icons.download),
  label: Text('Download'),
)
```

### 2.7 Full-width Button

```dart
SizedBox(
  width: double.infinity, // double.infinity = full width
  child: ElevatedButton(
    onPressed: () {},
    child: Text('Full Width Button'),
  ),
)
```

---

## 3. GestureDetector & InkWell

### 3.1 GestureDetector - Bắt gesture thuần (tap, double tap, long press, drag, scale…), Ko hiệu ứng (splash, ripple)

```dart
GestureDetector(
  onTap: () => print('Tap'), // sự kiện tap (nhấn và thả)
  onDoubleTap: () => print('Double tap'), // sự kiện double tap (nhấn 2 lần)
  onLongPress: () => print('Long press'), // sự kiện nhấn giữ
  onPanUpdate: (details) => print('Drag: ${details.delta}'), // sự kiện kéo (drag) khi ngón tay / chuột đang DI CHUYỂN
  
  child: Container(
    width: 100,
    height: 100,
    color: Colors.blue,
    child: Center(child: Text('Tap me')),
  ),
)
```
### 3.2 InkWell - Với hiệu ứng ripple (sóng nước)

```dart
InkWell(
  onTap: () => print('Tapped'),
  borderRadius: BorderRadius.circular(12), // bo góc
  splashColor: Colors.blue.withOpacity(0.3), // màu hiệu ứng ripple
  highlightColor: Colors.blue.withOpacity(0.1), // màu hiệu ứng khi nhấn
  
  child: Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text('Tap for ripple effect'),
  ),
)
```

---

## 4. Form & Validation

### 4.1 Form Widget

```dart
class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // Form key
  final _formKey = GlobalKey<FormState>(); // GlobalKey là widget để quản lý trạng thái của Form
  
  // Controllers
  final _emailController = TextEditingController(); // TextEditingController là widget để quản lý trạng thái của TextField
  final _passwordController = TextEditingController(); 

  @override
  void dispose() {
    _emailController.dispose(); // dispose() là phương thức để giải phóng tài nguyên của widget
    _passwordController.dispose();
    super.dispose();
  }
  
  // Submit form để validate và in ra kết quả
  void _submit() {
    // Validate
    if (_formKey.currentState!.validate()) { // validate() là phương thức để kiểm tra trạng thái của Form
      // Form is valid
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey, // Gán form key cho Form
      child: Column(
        children: [
          // Email field
          TextFormField(
            controller: _emailController, // Gán controller cho TextField
            decoration: InputDecoration(labelText: 'Email'), // InputDecoration là widget để tạo kiểu cho TextField
            keyboardType: TextInputType.emailAddress, // TextInputType là widget để tạo kiểu cho TextField
            validator: (value) { // Validator là widget để kiểm tra trạng thái của TextField
              if (value == null || value.isEmpty) { // Kiểm tra nếu value rỗng
                return 'Please enter email'; // Trả về thông báo lỗi
              }
              if (!value.contains('@')) { // Kiểm tra nếu value không chứa @
                return 'Please enter valid email'; // Trả về thông báo lỗi
              }
              return null; // Valid
            },
          ),
          
          SizedBox(height: 16),
          
          // Password field
          TextFormField(
            controller: _passwordController, // Gán controller cho TextField
            decoration: InputDecoration(labelText: 'Password'), // InputDecoration là widget để tạo kiểu cho TextField
            obscureText: true, // obscureText là widget để ẩn password
            validator: (value) { // Validator là widget để kiểm tra trạng thái của TextField
              if (value == null || value.isEmpty) { // Kiểm tra nếu value rỗng
                return 'Please enter password'; // Trả về thông báo lỗi
              }
              if (value.length < 6) { // Kiểm tra nếu value có ít hơn 6 ký tự
                return 'Password must be at least 6 characters'; // Trả về thông báo lỗi
              }
              return null; // Valid
            },
          ),
          
          SizedBox(height: 24),
          
          // Submit button
          SizedBox(
            width: double.infinity, // double.infinity = full width
            child: ElevatedButton(
              onPressed: _submit, // Gán callback cho button
              child: Text('Login'), // Text là widget để hiển thị text
            ),
          ),
        ],
      ),
    );
  }
}
```

### 4.2 TextFormField vs TextField

| TextFormField | TextField |
|---------------|-----------|
| Có `validator` | Không có |
| Dùng trong Form | Dùng độc lập |
| Có `onSaved` | Không có |

### 4.3 Common Validators

```dart
// Email validator
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) { // Kiểm tra nếu value rỗng
    return 'Email is required'; // Trả về thông báo lỗi
  }
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'); // Regex để kiểm tra email
  if (!emailRegex.hasMatch(value)) { // Kiểm tra nếu value không chứa @
    return 'Enter a valid email'; // Trả về thông báo lỗi
  }
  return null;
}

// Password validator
String? validatePassword(String? value) {
  if (value == null || value.isEmpty) { // Kiểm tra nếu value rỗng
    return 'Password is required'; // Trả về thông báo lỗi
  }
  if (value.length < 8) { // Kiểm tra nếu value có ít hơn 8 ký tự
    return 'Password must be at least 8 characters'; // Trả về thông báo lỗi
  }
  if (!value.contains(RegExp(r'[A-Z]'))) { // Kiểm tra nếu value không chứa chữ hoa
    return 'Password must contain uppercase letter'; // Trả về thông báo lỗi
  }
  if (!value.contains(RegExp(r'[0-9]'))) { // Kiểm tra nếu value không chứa số
    return 'Password must contain number'; // Trả về thông báo lỗi
  }
  return null; // Valid
}

// Phone validator
String? validatePhone(String? value) {
  if (value == null || value.isEmpty) { // Kiểm tra nếu value rỗng
    return 'Phone is required'; // Trả về thông báo lỗi
  }
  if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) { // Kiểm tra nếu value không chứa số
    return 'Enter valid 10-digit phone'; // Trả về thông báo lỗi
  }
  return null;
}
```

---

## 5. Checkbox, Radio, Switch

### 5.1 Checkbox

```dart
class _MyWidgetState extends State<MyWidget> {
  bool _isChecked = false; // Khai báo biến để lưu trạng thái của checkbox
  
  @override
  Widget build(BuildContext context) {
    // Checkbox là widget để tạo checkbox
    return Checkbox(
      value: _isChecked, // Giá trị của checkbox
      onChanged: (bool? value) { // Callback khi checkbox thay đổi
        setState(() { // setState để cập nhật trạng thái của widget
          _isChecked = value ?? false; // Cập nhật giá trị của checkbox
        });
      },
    );
  }
}

// CheckboxListTile là widget để tạo checkbox với tiêu đề và mô tả
CheckboxListTile(
  title: Text('Accept terms'), // Tiêu đề của checkbox
  subtitle: Text('I agree to the terms and conditions'), // Mô tả của checkbox
  value: _isChecked, // Giá trị của checkbox
  onChanged: (value) { // Callback khi checkbox thay đổi
    setState(() => _isChecked = value ?? false); // Cập nhật giá trị của checkbox
  },
)
```

### 5.2 Radio

```dart
enum Gender { male, female, other }

class _MyWidgetState extends State<MyWidget> {
  Gender? _selectedGender; // Khai báo biến để lưu trạng thái của radio
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile<Gender>( // RadioListTile là widget để tạo radio với tiêu đề và mô tả
          title: Text('Male'), // Tiêu đề của radio
          value: Gender.male, // Giá trị của radio
          groupValue: _selectedGender, // Giá trị của group
          onChanged: (Gender? value) { // Callback khi radio thay đổi
            setState(() => _selectedGender = value); // Cập nhật giá trị của radio
          },
        ),
        RadioListTile<Gender>(
          title: Text('Female'), // Tiêu đề của radio
          value: Gender.female, // Giá trị của radio
          groupValue: _selectedGender, // Giá trị của group
          onChanged: (Gender? value) { // Callback khi radio thay đổi
            setState(() => _selectedGender = value); // Cập nhật giá trị của radio
          },
        ),
      ],
    );
  }
}
```

### 5.3 Switch

```dart
Switch(
  value: _isEnabled, // Giá trị của switch
  onChanged: (bool value) { // Callback khi switch thay đổi
    setState(() => _isEnabled = value); // Cập nhật giá trị của switch
  },
)

// SwitchListTile là widget để tạo switch với tiêu đề và mô tả
SwitchListTile(
  title: Text('Enable notifications'), // Tiêu đề của switch
  subtitle: Text('Receive push notifications'), // Mô tả của switch
  value: _isEnabled, // Giá trị của switch
  onChanged: (value) { // Callback khi switch thay đổi
    setState(() => _isEnabled = value);
  },
)
```

---

## 6. DropdownButton

```dart
class _MyWidgetState extends State<MyWidget> {
  String? _selectedItem; // Khai báo biến để lưu trạng thái của dropdown
  final List<String> _items = ['Option 1', 'Option 2', 'Option 3']; // Danh sách các item
  
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>( // DropdownButton là widget để tạo dropdown
      value: _selectedItem, // Giá trị của dropdown
      hint: Text('Select an option'), // Hint của dropdown
      isExpanded: true, // Dropdown mở rộng
      items: _items.map((String item) { // Map các item
        return DropdownMenuItem<String>( // DropdownMenuItem là widget để tạo item
          value: item, // Giá trị của item
          child: Text(item), // Text của item
        );
      }).toList(), // Convert sang list
      onChanged: (String? value) { // Callback khi dropdown thay đổi
        setState(() => _selectedItem = value); // Cập nhật giá trị của dropdown
      },
    );
  }
}

// DropdownButtonFormField (trong Form)
DropdownButtonFormField<String>( // DropdownButtonFormField là widget để tạo dropdown trong form
  value: _selectedItem, // Giá trị của dropdown
  decoration: InputDecoration(labelText: 'Category'), // Decoration của dropdown
  items: _items.map((item) => DropdownMenuItem( // Map các item
    value: item, // Giá trị của item
    child: Text(item), // Text của item
  )).toList(), // Convert sang list
  onChanged: (value) => setState(() => _selectedItem = value), // Callback khi dropdown thay đổi
  validator: (value) => value == null ? 'Please select' : null, // Validator của dropdown
)
```

---

## 7. Bài Tập

### Exercise 15: Login Form
Tạo form đăng nhập với:
- Email field với validation
- Password field với toggle visibility
- Remember me checkbox
- Login button (full width)
- Forgot password link

### Exercise 16: Registration Form
Tạo form đăng ký với:
- Name, Email, Phone fields
- Password và Confirm Password
- Gender (Radio)
- Accept terms (Checkbox)
- Register button
- Full validation

### Exercise 17: Settings Page
Tạo trang settings với:
- SwitchListTile cho notifications
- SwitchListTile cho dark mode
- DropdownButton cho language
- TextButton để logout

---

## 📝 Checklist Bài 6

- [ ] Thành thạo TextField với Controller
- [ ] Biết styling InputDecoration
- [ ] Sử dụng các loại Button
- [ ] Tạo Form với validation
- [ ] Dùng Checkbox, Radio, Switch
- [ ] Hoàn thành 3 exercises
