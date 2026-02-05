/// ===========================================
/// EXERCISE 07: GET_IT BASIC
/// ===========================================
/// 🎯 Mục tiêu:
/// - Setup get_it service locator (trình định vị dịch vụ)
/// - Đăng ký Singleton và Factory
/// - Lấy dependencies từ container
///
/// 📝 get_it là gì?
/// - Service Locator pattern (pattern định vị dịch vụ)
/// - Container lưu trữ dependencies
/// - Dễ setup, dễ sử dụng

library;

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

/// ===========================================
/// SETUP GET_IT
/// ===========================================

/// [sl] = service locator (quy ước phổ biến)
final sl = GetIt.instance; // instance là thể hiện của lớp GetIt

/// [setupGetItDemo] - Đăng ký dependencies
/// Gọi 1 lần trong main() hoặc initState()
void setupGetItDemo() {
  // Reset để tránh duplicate registration trong demo
  if (sl.isRegistered<DemoLogger>()) return;

  /// ===========================================
  /// 1. REGISTER SINGLETON
  /// ===========================================
  /// [registerSingleton] - Tạo ngay, dùng chung 1 instance
  /// Use case (trường hợp sử dụng): Services khởi tạo sớm, dùng chung
  sl.registerSingleton<DemoLogger>(DemoLogger('MainLogger'));

  /// ===========================================
  /// 2. REGISTER LAZY SINGLETON
  /// ===========================================
  /// [registerLazySingleton] - Tạo khi cần, dùng chung
  /// Use case (trường hợp sử dụng): Services nặng, có thể không dùng
  sl.registerLazySingleton<DemoApiClient>(
    () => DemoApiClient(sl<DemoLogger>()),
  );

  /// ===========================================
  /// 3. REGISTER FACTORY
  /// ===========================================
  /// [registerFactory] - Tạo mới mỗi lần gọi
  /// Use case (trường hợp sử dụng): ViewModels, Controllers
  sl.registerFactory<DemoViewModel>(
    () =>
        DemoViewModel(logger: sl<DemoLogger>(), apiClient: sl<DemoApiClient>()),
  );

  /// ===========================================
  /// 4. REGISTER FACTORY WITH PARAM
  /// ===========================================
  /// [registerFactoryParam] - Factory với tham số
  /// Use case: ViewModel cần ID từ route
  sl.registerFactoryParam<DemoDetailViewModel, int, void>(
    (id, _) => DemoDetailViewModel(id: id, logger: sl<DemoLogger>()),
  );
}

/// ===========================================
/// DEMO CLASSES
/// ===========================================
// DemoLogger: Logger đơn giản
class DemoLogger {
  final String name;
  final DateTime createdAt = DateTime.now();

  DemoLogger(this.name) {
    debugPrint('[$name] Logger created at $createdAt');
  }

  void log(String message) {
    debugPrint('[$name] $message');
  }
}

// DemoApiClient: Client gọi API
class DemoApiClient {
  final DemoLogger logger;
  final DateTime createdAt = DateTime.now();

  DemoApiClient(this.logger) {
    logger.log('ApiClient created');
  }

  Future<String> fetch(String url) async {
    logger.log('Fetching $url');
    await Future.delayed(const Duration(milliseconds: 500));
    return 'Response from $url';
  }
}

// DemoViewModel: ViewModel sử dụng Logger và ApiClient
class DemoViewModel {
  final DemoLogger logger;
  final DemoApiClient apiClient;
  final DateTime createdAt = DateTime.now();

  DemoViewModel({required this.logger, required this.apiClient}) {
    logger.log('ViewModel created at $createdAt');
  }

  Future<String> loadData() async {
    return apiClient.fetch('/api/data');
  }
}

// DemoDetailViewModel: ViewModel với tham số ID
class DemoDetailViewModel {
  final int id;
  final DemoLogger logger;
  final DateTime createdAt = DateTime.now();

  DemoDetailViewModel({required this.id, required this.logger}) {
    logger.log('DetailViewModel for ID:$id created');
  }
}

