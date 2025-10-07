import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './login_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Services/auth_service.dart';
import '../../core/colors.dart';
=======
import './login_screen.dart';
>>>>>>> c69e55a (feat(auth) = implement user signup and login flow)

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // assigns a unique identifier to your Form.
  final _formKey = GlobalKey<FormState>();
  // Create a text controller and use it to retrieve the current value
  final _fullnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
<<<<<<< HEAD
  bool _isLoading = false;
=======
  // bool _isLoading = false;
>>>>>>> c69e55a (feat(auth) = implement user signup and login flow)

  // dropdown role variable
  String? _selectedRole;
  final List<String> _roles = ['User', 'Admin'];

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _fullnameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // submit form
<<<<<<< HEAD
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // loading state
      setState(() => _isLoading = true);

      Fluttertoast.showToast(
        msg: "Creating account...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.accent,
        textColor: AppColors.background,
        fontSize: 16.0,
      );

      final authService = AuthService();

      try {
        // Create user in Firebase Authentication
        final user = await authService.signUp(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (user == null) {
          Fluttertoast.showToast(
            msg: "Account creation failed",
            backgroundColor: AppColors.error,
            textColor: AppColors.background,
          );
          setState(() => _isLoading = false);
          return;
        }
        // Save user info in Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'fullname': _fullnameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'email': _emailController.text.trim(),
          'role': _selectedRole,
          'createdAt': FieldValue.serverTimestamp(),
        });

        Fluttertoast.showToast(
          msg: "Account created successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: AppColors.success,
          textColor: AppColors.background,
          fontSize: 16.0,
        );

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;

        String message = 'An error occurred';
        if (e.code == 'email-already-in-use') {
          message = 'Email already in use';
        } else if (e.code == 'weak-password') {
          message = 'Password is too weak';
        }

        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppColors.error,
          textColor: AppColors.background,
          fontSize: 16.0,
        );
      } catch (e) {
        if (!mounted) return;
        Fluttertoast.showToast(
          msg: "Error: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppColors.error,
          textColor: AppColors.background,
          fontSize: 16.0,
        );
      } finally {
        setState(() => _isLoading = false);
      }
=======
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // All inputs valid – handle sign-up logic here
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Creating account...')));
>>>>>>> c69e55a (feat(auth): implement user signup and login flow)
    }
  }

  // Email validation
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    const pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    if (!RegExp(pattern).hasMatch(value)) return 'Enter a valid email address';
    return null;
  }

  // Password validation
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      backgroundColor: AppColors.background,
=======
      backgroundColor: Colors.white,
>>>>>>> c69e55a (feat(auth): implement user signup and login flow)
      body: SafeArea(child: _buildAccountForm()),
    );
  }

  SingleChildScrollView buildAccountForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //header
            const Text(
              "Let's get started!",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
<<<<<<< HEAD
                color: AppColors.text,
=======
                color: Colors.black,
>>>>>>> c69e55a (feat(auth): implement user signup and login flow)
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Create an account to get all features",
<<<<<<< HEAD
              style: TextStyle(fontSize: 16, color: AppColors.text),
=======
              style: TextStyle(fontSize: 16, color: Colors.black),
>>>>>>> c69e55a (feat(auth): implement user signup and login flow)
            ),
            const SizedBox(height: 48),

            // Role dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.work),
                hintText: "Select Role",
              ),
              value: _selectedRole,
              items: _roles
                  .map(
                    (role) => DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRole = value;
                });
              },
              validator: (value) =>
                  value == null ? 'Please select a role' : null,
            ),
            const SizedBox(height: 24),

            //Full names Field
            TextFormField(
              controller: _fullnameController,
              decoration: const InputDecoration(
                hintText: "Full Name",
                prefixIcon: Icon(Icons.person),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your names';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Email Field
            const SizedBox(height: 8),

            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: "Email",
                prefixIcon: Icon(Icons.email),
              ),
              validator: validateEmail,
            ),
            const SizedBox(height: 24),

            //Phone Number Field
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                hintText: "Phone Number",
                prefixIcon: Icon(Icons.phone),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                if (value.length < 10) {
                  return 'Enter a valid phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            //Password Field
            TextFormField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                hintText: "Password",
                // obscureText: !_isPasswordVisible,
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
              validator: validatePassword,
            ),
            const SizedBox(height: 24),

            // Confirm Pasword field
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: !_isConfirmPasswordVisible,
              decoration: InputDecoration(
                hintText: "Confirm Password",
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),

            const SizedBox(height: 32),

            // Terms and Conditions
            Row(
              children: [
<<<<<<< HEAD
                Icon(Icons.check_circle, color: AppColors.success, size: 20),
=======
                Icon(
                  Icons.check_circle,
                  color: const Color(0xFF19e627),
                  size: 20,
                ),
>>>>>>> c69e55a (feat(auth): implement user signup and login flow)
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'I agree to the Terms of Service and Privacy Policy',
<<<<<<< HEAD
                    style: TextStyle(fontSize: 14, color: AppColors.accent),
=======
                    style: TextStyle(fontSize: 14, color: Colors.blue),
>>>>>>> c69e55a (feat(auth): implement user signup and login flow)
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            //sign up button
<<<<<<< HEAD
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.background,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Create Account"),
                    ),
                  ),
            const SizedBox(height: 16),
=======
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Create Account"),
              ),
            ),
>>>>>>> c69e55a (feat(auth): implement user signup and login flow)
            //Login Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account?",
<<<<<<< HEAD
                  style: TextStyle(color: AppColors.text),
=======
                  style: TextStyle(color: Colors.black),
>>>>>>> c69e55a (feat(auth): implement user signup and login flow)
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to Login Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(
<<<<<<< HEAD
                      color: AppColors.accent,
=======
                      color: Colors.blue,
>>>>>>> c69e55a (feat(auth): implement user signup and login flow)
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
