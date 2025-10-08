import 'dart:io';

import 'package:flutter/material.dart';

// Custom Exception Classes
class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  NetworkException(this.message, {this.statusCode});

  @override
  String toString() => 'NetworkException: $message';
}

class ValidationException implements Exception {
  final String message;
  final Map<String, String>? fieldErrors;

  ValidationException(this.message, {this.fieldErrors});

  @override
  String toString() => 'ValidationException: $message';
}

class AuthenticationException implements Exception {
  final String message;

  AuthenticationException(this.message);

  @override
  String toString() => 'AuthenticationException: $message';
}

class StorageException implements Exception {
  final String message;

  StorageException(this.message);

  @override
  String toString() => 'StorageException: $message';
}

class BiometricException implements Exception {
  final String message;
  final BiometricErrorType type;

  BiometricException(this.message, this.type);

  @override
  String toString() => 'BiometricException: $message';
}

enum BiometricErrorType {
  notAvailable,
  notEnrolled,
  lockedOut,
  userCancel,
  unknown,
}

// Error Handler Service
class ErrorHandlerService {
  static const String _logTag = 'ErrorHandler';

  // Handle and display errors to user
  static void handleError(
    BuildContext context,
    dynamic error, {
    String? customMessage,
    bool showSnackBar = true,
    VoidCallback? onRetry,
  }) {
    final errorInfo = _analyzeError(error);

    // Log error for debugging
    _logError(error, errorInfo);

    // Show user-friendly message
    if (showSnackBar) {
      _showErrorSnackBar(
        context,
        customMessage ?? errorInfo.userMessage,
        errorInfo.severity,
        onRetry: onRetry,
      );
    }

    // Handle critical errors
    if (errorInfo.severity == ErrorSeverity.critical) {
      _handleCriticalError(context, errorInfo);
    }
  }

  // Analyze error and return structured information
  static ErrorInfo _analyzeError(dynamic error) {
    if (error is NetworkException) {
      return ErrorInfo(
        type: ErrorType.network,
        severity: _getNetworkErrorSeverity(error.statusCode),
        userMessage: _getNetworkErrorMessage(error.statusCode),
        technicalMessage: error.message,
        canRetry: true,
      );
    }

    if (error is ValidationException) {
      return ErrorInfo(
        type: ErrorType.validation,
        severity: ErrorSeverity.warning,
        userMessage: error.message,
        technicalMessage: error.toString(),
        canRetry: false,
        fieldErrors: error.fieldErrors,
      );
    }

    if (error is AuthenticationException) {
      return ErrorInfo(
        type: ErrorType.authentication,
        severity: ErrorSeverity.high,
        userMessage: 'Authentication failed. Please sign in again.',
        technicalMessage: error.message,
        canRetry: true,
      );
    }

    if (error is StorageException) {
      return ErrorInfo(
        type: ErrorType.storage,
        severity: ErrorSeverity.medium,
        userMessage: 'Failed to save data. Please try again.',
        technicalMessage: error.message,
        canRetry: true,
      );
    }

    if (error is BiometricException) {
      return ErrorInfo(
        type: ErrorType.biometric,
        severity: ErrorSeverity.low,
        userMessage: _getBiometricErrorMessage(error.type),
        technicalMessage: error.message,
        canRetry: error.type != BiometricErrorType.notAvailable,
      );
    }

    if (error is SocketException) {
      return ErrorInfo(
        type: ErrorType.network,
        severity: ErrorSeverity.high,
        userMessage: 'No internet connection. Please check your network.',
        technicalMessage: error.toString(),
        canRetry: true,
      );
    }

    if (error is FormatException) {
      return ErrorInfo(
        type: ErrorType.parsing,
        severity: ErrorSeverity.medium,
        userMessage: 'Invalid data format received.',
        technicalMessage: error.toString(),
        canRetry: false,
      );
    }

    // Generic error
    return ErrorInfo(
      type: ErrorType.unknown,
      severity: ErrorSeverity.medium,
      userMessage: 'An unexpected error occurred. Please try again.',
      technicalMessage: error.toString(),
      canRetry: true,
    );
  }

  // Get network error severity based on status code
  static ErrorSeverity _getNetworkErrorSeverity(int? statusCode) {
    if (statusCode == null) return ErrorSeverity.high;

    if (statusCode >= 500) return ErrorSeverity.critical;
    if (statusCode >= 400) return ErrorSeverity.high;
    if (statusCode >= 300) return ErrorSeverity.medium;

    return ErrorSeverity.low;
  }

  // Get user-friendly network error message
  static String _getNetworkErrorMessage(int? statusCode) {
    if (statusCode == null) return 'Network error occurred';

    switch (statusCode) {
      case 400:
        return 'Invalid request. Please check your input.';
      case 401:
        return 'Authentication required. Please sign in.';
      case 403:
        return 'Access denied. You don\'t have permission.';
      case 404:
        return 'Requested resource not found.';
      case 408:
        return 'Request timeout. Please try again.';
      case 429:
        return 'Too many requests. Please wait and try again.';
      case 500:
        return 'Server error. Please try again later.';
      case 502:
        return 'Service temporarily unavailable.';
      case 503:
        return 'Service maintenance in progress.';
      default:
        if (statusCode >= 500) {
          return 'Server error occurred. Please try again later.';
        } else if (statusCode >= 400) {
          return 'Request failed. Please check your input.';
        }
        return 'Network error occurred';
    }
  }

