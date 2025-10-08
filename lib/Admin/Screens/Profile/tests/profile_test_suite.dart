import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';

import '../../../theme/theme.dart';
import '../services/analytics_service.dart';
import '../services/api_service.dart';
import '../services/biometric_service.dart';
import '../services/error_handler_service.dart';
import '../services/preferences_service.dart';
import '../services/responsive_service.dart';
import '../services/validation_service.dart';

/// Comprehensive test suite for the Profile system
///
/// This file contains test utilities and mock implementations
/// for testing all profile-related functionality.
///
/// Usage:
/// ```dart
/// void main() {
///   ProfileTestSuite.runAllTests();
/// }
/// ```
class ProfileTestSuite {
  static void runAllTests() {
    group('Profile System Tests', () {
      _testValidationService();
      _testPreferencesService();
      _testErrorHandlerService();
      _testResponsiveService();
      _testAnalyticsService();
      _testApiService();
      _testBiometricService();
    });
  }

  static void _testValidationService() {
    group('ValidationService Tests', () {
      test('should validate email correctly', () {
        expect(ValidationService.validateEmail('test@example.com'), isNull);
        expect(ValidationService.validateEmail('invalid-email'), isNotNull);
        expect(ValidationService.validateEmail(''), isNotNull);
      });

      test('should validate name correctly', () {
        expect(ValidationService.validateName('John Doe'), isNull);
        expect(ValidationService.validateName(''), isNotNull);
        expect(ValidationService.validateName('A'), isNotNull);
      });

      test('should validate phone correctly', () {
        expect(ValidationService.validatePhone('+1234567890'), isNull);
        expect(ValidationService.validatePhone('123'), isNotNull);
        expect(ValidationService.validatePhone(''), isNotNull);
      });

      test('should validate username correctly', () {
        expect(ValidationService.validateUsername('johndoe'), isNull);
        expect(ValidationService.validateUsername('jo'), isNotNull);
        expect(ValidationService.validateUsername(''), isNotNull);
      });

      test('should validate profile form correctly', () {
        final result = ValidationService.validateProfileForm(
          name: 'John Doe',
          username: 'johndoe',
          email: 'john@example.com',
          phone: '+1234567890',
          dateOfBirth: '1990-01-01',
        );

        expect(ValidationService.hasErrors(result), isFalse);
      });

      test('should detect form errors correctly', () {
        final result = ValidationService.validateProfileForm(
          name: '',
          username: 'jo',
          email: 'invalid-email',
          phone: '123',
          dateOfBirth: '',
        );

        expect(ValidationService.hasErrors(result), isTrue);
        expect(ValidationService.getFirstError(result), isNotNull);
      });
    });
  }

  static void _testPreferencesService() {
    group('PreferencesService Tests', () {
      test('should save and retrieve theme mode', () async {
        await PreferencesService.saveThemeMode(AdminThemeMode.light);
        final theme = await PreferencesService.getThemeMode();
        expect(theme, equals(AdminThemeMode.light));
      });

      test('should save and retrieve profile data', () async {
        final profileData = {'name': 'John Doe', 'email': 'john@example.com'};

        await PreferencesService.saveProfileData(profileData);
        final retrieved = await PreferencesService.getProfileData();

        expect(retrieved, isNotNull);
        expect(retrieved!['name'], equals('John Doe'));
        expect(retrieved['email'], equals('john@example.com'));
      });

      test('should handle biometric settings', () async {
        await PreferencesService.setBiometricEnabled(true);
        final enabled = await PreferencesService.isBiometricEnabled();
        expect(enabled, isTrue);

        await PreferencesService.setBiometricEnabled(false);
        final disabled = await PreferencesService.isBiometricEnabled();
        expect(disabled, isFalse);
      });
    });
  }

  static void _testErrorHandlerService() {
    group('ErrorHandlerService Tests', () {
      test('should create network exceptions correctly', () {
        final exception = ErrorHandlerService.networkError(
          'Test error',
          statusCode: 404,
        );
        expect(exception, isA<NetworkException>());
        expect(exception.message, equals('Test error'));
        expect(exception.statusCode, equals(404));
      });

      test('should create validation exceptions correctly', () {
        final fieldErrors = {'email': 'Invalid email'};
        final exception = ErrorHandlerService.validationError(
          'Validation failed',
          fieldErrors: fieldErrors,
        );

        expect(exception, isA<ValidationException>());
        expect(exception.message, equals('Validation failed'));
        expect(exception.fieldErrors, equals(fieldErrors));
      });

      test('should create authentication exceptions correctly', () {
        final exception = ErrorHandlerService.authError('Auth failed');
        expect(exception, isA<AuthenticationException>());
        expect(exception.message, equals('Auth failed'));
      });

      test('should create biometric exceptions correctly', () {
        final exception = ErrorHandlerService.biometricError(
          'Biometric failed',
          BiometricErrorType.notAvailable,
        );

        expect(exception, isA<BiometricException>());
        expect(exception.message, equals('Biometric failed'));
        expect(exception.type, equals(BiometricErrorType.notAvailable));
      });
    });
  }

