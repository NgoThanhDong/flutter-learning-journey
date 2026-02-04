/// ===========================================
/// EXERCISE 14: OFFLINE CACHE
/// ===========================================
/// 🎯 Mục tiêu:
/// - Cache API response vào local storage
/// - Hiển thị cached data khi offline
///
/// 📝 Strategy: Cache-first với expiry (Chiến lược: Cache-first khi hết hạn)

library;

import 'dart:convert'; // JSON encoder/decoder
import 'package:flutter/material.dart'; // Flutter UI
import 'package:http/http.dart' as http; // HTTP Client
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences

/// [USER] - User model
class User {
  final int id;
  final String name;
  final String email;

  const User({required this.id, required this.name, required this.email});

  // [FROM JSON] - Convert JSON to User object
  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as int,
    name: json['name'] as String,
    email: json['email'] as String,
  );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email};
}

/// [EX14_OFFLINE_CACHE] - là widget chính Offline Cache
class Ex14OfflineCache extends StatefulWidget {
  const Ex14OfflineCache({super.key});

  @override
  State<Ex14OfflineCache> createState() => _Ex14OfflineCacheState();
}

class _Ex14OfflineCacheState extends State<Ex14OfflineCache> {
  List<User> _users = []; // Danh sách User
  bool _isLoading = false; // Loading state
  bool _isFromCache = false; // Cache state
  String? _error; // Error state

  @override
  void initState() {
    super.initState();
    _loadData(); // Load data on init
  }

  /// [_loadData] - Load data from API or cache
  /// forceRefresh: Force refresh from API
  Future<void> _loadData({bool forceRefresh = false}) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Check cache first
      if (!forceRefresh) {
        final cached = await _getCached(); // Get cached data
        if (cached != null) {
          setState(() {
            _users = cached;
            _isFromCache = true;
            _isLoading = false;
          });
          return;
        }
      }

      // Fetch from API
      // Get data from API and cache it
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/users'),
      );

      if (response.statusCode == 200) {
        // Parse response body to List<User>
        final List<dynamic> jsonList = jsonDecode(response.body);
        // Convert List<dynamic> to List<User>
        final users = jsonList.map((j) => User.fromJson(j)).toList();

        await _cache(users); // Cache data
        setState(() {
          _users = users;
          _isFromCache = false;
        });
      }
    } catch (e) {
      // Fallback to cache
      final cached = await _getCached(); // Get cached data
      if (cached != null) {
        setState(() {
          _users = cached;
          _isFromCache = true;
          _error = 'Offline mode';
        });
      } else {
        setState(() => _error = 'Error: $e');
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// [_getCached] - Get cached data
  /// Returns null if no cache found
  /// @return `List<User>?` - Cached data
  Future<List<User>?> _getCached() async {
    // Get cached data from SharedPreferences with key 'users_cache'
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('users_cache');

    // Return null if no cache found
    if (json == null) return null;

    // Parse JSON to List<User>
    final list = jsonDecode(json) as List;
    return list.map((j) => User.fromJson(j)).toList();
  }

  /// [_cache] - Cache data
  /// @param users - List of users to cache
  Future<void> _cache(List<User> users) async {
    // Cache data to SharedPreferences with key 'users_cache'
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'users_cache',
      jsonEncode(users.map((u) => u.toJson()).toList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with title and refresh button
      appBar: AppBar(
        title: const Text('Ex14: Offline Cache'),
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _loadData(forceRefresh: true),
          ),
        ],
      ),

      // Body content with loading indicator or ListView
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            // Show cache or API source
            // Green: From API, Orange: From Cache
            color: _isFromCache ? Colors.orange[100] : Colors.green[100],
            child: Text(_isFromCache ? '📦 From Cache' : '☁️ From API'),
          ),

          // Error message
          if (_error != null)
            Text(_error!, style: const TextStyle(color: Colors.red)),

          // Loading indicator or ListView
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _users.length,
                    itemBuilder: (context, i) => ListTile(
                      leading: CircleAvatar(child: Text('${_users[i].id}')),
                      title: Text(_users[i].name),
                      subtitle: Text(_users[i].email),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
