/// ===========================================
/// EXERCISE 04: INTERFACE SEGREGATION PRINCIPLE
/// ===========================================
/// 🎯 Mục tiêu:
/// - Hiểu ISP: Interface nhỏ gọn, chuyên biệt
/// - Tránh "fat interface"
/// - Dùng nhiều interface nhỏ thay vì 1 interface lớn
///
/// 📝 ISP nói gì?
/// "Clients should not be forced to depend on methods they don't use"
/// = Không ép client implement method không cần

library;

import 'package:flutter/material.dart';

/// ===========================================
/// ❌ VI PHẠM ISP - Interface quá lớn (Fat Interface)
/// ===========================================
abstract class BadWorker {
  void work();
  void eat();
  void sleep();
  void code();
  void manage();
  void design();
  void test();
}

/// Robot không cần eat/sleep nhưng bắt buộc implement
class BadRobot implements BadWorker {
  @override
  void work() => debugPrint('Working...');

  // UnimplementedError là một lỗi được ném ra khi một phương thức không được implement
  @override
  void eat() => throw UnimplementedError(); // Robot không ăn!

  @override
  void sleep() => throw UnimplementedError(); // Robot không ngủ!

  @override
  void code() => debugPrint('Coding...');

  @override
  void manage() => throw UnimplementedError(); // Robot không quản lý

  @override
  void design() => throw UnimplementedError(); // Robot không thiết kế

  @override
  void test() => debugPrint('Testing...');
}

/// ===========================================
/// ✅ TUÂN THỦ ISP - Các interface nhỏ, chuyên biệt
/// ===========================================

/// [Workable] - Khả năng làm việc
abstract class Workable {
  void work();
}

/// [Eatable] - Khả năng ăn
abstract class Eatable {
  void eat();
}

/// [Sleepable] - Khả năng ngủ
abstract class Sleepable {
  void sleep();
}

/// [Codeable] - Khả năng code
abstract class Codeable {
  void code();
  String get programmingLanguage;
}

/// [Manageable] - Khả năng quản lý
abstract class Manageable {
  void manage();
  int get teamSize;
}

/// [Designable] - Khả năng thiết kế
abstract class Designable {
  void design();
  String get designTool;
}

/// ===========================================
/// Các Worker chỉ implement interfaces cần thiết
/// ===========================================

/// [Developer] - Implements các interface cần cho dev
class Developer implements Workable, Eatable, Sleepable, Codeable {
  // tên của dev
  final String name;

  // ngôn ngữ lập trình của dev
  @override
  final String programmingLanguage;

  // constructor
  Developer(this.name, {this.programmingLanguage = 'Dart'});

  // implement Workable
  @override
  void work() => debugPrint('$name is working on code...');

  // implement Eatable
  @override
  void eat() => debugPrint('$name is eating lunch...');

  // implement Sleepable
  @override
  void sleep() => debugPrint('$name is sleeping...');

  // implement Codeable
  @override
  void code() => debugPrint('$name is coding in $programmingLanguage...');
}

/// [Manager] - Implements quản lý, không cần code
class Manager implements Workable, Eatable, Sleepable, Manageable {
  // tên của manager
  final String name;

  // số lượng thành viên trong team của manager
  @override
  final int teamSize;

  // constructor
  Manager(this.name, {this.teamSize = 5});

  // implement Workable
  @override
  void work() => debugPrint('$name is in meetings...');

  // implement Eatable
  @override
  void eat() => debugPrint('$name is having business lunch...');

  // implement Sleepable
  @override
  void sleep() => debugPrint('$name is resting...');

  // implement Manageable
  @override
  void manage() => debugPrint('$name is managing $teamSize people...');
}

/// [Robot] - Chỉ work và code, KHÔNG cần eat/sleep
class Robot implements Workable, Codeable {
  // model của robot
  final String model;

  // ngôn ngữ lập trình của robot
  @override
  final String programmingLanguage;

  // constructor
  Robot(this.model, {this.programmingLanguage = 'Python'});

  // implement Workable
  @override
  void work() => debugPrint('Robot $model is working 24/7...');

  // implement Codeable
  @override
  void code() =>
      debugPrint('Robot $model is auto-coding in $programmingLanguage...');
}

/// [Designer] - Design, không cần code
class Designer implements Workable, Eatable, Sleepable, Designable {
  // tên của designer
  final String name;

  // công cụ thiết kế của designer
  @override
  final String designTool;

  // constructor
  Designer(this.name, {this.designTool = 'Figma'});

  // implement Workable
  @override
  void work() => debugPrint('$name is designing...');

  // implement Eatable
  @override
  void eat() => debugPrint('$name is eating...');

  // implement Sleepable
  @override
  void sleep() => debugPrint('$name is sleeping...');

  // implement Designable
  @override
  void design() => debugPrint('$name is designing in $designTool...');
}

/// ===========================================
/// DEMO UI
/// ===========================================
class Ex04InterfaceSegregation extends StatefulWidget {
  const Ex04InterfaceSegregation({super.key});

  @override
  State<Ex04InterfaceSegregation> createState() =>
      _Ex04InterfaceSegregationState();
}

class _Ex04InterfaceSegregationState extends State<Ex04InterfaceSegregation> {
  // danh sách các worker
  final List<Workable> _workers = [
    Developer('Alice', programmingLanguage: 'Flutter'),
    Manager('Bob', teamSize: 8),
    Robot('RX-78', programmingLanguage: 'Python'),
    Designer('Carol', designTool: 'Figma'),
  ];

