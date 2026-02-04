/// EXERCISE 16: FAILURE CLASSES
library;

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' show Either, Left, Right;

/// Custom Failure classes
abstract class Failure {
  final String message;
  final String? code;
  const Failure(this.message, {this.code});
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode, super.code});

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

class NetworkFailure extends Failure {
  const NetworkFailure() : super('No internet connection', code: 'NETWORK');
}

class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code});
}

class ValidationFailure extends Failure {
  final Map<String, String> fieldErrors;
  const ValidationFailure(super.message, {this.fieldErrors = const {}});
}

/// Fake API
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

class Ex16FailureClasses extends StatefulWidget {
  const Ex16FailureClasses({super.key});
  @override
  State<Ex16FailureClasses> createState() => _Ex16FailureClassesState();
}

class _Ex16FailureClassesState extends State<Ex16FailureClasses> {
  final _api = FakeApi();
  String _result = '';
  bool _isLoading = false;

  Future<void> _callApi(int endpoint) async {
    setState(() {
      _isLoading = true;
      _result = '';
    });
    final result = await _api.call(endpoint);
    result.fold(
      (failure) => setState(() => _result = _mapFailureToMessage(failure)),
      (success) => setState(() => _result = '✅ $success'),
    );
    setState(() => _isLoading = false);
  }

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
            if (_isLoading) const CircularProgressIndicator(),
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
