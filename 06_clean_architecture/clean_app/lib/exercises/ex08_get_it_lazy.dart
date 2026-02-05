/// ===========================================
/// EXERCISE 08: GET_IT LAZY & DISPOSE
/// ===========================================
/// 🎯 Mục tiêu:
/// - Lazy registration khi có async init
/// - Dispose callback để cleanup (giải phóng tài nguyên khi không dùng nữa)
/// - Reset và unregister (xóa dependency khỏi get_it)
///
/// 📝 Advanced get_it patterns:
/// - registerLazySingletonAsync (đăng ký lazy singleton với async init)
/// - disposingFunction (callback để cleanup)
/// - resetLazySingleton (reset lazy singleton)
/// - unregister (xóa dependency khỏi get_it)

library;

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

/// ===========================================
/// SETUP
/// ===========================================
final sl2 = GetIt.asNewInstance(); // Instance riêng cho demo

/// [DatabaseConnection] - Giả lập database với async init
class DatabaseConnection {
  final String dbName;
  bool _isConnected = false;

  DatabaseConnection(this.dbName);

  bool get isConnected => _isConnected;

  /// [connect] - Async initialization
  Future<void> connect() async {
    debugPrint('[$dbName] Connecting...');
    await Future.delayed(const Duration(seconds: 1));
    _isConnected = true;
    debugPrint('[$dbName] Connected!');
  }

  /// [close] - Cleanup
  Future<void> close() async {
    debugPrint('[$dbName] Closing connection...');
    await Future.delayed(const Duration(milliseconds: 500));
    _isConnected = false;
    debugPrint('[$dbName] Connection closed!');
  }

  /// [query] - Query database
  Future<String> query(String sql) async {
    if (!_isConnected) throw Exception('Not connected!');
    await Future.delayed(const Duration(milliseconds: 300));
    return 'Result for: $sql';
  }
}

/// [CacheService] - Service với dispose
class CacheService {
  final Map<String, String> _cache = {}; // Cache data
  bool _isDisposed = false; // Check if disposed

  bool get isDisposed => _isDisposed;
  int get cacheSize => _cache.length;

  /// [put] - Put data into cache
  void put(String key, String value) {
    if (_isDisposed) throw Exception('Cache disposed!');
    _cache[key] = value;
    debugPrint('[Cache] Put: $key = $value');
  }

  /// [get] - Get data from cache
  String? get(String key) {
    return _cache[key];
  }

  /// [dispose] - Cleanup resources
  void dispose() {
    debugPrint('[Cache] Disposing... (${_cache.length} items)');
    _cache.clear();
    _isDisposed = true;
    debugPrint('[Cache] Disposed!');
  }
}

/// ===========================================
/// REGISTRATION
/// ===========================================
/// [setupAsyncDependencies] - Setup async dependencies (đăng ký dependency)
Future<void> setupAsyncDependencies() async {
  if (sl2.isRegistered<DatabaseConnection>()) return;

  /// ===========================================
  /// 1. LAZY SINGLETON ASYNC
  /// ===========================================
  /// [registerLazySingletonAsync] - Async factory, singleton
  /// Dùng khi cần await trong factory function
  sl2.registerLazySingletonAsync<DatabaseConnection>(
    () async {
      final db = DatabaseConnection('MainDB');
      await db.connect(); // Async init!
      return db;
    },
    dispose: (db) => db.close(), // Cleanup callback
  );

  /// ===========================================
  /// 2. SINGLETON WITH DISPOSE
  /// ===========================================
  /// [registerLazySingleton với dispose]
  /// dispose được gọi khi reset hoặc unregister
  sl2.registerLazySingleton<CacheService>(
    () => CacheService(),
    dispose: (cache) => cache.dispose(),
  );
}

/// ===========================================
/// DEMO UI
/// ===========================================
class Ex08GetItLazy extends StatefulWidget {
  const Ex08GetItLazy({super.key});

  @override
  State<Ex08GetItLazy> createState() => _Ex08GetItLazyState();
}

class _Ex08GetItLazyState extends State<Ex08GetItLazy> {
  final List<String> _logs = []; // Log messages
  bool _isRegistered = false; // Check if registered

