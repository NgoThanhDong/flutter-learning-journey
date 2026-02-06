/// ===========================================
/// EXERCISE 16: FAILURE CLASSES
/// ===========================================
/// Best Practices:
///  - Domain layer return Either, không throw
///  - Failure classes có message rõ ràng
///  - Map Failure → user-friendly message ở UI
///  - Log original error ở repository
///  - Retry logic ở repository hoặc use case

library;

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' show Either, Left, Right;

/// Custom Failure classes
abstract class Failure {
  final String message;
  final String? code;
  const Failure(this.message, {this.code});
}

/// Server Failure class định nghĩa các lỗi từ server
class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode, super.code});

  /// Factory constructor để tạo instance ServerFailure từ status code
  factory ServerFailure.fromStatusCode(int code) {
    switch (code) {
      case 400:
        return ServerFailure('Bad request', statusCode: 400);
      case 401:
        return ServerFailure('Unauthorized', statusCode: 401, code: 'AUTH');
      case 404:
        return ServerFailure('Not found', statusCode: 404);
      case 500:
        return ServerFailure('Server error', statusCode: 500);
      default:
        return ServerFailure('Unknown error', statusCode: code);
    }
  }
}

/// Network Failure class định nghĩa các lỗi từ network
class NetworkFailure extends Failure {
  const NetworkFailure() : super('No internet connection', code: 'NETWORK');
}

/// Cache Failure class định nghĩa các lỗi từ cache
class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code});
}

/// Validation Failure class định nghĩa các lỗi từ validation
class ValidationFailure extends Failure {
  final Map<String, String> fieldErrors;
  const ValidationFailure(super.message, {this.fieldErrors = const {}});
}

/// Fake API class định nghĩa các endpoint để test
class FakeApi {
  Future<Either<Failure, String>> call(int endpoint) async {
    await Future.delayed(const Duration(milliseconds: 500));
    switch (endpoint) {
      case 400:
        return Left(ServerFailure.fromStatusCode(400));
      case 401:
        return Left(ServerFailure.fromStatusCode(401));
      case 404:
        return Left(ServerFailure.fromStatusCode(404));
      case 500:
        return Left(ServerFailure.fromStatusCode(500));
      case 0:
        return const Left(NetworkFailure());
      case -1:
        return const Left(CacheFailure('Cache expired'));
      case -2:
        return Left(
          ValidationFailure(
            'Validation failed',
            fieldErrors: {'email': 'Invalid'},
          ),
        );
      default:
        return Right('Success from endpoint $endpoint');
    }
  }
}

/// Ex16FailureClasses class định nghĩa giao diện người dùng
class Ex16FailureClasses extends StatefulWidget {
  const Ex16FailureClasses({super.key});
  @override
  State<Ex16FailureClasses> createState() => _Ex16FailureClassesState();
}

class _Ex16FailureClassesState extends State<Ex16FailureClasses> {
  final _api = FakeApi();
  String _result = '';
  bool _isLoading = false;

  /// _callApi method gọi API và xử lý kết quả
  Future<void> _callApi(int endpoint) async {
    setState(() {
      _isLoading = true;
      _result = '';
    });

    /// Gọi API và xử lý kết quả
    final result = await _api.call(endpoint);

    /// result.fold() method xử lý kết quả của API call
    /// Nếu có lỗi, sẽ chuyển đổi Failure thành message
    /// Nếu thành công, sẽ hiển thị kết quả
    result.fold(
      (failure) => setState(() => _result = _mapFailureToMessage(failure)),
      (success) => setState(() => _result = '✅ $success'),
    );
    setState(() => _isLoading = false);
  }

  /// _mapFailureToMessage method chuyển đổi Failure thành message
  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return '❌ Server Error (${failure.statusCode}): ${failure.message}';
    } else if (failure is NetworkFailure) {
      return '📶 No Internet: ${failure.message}';
    } else if (failure is CacheFailure) {
      return '💾 Cache Error: ${failure.message}';
    } else if (failure is ValidationFailure) {
      return '⚠️ Validation: ${failure.fieldErrors}';
    }
    return '❓ Unknown error';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ex16: Failure Classes')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Card(
              color: Colors.red,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  '💡 Custom Failure classes:\nServerFailure, NetworkFailure, CacheFailure, ValidationFailure',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Simulate API calls:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            /// Wrap widget để hiển thị các button theo hàng ngang
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => _callApi(200),
                  child: const Text('Success'),
                ),
                ElevatedButton(
                  onPressed: () => _callApi(400),
                  child: const Text('400'),
                ),
                ElevatedButton(
                  onPressed: () => _callApi(401),
                  child: const Text('401'),
                ),
                ElevatedButton(
                  onPressed: () => _callApi(404),
                  child: const Text('404'),
                ),
                ElevatedButton(
                  onPressed: () => _callApi(500),
                  child: const Text('500'),
                ),
                ElevatedButton(
                  onPressed: () => _callApi(0),
                  child: const Text('Network'),
                ),
                ElevatedButton(
                  onPressed: () => _callApi(-1),
                  child: const Text('Cache'),
                ),
                ElevatedButton(
                  onPressed: () => _callApi(-2),
                  child: const Text('Validation'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            /// Hiển thị loading khi đang gọi API
            if (_isLoading) const CircularProgressIndicator(),

            /// Hiển thị kết quả khi có kết quả
            if (_result.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(_result, style: const TextStyle(fontSize: 16)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
