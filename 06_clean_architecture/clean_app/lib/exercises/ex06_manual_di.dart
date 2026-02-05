/// ===========================================
/// EXERCISE 06: MANUAL DEPENDENCY INJECTION
/// ===========================================
/// 🎯 Mục tiêu:
/// - Hiểu Constructor Injection
/// - Tự tay inject dependencies
/// - Thấy vấn đề khi scale (nhiều dependencies)
///
/// 📝 Manual DI:
/// - Tạo dependencies ở 1 nơi (composition root)
/// - Truyền qua constructor
/// - Không dùng thư viện bên ngoài

library;

import 'package:flutter/material.dart';

/// ===========================================
/// DEPENDENCIES (các class cần inject)
/// ===========================================

/// [Logger] - Ghi log
abstract class Logger {
  void log(String message);
}

/// [ConsoleLogger] - Ghi log ra console
class ConsoleLogger implements Logger {
  @override
  void log(String message) {
    debugPrint('[LOG] $message');
  }
}

/// [ApiClient] - Gọi API
abstract class ApiClient {
  Future<Map<String, dynamic>> get(String endpoint);
}

/// [HttpApiClient] - Gọi API thông qua HTTP
class HttpApiClient implements ApiClient {
  final Logger logger; // Inject Logger

  /// [Constructor Injection] - Inject Logger
  HttpApiClient(this.logger);

  /// [Override] - Implement get method from ApiClient
  @override
  Future<Map<String, dynamic>> get(String endpoint) async {
    logger.log('Fetching $endpoint...');
    await Future.delayed(const Duration(milliseconds: 500));
    logger.log('Got response from $endpoint');
    return {'status': 'ok', 'endpoint': endpoint};
  }
}

/// [UserRepository] - Quản lý user data
abstract class UserRepository {
  Future<Map<String, dynamic>> getUser(int id);
}

/// [ApiUserRepository] - Quản lý user data thông qua API
class ApiUserRepository implements UserRepository {
  final ApiClient apiClient; // Inject ApiClient
  final Logger logger; // Inject Logger

  /// [Multiple dependencies] - Inject nhiều dependencies
  ApiUserRepository({required this.apiClient, required this.logger});

  /// [Override] - Implement getUser method from UserRepository
  @override
  Future<Map<String, dynamic>> getUser(int id) async {
    logger.log('Getting user $id');
    final data = await apiClient.get('/users/$id');
    return {...data, 'userId': id, 'name': 'User $id'};
  }
}

/// [UserService] - Business logic
class UserService {
  final UserRepository repository; // Inject UserRepository
  final Logger logger; // Inject Logger

  /// [Constructor Injection] - Inject UserRepository, Logger
  UserService({required this.repository, required this.logger});

  /// [Override] - Implement fetchUser method from UserService
  Future<Map<String, dynamic>> fetchUser(int id) async {
    logger.log('Service: fetching user $id');
    return repository.getUser(id);
  }
}

/// ===========================================
/// COMPOSITION ROOT (nơi tạo và wire dependencies)
/// ===========================================
class DependencyContainer {
  /// [Singleton instance]
  /// - Chỉ có 1 instance duy nhất
  /// - Tránh tạo nhiều instance không cần thiết
  static final DependencyContainer _instance = DependencyContainer._();

  /// [Factory constructor] - Chỉ có 1 instance duy nhất
  factory DependencyContainer() => _instance;

  /// [Private constructor] - Chỉ có 1 instance duy nhất
  DependencyContainer._();

  /// [Lazy initialization]
  /// - Chỉ tạo instance khi cần
  /// - Tốt cho performance
  /// - Tốt cho testing
  Logger? _logger;
  ApiClient? _apiClient;
  UserRepository? _userRepository;
  UserService? _userService;

  /// [Getters với lazy init] - Chỉ tạo instance khi cần
  Logger get logger => _logger ??= ConsoleLogger();

  ApiClient get apiClient => _apiClient ??= HttpApiClient(logger);

  UserRepository get userRepository => _userRepository ??= ApiUserRepository(
    apiClient: apiClient,
    logger: logger,
  );

  UserService get userService =>
      _userService ??= UserService(repository: userRepository, logger: logger);

  /// [Reset for testing]
  void reset() {
    _logger = null;
    _apiClient = null;
    _userRepository = null;
    _userService = null;
  }
}

/// ===========================================
/// DEMO UI
/// ===========================================
class Ex06ManualDI extends StatefulWidget {
  const Ex06ManualDI({super.key});

  @override
  State<Ex06ManualDI> createState() => _Ex06ManualDIState();
}

class _Ex06ManualDIState extends State<Ex06ManualDI> {
  /// [DependencyContainer] - Tạo instance từ container
  final _container = DependencyContainer();

  /// [State variables]
  Map<String, dynamic>? _userData; // Data từ API
  bool _isLoading = false; // Loading state
  final List<String> _logs = []; // Log messages

  @override
  void initState() {
    super.initState();
    // Có thể override logger cho UI
    _setupLogging();
  }

  /// [Setup logging] - Setup logger cho UI
  void _setupLogging() {
    // Trong real app, có thể inject UILogger
  }

  /// [Fetch user] - Lấy user từ API
  Future<void> _fetchUser() async {
    setState(() {
      _isLoading = true;
      _logs.clear();
    });

    // Lấy service từ container
    final service = _container.userService;

    // Log dependencies
    _logs.add('Got UserService from container');
    _logs.add('UserService has UserRepository injected');
    _logs.add('UserRepository has ApiClient, Logger injected');

    // Lấy user từ API
    final user = await service.fetchUser(1);

    setState(() {
      _userData = user;
      _isLoading = false;
      _logs.add('User fetched successfully');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex06: Manual DI')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info
            const Card(
              color: Colors.indigo,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💡 Manual Dependency Injection',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Dependency graph:\n'
                      'Logger\n'
                      '  └→ ApiClient(Logger)\n'
                      '       └→ UserRepository(ApiClient, Logger)\n'
                      '            └→ UserService(Repository, Logger)',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Button fetch user
            ElevatedButton(
              onPressed: _isLoading ? null : _fetchUser,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Fetch User (via DI)'),
            ),

            const SizedBox(height: 16),

            // Logs
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'DI Resolution Log:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Divider(),

                    // Log messages
                    // _logs là một List<String>
                    // List.generate(_logs.length, (i) { ... }) tạo ra một List<Widget>
                    // Mỗi widget là một Text widget hiển thị log message
                    ...List.generate(_logs.length, (i) {
                      return Text('${i + 1}. ${_logs[i]}');
                    }),
                    if (_logs.isEmpty)
                      const Text('Click button to see DI in action'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Result
            if (_userData != null)
              Card(
                color: Colors.green[50],
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'User Data:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Divider(),

                      // User data
                      // _userData!.entries là một Map<String, dynamic>
                      // .entries trả về một Iterable<MapEntry<String, dynamic>>
                      // .map() lặp qua từng entry và trả về một Widget
                      // Text('${e.key}: ${e.value}') hiển thị key và value của mỗi entry
                      ..._userData!.entries.map(
                        (e) => Text('${e.key}: ${e.value}'),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Problem
            const Card(
              color: Colors.orange,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '⚠️ Vấn đề với Manual DI:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '1. Phải tự quản lý lifecycle\n'
                      '2. Code container dài khi nhiều deps\n'
                      '3. Khó track dependency graph\n\n'
                      '→ Giải pháp: Dùng get_it (bài sau)',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