/// ===========================================
/// DEMO UI
/// ===========================================
class Ex07GetItBasic extends StatefulWidget {
  const Ex07GetItBasic({super.key});

  @override
  State<Ex07GetItBasic> createState() => _Ex07GetItBasicState();
}

class _Ex07GetItBasicState extends State<Ex07GetItBasic> {
  String _output = '';

  @override
  void initState() {
    super.initState();
    setupGetItDemo(); // setup get_it demo
  }

  // test singleton để kiểm tra xem có cùng 1 instance không
  void _testSingleton() {
    final logger1 = sl<DemoLogger>();
    final logger2 = sl<DemoLogger>();

    setState(() {
      _output =
          '''
Logger 1 hashCode: ${logger1.hashCode}
Logger 2 hashCode: ${logger2.hashCode}
Same instance: ${logger1 == logger2}
Created at: ${logger1.createdAt}

→ SINGLETON: Cùng 1 instance!
''';
    });
  }

  // test factory để kiểm tra xem có tạo ra instance mới không
  void _testFactory() {
    final vm1 = sl<DemoViewModel>();
    final vm2 = sl<DemoViewModel>();

    setState(() {
      _output =
          '''
ViewModel 1 hashCode: ${vm1.hashCode}
ViewModel 2 hashCode: ${vm2.hashCode}
Same instance: ${vm1 == vm2}
VM1 created at: ${vm1.createdAt}
VM2 created at: ${vm2.createdAt}

→ FACTORY: Instance MỚI mỗi lần gọi!
''';
    });
  }

  // test factory param để kiểm tra xem có tạo ra instance mới không và có tham số không
  void _testFactoryParam() {
    final vm1 = sl<DemoDetailViewModel>(param1: 101);
    final vm2 = sl<DemoDetailViewModel>(param1: 202);

    setState(() {
      _output =
          '''
ViewModel 1 ID: ${vm1.id}
ViewModel 2 ID: ${vm2.id}
Same instance: ${vm1 == vm2}

→ FACTORY_PARAM: Mới + có tham số!
''';
    });
  }

  // test lazy singleton để kiểm tra xem có tạo ra instance mới không và có tham số không
  Future<void> _testLazySingleton() async {
    setState(() {
      _output = 'Đang get ApiClient lần đầu...\n';
    });

    final api1 = sl<DemoApiClient>();

    setState(() {
      _output += 'ApiClient 1 created: ${api1.createdAt}\n\n';
      _output += 'Get lần 2...\n';
    });

    final api2 = sl<DemoApiClient>();

    setState(() {
      _output += 'ApiClient 2 created: ${api2.createdAt}\n\n';
      _output += 'Same instance: ${api1 == api2}\n\n';
      _output += '→ LAZY_SINGLETON: Tạo 1 lần duy nhất!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex07: get_it Basic')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info
            Card(
              color: Colors.deepPurple,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '💡 get_it Registration Types',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // build type row
                    _buildTypeRow('Singleton', 'Tạo ngay, dùng chung'),
                    _buildTypeRow('LazySingleton', 'Tạo khi cần, dùng chung'),
                    _buildTypeRow('Factory', 'Mới mỗi lần gọi'),
                    _buildTypeRow('FactoryParam', 'Mới + có tham số'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Test buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // test singleton
                ElevatedButton(
                  onPressed: _testSingleton,
                  child: const Text('Test Singleton'),
                ),

                // test lazy singleton
                ElevatedButton(
                  onPressed: _testLazySingleton,
                  child: const Text('Test Lazy'),
                ),

                // test factory
                ElevatedButton(
                  onPressed: _testFactory,
                  child: const Text('Test Factory'),
                ),

                // test factory param
                ElevatedButton(
                  onPressed: _testFactoryParam,
                  child: const Text('Test Param'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Output
            Card(
              color: Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Output:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Divider(),

                    // SelectableText là widget cho phép copy text
                    SelectableText(
                      _output.isEmpty ? 'Click a button to test' : _output,
                      style: const TextStyle(fontFamily: 'monospace'),
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

  // _buildTypeRow là widget để build type row
  Widget _buildTypeRow(String type, String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        '• $type: $desc',
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