  @override
  void initState() {
    super.initState();
    _setup(); // Setup async dependencies
  }

  /// [setup] - Setup async dependencies (đăng ký dependency)
  Future<void> _setup() async {
    await setupAsyncDependencies();
    setState(() => _isRegistered = true);
  }

  /// [log] - Log messages (thêm log vào danh sách)
  void _log(String message) {
    setState(() {
      _logs.insert(0, '[${DateTime.now().second}s] $message');
      if (_logs.length > 15) _logs.removeLast();
    });
  }

  /// [getDatabase] - Get async dependency (lấy async dependency)
  Future<void> _getDatabase() async {
    _log('Getting DatabaseConnection...');

    /// [isReadySync] - Check if ready synchronously (kiểm tra xem đã sẵn sàng chưa)
    if (!sl2.isReadySync<DatabaseConnection>()) {
      _log('DB not ready, awaiting...');
    }

    /// [getAsync] - Lấy async dependency
    /// Chờ đến khi ready
    final db = await sl2.getAsync<DatabaseConnection>();

    _log('Got DB: ${db.dbName}, connected: ${db.isConnected}');
  }

  /// [queryDatabase] - Query database (truy vấn database)
  Future<void> _queryDatabase() async {
    try {
      final db = await sl2.getAsync<DatabaseConnection>();
      final result = await db.query('SELECT * FROM users');
      _log('Query result: $result');
    } catch (e) {
      _log('Error: $e');
    }
  }

  /// [useCache] - Use cache (sử dụng cache)
  void _useCache() {
    final cache = sl2<CacheService>(); // Lấy cache
    cache.put('user', 'John Doe'); // Put data into cache
    cache.put('token', 'abc123'); // Put data into cache
    _log('Cache size: ${cache.cacheSize}'); // Log cache size
  }

  /// [resetLazySingleton] - Reset 1 lazy singleton (reset lazy singleton)
  Future<void> _resetLazySingleton() async {
    _log('Resetting DatabaseConnection...');

    /// [resetLazySingleton] - Reset 1 lazy singleton
    /// dispose callback được gọi, sau đó tạo mới khi get
    await sl2.resetLazySingleton<DatabaseConnection>();

    _log('DB reset! Will reconnect on next get.');
  }

  /// [resetAll] - Reset toàn bộ (reset toàn bộ)
  Future<void> _resetAll() async {
    _log('Resetting ALL dependencies...');

    /// [reset] - Reset toàn bộ
    /// Tất cả dispose callbacks được gọi
    await sl2.reset();

    _log('All reset! Re-registering...');
    await _setup(); // Setup lại async dependencies
    _log('Re-registered!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex08: get_it Lazy & Dispose')),
      body: Column(
        children: [
          // Info
          const Card(
            color: Colors.teal,
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 Advanced get_it Features',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• registerLazySingletonAsync: Async factory\n'
                    '• dispose callback: Cleanup resources\n'
                    '• resetLazySingleton: Reset 1 dependency\n'
                    '• reset(): Reset all dependencies',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),

          // Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // Get async dependency (lấy async dependency)
                ElevatedButton(
                  onPressed: _isRegistered ? _getDatabase : null,
                  child: const Text('Get DB'),
                ),
                // Query database (truy vấn database)
                ElevatedButton(
                  onPressed: _isRegistered ? _queryDatabase : null,
                  child: const Text('Query'),
                ),
                // Use cache (sử dụng cache)
                ElevatedButton(
                  onPressed: _isRegistered ? _useCache : null,
                  child: const Text('Use Cache'),
                ),
                // Reset 1 lazy singleton (reset lazy singleton)
                OutlinedButton(
                  onPressed: _isRegistered ? _resetLazySingleton : null,
                  child: const Text('Reset DB'),
                ),
                // Reset toàn bộ (reset toàn bộ)
                OutlinedButton(
                  onPressed: _isRegistered ? _resetAll : null,
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Reset All'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Logs
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                itemCount: _logs.length,
                itemBuilder: (context, index) {
                  return Text(
                    _logs[index], // Hiển thị log
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