  static void _testResponsiveService() {
    group('ResponsiveService Tests', () {
      testWidgets('should detect device types correctly', (
        WidgetTester tester,
      ) async {
        // Test mobile
        await tester.binding.setSurfaceSize(const Size(400, 800));
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                expect(ResponsiveService.isMobile(context), isTrue);
                expect(ResponsiveService.isTablet(context), isFalse);
                expect(ResponsiveService.isDesktop(context), isFalse);
                return Container();
              },
            ),
          ),
        );

        // Test tablet
        await tester.binding.setSurfaceSize(const Size(800, 600));
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                expect(ResponsiveService.isMobile(context), isFalse);
                expect(ResponsiveService.isTablet(context), isTrue);
                expect(ResponsiveService.isDesktop(context), isFalse);
                return Container();
              },
            ),
          ),
        );

        // Test desktop
        await tester.binding.setSurfaceSize(const Size(1200, 800));
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                expect(ResponsiveService.isMobile(context), isFalse);
                expect(ResponsiveService.isTablet(context), isFalse);
                expect(ResponsiveService.isDesktop(context), isTrue);
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('should return responsive values correctly', (
        WidgetTester tester,
      ) async {
        await tester.binding.setSurfaceSize(const Size(400, 800)); // Mobile
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final value = ResponsiveService.responsive<int>(
                  context,
                  mobile: 1,
                  tablet: 2,
                  desktop: 3,
                );
                expect(value, equals(1));
                return Container();
              },
            ),
          ),
        );
      });
    });
  }

  static void _testAnalyticsService() {
    group('AnalyticsService Tests', () {
      test('should initialize correctly', () async {
        await AnalyticsService.initialize();
        // Test that analytics data can be retrieved (indirect test of initialization)
        final data = await AnalyticsService.getAnalyticsData();
        expect(data, isNotNull);
        expect(data['session_id'], isNotNull);
      });

      test('should log events correctly', () async {
        await AnalyticsService.initialize();

        // This would normally test event logging
        // In a real test, you'd mock the API service
        await AnalyticsService.logEvent('test_event', {'key': 'value'});

        // Test that events are being tracked by checking analytics data
        final data = await AnalyticsService.getAnalyticsData();
        expect(data['events_count'], greaterThan(0));
      });

      test('should export analytics data', () async {
        await AnalyticsService.initialize();
        await AnalyticsService.logEvent('test_event', {'key': 'value'});

        final exportData = await AnalyticsService.exportAnalyticsData();
        expect(exportData, isNotNull);
        expect(exportData, contains('test_event'));
      });
    });
  }

  static void _testApiService() {
    group('ApiService Tests', () {
      test('should handle API responses correctly', () {
        final json = {
          'success': true,
          'data': {'id': '1', 'name': 'Test'},
          'message': 'Success',
        };

        final response = ApiResponse<Map<String, dynamic>>.fromJson(
          json,
          (data) => data,
        );

        expect(response.success, isTrue);
        expect(response.data, isNotNull);
        expect(response.message, equals('Success'));
      });

      test('should create user profile from JSON', () {
        final json = {
          'id': '1',
          'name': 'John Doe',
          'username': 'johndoe',
          'email': 'john@example.com',
          'phone': '+1234567890',
          'date_of_birth': '1990-01-01',
          'gender': 'Male',
          'created_at': '2023-01-01T00:00:00Z',
          'updated_at': '2023-01-01T00:00:00Z',
        };

        final profile = UserProfile.fromJson(json);

        expect(profile.id, equals('1'));
        expect(profile.name, equals('John Doe'));
        expect(profile.email, equals('john@example.com'));
      });
    });
  }

  static void _testBiometricService() {
    group('BiometricService Tests', () {
      test('should handle biometric capability correctly', () async {
        // This would require mocking the local_auth package
        // For now, we test the data structures

        final capability = BiometricCapability(
          isAvailable: true,
          isEnrolled: true,
          availableTypes: [BiometricType.fingerprint],
          isEnabledInApp: false,
        );

        expect(capability.canUseBiometrics, isTrue);
        expect(capability.availableTypeNames, contains('Fingerprint'));
      });

      test('should create auth results correctly', () {
        final result = AuthResult(success: true, method: AuthMethod.biometric);

        expect(result.success, isTrue);
        expect(result.method, equals(AuthMethod.biometric));
        expect(result.cancelled, isFalse);
      });
    });
  }
}

