import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final String userRole;

  const ForgotPasswordScreen({Key? key, required this.userRole}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailFormKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  int _currentStep = 0; // 0: Email, 1: OTP, 2: New Password

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    if (_emailFormKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate sending OTP
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
        _currentStep = 1;
      });

      print("OTP sent to: ${_emailController.text}");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("OTP sent to your email"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _verifyOTP() async {
    if (_otpFormKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate OTP verification
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
        _currentStep = 2;
      });

      print("OTP verified: ${_otpController.text}");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("OTP verified successfully"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _resetPassword() async {
    if (_passwordFormKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate password reset
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      print("Password reset successful");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password reset successful!"),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back to login after a short delay
      await Future.delayed(const Duration(milliseconds: 500));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Title
                Text(
                  _currentStep == 0
                      ? "Forgot Password?"
                      : _currentStep == 1
                      ? "Verify OTP"
                      : "Create New Password",
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 8),

                // Subtitle
                Text(
                  _currentStep == 0
                      ? "Enter your email address to receive a verification code"
                      : _currentStep == 1
                      ? "Enter the 6-digit code sent to ${_emailController.text}"
                      : "Your new password must be different from previous passwords",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 48),

                // Step indicator
                _buildStepIndicator(),

                const SizedBox(height: 48),

                // Content based on current step
                if (_currentStep == 0) _buildEmailStep(),
                if (_currentStep == 1) _buildOTPStep(),
                if (_currentStep == 2) _buildPasswordStep(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      children: [
        _buildStepCircle(0, "1"),
        _buildStepLine(0),
        _buildStepCircle(1, "2"),
        _buildStepLine(1),
        _buildStepCircle(2, "3"),
      ],
    );
  }

  Widget _buildStepCircle(int step, String label) {
    final isActive = _currentStep >= step;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF7C3AED) : Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey.shade600,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildStepLine(int step) {
    final isActive = _currentStep > step;
    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? const Color(0xFF7C3AED) : Colors.grey.shade300,
      ),
    );
  }

  Widget _buildEmailStep() {
    return Form(
      key: _emailFormKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _emailController,
            label: "Email",
            hintText: "Enter your email",
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your email";
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return "Please enter a valid email";
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _sendOTP,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : const Text(
                "Send OTP",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOTPStep() {
    return Form(
      key: _otpFormKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _otpController,
            label: "OTP Code",
            hintText: "Enter 6-digit code",
            keyboardType: TextInputType.number,
            prefixIcon: Icons.pin_outlined,
            maxLength: 6,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter the OTP code";
              }
              if (value.length != 6) {
                return "OTP must be 6 digits";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // Resend OTP
                _sendOTP();
              },
              child: const Text(
                "Resend OTP",
                style: TextStyle(
                  color: Color(0xFF7C3AED),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _verifyOTP,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : const Text(
                "Verify OTP",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordStep() {
    return Form(
      key: _passwordFormKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _newPasswordController,
            label: "New Password",
            hintText: "Enter new password",
            isPassword: true,
            isPasswordVisible: _isNewPasswordVisible,
            prefixIcon: Icons.lock_outlined,
            suffixIcon: IconButton(
              icon: Icon(
                _isNewPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.grey.shade600,
              ),
              onPressed: () {
                setState(() {
                  _isNewPasswordVisible = !_isNewPasswordVisible;
                });
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter a new password";
              }
              if (value.length < 6) {
                return "Password must be at least 6 characters";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _confirmPasswordController,
            label: "Confirm Password",
            hintText: "Re-enter new password",
            isPassword: true,
            isPasswordVisible: _isConfirmPasswordVisible,
            prefixIcon: Icons.lock_outlined,
            suffixIcon: IconButton(
              icon: Icon(
                _isConfirmPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.grey.shade600,
              ),
              onPressed: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please confirm your password";
              }
              if (value != _newPasswordController.text) {
                return "Passwords do not match";
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _resetPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : const Text(
                "Reset Password",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}