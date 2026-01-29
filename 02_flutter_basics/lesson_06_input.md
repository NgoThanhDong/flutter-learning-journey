# Bài 6: Input Widgets - TextField, Button, Form

## 🎯 Mục tiêu
- Thành thạo TextField và TextEditingController
- Sử dụng các loại Button
- Tạo Form với validation

---

## 1. TextField - Ô Nhập Liệu

### 1.1 Cơ bản

```dart
TextField(
  decoration: InputDecoration(
    labelText: 'Username',
    hintText: 'Enter your username',
  ),
)
```

### 1.2 TextEditingController - Lấy giá trị

```dart
class _MyFormState extends State<MyForm> {
  // Khai báo controller
  final TextEditingController _nameController = TextEditingController();
  
  @override
  void dispose() {
    _nameController.dispose(); // QUAN TRỌNG: Dispose!
    super.dispose();
  }
  
  void _submit() {
    String name = _nameController.text;
    print('Name: $name');
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: InputDecoration(labelText: 'Name'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text('Submit'),
        ),
      ],
    );
  }
}
```

### 1.3 InputDecoration đầy đủ

```dart
TextField(
  controller: _controller,
  
  decoration: InputDecoration(
    // Label
    labelText: 'Email',
    labelStyle: TextStyle(color: Colors.grey),
    
    // Hint
    hintText: 'example@email.com',
    hintStyle: TextStyle(color: Colors.grey[400]),
    
    // Helper text
    helperText: 'Enter a valid email',
    
    // Error text
    errorText: _hasError ? 'Invalid email' : null,
    
    // Prefix
    prefixIcon: Icon(Icons.email),
    prefixText: '+84 ',
    
    // Suffix
    suffixIcon: IconButton(
      icon: Icon(Icons.clear),
      onPressed: () => _controller.clear(),
    ),
    
    // Counter
    counterText: '${_controller.text.length}/50',
    
    // Border
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    
    // Focused border
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.blue, width: 2),
    ),
    
    // Enabled border
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey),
    ),
    
    // Error border
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.red),
    ),
    
    // Filled
    filled: true,
    fillColor: Colors.grey[100],
    
    // Content padding
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
)
```

### 1.4 TextField Properties

```dart
TextField(
  controller: _controller,
  
  // Keyboard type
  keyboardType: TextInputType.emailAddress,
  // TextInputType.text, number, phone, url, multiline
  
  // Text input action (nút trên keyboard)
  textInputAction: TextInputAction.next,
  // TextInputAction.done, search, send, go
  
  // Max lines
  maxLines: 1,         // Single line
  // maxLines: null,   // Unlimited (multiline)
  // maxLines: 5,      // Max 5 lines
  
  // Max length
  maxLength: 100,
  
  // Obscure text (password)
  obscureText: true,
  
  // Auto focus
  autofocus: true,
  
  // Enabled/Disabled
  enabled: true,
  
  // Read only
  readOnly: false,
  
  // Text capitalization
  textCapitalization: TextCapitalization.words,
  // TextCapitalization.sentences, characters, none
  
  // Callbacks
  onChanged: (value) {
    print('Changed: $value');
  },
  onSubmitted: (value) {
    print('Submitted: $value');
  },
  onTap: () {
    print('Tapped');
  },
)
```

### 1.5 Password Field với Toggle

```dart
class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;
  final _controller = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
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

### 2.1 ElevatedButton (Primary)

```dart
ElevatedButton(
  onPressed: () {
    print('Pressed!');
  },
  child: Text('Submit'),
)

// Disabled
ElevatedButton(
  onPressed: null, // null = disabled
  child: Text('Disabled'),
)

// Styled
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 4,
  ),
  child: Text('Styled Button'),
)
```

### 2.2 TextButton (Flat)

```dart
TextButton(
  onPressed: () {},
  child: Text('Text Button'),
)

TextButton(
  onPressed: () {},
  style: TextButton.styleFrom(
    foregroundColor: Colors.blue,
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  ),
  child: Text('Cancel'),
)
```

### 2.3 OutlinedButton

```dart
OutlinedButton(
  onPressed: () {},
  child: Text('Outlined'),
)

