/// ===========================================
/// EXERCISE 18: INFINITE LIST (PAGINATION)
/// ===========================================
/// 🎯 Mục tiêu:
/// - Xử lý Pagination (Lazy Loading)
/// - Kết hợp ScrollController với BLoC Event
/// - Kỹ thuật Debounce (chống spam request khi scroll nhanh)
/// - Trạng thái: HasReachedMax (kết thúc danh sách)
///
/// 📝 Logic:
/// - Khi user cuộn xuống gần đáy (còn 200px) -> Gửi event PostFetched
/// - BLoC check: nếu chưa max -> load trang tiếp theo
/// - Append dữ liệu cũ + mới

library;

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart'
    as http; // (Optional) dùng giả lập, ở đây dùng dio hoặc fake
import 'package:stream_transform/stream_transform.dart';

/// 1. MODEL
class Post extends Equatable {
  final int id;
  final String title;
  final String body;

  const Post({required this.id, required this.title, required this.body});

  @override
  List<Object> get props => [id, title, body];
}

/// 2. EVENTS
sealed class PostEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PostFetched extends PostEvent {}

/// 3. STATES
enum PostStatus { initial, success, failure }

class PostState extends Equatable {
  final PostStatus status;
  final List<Post> posts;
  final bool hasReachedMax;

  const PostState({
    this.status = PostStatus.initial,
    this.posts = const <Post>[],
    this.hasReachedMax = false,
  });

  PostState copyWith({
    PostStatus? status,
    List<Post>? posts,
    bool? hasReachedMax,
  }) {
    return PostState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [status, posts, hasReachedMax];
}

/// 4. BLOC
/// Cần cài thêm package `stream_transform` để dùng throttle/debounce,
/// hoặc tự viết transformer. Ở đây ta dùng transformer custom đơn giản.
EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PostBloc extends Bloc<PostEvent, PostState> {
  static const int _postLimit = 10;

  PostBloc() : super(const PostState()) {
    on<PostFetched>(
      _onPostFetched,

      /// Transformer: Throttle để tránh spam event khi scroll liên tục
      transformer: throttleDroppable(const Duration(milliseconds: 100)),
    );
  }

  Future<void> _onPostFetched(
      PostFetched event, Emitter<PostState> emit) async {
    if (state.hasReachedMax) return;

    try {
      if (state.status == PostStatus.initial) {
        final posts = await _fetchPosts(); // Initial load
        return emit(state.copyWith(
          status: PostStatus.success,
          posts: posts,
          hasReachedMax: false,
        ));
      }

      // Load more
      final posts = await _fetchPosts(startIndex: state.posts.length);

      emit(posts.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: PostStatus.success,
              posts: List.of(state.posts)..addAll(posts),
              hasReachedMax: false,
            ));
    } catch (_) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }

  /// Fake API Call
  Future<List<Post>> _fetchPosts({int startIndex = 0}) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate Network

    // Giới hạn tổng số bài post là 50
    if (startIndex >= 50) return [];

    return List.generate(_postLimit, (index) {
      final id = startIndex + index;
      return Post(
        id: id,
        title: 'Post Title $id',
        body:
            'This is the body content of post $id. It contains some dummy text to fill the UI.',
      );
    });
  }
}

/// 5. UI
class Ex18InfiniteList extends StatelessWidget {
  const Ex18InfiniteList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostBloc()..add(PostFetched()), // Initial Load
      child: const PostListView(),
    );
  }
}

class PostListView extends StatefulWidget {
  const PostListView({super.key});

  @override
  State<PostListView> createState() => _PostListViewState();
}

class _PostListViewState extends State<PostListView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<PostBloc>().add(PostFetched());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9); // 90% scroll -> load more
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex18: Infinite List')),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          switch (state.status) {
            case PostStatus.failure:
              return const Center(child: Text('Failed to fetch posts'));
            case PostStatus.success:
              if (state.posts.isEmpty) {
                return const Center(child: Text('No posts'));
              }
              return ListView.builder(
                controller: _scrollController,
                itemCount: state.hasReachedMax
                    ? state.posts.length
                    : state.posts.length + 1, // +1 for Loading Indicator
                itemBuilder: (context, index) {
                  /// Item Loading ở cuối cùng
                  if (index >= state.posts.length) {
                    return const BottomLoader();
                  }

                  return PostListItem(post: state.posts[index]);
                },
              );
            case PostStatus.initial:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class BottomLoader extends StatelessWidget {
  const BottomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

class PostListItem extends StatelessWidget {
  final Post post;
  const PostListItem({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text('${post.id}')),
      title: Text(post.title),
      subtitle: Text(post.body),
      dense: true,
    );
  }
}
