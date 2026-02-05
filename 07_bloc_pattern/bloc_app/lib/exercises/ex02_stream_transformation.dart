/// ===========================================
/// EXERCISE 02: STREAM TRANSFORMATIONS
/// ===========================================
/// 🎯 Mục tiêu:
/// - Sử dụng các operators: map, where, distinct
/// - Xử lý dữ liệu TRƯỚC khi nó đến được UI
/// - Chaining (nối chuỗi) các operators
///
/// 📝 Transformations:
/// - .map: Biến hình (VD: int -> String)
/// - .where: Lọc (VD: chỉ lấy số chẵn)
/// - .distinct: Bỏ qua nếu giống cái trước đó
/// - .take/skip: Lấy/Bỏ qua N phần tử đầu

library;

import 'dart:async';
import 'package:flutter/material.dart';

class Ex02StreamTransformation extends StatefulWidget {
  const Ex02StreamTransformation({super.key});

  @override
  State<Ex02StreamTransformation> createState() =>
      _Ex02StreamTransformationState();
}

class _Ex02StreamTransformationState extends State<Ex02StreamTransformation> {
  final StreamController<int> _controller = StreamController<int>.broadcast();

  /// Stream đã được biến đổi (Transformed Stream)
  late Stream<String> _transformedStream;

  String _output = "Waiting for data...";
  int _inputValue = 0;

  @override
  void initState() {
    super.initState();

    /// ===========================================
    /// PIPELINE XỬ LÝ DỮ LIỆU
    /// ===========================================
    /// Input: Stream<int> (số nguyên)
    /// Output: Stream<String> (chuỗi kết quả)

    _transformedStream = _controller.stream
        // 1. Where: Chỉ cho phép số dương đi qua
        .where((number) {
          final isPositive = number >= 0;
          debugPrint(
            "Filter(Where): $number -> ${isPositive ? 'Pass' : 'Blocked'}",
          );
          return isPositive;
        })
        // 2. Map: Nhân đôi giá trị
        .map((number) {
          final doubled = number * 2;
          debugPrint("Transform(Map): $number * 2 = $doubled");
          return doubled;
        })
        // 3. Distinct: Bỏ qua nếu giá trị GIỐNG HỆT giá trị ngay trước nó
        .distinct((prev, next) {
          final isSame = prev == next;
          if (isSame) debugPrint("Distinct: Skipped duplicate $next");
          return isSame;
        })
        // 4. Map: Chuyển thành String để hiển thị
        .map((number) => "Result: $number");

    /// Lắng nghe kết quả cuối đường ống
    _transformedStream.listen((data) {
      setState(() {
        _output = data;
      });
    });
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  void _pushNumber(int number) {
    debugPrint("\n--- Pushing $number ---");
    _controller.sink.add(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex02: Stream Transformations')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // VISUALIZATION PIPELINE
              const Text(
                "Data Pipeline:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildPipelineStep("📥 Input (int)", Colors.grey),
              const Icon(Icons.arrow_downward),
              _buildPipelineStep("🔍 where(n >= 0)", Colors.orange),
              const Icon(Icons.arrow_downward),
              _buildPipelineStep("✨ map(n * 2)", Colors.blue),
              const Icon(Icons.arrow_downward),
              _buildPipelineStep("🚫 distinct()", Colors.purple),
              const Icon(Icons.arrow_downward),
              _buildPipelineStep("📦 Output (String)", Colors.green),

              const SizedBox(height: 30),

              // OUTPUT DISPLAY
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green),
                ),
                child: Text(
                  _output,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // INPUT CONTROLS
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => setState(() => _inputValue--),
                    icon: const Icon(Icons.remove_circle, size: 32),
                  ),
                  Container(
                    width: 60,
                    alignment: Alignment.center,
                    child: Text(
                      "$_inputValue",
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _inputValue++),
                    icon: const Icon(Icons.add_circle, size: 32),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () => _pushNumber(_inputValue),
                icon: const Icon(Icons.send),
                label: const Text("Push to Stream"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                "Thử nghiệm:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text("1. Nhập số âm -> Sẽ bị chặn bởi 'where'"),
              const Text("2. Nhập số dương -> Sẽ được x2"),
              const Text(
                "3. Nhập cùng 1 số liên tiếp -> Sẽ bị chặn bởi 'distinct'",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPipelineStep(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color.withOpacity(1.0),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