  // Get biometric error message
  static String _getBiometricErrorMessage(BiometricErrorType type) {
    switch (type) {
      case BiometricErrorType.notAvailable:
        return 'Biometric authentication is not available on this device.';
      case BiometricErrorType.notEnrolled:
        return 'No biometric credentials enrolled. Please set up biometrics in device settings.';
      case BiometricErrorType.lockedOut:
        return 'Biometric authentication is temporarily locked. Please try again later.';
      case BiometricErrorType.userCancel:
        return 'Biometric authentication was cancelled.';
      case BiometricErrorType.unknown:
        return 'Biometric authentication failed. Please try again.';
    }
  }

  // Show error snackbar with appropriate styling
  static void _showErrorSnackBar(
    BuildContext context,
    String message,
    ErrorSeverity severity, {
    VoidCallback? onRetry,
  }) {
    Color backgroundColor;
    IconData icon;

    switch (severity) {
      case ErrorSeverity.critical:
        backgroundColor = Colors.red.shade700;
        icon = Icons.error;
        break;
      case ErrorSeverity.high:
        backgroundColor = Colors.red.shade600;
        icon = Icons.warning;
        break;
      case ErrorSeverity.medium:
        backgroundColor = Colors.orange.shade600;
        icon = Icons.info;
        break;
      case ErrorSeverity.low:
        backgroundColor = Colors.blue.shade600;
        icon = Icons.info_outline;
        break;
      case ErrorSeverity.warning:
        backgroundColor = Colors.amber.shade600;
        icon = Icons.warning_amber;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: Duration(seconds: severity == ErrorSeverity.critical ? 8 : 4),
        action: onRetry != null
            ? SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: onRetry,
              )
            : null,
      ),
    );
  }

  // Handle critical errors that might require app restart or logout
  static void _handleCriticalError(BuildContext context, ErrorInfo errorInfo) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 8),
              Text('Critical Error'),
            ],
          ),
          content: Text(errorInfo.userMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Could implement app restart logic here
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Log error for debugging and analytics
  static void _logError(dynamic error, ErrorInfo errorInfo) {
    final timestamp = DateTime.now().toIso8601String();

    debugPrint('[$_logTag] [$timestamp] ${errorInfo.type.name.toUpperCase()}');
    debugPrint('User Message: ${errorInfo.userMessage}');
    debugPrint('Technical: ${errorInfo.technicalMessage}');
    debugPrint('Severity: ${errorInfo.severity.name}');
    debugPrint('Can Retry: ${errorInfo.canRetry}');

    if (errorInfo.fieldErrors != null) {
      debugPrint('Field Errors: ${errorInfo.fieldErrors}');
    }

    // Here you could send to analytics service
    // AnalyticsService.logError(errorInfo);
  }

  // Wrapper for async operations with error handling
  static Future<T?> safeExecute<T>(
    Future<T> Function() operation, {
    required BuildContext context,
    String? loadingMessage,
    String? successMessage,
    VoidCallback? onSuccess,
    VoidCallback? onError,
    bool showLoading = false,
  }) async {
    try {
      if (showLoading && loadingMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 12),
                Text(loadingMessage),
              ],
            ),
            duration: const Duration(
              minutes: 1,
            ), // Will be dismissed when operation completes
          ),
        );
      }

      final result = await operation();

      if (showLoading) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }

      if (successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Text(successMessage),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );
      }

      onSuccess?.call();
      return result;
    } catch (error) {
      if (showLoading) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }

      handleError(context, error);
      onError?.call();
      return null;
    }
  }

  // Create specific exception types
  static NetworkException networkError(String message, {int? statusCode}) {
    return NetworkException(message, statusCode: statusCode);
  }

  static ValidationException validationError(
    String message, {
    Map<String, String>? fieldErrors,
  }) {
    return ValidationException(message, fieldErrors: fieldErrors);
  }

  static AuthenticationException authError(String message) {
    return AuthenticationException(message);
  }

  static StorageException storageError(String message) {
    return StorageException(message);
  }

  static BiometricException biometricError(
    String message,
    BiometricErrorType type,
  ) {
    return BiometricException(message, type);
  }
}

// Error Information Structure
class ErrorInfo {
  final ErrorType type;
  final ErrorSeverity severity;
  final String userMessage;
  final String technicalMessage;
  final bool canRetry;
  final Map<String, String>? fieldErrors;

  ErrorInfo({
    required this.type,
    required this.severity,
    required this.userMessage,
    required this.technicalMessage,
    required this.canRetry,
    this.fieldErrors,
  });
}

// Error Types
enum ErrorType {
  network,
  validation,
  authentication,
  storage,
  biometric,
  parsing,
  unknown,
}

// Error Severity Levels
enum ErrorSeverity { low, medium, high, critical, warning }
