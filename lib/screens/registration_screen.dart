import 'package:flutter/material.dart';
import 'package:trafficking_detector/controllers/auth_controller.dart';
import 'package:trafficking_detector/screens/main_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _agreedToTerms = false;
  bool _isLoading = false;

  //final AuthController _authController = AuthController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleRegistration() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreedToTerms) {
      _showSnackBar(
        'Please agree to the privacy policy and terms',
        isError: true,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // try {
    //   final result = await _authController.registerUser(
    //     firstName: _firstNameController.text.trim(),
    //     lastName: _lastNameController.text.trim(),
    //     email: _emailController.text.trim(),
    //     phoneNumber: _phoneController.text.trim(),
    //   );

    //   if (mounted) {
    //     if (result['success']) {
    //       _showSnackBar(
    //         result['message'],
    //         isError: false,
    //       );

    //       // Navigate to main screen after a brief delay
    //       await Future.delayed(const Duration(seconds: 1));

    //       if (mounted) {
    //         Navigator.of(context).pushReplacement(
    //           MaterialPageRoute(
    //             builder: (context) => MainScreen(),
    //           ),
    //         );
    //       }
    //     } else {
    //       _showSnackBar(
    //         result['message'],
    //         isError: true,
    //       );
    //     }
    //   }
    // } catch (e) {
    //   if (mounted) {
    //     _showSnackBar(
    //       'An unexpected error occurred. Please try again.',
    //       isError: true,
    //     );
    //   }
    // } finally {
    //   if (mounted) {
    //     setState(() {
    //       _isLoading = false;
    //     });
    //   }
    // }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: isError ? 4 : 2),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.red.withOpacity(0.5), width: 1.5),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    // Remove any non-digit characters for validation
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.length < 10) {
      return 'Please enter a valid phone number (at least 10 digits)';
    }
    if (digitsOnly.length > 15) {
      return 'Phone number is too long';
    }
    return null;
  }

  String? _validateName(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    if (value.trim().length < 2) {
      return '$fieldName must be at least 2 characters long';
    }
    if (value.trim().length > 50) {
      return '$fieldName is too long (maximum 50 characters)';
    }
    // Check for valid characters (letters, spaces, hyphens, apostrophes)
    final nameRegex = RegExp(r"^[a-zA-Z\s\-']+$");
    if (!nameRegex.hasMatch(value.trim())) {
      return '$fieldName can only contain letters, spaces, hyphens, and apostrophes';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C3E50),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  // Title
                  const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // First Name and Last Name Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _firstNameController,
                          hint: 'First Name',
                          validator: (value) =>
                              _validateName(value, 'First name'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          controller: _lastNameController,
                          hint: 'Last Name',
                          validator: (value) =>
                              _validateName(value, 'Last name'),
                        ),
                      ),
                    ],
                  ),

                  // Email
                  _buildTextField(
                    controller: _emailController,
                    hint: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                  ),

                  // Phone Number
                  _buildTextField(
                    controller: _phoneController,
                    hint: 'Phone Number',
                    keyboardType: TextInputType.phone,
                    validator: _validatePhoneNumber,
                  ),

                  const SizedBox(height: 16),

                  // Privacy Policy Checkbox
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _agreedToTerms,
                        onChanged: (value) {
                          setState(() {
                            _agreedToTerms = value ?? false;
                          });
                        },
                        activeColor: Colors.red,
                        checkColor: Colors.white,
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                                color: Colors.grey[400], fontSize: 14),
                            children: const [
                              TextSpan(text: 'I Agree with '),
                              TextSpan(
                                text: 'privacy',
                                style: TextStyle(color: Colors.red),
                              ),
                              TextSpan(text: ' and '),
                              TextSpan(
                                text: 'policy',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Sign Up Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleRegistration,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
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
                              'Sign up',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
