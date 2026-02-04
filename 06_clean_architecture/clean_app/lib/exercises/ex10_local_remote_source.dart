/// ===========================================
/// EXERCISE 10: LOCAL & REMOTE DATA SOURCES
/// ===========================================
/// 🎯 Mục tiêu:
/// - Tách biệt Local và Remote data sources
/// - Repository kết hợp nhiều sources
/// - Caching strategy
///
/// 📝 Data Source Pattern:
/// - RemoteDataSource: API calls
/// - LocalDataSource: Local DB, SharedPreferences
/// - Repository: Orchestrate cả hai

library;

import 'dart:math';
import 'package:flutter/material.dart';

/// ===========================================
/// DOMAIN LAYER
/// ===========================================

/// [Article] - Domain Entity
class Article {
  final int id;
  final String title;
  final String content;
  final DateTime publishedAt;

  const Article({
    required this.id,
    required this.title,
    required this.content,
    required this.publishedAt,
  });
}

/// ===========================================
/// DATA LAYER - DATA SOURCES
/// ===========================================

/// [ArticleRemoteDataSource] - Remote API calls
abstract class ArticleRemoteDataSource {
  Future<List<Article>> fetchArticles();
  Future<Article> fetchArticle(int id);
}

/// [ArticleLocalDataSource] - Local storage
abstract class ArticleLocalDataSource {
  Future<List<Article>?> getCachedArticles();
  Future<Article?> getCachedArticle(int id);
  Future<void> cacheArticles(List<Article> articles);
  Future<void> cacheArticle(Article article);
  Future<void> clearCache();
}

/// ===========================================
/// DATA SOURCE IMPLEMENTATIONS
/// ===========================================

/// [ApiArticleDataSource] - Giả lập remote API
class ApiArticleDataSource implements ArticleRemoteDataSource {
  /// Giả lập delay network
  final int _networkDelayMs;

  /// Giả lập lỗi network
  final double _errorRate;

  ApiArticleDataSource({int networkDelayMs = 1000, double errorRate = 0.1})
    : _networkDelayMs = networkDelayMs,
      _errorRate = errorRate;

  @override
  Future<List<Article>> fetchArticles() async {
    await Future.delayed(Duration(milliseconds: _networkDelayMs));

    // Giả lập network error
    if (Random().nextDouble() < _errorRate) {
      throw Exception('Network error! Unable to fetch articles.');
    }

    return List.generate(
      5,
      (i) => Article(
        id: i + 1,
        title: 'Article ${i + 1} from API',
        content: 'Fresh content from server...',
        publishedAt: DateTime.now().subtract(Duration(hours: i)),
      ),
    );
  }

  @override
  Future<Article> fetchArticle(int id) async {
    await Future.delayed(Duration(milliseconds: _networkDelayMs ~/ 2));

    if (Random().nextDouble() < _errorRate) {
      throw Exception('Network error!');
    }

    return Article(
      id: id,
      title: 'Article $id (from API)',
      content: 'Detailed content for article $id from server...',
      publishedAt: DateTime.now(),
    );
  }
}

/// [InMemoryLocalDataSource] - Giả lập local storage
class InMemoryLocalDataSource implements ArticleLocalDataSource {
  List<Article>? _cachedArticles;
  final Map<int, Article> _articleCache = {};

  @override
  Future<List<Article>?> getCachedArticles() async {
    debugPrint('[LocalDS] Getting cached articles...');
    // Simulate disk read
    await Future.delayed(const Duration(milliseconds: 100));
    return _cachedArticles;
  }

  @override
  Future<Article?> getCachedArticle(int id) async {
    debugPrint('[LocalDS] Getting cached article $id...');
    await Future.delayed(const Duration(milliseconds: 50));
    return _articleCache[id];
  }

  @override
  Future<void> cacheArticles(List<Article> articles) async {
    debugPrint('[LocalDS] Caching ${articles.length} articles...');
    await Future.delayed(const Duration(milliseconds: 100));
    _cachedArticles = articles;
    for (final article in articles) {
      _articleCache[article.id] = article;
    }
  }

  @override
  Future<void> cacheArticle(Article article) async {
    debugPrint('[LocalDS] Caching article ${article.id}...');
    await Future.delayed(const Duration(milliseconds: 50));
    _articleCache[article.id] = article;
  }

