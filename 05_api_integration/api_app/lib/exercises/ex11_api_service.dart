/// ===========================================
/// EXERCISE 11: API SERVICE (REPOSITORY PATTERN)
/// ===========================================
/// 🎯 Mục tiêu:
/// - Tổ chức code API theo Repository pattern
/// - Tách biệt API logic khỏi UI
/// - Singleton pattern cho Dio instance
///
/// 📝 Giải thích:
/// Repository = Lớp trung gian giữa Data Source (API) và UI
/// - UI không biết API từ đâu
/// - Dễ test, dễ thay đổi source (API → Local Database)
/// - Code clean, maintainable

library;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// ===========================================
/// MODELS
/// ===========================================
class Post {
  final int id;
  final int userId;
  final String title;
  final String body;

  const Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'title': title,
    'body': body,
  };
}

/// ===========================================
/// API SERVICE (Singleton)
/// ===========================================
class ApiService {
  /// [Singleton Pattern]
  /// Đảm bảo chỉ có 1 instance trong cả app
  static final ApiService _instance = ApiService._internal();

  /// [Factory constructor] trả về instance duy nhất
  factory ApiService() => _instance;

  /// [Private constructor] ngăn tạo instance từ bên ngoài
  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://jsonplaceholder.typicode.com',
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  late final Dio _dio;

  /// [Getter] để truy cập Dio nếu cần
  Dio get dio => _dio;
}

/// ===========================================
/// POST REPOSITORY
/// ===========================================
/// Tất cả logic liên quan đến Posts nằm ở đây
class PostRepository {
  final Dio _dio = ApiService().dio;

  /// [GET] Lấy danh sách posts
  Future<List<Post>> getPosts({int limit = 10}) async {
    try {
      final response = await _dio.get(
        '/posts',
        queryParameters: {'_limit': limit},
      );

      final List<dynamic> data = response.data;
      return data.map((json) => Post.fromJson(json)).toList();
    } on DioException {
      rethrow; // Ném lại để UI handle
    }
  }

  /// [GET] Lấy 1 post theo ID
  Future<Post> getPostById(int id) async {
    final response = await _dio.get('/posts/$id');
    return Post.fromJson(response.data);
  }

  /// [POST] Tạo post mới
  Future<Post> createPost({
    required String title,
    required String body,
    int userId = 1,
  }) async {
    final response = await _dio.post(
      '/posts',
      data: {'title': title, 'body': body, 'userId': userId},
    );
    return Post.fromJson(response.data);
  }

  /// [DELETE] Xóa post
  Future<void> deletePost(int id) async {
    await _dio.delete('/posts/$id');
  }
}

/// ===========================================
/// UI WIDGET
/// ===========================================
class Ex11ApiService extends StatefulWidget {
  const Ex11ApiService({super.key});

  @override
  State<Ex11ApiService> createState() => _Ex11ApiServiceState();
}

class _Ex11ApiServiceState extends State<Ex11ApiService> {
  /// [Repository instance]
  /// UI chỉ biết getPost(), createPost()...
  /// Không biết Dio, URL, headers... gì cả!
  final _postRepo = PostRepository();

  List<Post> _posts = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      /// [Clean call]
      /// UI code rất clean - không có Dio, URL, headers
      _posts = await _postRepo.getPosts(limit: 5);
    } on DioException catch (e) {
      _error = 'Lỗi: ${e.message}';
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _createPost() async {
    try {
      final newPost = await _postRepo.createPost(
        title: 'New Post from App',
        body: 'This post was created at ${DateTime.now()}',
      );

      setState(() {
        _posts.insert(0, newPost);
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Created post #${newPost.id}')));
      }
    } on DioException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.message}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex11: API Service'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadPosts),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createPost,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Info card
          const Card(
            margin: EdgeInsets.all(16),
            color: Colors.teal,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                '💡 Repository Pattern:\n'
                '• UI gọi: postRepo.getPosts()\n'
                '• Repository handle: Dio, URL, parsing\n'
                '• Clean separation of concerns!',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),

          // Content
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(_error!),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadPosts, child: const Text('Retry')),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(child: Text('${post.id}')),
            title: Text(
              post.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              post.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }
}
