/// ===========================================
/// EXERCISE 07: LIST PARSING
/// ===========================================
/// 🎯 Mục tiêu:
/// - Parse JSON array thành List<Object>
/// - Xử lý nested arrays
/// - Common patterns khi làm việc với lists
///
/// 📝 JSON Array Structure:
/// [
///   {"id": 1, "title": "Post 1", "tags": ["flutter", "dart"]},
///   {"id": 2, "title": "Post 2", "tags": ["mobile"]},
///   ...
/// ]

library;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// ===========================================
/// MODEL
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

  /// [Factory method: fromJson]
  /// Tạo Post từ [Map<String, dynamic>]
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }

  /// [Static method: fromJsonList]
  /// Tiện lợi để parse cả list trong 1 method
  /// Thay vì viết logic parse ở nhiều nơi
  static List<Post> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => Post.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}

/// ===========================================
/// UI WIDGET
/// ===========================================
// [Ex07ListParsing] là widget hiển thị danh sách các bài viết
class Ex07ListParsing extends StatefulWidget {
  const Ex07ListParsing({super.key});

  @override
  State<Ex07ListParsing> createState() => _Ex07ListParsingState();
}

class _Ex07ListParsingState extends State<Ex07ListParsing> {
  // [late Future<List<Post>>] là biến lưu trữ kết quả của async method
  // [Future] là object đại diện cho kết quả của async operation
  // [List<Post>] là kiểu dữ liệu trả về
  late Future<List<Post>> _postsFuture;

  /// [Method: initState]
  /// Khởi tạo state khi widget được tạo
  /// Gọi _fetchPosts để fetch danh sách các bài viết
  @override
  void initState() {
    super.initState();
    _postsFuture = _fetchPosts();
  }

  /// [Async method: _fetchPosts]
  /// Fetch danh sách các bài viết từ API
  Future<List<Post>> _fetchPosts() async {
    final response = await http.get(
      /// [Query parameter]
      /// ?_limit=10 giới hạn số lượng kết quả (JSONPlaceholder feature)
      Uri.parse('https://jsonplaceholder.typicode.com/posts?_limit=10'),
    );

    if (response.statusCode == 200) {
      /// [Parse JSON Array]
      ///
      /// Cách 1: Inline
      // final List<dynamic> jsonList = jsonDecode(response.body);
      // return jsonList
      //     .map((json) => Post.fromJson(json as Map<String, dynamic>))
      //     .toList();

      /// Cách 2: Dùng static method (cleaner)
      return Post.fromJsonList(jsonDecode(response.body));
    }
    throw Exception('Failed to load posts');
  }

  /// [Method: _refresh]
  /// Refresh danh sách các bài viết
  void _refresh() {
    setState(() {
      _postsFuture = _fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex07: List Parsing'),
        actions: [
          /// [Button: Refresh]
          /// Gọi _refresh để refresh danh sách các bài viết
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refresh),
        ],
      ),

      /// [Body: FutureBuilder]
      /// Xử lý 3 trạng thái: loading, error, success
      /// [FutureBuilder] là widget để xử lý async operation
      /// [snapshot] là object chứa kết quả của async operation
      body: FutureBuilder<List<Post>>(
        // [Future] là object đại diện cho kết quả của async operation
        future: _postsFuture,
        // [builder] là function để build widget dựa trên trạng thái của future
        builder: (context, snapshot) {
          // [snapshot.connectionState == ConnectionState.waiting] là trạng thái loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // [snapshot.hasError] là trạng thái error
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 48, color: Colors.red),
                  Text('Error: ${snapshot.error}'),
                  ElevatedButton(
                    onPressed: _refresh,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // [snapshot.data!] là dữ liệu đã được parse
          final posts = snapshot.data!;

          // [Empty state] là trạng thái khi không có dữ liệu
          if (posts.isEmpty) {
            return const Center(child: Text('No posts found'));
          }

          return Column(
            children: [
              // [Header với count] là header hiển thị số lượng bài viết
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.blue[50],
                child: Row(
                  children: [
                    const Icon(Icons.list),
                    const SizedBox(width: 8),
                    Text(
                      'Loaded ${posts.length} posts',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              // [List] là danh sách các bài viết
              // [Expanded] là widget để chiếm hết không gian còn lại
              // [ListView.separated] là widget để hiển thị danh sách các bài viết
              // [itemCount] là số lượng bài viết
              // [separatorBuilder] là function để build separator giữa các bài viết
              // [itemBuilder] là function để build từng bài viết
              Expanded(
                child: ListView.separated(
                  itemCount: posts.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final post = posts[index];

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(
                          '${post.id}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        post.title,
                        maxLines: 1,
                        // [overflow] là để hiển thị ... khi text quá dài
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        post.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                      // [trailing] là để hiển thị thông tin ngắn gọn ở cuối ListTile
                      // [Chip] là widget để hiển thị thông tin ngắn gọn
                      trailing: Chip(
                        label: Text('User ${post.userId}'),
                        padding: EdgeInsets.zero,
                        labelStyle: const TextStyle(fontSize: 10),
                      ),

                      // [onTap] là để hiển thị dialog khi click vào bài viết
                      onTap: () {
                        // [Show detail dialog] là dialog hiển thị chi tiết bài viết
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Post #${post.id}'),
                            // [content] là nội dung của dialog
                            // [SingleChildScrollView] là widget để hiển thị nội dung có thể cuộn
                            content: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Title:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(post.title),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Body:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(post.body),
                                ],
                              ),
                            ),
                            actions: [
                              // [TextButton] là widget để hiển thị nút bấm
                              TextButton(
                                // [onPressed] là để đóng dialog
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
