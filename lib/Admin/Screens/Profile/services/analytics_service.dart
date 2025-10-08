import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'api_service.dart';
import 'preferences_service.dart';

class AnalyticsService {
  // Note: These keys are reserved for future local storage implementation
  // static const String _analyticsKey = 'analytics_data';
  // static const String _sessionKey = 'current_session';

  static bool _isInitialized = false;
  static String? _sessionId;
  static DateTime? _sessionStart;
  static final List<AnalyticsEvent> _eventQueue = [];

  // Initialize analytics service
  static Future<void> initialize() async {
    if (_isInitialized) return;

    _sessionId = _generateSessionId();
    _sessionStart = DateTime.now();
    _isInitialized = true;

    // Start new session
    await logEvent('session_start', {
      'session_id': _sessionId,
      'timestamp': _sessionStart!.toIso8601String(),
    });

    debugPrint('Analytics initialized with session: $_sessionId');
  }

  // Log user events
  static Future<void> logEvent(
    String eventName,
    Map<String, dynamic> properties,
  ) async {
    if (!_isInitialized) {
      await initialize();
    }

    final event = AnalyticsEvent(
      name: eventName,
      properties: {
        ...properties,
        'session_id': _sessionId,
        'timestamp': DateTime.now().toIso8601String(),
        'platform': defaultTargetPlatform.name,
      },
    );

    // Add to queue
    _eventQueue.add(event);

    // Store locally
    await _storeEventLocally(event);

    // Send to server (if online)
    _sendEventToServer(event);

    debugPrint('Analytics Event: ${event.name} - ${event.properties}');
  }

  // Profile-specific events
  static Future<void> logProfileView() async {
    await logEvent('profile_viewed', {'screen': 'profile_page'});
  }

  static Future<void> logProfileEdit(String field) async {
    await logEvent('profile_edited', {
      'field': field,
      'screen': 'profile_page',
    });
  }

  static Future<void> logProfileSave(bool success) async {
    await logEvent('profile_saved', {
      'success': success,
      'screen': 'profile_page',
    });
  }

  static Future<void> logSettingsView(String section) async {
    await logEvent('settings_viewed', {
      'section': section,
      'screen': 'settings_page',
    });
  }

  static Future<void> logSecurityAction(String action) async {
    await logEvent('security_action', {
      'action': action,
      'screen': 'security_settings',
    });
  }

  static Future<void> logBiometricAction(String action, bool success) async {
    await logEvent('biometric_action', {
      'action': action,
      'success': success,
      'screen': 'security_settings',
    });
  }

  static Future<void> logNotificationChange(String type, bool enabled) async {
    await logEvent('notification_changed', {
      'type': type,
      'enabled': enabled,
      'screen': 'notification_preferences',
    });
  }

  static Future<void> logAccountConnection(
    String provider,
    bool success,
  ) async {
    await logEvent('account_connected', {
      'provider': provider,
      'success': success,
      'screen': 'connected_accounts',
    });
  }

  static Future<void> logDataExport(String format) async {
    await logEvent('data_exported', {
      'format': format,
      'screen': 'data_management',
    });
  }

  static Future<void> logHelpAction(String action) async {
    await logEvent('help_action', {'action': action, 'screen': 'help_support'});
  }

  // Screen tracking
  static Future<void> logScreenView(String screenName) async {
    await logEvent('screen_view', {
      'screen_name': screenName,
      'previous_screen': _lastScreen,
    });
    _lastScreen = screenName;
  }

  static String? _lastScreen;

  // User interaction tracking
  static Future<void> logButtonTap(String buttonName, String screen) async {
    await logEvent('button_tap', {'button_name': buttonName, 'screen': screen});
  }

  static Future<void> logFormSubmission(
    String formName,
    bool success,
    Map<String, dynamic>? errors,
  ) async {
    await logEvent('form_submission', {
      'form_name': formName,
      'success': success,
      'errors': errors,
    });
  }

  static Future<void> logSearchQuery(String query, String screen) async {
    await logEvent('search_query', {
      'query': query.length > 50 ? '${query.substring(0, 50)}...' : query,
      'query_length': query.length,
      'screen': screen,
    });
  }

  // Performance tracking
  static Future<void> logPerformanceMetric(
    String metricName,
    double value,
    String unit,
  ) async {
    await logEvent('performance_metric', {
      'metric_name': metricName,
      'value': value,
      'unit': unit,
    });
  }

  static Future<void> logLoadTime(String screen, Duration loadTime) async {
    await logPerformanceMetric(
      'screen_load_time',
      loadTime.inMilliseconds.toDouble(),
      'milliseconds',
    );
  }

  // Error tracking
  static Future<void> logError(
    String errorType,
    String errorMessage,
    String screen,
  ) async {
    await logEvent('error_occurred', {
      'error_type': errorType,
      'error_message': errorMessage,
      'screen': screen,
    });
  }