  // danh sách các logs
  final List<String> _logs = [];

  // hàm log action
  void _logAction(String action) {
    setState(() {
      // thêm action vào đầu danh sách
      _logs.insert(0, action);
      // nếu danh sách có nhiều hơn 10 action thì xóa action cũ nhất
      if (_logs.length > 10) _logs.removeLast();
    });
  }

  // hàm cho tất cả worker làm việc
  void _allWork() {
    for (final worker in _workers) {
      // gọi method work() của worker
      worker.work();
      // log action
      _logAction('${_getName(worker)} worked');
    }
  }

  // hàm cho tất cả worker ăn
  void _allEat() {
    for (final worker in _workers) {
      // kiểm tra xem worker có implements Eatable không
      if (worker is Eatable) {
        // ép kiểu và gọi method eat()
        (worker as Eatable).eat();
        // log action
        _logAction('${_getName(worker)} ate');
      } else {
        // log action
        _logAction('${_getName(worker)} cannot eat (not Eatable)');
      }
    }
  }

  // hàm lấy tên của worker
  String _getName(Workable worker) {
    if (worker is Developer) return worker.name;
    if (worker is Manager) return worker.name;
    if (worker is Robot) return 'Robot ${worker.model}';
    if (worker is Designer) return worker.name;
    return 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex04: Interface Segregation')),
      body: Column(
        children: [
          // Info card
          const Card(
            color: Colors.purple,
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 ISP = Interface Segregation Principle',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Interfaces nhỏ:\n'
                    '• Workable - work()\n'
                    '• Eatable - eat()\n'
                    '• Codeable - code()\n\n'
                    'Robot chỉ implements Workable, Codeable\n'
                    '→ Không cần implement eat(), sleep()',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),

          // Workers list
          Expanded(
            // danh sách các worker
            child: ListView.builder(
              itemCount: _workers.length, // số lượng worker
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                // lấy worker tại index
                final worker = _workers[index];

                return Card(
                  // ExpansionTile là widget cho phép mở rộng và thu gọn
                  child: ExpansionTile(
                    leading: _getWorkerIcon(worker), // icon của worker
                    title: Text(_getName(worker)), // tên của worker
                    subtitle: Text(
                      // các interface mà worker implements
                      _getCapabilities(worker),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Wrap(
                          spacing: 8,
                          // các action button
                          children: _buildActionButtons(worker),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _allWork,
                    child: const Text('All Work'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _allEat,
                    child: const Text('All Eat'),
                  ),
                ),
              ],
            ),
          ),

          // Logs
          Container(
            height: 150,
            color: Colors.grey[200],
            padding: const EdgeInsets.all(8),
            child: ListView(
              children: _logs.map((log) => Text('• $log')).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // hàm lấy icon của worker
  Icon _getWorkerIcon(Workable worker) {
    if (worker is Developer) return const Icon(Icons.code);
    if (worker is Manager) return const Icon(Icons.supervisor_account);
    if (worker is Robot) return const Icon(Icons.smart_toy);
    if (worker is Designer) return const Icon(Icons.design_services);
    return const Icon(Icons.person);
  }

  // hàm lấy các interface mà worker implements
  String _getCapabilities(Workable worker) {
    final caps = <String>['Workable'];
    if (worker is Eatable) caps.add('Eatable');
    if (worker is Sleepable) caps.add('Sleepable');
    if (worker is Codeable) caps.add('Codeable');
    if (worker is Manageable) caps.add('Manageable');
    if (worker is Designable) caps.add('Designable');
    return caps.join(', ');
  }

  // hàm tạo các action button cho worker
  List<Widget> _buildActionButtons(Workable worker) {
    final buttons = <Widget>[
      // ActionChip là widget cho phép tạo các action button
      ActionChip(
        label: const Text('Work'),
        onPressed: () {
          worker.work();
          _logAction('${_getName(worker)} worked');
        },
      ),
    ];

    // nếu worker implements Eatable
    if (worker is Eatable) {
      buttons.add(
        ActionChip(
          label: const Text('Eat'),
          onPressed: () {
            (worker as Eatable).eat(); // ép worker thành Eatable
            _logAction('${_getName(worker)} ate');
          },
        ),
      );
    }

    // nếu worker implements Codeable
    if (worker is Codeable) {
      buttons.add(
        ActionChip(
          label: const Text('Code'),
          onPressed: () {
            (worker as Codeable).code(); // ép worker thành Codeable
            _logAction('${_getName(worker)} coded');
          },
        ),
      );
    }

    // nếu worker implements Manageable
    if (worker is Manageable) {
      buttons.add(
        ActionChip(
          label: const Text('Manage'),
          onPressed: () {
            (worker as Manageable).manage(); // ép worker thành Manageable
            _logAction('${_getName(worker)} managed');
          },
        ),
      );
    }

    // nếu worker implements Designable
    if (worker is Designable) {
      buttons.add(
        ActionChip(
          label: const Text('Design'),
          onPressed: () {
            (worker as Designable).design(); // ép worker thành Designable
            _logAction('${_getName(worker)} designed');
          },
        ),
      );
    }

    return buttons;
  }
}