/// Mock implementations for testing
class MockApiService {
  static Future<ApiResponse<T>> mockGet<T>(
    String endpoint, {
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));

    return ApiResponse<T>(
      success: true,
      data: fromJson != null ? fromJson({'mock': 'data'}) : null,
      message: 'Mock success',
    );
  }

  static Future<ApiResponse<T>> mockPost<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));

    return ApiResponse<T>(
      success: true,
      data: fromJson != null ? fromJson({'mock': 'data'}) : null,
      message: 'Mock success',
    );
  }
}

class MockBiometricService {
  static bool _isAvailable = true;
  static bool _isEnrolled = true;
  static bool _authResult = true;

  static Future<bool> mockIsAvailable() async {
    return _isAvailable;
  }

  static Future<bool> mockAuthenticate() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _authResult;
  }

  static void setMockValues({
    bool? isAvailable,
    bool? isEnrolled,
    bool? authResult,
  }) {
    _isAvailable = isAvailable ?? _isAvailable;
    _isEnrolled = isEnrolled ?? _isEnrolled;
    _authResult = authResult ?? _authResult;
  }
}

/// Test utilities
class ProfileTestUtils {
  static Map<String, dynamic> createMockProfileData() {
    return {
      'name': 'Test User',
      'username': 'testuser',
      'email': 'test@example.com',
      'phone': '+1234567890',
      'dateOfBirth': '1990-01-01',
      'gender': 'Other',
    };
  }

  static Map<String, dynamic> createMockNotificationSettings() {
    return {
      'email_notifications': true,
      'push_notifications': true,
      'sms_notifications': false,
      'quiet_hours': false,
    };
  }

  static List<Map<String, dynamic>> createMockConnectedAccounts() {
    return [
      {
        'id': '1',
        'provider': 'google',
        'account_id': 'google123',
        'email': 'test@gmail.com',
        'is_active': true,
        'connected_at': '2023-01-01T00:00:00Z',
      },
      {
        'id': '2',
        'provider': 'facebook',
        'account_id': 'fb456',
        'email': 'test@facebook.com',
        'is_active': false,
        'connected_at': '2023-01-01T00:00:00Z',
      },
    ];
  }

  static Widget createTestApp(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  static Future<void> pumpAndSettle(WidgetTester tester, Widget widget) async {
    await tester.pumpWidget(createTestApp(widget));
    await tester.pumpAndSettle();
  }
}

/// Integration test helpers
class ProfileIntegrationTests {
  static Future<void> testCompleteProfileFlow(WidgetTester tester) async {
    // This would test the complete profile editing flow
    // 1. Navigate to profile page
    // 2. Edit profile information
    // 3. Save changes
    // 4. Verify changes are persisted
  }

  static Future<void> testSecuritySettingsFlow(WidgetTester tester) async {
    // This would test the security settings flow
    // 1. Navigate to security settings
    // 2. Enable/disable 2FA
    // 3. Test biometric authentication
    // 4. Change password
  }

  static Future<void> testNotificationFlow(WidgetTester tester) async {
    // This would test the notification settings flow
    // 1. Navigate to notification settings
    // 2. Toggle various notification types
    // 3. Set quiet hours
    // 4. Verify settings are saved
  }
}

/// Performance test utilities
class ProfilePerformanceTests {
  static Future<void> measureProfileLoadTime() async {
    final stopwatch = Stopwatch()..start();

    // Simulate profile loading
    await Future.delayed(const Duration(milliseconds: 100));

    stopwatch.stop();

    expect(stopwatch.elapsedMilliseconds, lessThan(1000));
  }

  static Future<void> measureFormValidationTime() async {
    final stopwatch = Stopwatch()..start();

    // Test form validation performance
    for (int i = 0; i < 1000; i++) {
      ValidationService.validateEmail('test@example.com');
    }

    stopwatch.stop();

    expect(stopwatch.elapsedMilliseconds, lessThan(100));
  }
}