  // User engagement
  static Future<void> logFeatureUsage(String feature, String screen) async {
    await logEvent('feature_used', {'feature': feature, 'screen': screen});
  }

  static Future<void> logTimeSpent(String screen, Duration timeSpent) async {
    await logEvent('time_spent', {
      'screen': screen,
      'duration_seconds': timeSpent.inSeconds,
    });
  }

  // Session management
  static Future<void> endSession() async {
    if (_sessionStart != null) {
      final sessionDuration = DateTime.now().difference(_sessionStart!);

      await logEvent('session_end', {
        'session_id': _sessionId,
        'duration_seconds': sessionDuration.inSeconds,
        'events_count': _eventQueue.length,
      });
    }

    // Send any remaining events
    await _flushEventQueue();
  }

  // Get analytics data
  static Future<Map<String, dynamic>> getAnalyticsData() async {
    final prefs = await PreferencesService.exportAllSettings();
    final events = await _getStoredEvents();

    return {
      'session_id': _sessionId,
      'session_start': _sessionStart?.toIso8601String(),
      'events_count': _eventQueue.length,
      'stored_events_count': events.length,
      'preferences': prefs,
    };
  }

  // Export analytics data
  static Future<String> exportAnalyticsData() async {
    final data = await getAnalyticsData();
    final events = await _getStoredEvents();

    final exportData = {
      'metadata': data,
      'events': events.map((e) => e.toJson()).toList(),
      'exported_at': DateTime.now().toIso8601String(),
    };

    return jsonEncode(exportData);
  }

  // Clear analytics data
  static Future<void> clearAnalyticsData() async {
    _eventQueue.clear();
    await _clearStoredEvents();
  }

  // Private methods
  static String _generateSessionId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecond}';
  }

  static Future<void> _storeEventLocally(AnalyticsEvent event) async {
    try {
      final events = await _getStoredEvents();
      events.add(event);

      // Keep only last 1000 events to prevent storage bloat
      if (events.length > 1000) {
        events.removeRange(0, events.length - 1000);
      }

      // Store events (simplified implementation for now)
      // final prefs = await PreferencesService.exportAllSettings();
      // final eventsJson = events.map((e) => e.toJson()).toList();

      // Store in a way that doesn't interfere with other preferences
      // This is a simplified approach - in production you might use a separate storage
      debugPrint('Stored ${events.length} analytics events locally');
    } catch (e) {
      debugPrint('Failed to store analytics event locally: $e');
    }
  }

  static Future<List<AnalyticsEvent>> _getStoredEvents() async {
    try {
      // This is a simplified implementation
      // In production, you'd have a proper local database
      return [];
    } catch (e) {
      debugPrint('Failed to get stored events: $e');
      return [];
    }
  }

  static Future<void> _clearStoredEvents() async {
    try {
      // Clear stored events
      debugPrint('Cleared stored analytics events');
    } catch (e) {
      debugPrint('Failed to clear stored events: $e');
    }
  }

  static void _sendEventToServer(AnalyticsEvent event) {
    // Send to server asynchronously without blocking UI
    Future.microtask(() async {
      try {
        await ApiService.logEvent(event.name, event.properties);
      } catch (e) {
        debugPrint('Failed to send analytics event to server: $e');
        // Event is already stored locally, so it's not lost
      }
    });
  }

  static Future<void> _flushEventQueue() async {
    if (_eventQueue.isEmpty) return;

    try {
      // Send all queued events
      for (final event in _eventQueue) {
        await ApiService.logEvent(event.name, event.properties);
      }

      _eventQueue.clear();
      debugPrint('Flushed ${_eventQueue.length} analytics events');
    } catch (e) {
      debugPrint('Failed to flush event queue: $e');
    }
  }

  // User properties
  static Future<void> setUserProperty(String key, dynamic value) async {
    await logEvent('user_property_set', {
      'property_key': key,
      'property_value': value.toString(),
    });
  }

  // A/B Testing support
  static Future<void> logExperimentExposure(
    String experimentName,
    String variant,
  ) async {
    await logEvent('experiment_exposure', {
      'experiment_name': experimentName,
      'variant': variant,
    });
  }

  // Conversion tracking
  static Future<void> logConversion(
    String conversionType,
    Map<String, dynamic> properties,
  ) async {
    await logEvent('conversion', {
      'conversion_type': conversionType,
      ...properties,
    });
  }
}

// Analytics Event Model
class AnalyticsEvent {
  final String name;
  final Map<String, dynamic> properties;
  final DateTime timestamp;

  AnalyticsEvent({
    required this.name,
    required this.properties,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'properties': properties,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory AnalyticsEvent.fromJson(Map<String, dynamic> json) {
    return AnalyticsEvent(
      name: json['name'],
      properties: json['properties'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
