import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

import 'error_handler_service.dart';
import 'preferences_service.dart';

class BiometricService {
  static final LocalAuthentication _localAuth = LocalAuthentication();

  // Check if biometric authentication is available
  static Future<bool> isAvailable() async {
    try {
      final bool isAvailable = await _localAuth.isDeviceSupported();
      final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;

      return isAvailable && canCheckBiometrics;
    } catch (e) {
      debugPrint('Error checking biometric availability: $e');
      return false;
    }
  }

  // Get available biometric types
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      debugPrint('Error getting available biometrics: $e');
      return [];
    }
  }

  // Check if biometrics are enrolled
  static Future<bool> isBiometricEnrolled() async {
    try {
      final availableBiometrics = await getAvailableBiometrics();
      return availableBiometrics.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking biometric enrollment: $e');
      return false;
    }
  }

  // Authenticate with biometrics
  static Future<bool> authenticate({
    String reason = 'Please authenticate to continue',
    bool useErrorDialogs = true,
    bool stickyAuth = false,
  }) async {
    try {
      // Check if biometrics are available
      if (!await isAvailable()) {
        throw ErrorHandlerService.biometricError(
          'Biometric authentication is not available',
          BiometricErrorType.notAvailable,
        );
      }

      // Check if biometrics are enrolled
      if (!await isBiometricEnrolled()) {
        throw ErrorHandlerService.biometricError(
          'No biometric credentials enrolled',
          BiometricErrorType.notEnrolled,
        );
      }

      // Perform authentication
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: reason,
        authMessages: const [
          AndroidAuthMessages(
            signInTitle: 'Biometric Authentication',
            cancelButton: 'Cancel',
            deviceCredentialsRequiredTitle: 'Device Credential Required',
            deviceCredentialsSetupDescription:
                'Device credential setup required',
            goToSettingsButton: 'Go to Settings',
            goToSettingsDescription: 'Setup biometric authentication',
          ),
          IOSAuthMessages(
            cancelButton: 'Cancel',
            goToSettingsButton: 'Go to Settings',
            goToSettingsDescription: 'Setup biometric authentication',
            lockOut: 'Biometric authentication is disabled',
          ),
        ],
        options: AuthenticationOptions(
          useErrorDialogs: useErrorDialogs,
          stickyAuth: stickyAuth,
          biometricOnly: false,
        ),
      );

      return didAuthenticate;
    } on PlatformException catch (e) {
      return _handlePlatformException(e);
    } catch (e) {
      throw ErrorHandlerService.biometricError(
        'Authentication failed: $e',
        BiometricErrorType.unknown,
      );
    }
  }

  // Handle platform-specific exceptions
  static bool _handlePlatformException(PlatformException e) {
    switch (e.code) {
      case 'NotAvailable':
        throw ErrorHandlerService.biometricError(
          'Biometric authentication is not available',
          BiometricErrorType.notAvailable,
        );
      case 'NotEnrolled':
        throw ErrorHandlerService.biometricError(
          'No biometric credentials enrolled',
          BiometricErrorType.notEnrolled,
        );
      case 'LockedOut':
      case 'PermanentlyLockedOut':
        throw ErrorHandlerService.biometricError(
          'Biometric authentication is locked',
          BiometricErrorType.lockedOut,
        );
      case 'UserCancel':
        throw ErrorHandlerService.biometricError(
          'Authentication cancelled by user',
          BiometricErrorType.userCancel,
        );
      default:
        throw ErrorHandlerService.biometricError(
          'Authentication failed: ${e.message}',
          BiometricErrorType.unknown,
        );
    }
  }

  // Enable biometric authentication for the app
  static Future<bool> enableBiometricAuth() async {
    try {
      // First check if biometrics are available
      if (!await isAvailable()) {
        throw ErrorHandlerService.biometricError(
          'Biometric authentication is not available on this device',
          BiometricErrorType.notAvailable,
        );
      }

      // Check if biometrics are enrolled
      if (!await isBiometricEnrolled()) {
        throw ErrorHandlerService.biometricError(
          'Please enroll biometric credentials in device settings first',
          BiometricErrorType.notEnrolled,
        );
      }

      // Test authentication
      final bool authenticated = await authenticate(
        reason: 'Authenticate to enable biometric login',
      );

      if (authenticated) {
        // Save biometric preference
        await PreferencesService.setBiometricEnabled(true);
        return true;
      }

      return false;
    } catch (e) {
      rethrow;
    }
  }

  // Disable biometric authentication for the app
  static Future<void> disableBiometricAuth() async {
    await PreferencesService.setBiometricEnabled(false);
  }

  // Check if biometric auth is enabled in app settings
  static Future<bool> isBiometricAuthEnabled() async {
    return await PreferencesService.isBiometricEnabled();
  }

  // Get biometric capability info
  static Future<BiometricCapability> getBiometricCapability() async {
    final bool isAvailable = await BiometricService.isAvailable();
    final bool isEnrolled = await isBiometricEnrolled();
    final List<BiometricType> availableTypes = await getAvailableBiometrics();
    final bool isEnabledInApp = await isBiometricAuthEnabled();

    return BiometricCapability(
      isAvailable: isAvailable,
      isEnrolled: isEnrolled,
      availableTypes: availableTypes,
      isEnabledInApp: isEnabledInApp,
    );
  }

  // Get user-friendly biometric type names
  static String getBiometricTypeName(BiometricType type) {
    switch (type) {
      case BiometricType.face:
        return 'Face ID';
      case BiometricType.fingerprint:
        return 'Fingerprint';
      case BiometricType.iris:
        return 'Iris';
      case BiometricType.weak:
        return 'Pattern/PIN';
      case BiometricType.strong:
        return 'Secure Biometric';
    }
  }

  // Get biometric setup instructions
  static String getBiometricSetupInstructions() {
    return '''
To enable biometric authentication:

1. Go to your device Settings
2. Navigate to Security & Privacy
3. Set up Face ID, Fingerprint, or other biometric authentication
4. Return to this app and enable biometric login

Note: Your biometric data is stored securely on your device and never shared with our servers.
''';
  }

  // Quick biometric login (for app unlock)
  static Future<bool> quickAuth() async {
    try {
      // Check if biometric auth is enabled in app
      if (!await isBiometricAuthEnabled()) {
        return false;
      }

      // Perform quick authentication
      return await authenticate(
        reason: 'Unlock app with biometrics',
        useErrorDialogs: false,
        stickyAuth: false,
      );
    } catch (e) {
      // For quick auth, we don't want to show errors
      debugPrint('Quick biometric auth failed: $e');
      return false;
    }
  }

  // Biometric authentication with fallback options
  static Future<AuthResult> authenticateWithFallback({
    String reason = 'Please authenticate to continue',
    bool allowDeviceCredentials = true,
  }) async {
    try {
      // Try biometric authentication first
      final bool biometricResult = await authenticate(
        reason: reason,
        useErrorDialogs: false,
      );

      if (biometricResult) {
        return AuthResult(success: true, method: AuthMethod.biometric);
      }

      // If biometric fails and device credentials are allowed
      if (allowDeviceCredentials) {
        final bool deviceCredentialResult =
            await _authenticateWithDeviceCredentials(reason);
        if (deviceCredentialResult) {
          return AuthResult(success: true, method: AuthMethod.deviceCredential);
        }
      }

      return AuthResult(success: false, method: AuthMethod.none);
    } catch (e) {
      if (e is BiometricException && e.type == BiometricErrorType.userCancel) {
        return AuthResult(
          success: false,
          method: AuthMethod.none,
          cancelled: true,
        );
      }

      // If biometric fails, try device credentials as fallback
      if (allowDeviceCredentials) {
        try {
          final bool deviceCredentialResult =
              await _authenticateWithDeviceCredentials(reason);
          if (deviceCredentialResult) {
            return AuthResult(
              success: true,
              method: AuthMethod.deviceCredential,
            );
          }
        } catch (fallbackError) {
          debugPrint('Fallback authentication failed: $fallbackError');
        }
      }

      return AuthResult(
        success: false,
        method: AuthMethod.none,
        error: e.toString(),
      );
    }
  }

  // Authenticate with device credentials (PIN, pattern, password)
  static Future<bool> _authenticateWithDeviceCredentials(String reason) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: false,
          biometricOnly: false,
        ),
      );
    } catch (e) {
      debugPrint('Device credential authentication failed: $e');
      return false;
    }
  }
}

// Biometric capability information
class BiometricCapability {
  final bool isAvailable;
  final bool isEnrolled;
  final List<BiometricType> availableTypes;
  final bool isEnabledInApp;

  BiometricCapability({
    required this.isAvailable,
    required this.isEnrolled,
    required this.availableTypes,
    required this.isEnabledInApp,
  });

  bool get canUseBiometrics => isAvailable && isEnrolled;

  String get statusMessage {
    if (!isAvailable) {
      return 'Biometric authentication is not available on this device';
    }
    if (!isEnrolled) {
      return 'No biometric credentials enrolled. Please set up biometrics in device settings.';
    }
    if (!isEnabledInApp) {
      return 'Biometric authentication is available but not enabled in app';
    }
    return 'Biometric authentication is ready to use';
  }

  List<String> get availableTypeNames {
    return availableTypes
        .map((type) => BiometricService.getBiometricTypeName(type))
        .toList();
  }
}

// Authentication result
class AuthResult {
  final bool success;
  final AuthMethod method;
  final bool cancelled;
  final String? error;

  AuthResult({
    required this.success,
    required this.method,
    this.cancelled = false,
    this.error,
  });
}

// Authentication methods
enum AuthMethod { biometric, deviceCredential, none }
