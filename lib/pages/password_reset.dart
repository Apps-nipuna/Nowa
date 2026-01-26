import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:orsa_3/pages/sign_in_page.dart';

@NowaGenerated()
class PasswordReset extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const PasswordReset({super.key});

  @override
  State<PasswordReset> createState() {
    return _PasswordResetState();
  }
}

@NowaGenerated()
class _PasswordResetState extends State<PasswordReset> {
  final _passwordController = TextEditingController();

  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  bool _showPassword = false;

  bool _showConfirmPassword = false;

  String? _errorMessage;

  String? _successMessage;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ts = Theme.of(context).textTheme;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [cs.surface, cs.surface.withValues(alpha: 0.95)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 32.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: !_isLoading ? () => Navigator.pop(context) : null,
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: cs.primary,
                      size: 24.0,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                  width: 120.0,
                  height: 120.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: cs.primary.withValues(alpha: 0.2),
                        blurRadius: 20.0,
                        spreadRadius: 5.0,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image(
                      image: const AssetImage('assets/orsa_logo.png'),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: cs.primary,
                        child: Icon(
                          Icons.group,
                          size: 60.0,
                          color: cs.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                Text(
                  'Old Rajans Scout Association',
                  textAlign: TextAlign.center,
                  style: ts.headlineSmall?.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Create New Password',
                  style: ts.titleMedium?.copyWith(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Enter your new password below to complete the reset process.',
                  textAlign: TextAlign.center,
                  style: ts.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: 40.0),
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: cs.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: cs.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: ts.bodySmall?.copyWith(color: cs.error),
                    ),
                  ),
                if (_errorMessage != null) const SizedBox(height: 16.0),
                if (_successMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: cs.tertiary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: cs.tertiary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: cs.tertiary,
                          size: 20.0,
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Text(
                            _successMessage!,
                            style: ts.bodySmall?.copyWith(color: cs.tertiary),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_successMessage != null) const SizedBox(height: 16.0),
                TextField(
                  controller: _passwordController,
                  obscureText: !_showPassword,
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    labelStyle: TextStyle(color: cs.onSurfaceVariant),
                    prefixIcon: Icon(Icons.lock_outline, color: cs.primary),
                    suffixIcon: GestureDetector(
                      onTap: !_isLoading
                          ? () => setState(() => _showPassword = !_showPassword)
                          : null,
                      child: Icon(
                        _showPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: cs.primary,
                      ),
                    ),
                    filled: true,
                    fillColor: cs.primaryContainer.withValues(alpha: 0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: cs.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: cs.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: cs.primary, width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: !_showConfirmPassword,
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    labelStyle: TextStyle(color: cs.onSurfaceVariant),
                    prefixIcon: Icon(Icons.lock_outline, color: cs.primary),
                    suffixIcon: GestureDetector(
                      onTap: !_isLoading
                          ? () => setState(
                              () =>
                                  _showConfirmPassword = !_showConfirmPassword,
                            )
                          : null,
                      child: Icon(
                        _showConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: cs.primary,
                      ),
                    ),
                    filled: true,
                    fillColor: cs.primaryContainer.withValues(alpha: 0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: cs.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: cs.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: cs.primary, width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                SizedBox(
                  width: double.infinity,
                  height: 52.0,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _resetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      disabledBackgroundColor: cs.primary.withValues(
                        alpha: 0.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 4.0,
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 24.0,
                            height: 24.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation(cs.onPrimary),
                            ),
                          )
                        : Text(
                            'Reset Password',
                            style: ts.labelLarge?.copyWith(
                              color: cs.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _resetPassword() async {
    if (_passwordController.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter a new password');
      return;
    }
    if (_confirmPasswordController.text.isEmpty) {
      setState(() => _errorMessage = 'Please confirm your password');
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _errorMessage = 'Passwords do not match');
      return;
    }
    if (_passwordController.text.length < 6) {
      setState(() => _errorMessage = 'Password must be at least 6 characters');
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });
    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: _passwordController.text.trim()),
      );
      setState(() => _successMessage = 'Password updated successfully!');
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SignInPage()),
          (route) => false,
        );
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
