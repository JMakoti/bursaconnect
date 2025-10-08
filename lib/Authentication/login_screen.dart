import 'package:flutter/material.dart';
import '../../core/colors.dart';
import './signup_screen.dart';
import '../Services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // assigns a unique identifier to your Form.
  final _formKey = GlobalKey<FormState>();
  // Create a text controller and use it to retrieve the current value
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  final AuthService authService = AuthService();

  // submit form
  // --- LOGIN USER ---
  Future<void> _loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await authService.signIn(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (result != null) {
      final role = result['role'];
      if(!mounted) return;
      if (role == 'Admin') {
        Navigator.pushNamed(context, '/adminDashboard');
      } else {
        Navigator.pushNamed(context, '/userDashboard');
      }
    } else {
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed. Check credentials.')),
      );
    }
  }
  // void _submitForm() {
  //   if (_formKey.currentState!.validate()) {
  //     // All inputs valid – handle sign-up logic here
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text('Loging in......')));
  //   }
  // }

  // Email validation
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    const pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    if (!RegExp(pattern).hasMatch(value)) return 'Enter a valid email address';
    return null;
  }

  // Password validation
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: _buildAccountForm()),
    );
  }

  SingleChildScrollView _buildAccountForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        //flexiable for , expanded to prevent machine overflow
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //header
            const Text(
              "Welcome Back",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Sign in to continue your bursary-journey",
              style: TextStyle(fontSize: 16, color: AppColors.secondaryText,),
            ),
            const SizedBox(height: 48),

            // Email Field
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: "Email",
                prefixIcon: Icon(Icons.email),
              ),
              validator: _validateEmail,
            ),
            const SizedBox(height: 24),

            //Password Field
            TextFormField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                hintText: "Password",
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              validator: _validatePassword,
            ),
            const SizedBox(height: 24),

            //Login button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:  _isLoading ? null : _loginUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.background,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child:  _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    :const Text("Log In"),
              ),
            ),

            //Sign up Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Create A New Account?",
                  style: TextStyle(color: AppColors.text),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to Login Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
