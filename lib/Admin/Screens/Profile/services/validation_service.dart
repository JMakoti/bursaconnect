class ValidationService {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }

    if (value.length > 50) {
      return 'Name must be less than 50 characters';
    }

    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegex.hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }

    return null;
  }

  // Username validation
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }

    // Remove @ if present at the beginning
    String username = value.startsWith('@') ? value.substring(1) : value;

    if (username.length < 3) {
      return 'Username must be at least 3 characters';
    }

    if (username.length > 20) {
      return 'Username must be less than 20 characters';
    }

    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegex.hasMatch(username)) {
      return 'Username can only contain letters, numbers, and underscores';
    }

    return null;
  }

  // Phone validation
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove all non-digit characters for validation
    String digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length < 10) {
      return 'Phone number must be at least 10 digits';
    }

    if (digitsOnly.length > 15) {
      return 'Phone number must be less than 15 digits';
    }

    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (value.length > 128) {
      return 'Password must be less than 128 characters';
    }

    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }

    // Check for at least one digit
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    // Check for at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(
    String? value,
    String? originalPassword,
  ) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != originalPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  // Date of birth validation
  static String? validateDateOfBirth(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date of birth is required';
    }

    try {
      // Try to parse different date formats
      DateTime? date;

      // Try MM/dd/yyyy format
      if (RegExp(r'^\d{1,2}/\d{1,2}/\d{4}$').hasMatch(value)) {
        final parts = value.split('/');
        date = DateTime(
          int.parse(parts[2]), // year
          int.parse(parts[0]), // month
          int.parse(parts[1]), // day
        );
      }
      // Try Month dd, yyyy format
      else if (RegExp(r'^[A-Za-z]+ \d{1,2}, \d{4}$').hasMatch(value)) {
        // This is already in a valid format, just check if it's reasonable
        final months = [
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December',
        ];

        final parts = value.split(' ');
        final monthName = parts[0];
        final day = int.parse(parts[1].replaceAll(',', ''));
        final year = int.parse(parts[2]);

        final monthIndex = months.indexOf(monthName);
        if (monthIndex == -1) {
          return 'Invalid month name';
        }

        date = DateTime(year, monthIndex + 1, day);
      }

      if (date == null) {
        return 'Invalid date format';
      }

      // Check if date is in the future
      if (date.isAfter(DateTime.now())) {
        return 'Date of birth cannot be in the future';
      }

      // Check if date is too far in the past (more than 120 years)
      final minDate = DateTime.now().subtract(const Duration(days: 365 * 120));
      if (date.isBefore(minDate)) {
        return 'Invalid date of birth';
      }

      // Check if person is at least 13 years old
      final minAge = DateTime.now().subtract(const Duration(days: 365 * 13));
      if (date.isAfter(minAge)) {
        return 'You must be at least 13 years old';
      }

      return null;
    } catch (e) {
      return 'Invalid date format';
    }
  }

  // Generic required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // URL validation
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; // URL is optional
    }

    try {
      final uri = Uri.parse(value);
      if (!uri.hasScheme || (!uri.scheme.startsWith('http'))) {
        return 'Enter a valid URL (must start with http:// or https://)';
      }
      return null;
    } catch (e) {
      return 'Enter a valid URL';
    }
  }

  // Batch validation for forms
  static Map<String, String?> validateProfileForm({
    required String? name,
    required String? username,
    required String? email,
    required String? phone,
    required String? dateOfBirth,
  }) {
    return {
      'name': validateName(name),
      'username': validateUsername(username),
      'email': validateEmail(email),
      'phone': validatePhone(phone),
      'dateOfBirth': validateDateOfBirth(dateOfBirth),
    };
  }

  // Check if form has any errors
  static bool hasErrors(Map<String, String?> validationResults) {
    return validationResults.values.any((error) => error != null);
  }

  // Get first error message
  static String? getFirstError(Map<String, String?> validationResults) {
    for (String? error in validationResults.values) {
      if (error != null) return error;
    }
    return null;
  }
}
