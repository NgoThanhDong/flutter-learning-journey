# Lesson 5: Loading States 🔄

## Mục tiêu

- Hiểu các trạng thái UI khi gọi API
- Master FutureBuilder
- Implement loading/error/data pattern
- Best practices cho async UI

---

## 1. Các Trạng Thái UI

Khi gọi API, UI có 4 trạng thái:

| State | Mô tả | UI hiển thị |
|-------|-------|-------------|
| **Initial** | Chưa bắt đầu | Nút "Load" |
| **Loading** | Đang chờ | Spinner |
| **Success** | Có dữ liệu | Hiển thị data |
| **Error** | Có lỗi | Message + Retry |

---

## 2. FutureBuilder

Widget tự động build UI dựa trên trạng thái Future.

### Cú pháp:
```dart
FutureBuilder<T>(
  future: yourFuture,
  builder: (context, snapshot) {
    // snapshot chứa trạng thái hiện tại
    return widget;
  },
)
```

### AsyncSnapshot states:
```dart
FutureBuilder<List<User>>(
  future: fetchUsers(),
  builder: (context, snapshot) {
    /// [connectionState] - Trạng thái kết nối
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        // Future chưa được cung cấp
        return const Text('Press button to load');
        
      case ConnectionState.waiting:
        // Đang chờ Future complete
        return const CircularProgressIndicator();
        
      case ConnectionState.done:
        // Future đã complete (có thể success hoặc error)
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.hasData) {
          return UserList(users: snapshot.data!);
        }
        return const Text('No data');
        
      default:
        return const SizedBox();
    }
  },
)
```

---

## 3. Pattern Đơn Giản

```dart
FutureBuilder<List<User>>(
  future: fetchUsers(),
  builder: (context, snapshot) {
    // Loading
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    
    // Error
    if (snapshot.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 48, color: Colors.red),
            Text('Error: ${snapshot.error}'),
            ElevatedButton(
              onPressed: () => setState(() {}), // Trigger rebuild
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    
    // Empty
    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(child: Text('No users found'));
    }
    
    // Success
    final users = snapshot.data!;
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(users[index].name),
      ),
    );
  },
)
```

---

## 4. ⚠️ Common Mistake

### ❌ Sai: Future trong build()
```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Mỗi lần build lại tạo Future mới → gọi API lại!
      future: fetchUsers(), // ❌ SAI!
      builder: ...
    );
  }
}
```

### ✅ Đúng: Future trong initState
```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late Future<List<User>> _usersFuture;
  
  @override
  void initState() {
    super.initState();
    _usersFuture = fetchUsers(); // ✅ Chỉ gọi 1 lần
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _usersFuture,
      builder: ...
    );
  }
  
  void refresh() {
    setState(() {
      _usersFuture = fetchUsers(); // Gọi lại khi cần
    });
  }
}
```

---

## 5. Custom State Class

Để quản lý state tốt hơn:

```dart
/// Generic state class cho async operations
sealed class AsyncState<T> {}

class Initial<T> extends AsyncState<T> {}
class Loading<T> extends AsyncState<T> {}
class Success<T> extends AsyncState<T> {
  final T data;
  Success(this.data);
}
class Error<T> extends AsyncState<T> {
  final String message;
  Error(this.message);
}
```

### Sử dụng với State:
```dart
class _MyPageState extends State<MyPage> {
  AsyncState<List<User>> _state = Initial();
  
  @override
  void initState() {
    super.initState();
    _loadUsers();
  }
  
  Future<void> _loadUsers() async {
    setState(() => _state = Loading());
    
    try {
      final users = await fetchUsers();
      setState(() => _state = Success(users));
    } catch (e) {
      setState(() => _state = Error(e.toString()));
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return switch (_state) {
      Initial() => const Text('Press to load'),
      Loading() => const CircularProgressIndicator(),
      Success(:final data) => UserList(users: data),
      Error(:final message) => ErrorWidget(message: message),
    };
  }
}
```

---

## 6. Pull to Refresh

```dart
class _MyPageState extends State<MyPage> {
  late Future<List<User>> _usersFuture;
  
  @override
  void initState() {
    super.initState();
    _usersFuture = fetchUsers();
  }
  
  Future<void> _refresh() async {
    setState(() {
      _usersFuture = fetchUsers();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: FutureBuilder<List<User>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return ListView(
              children: [
                Center(child: Text('Error: ${snapshot.error}')),
              ],
            );
          }
          
          final users = snapshot.data ?? [];
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return ListTile(title: Text(users[index].name));
            },
          );
        },
      ),
    );
  }
}
```

---

## 7. Skeleton Loading

```dart
Widget _buildSkeleton() {
  return ListView.builder(
    itemCount: 5,
    itemBuilder: (context, index) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 16,
                      width: double.infinity,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 12,
                      width: 100,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
```

---

## 8. Complete Pattern

```dart
class UsersPage extends StatefulWidget {
  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late Future<List<User>> _usersFuture;
  
  @override
  void initState() {
    super.initState();
    _usersFuture = _loadUsers();
  }
  
  Future<List<User>> _loadUsers() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
    );
    
    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list.map((json) => User.fromJson(json)).toList();
    }
    throw Exception('Failed to load users');
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {
              _usersFuture = _loadUsers();
            }),
          ),
        ],
      ),
      body: FutureBuilder<List<User>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return _buildError(snapshot.error.toString());
          }
          
          final users = snapshot.data ?? [];
          if (users.isEmpty) {
            return _buildEmpty();
          }
          
          return _buildList(users);
        },
      ),
    );
  }
  
  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => setState(() {
              _usersFuture = _loadUsers();
            }),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmpty() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('No users found'),
        ],
      ),
    );
  }
  
  Widget _buildList(List<User> users) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          leading: CircleAvatar(child: Text(user.name[0])),
          title: Text(user.name),
          subtitle: Text(user.email),
        );
      },
    );
  }
}
```

---

## Tóm Tắt

| Component | Mục đích |
|-----------|----------|
| `FutureBuilder` | Auto-rebuild based on Future |
| `snapshot.connectionState` | Check loading state |
| `snapshot.hasError` | Check error |
| `snapshot.data` | Get data |
| `RefreshIndicator` | Pull to refresh |
| `late Future` | Cache Future in initState |

---

---

## Bài Tập Liên Quan

- `ex04_loading_states.dart` - Implement FutureBuilder và các trạng thái Loading/Error/Success

---

## Bài Tiếp Theo

➡️ [Lesson 6: Local Storage](lesson_06_local_storage.md)