OutlinedButton(
  onPressed: () {},
  style: OutlinedButton.styleFrom(
    foregroundColor: Colors.blue,
    side: BorderSide(color: Colors.blue, width: 2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  child: Text('Outlined'),
)
```

### 2.4 IconButton

```dart
IconButton(
  icon: Icon(Icons.favorite),
  iconSize: 30,
  color: Colors.red,
  onPressed: () {},
)
```

### 2.5 FloatingActionButton

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
  width: double.infinity,
  child: ElevatedButton(
    onPressed: () {},
    child: Text('Full Width Button'),
  ),
)
```

---

## 3. GestureDetector & InkWell

### 3.1 GestureDetector

```dart
GestureDetector(
  onTap: () => print('Tap'),
  onDoubleTap: () => print('Double tap'),
  onLongPress: () => print('Long press'),
  onPanUpdate: (details) => print('Drag: ${details.delta}'),
  
  child: Container(
    width: 100,
    height: 100,
    color: Colors.blue,
    child: Center(child: Text('Tap me')),
  ),
)
```

### 3.2 InkWell - Với hiệu ứng ripple

```dart
InkWell(
  onTap: () => print('Tapped'),
  borderRadius: BorderRadius.circular(12),
  splashColor: Colors.blue.withOpacity(0.3),
  highlightColor: Colors.blue.withOpacity(0.1),
  
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
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  void _submit() {
    // Validate
    if (_formKey.currentState!.validate()) {
      // Form is valid
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Email field
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter email';
              }
              if (!value.contains('@')) {
                return 'Please enter valid email';
              }
              return null; // Valid
            },
          ),
          
          SizedBox(height: 16),
          
          // Password field
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          
          SizedBox(height: 24),
          
          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              child: Text('Login'),
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
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) {
    return 'Enter a valid email';
  }
  return null;
}

// Password validator
String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }
  if (value.length < 8) {
    return 'Password must be at least 8 characters';
  }
  if (!value.contains(RegExp(r'[A-Z]'))) {
    return 'Password must contain uppercase letter';
  }
  if (!value.contains(RegExp(r'[0-9]'))) {
    return 'Password must contain number';
  }
  return null;
}

// Phone validator
String? validatePhone(String? value) {
  if (value == null || value.isEmpty) {
    return 'Phone is required';
  }
  if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
    return 'Enter valid 10-digit phone';
  }
  return null;
}
```

---

## 5. Checkbox, Radio, Switch

### 5.1 Checkbox

```dart
class _MyWidgetState extends State<MyWidget> {
  bool _isChecked = false;
  
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: _isChecked,
      onChanged: (bool? value) {
        setState(() {
          _isChecked = value ?? false;
        });
      },
    );
  }
}

// CheckboxListTile
CheckboxListTile(
  title: Text('Accept terms'),
  subtitle: Text('I agree to the terms and conditions'),
  value: _isChecked,
  onChanged: (value) {
    setState(() => _isChecked = value ?? false);
  },
)
```

### 5.2 Radio

```dart
enum Gender { male, female, other }

class _MyWidgetState extends State<MyWidget> {
  Gender? _selectedGender;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile<Gender>(
          title: Text('Male'),
          value: Gender.male,
          groupValue: _selectedGender,
          onChanged: (Gender? value) {
            setState(() => _selectedGender = value);
          },
        ),
        RadioListTile<Gender>(
          title: Text('Female'),
          value: Gender.female,
          groupValue: _selectedGender,
          onChanged: (Gender? value) {
            setState(() => _selectedGender = value);
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
  value: _isEnabled,
  onChanged: (bool value) {
    setState(() => _isEnabled = value);
  },
)

// SwitchListTile
SwitchListTile(
  title: Text('Enable notifications'),
  subtitle: Text('Receive push notifications'),
  value: _isEnabled,
  onChanged: (value) {
    setState(() => _isEnabled = value);
  },
)
```

---

## 6. DropdownButton

```dart
class _MyWidgetState extends State<MyWidget> {
  String? _selectedItem;
  final List<String> _items = ['Option 1', 'Option 2', 'Option 3'];
  
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedItem,
      hint: Text('Select an option'),
      isExpanded: true,
      items: _items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() => _selectedItem = value);
      },
    );
  }
}

// DropdownButtonFormField (trong Form)
DropdownButtonFormField<String>(
  value: _selectedItem,
  decoration: InputDecoration(labelText: 'Category'),
  items: _items.map((item) => DropdownMenuItem(
    value: item,
    child: Text(item),
  )).toList(),
  onChanged: (value) => setState(() => _selectedItem = value),
  validator: (value) => value == null ? 'Please select' : null,
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
