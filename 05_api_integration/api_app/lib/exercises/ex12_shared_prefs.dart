/// ===========================================
/// EXERCISE 12: SHARED PREFERENCES
/// ===========================================
/// 🎯 Mục tiêu:
/// - Lưu dữ liệu key-value đơn giản
/// - CRUD operations với SharedPreferences
/// - Các use cases: settings, auth token, preferences
///
/// 📝 Giải thích:
/// SharedPreferences = Local storage dạng key-value
/// - Hỗ trợ: String, int, double, bool, [List<String>]
/// - Persist sau khi đóng app
/// - Async operations (cần await)

library;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Ex12SharedPrefs extends StatefulWidget {
  const Ex12SharedPrefs({super.key});

  @override
  State<Ex12SharedPrefs> createState() => _Ex12SharedPrefsState();
}

class _Ex12SharedPrefsState extends State<Ex12SharedPrefs> {
  /// [Controllers]
  final _usernameController = TextEditingController();

  /// [State]
  String? _savedUsername;
  int _counter = 0;
  bool _isDarkMode = false;
  List<String> _tags = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  /// [LOAD] Đọc tất cả data đã lưu
  Future<void> _loadAllData() async {
    /// [getInstance] - Lấy SharedPreferences instance
    /// Phải await vì đọc từ storage
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      /// [getString] - Đọc String, trả về null nếu key không tồn tại
      _savedUsername = prefs.getString('username');

      /// [getInt] - Đọc int, dùng ?? để set default value
      _counter = prefs.getInt('counter') ?? 0;

      /// [getBool] - Đọc bool
      _isDarkMode = prefs.getBool('dark_mode') ?? false;

      /// [getStringList] - Đọc List<String>
      _tags = prefs.getStringList('tags') ?? [];

      _isLoading = false;
    });

    _usernameController.text = _savedUsername ?? '';
  }

  /// [SAVE STRING]
  Future<void> _saveUsername() async {
    final prefs = await SharedPreferences.getInstance();

    /// [setString] - Lưu String
    await prefs.setString('username', _usernameController.text);

    setState(() {
      _savedUsername = _usernameController.text;
    });

    _showSnackBar('Username saved!');
  }

  /// [SAVE INT] - Increment và save counter
  Future<void> _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _counter++;
    });

    /// [setInt] - Lưu int
    await prefs.setInt('counter', _counter);
  }

  /// [SAVE BOOL] - Toggle dark mode
  Future<void> _toggleDarkMode() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _isDarkMode = !_isDarkMode;
    });

    /// [setBool] - Lưu bool
    await prefs.setBool('dark_mode', _isDarkMode);
  }

  /// [SAVE LIST] - Add tag
  Future<void> _addTag(String tag) async {
    if (tag.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _tags.add(tag);
    });

    /// [setStringList] - Lưu List<String>
    await prefs.setStringList('tags', _tags);
  }

  /// [REMOVE] - Xóa một key
  Future<void> _removeUsername() async {
    final prefs = await SharedPreferences.getInstance();

    /// [remove] - Xóa key khỏi storage
    await prefs.remove('username');

    setState(() {
      _savedUsername = null;
      _usernameController.clear();
    });

    _showSnackBar('Username removed!');
  }

  /// [CLEAR] - Xóa tất cả
  Future<void> _clearAll() async {
    final prefs = await SharedPreferences.getInstance();

    /// [clear] - Xóa toàn bộ data
    await prefs.clear();

    setState(() {
      _savedUsername = null;
      _counter = 0;
      _isDarkMode = false;
      _tags = [];
      _usernameController.clear();
    });

    _showSnackBar('All data cleared!');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex12: SharedPreferences'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: _clearAll,
            tooltip: 'Clear All',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. String - Username
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '1. String: Username',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _saveUsername,
                        child: const Text('Save'),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: _removeUsername,
                        child: const Text('Remove'),
                      ),
                    ],
                  ),
                  if (_savedUsername != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text('Saved: $_savedUsername'),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 2. Int - Counter
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text(
                    '2. Int: Counter',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text('$_counter', style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: _incrementCounter,
                    icon: const Icon(Icons.add_circle),
                    iconSize: 32,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 3. Bool - Dark Mode
          Card(
            child: SwitchListTile(
              title: const Text('3. Bool: Dark Mode'),
              value: _isDarkMode,
              onChanged: (_) => _toggleDarkMode(),
            ),
          ),

          const SizedBox(height: 16),

          // 4. List<String> - Tags
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        '4. List<String>: Tags',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              final controller = TextEditingController();
                              return AlertDialog(
                                title: const Text('Add Tag'),
                                content: TextField(
                                  controller: controller,
                                  autofocus: true,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _addTag(controller.text);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Add'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _tags
                        .map((tag) => Chip(label: Text(tag)))
                        .toList(),
                  ),
                  if (_tags.isEmpty) const Text('No tags. Tap + to add.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
