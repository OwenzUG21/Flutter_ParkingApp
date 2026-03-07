import 'package:flutter/material.dart';
import '../widgets/inputs.dart';
import '../themes/colors.dart';
import '../services/auth_service.dart';
import 'login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool agree = false;
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    // Validation
    if (_nameController.text.trim().isEmpty) {
      _showError('Please enter your full name');
      return;
    }

    if (_emailController.text.trim().isEmpty) {
      _showError('Please enter your email');
      return;
    }

    if (_passwordController.text.length < 6) {
      _showError('Password must be at least 6 characters');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showError('Passwords do not match');
      return;
    }

    if (!agree) {
      _showError('Please agree to the Terms of Service and Privacy Policy');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.signUpWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
      );

      // Sign out immediately after signup
      await _authService.signOut();

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Account created successfully! Please sign in.',
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        // Navigate back to auth wrapper and clear stack
        Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);

        // Wait a bit then navigate to login with credentials
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(
                  prefilledEmail: _emailController.text.trim(),
                  prefilledPassword: _passwordController.text,
                ),
              ),
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        _showError(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                /// Logo
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      "P",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF121212),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                const Text(
                  "Create Account",
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 12),
                const Text(
                  "Sign up to get started",
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 40),

                /// NAME FIELD
                CustomInput(
                  label: "Full Name",
                  hint: "Enter your full name",
                  controller: _nameController,
                ),

                const SizedBox(height: 20),

                /// EMAIL FIELD
                CustomInput(
                  label: "Email",
                  hint: "Enter your email",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 20),

                /// PASSWORD FIELD
                CustomInput(
                  label: "Password",
                  hint: "Create a password",
                  isPassword: true,
                  controller: _passwordController,
                ),

                const SizedBox(height: 20),

                /// CONFIRM PASSWORD FIELD
                CustomInput(
                  label: "Confirm Password",
                  hint: "Re-enter your password",
                  isPassword: true,
                  controller: _confirmPasswordController,
                ),

                const SizedBox(height: 16),

                /// TERMS CHECKBOX
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: agree,
                        onChanged: (val) {
                          setState(() => agree = val ?? false);
                        },
                        activeColor: AppColors.redButton,
                        checkColor: Colors.white,
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "I agree to the ",
                              style: TextStyle(
                                color: AppColors.secondaryText,
                                fontSize: 13,
                              ),
                            ),
                            TextSpan(
                              text: "Terms of Services ",
                              style: TextStyle(
                                color: AppColors.redButton,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            TextSpan(
                              text: "and ",
                              style: TextStyle(
                                color: AppColors.secondaryText,
                                fontSize: 13,
                              ),
                            ),
                            TextSpan(
                              text: "Privacy Policy",
                              style: TextStyle(
                                color: AppColors.redButton,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                /// SIGN UP BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: agree
                          ? AppColors.redButton
                          : Colors.grey.shade700,
                      foregroundColor: AppColors.primaryText,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: (agree && !_isLoading) ? _signUp : null,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 24),

                /// OR Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.white.withValues(alpha: 0.2),
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "OR",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.white.withValues(alpha: 0.2),
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// Social Login Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton(
                      onTap: () {
                        _showError('Google sign-up coming soon!');
                      },
                      child: const Icon(
                        Icons.g_mobiledata,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    _buildSocialButton(
                      onTap: () {
                        _showError('Apple sign-up coming soon!');
                      },
                      child: const Icon(
                        Icons.apple,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                /// SIGN IN REDIRECT
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          color: AppColors.redButton,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required VoidCallback onTap,
    required Widget child,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Center(child: child),
      ),
    );
  }
}
