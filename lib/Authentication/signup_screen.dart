import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './login_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  // bool _isLoading = false;

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
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
        msg: "Creating account...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      try {
        // Create user in Firebase Authentication
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );

        // Save user info in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(credential.user!.uid)
            .set({
              'fullname': _fullnameController.text.trim(),
              'phone': _phoneController.text.trim(),
              'email': _emailController.text.trim(),
              'role': _selectedRole,
              'createdAt': FieldValue.serverTimestamp(),
            });

        if (!mounted) return;

        Fluttertoast.showToast(
          msg: "Account created successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

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
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } catch (e) {
        if (!mounted) return;
        Fluttertoast.showToast(
          msg: "Error: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }

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
      backgroundColor: Colors.white,
      body: SafeArea(child: _buildAccountForm()),
    );
  }

  SingleChildScrollView _buildAccountForm() {
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
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Create an account to get all features",
              style: TextStyle(fontSize: 16, color: Colors.black),
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
              validator: _validateEmail,
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
              validator: _validatePassword,
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
                Icon(
                  Icons.check_circle,
                  color: const Color(0xFF19e627),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'I agree to the Terms of Service and Privacy Policy',
                    style: TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            //sign up button
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
            //Login Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account?",
                  style: TextStyle(color: Colors.black),
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
                      color: Colors.blue,
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
