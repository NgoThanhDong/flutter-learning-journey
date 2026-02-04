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

  @override
  void eat() => throw UnimplementedError(); // Robot không ăn!

  @override
  void sleep() => throw UnimplementedError(); // Robot không ngủ!

  @override
  void code() => debugPrint('Coding...');

  @override
  void manage() => throw UnimplementedError();

  @override
  void design() => throw UnimplementedError();

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
  final String name;

  @override
  final String programmingLanguage;

  Developer(this.name, {this.programmingLanguage = 'Dart'});

  @override
  void work() => debugPrint('$name is working on code...');

  @override
  void eat() => debugPrint('$name is eating lunch...');

  @override
  void sleep() => debugPrint('$name is sleeping...');

  @override
  void code() => debugPrint('$name is coding in $programmingLanguage...');
}

/// [Manager] - Implements quản lý, không cần code
class Manager implements Workable, Eatable, Sleepable, Manageable {
  final String name;

  @override
  final int teamSize;

  Manager(this.name, {this.teamSize = 5});

  @override
  void work() => debugPrint('$name is in meetings...');

  @override
  void eat() => debugPrint('$name is having business lunch...');

  @override
  void sleep() => debugPrint('$name is resting...');

  @override
  void manage() => debugPrint('$name is managing $teamSize people...');
}

/// [Robot] - Chỉ work và code, KHÔNG cần eat/sleep
class Robot implements Workable, Codeable {
  final String model;

  @override
  final String programmingLanguage;

  Robot(this.model, {this.programmingLanguage = 'Python'});

  @override
  void work() => debugPrint('Robot $model is working 24/7...');

  @override
  void code() =>
      debugPrint('Robot $model is auto-coding in $programmingLanguage...');
}

/// [Designer] - Design, không cần code
class Designer implements Workable, Eatable, Sleepable, Designable {
  final String name;

  @override
  final String designTool;

  Designer(this.name, {this.designTool = 'Figma'});

  @override
  void work() => debugPrint('$name is designing...');

  @override
  void eat() => debugPrint('$name is eating...');

  @override
  void sleep() => debugPrint('$name is sleeping...');

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
  final List<Workable> _workers = [
    Developer('Alice', programmingLanguage: 'Flutter'),
    Manager('Bob', teamSize: 8),
    Robot('RX-78', programmingLanguage: 'Python'),
    Designer('Carol', designTool: 'Figma'),
  ];

  final List<String> _logs = [];

  void _logAction(String action) {
    setState(() {
      _logs.insert(0, action);
      if (_logs.length > 10) _logs.removeLast();
    });
  }

  void _allWork() {
    for (final worker in _workers) {
      worker.work();
      _logAction('${_getName(worker)} worked');
    }
  }

  void _allEat() {
    for (final worker in _workers) {
      if (worker is Eatable) {
        (worker as Eatable).eat();
        _logAction('${_getName(worker)} ate');
      } else {
        _logAction('${_getName(worker)} cannot eat (not Eatable)');
      }
    }
  }

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
            child: ListView.builder(
              itemCount: _workers.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final worker = _workers[index];
                return Card(
                  child: ExpansionTile(
                    leading: _getWorkerIcon(worker),
                    title: Text(_getName(worker)),
                    subtitle: Text(_getCapabilities(worker)),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Wrap(
                          spacing: 8,
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

  Icon _getWorkerIcon(Workable worker) {
    if (worker is Developer) return const Icon(Icons.code);
    if (worker is Manager) return const Icon(Icons.supervisor_account);
    if (worker is Robot) return const Icon(Icons.smart_toy);
    if (worker is Designer) return const Icon(Icons.design_services);
    return const Icon(Icons.person);
  }

  String _getCapabilities(Workable worker) {
    final caps = <String>['Workable'];
    if (worker is Eatable) caps.add('Eatable');
    if (worker is Sleepable) caps.add('Sleepable');
    if (worker is Codeable) caps.add('Codeable');
    if (worker is Manageable) caps.add('Manageable');
    if (worker is Designable) caps.add('Designable');
    return caps.join(', ');
  }

  List<Widget> _buildActionButtons(Workable worker) {
    final buttons = <Widget>[
      ActionChip(
        label: const Text('Work'),
        onPressed: () {
          worker.work();
          _logAction('${_getName(worker)} worked');
        },
      ),
    ];

    if (worker is Eatable) {
      buttons.add(
        ActionChip(
          label: const Text('Eat'),
          onPressed: () {
            (worker as Eatable).eat();
            _logAction('${_getName(worker)} ate');
          },
        ),
      );
    }

    if (worker is Codeable) {
      buttons.add(
        ActionChip(
          label: const Text('Code'),
          onPressed: () {
            (worker as Codeable).code();
            _logAction('${_getName(worker)} coded');
          },
        ),
      );
    }

    if (worker is Manageable) {
      buttons.add(
        ActionChip(
          label: const Text('Manage'),
          onPressed: () {
            (worker as Manageable).manage();
            _logAction('${_getName(worker)} managed');
          },
        ),
      );
    }

    if (worker is Designable) {
      buttons.add(
        ActionChip(
          label: const Text('Design'),
          onPressed: () {
            (worker as Designable).design();
            _logAction('${_getName(worker)} designed');
          },
        ),
      );
    }

    return buttons;
  }
}