  @override
  Future<void> clearCache() async {
    debugPrint('[LocalDS] Clearing cache...');
    await Future.delayed(const Duration(milliseconds: 50));
    _cachedArticles = null;
    _articleCache.clear();
  }
}

/// ===========================================
/// REPOSITORY với CACHE STRATEGY
/// ===========================================
class ArticleRepository {
  final ArticleRemoteDataSource remoteDataSource;
  final ArticleLocalDataSource localDataSource;

  ArticleRepository({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  /// [getArticles] - Cache-first strategy
  /// 1. Trả về cache nếu có
  /// 2. Fetch từ API
  /// 3. Cache lại
  Future<(List<Article>, bool isCached)> getArticles({
    bool forceRefresh = false,
  }) async {
    // 1. Nếu không force refresh, kiểm tra cache
    if (!forceRefresh) {
      final cached = await localDataSource.getCachedArticles();
      if (cached != null && cached.isNotEmpty) {
        debugPrint('[Repo] Returning ${cached.length} cached articles');
        return (cached, true);
      }
    }

    // 2. Fetch từ remote
    try {
      debugPrint('[Repo] Fetching from remote...');
      final articles = await remoteDataSource.fetchArticles();

      // 3. Cache lại
      await localDataSource.cacheArticles(articles);

      return (articles, false);
    } catch (e) {
      // 4. Nếu lỗi, fallback sang cache
      debugPrint('[Repo] Remote failed, trying cache fallback...');
      final cached = await localDataSource.getCachedArticles();
      if (cached != null && cached.isNotEmpty) {
        return (cached, true);
      }
      rethrow;
    }
  }

  Future<void> clearCache() async {
    await localDataSource.clearCache();
  }
}

/// ===========================================
/// DEMO UI
/// ===========================================
class Ex10LocalRemoteSource extends StatefulWidget {
  const Ex10LocalRemoteSource({super.key});

  @override
  State<Ex10LocalRemoteSource> createState() => _Ex10LocalRemoteSourceState();
}

class _Ex10LocalRemoteSourceState extends State<Ex10LocalRemoteSource> {
  late final ArticleRepository _repository;

  List<Article> _articles = [];
  bool _isLoading = false;
  bool _isCached = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _repository = ArticleRepository(
      remoteDataSource: ApiArticleDataSource(
        networkDelayMs: 1500,
        errorRate: 0.2, // 20% chance of error
      ),
      localDataSource: InMemoryLocalDataSource(),
    );
    _loadArticles();
  }

  Future<void> _loadArticles({bool forceRefresh = false}) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final (articles, isCached) = await _repository.getArticles(
        forceRefresh: forceRefresh,
      );
      setState(() {
        _articles = articles;
        _isCached = isCached;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _clearCache() async {
    await _repository.clearCache();
    setState(() {
      _articles = [];
      _isCached = false;
    });
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Cache cleared!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex10: Data Sources'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _clearCache,
            tooltip: 'Clear Cache',
          ),
        ],
      ),
      body: Column(
        children: [
          // Info
          Card(
            color: Colors.deepOrange,
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '💡 Local & Remote Data Sources',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Source: ${_isCached ? "📦 CACHE" : "🌐 REMOTE"}\n'
                    'Strategy: Cache-first with fallback\n'
                    '20% chance of network error to test fallback',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),

          // Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : () => _loadArticles(),
                    icon: const Icon(Icons.download),
                    label: const Text('Load (Cache first)'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isLoading
                        ? null
                        : () => _loadArticles(forceRefresh: true),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Force Refresh'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

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
            Text('Error: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _loadArticles(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_articles.isEmpty) {
      return const Center(child: Text('No articles. Click Load to fetch.'));
    }

    return ListView.builder(
      itemCount: _articles.length,
      itemBuilder: (context, index) {
        final article = _articles[index];
        return ListTile(
          leading: CircleAvatar(child: Text('${article.id}')),
          title: Text(article.title),
          subtitle: Text(article.content),
          trailing: Icon(
            _isCached ? Icons.storage : Icons.cloud_download,
            color: _isCached ? Colors.orange : Colors.blue,
          ),
        );
      },
    );
  }
}
