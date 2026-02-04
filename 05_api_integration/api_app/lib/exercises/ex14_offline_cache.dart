/// ===========================================
/// EXERCISE 14: OFFLINE CACHE
/// ===========================================
/// 🎯 Mục tiêu:
/// - Cache API response vào local storage
/// - Hiển thị cached data khi offline
///
/// 📝 Strategy: Cache-first với expiry

library;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final int id;
  final String name;
  final String email;

  const User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as int,
    name: json['name'] as String,
    email: json['email'] as String,
  );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email};
}

class Ex14OfflineCache extends StatefulWidget {
  const Ex14OfflineCache({super.key});

  @override
  State<Ex14OfflineCache> createState() => _Ex14OfflineCacheState();
}

class _Ex14OfflineCacheState extends State<Ex14OfflineCache> {
  List<User> _users = [];
  bool _isLoading = false;
  bool _isFromCache = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData({bool forceRefresh = false}) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Check cache first
      if (!forceRefresh) {
        final cached = await _getCached();
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
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/users'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final users = jsonList.map((j) => User.fromJson(j)).toList();

        await _cache(users);
        setState(() {
          _users = users;
          _isFromCache = false;
        });
      }
    } catch (e) {
      // Fallback to cache
      final cached = await _getCached();
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

  Future<List<User>?> _getCached() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('users_cache');
    if (json == null) return null;
    final list = jsonDecode(json) as List;
    return list.map((j) => User.fromJson(j)).toList();
  }

  Future<void> _cache(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'users_cache',
      jsonEncode(users.map((u) => u.toJson()).toList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex14: Offline Cache'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _loadData(forceRefresh: true),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: _isFromCache ? Colors.orange[100] : Colors.green[100],
            child: Text(_isFromCache ? '📦 From Cache' : '☁️ From API'),
          ),
          if (_error != null)
            Text(_error!, style: const TextStyle(color: Colors.red)),
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
