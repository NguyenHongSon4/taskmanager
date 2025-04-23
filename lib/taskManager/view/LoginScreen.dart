import 'package:flutter/material.dart';
import '../db/UserDatabase.dart';
import '../model/UserModel.dart';
import 'package:taskmanager/main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        final users = await UserDatabase.instance.getAllUsers();
        final user = users.firstWhere(
              (user) =>
          user.username == _usernameController.text &&
              user.password == _passwordController.text,
          orElse: () =>
              User(
                id: '',
                username: '',
                password: '',
                email: '',
                createdAt: DateTime.now(),
                lastActive: DateTime.now(),
              ),
        );

        if (user.id.isNotEmpty) {
          final updatedUser = user.copyWith(lastActive: DateTime.now());
          await UserDatabase.instance.updateUser(updatedUser);
          if (mounted) {
            Navigator.pushReplacementNamed(
                context, '/task_list', arguments: updatedUser);
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Tên đăng nhập hoặc mật khẩu không đúng')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Đã có lỗi xảy ra: $e')),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeSwitching = ThemeSwitchingWidget.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng nhập'),
        elevation: 0, // Flat app bar for a cleaner look
        backgroundColor: Colors.transparent, // Transparent app bar
        actions: [
          IconButton(
            icon: Icon(
              themeSwitching.isDarkMode ? Icons.brightness_7 : Icons
                  .brightness_4,
              color: Colors.white, // White icon for contrast
            ),
            onPressed: themeSwitching.toggleTheme,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/download (1).jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black54, // Slightly darker overlay for better contrast
              BlendMode.darken,
            ),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
                horizontal: 32.0, vertical: 16.0), // Adjusted padding
            child: Container(
              padding: const EdgeInsets.all(32),
              // Increased padding for better spacing
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                // Slightly more transparent for glass effect
                borderRadius: BorderRadius.circular(24),
                // More rounded corners
                border: Border.all(color: Colors.white.withOpacity(0.2)),
                // Subtle border
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Chào mừng bạn',
                      style: TextStyle(
                        fontSize: 32, // Larger font for emphasis
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // White text for contrast
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32), // More spacing
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: 'Tên đăng nhập',
                        hintStyle: const TextStyle(color: Colors.black54),
                        // Softer hint text
                        prefixIcon: const Icon(Icons.person, color: Colors
                            .black54),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        // Slightly transparent white
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          // More rounded
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.2)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                              color: Colors.blueAccent, width: 2),
                        ),
                      ),
                      style: const TextStyle(color: Colors.black87),
                      // Text color
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tên đăng nhập';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: 'Mật khẩu',
                        hintStyle: const TextStyle(color: Colors.black54),
                        prefixIcon: const Icon(Icons.lock, color: Colors
                            .black54),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.2)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                              color: Colors.blueAccent, width: 2),
                        ),
                      ),
                      obscureText: true,
                      style: const TextStyle(color: Colors.black87),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mật khẩu';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      // Animation duration
                      width: double.infinity,
                      height: 56,
                      // Taller button
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent.withOpacity(0.9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                          // Add elevation for depth
                          shadowColor: Colors.black26,
                          // Subtle shadow
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text(
                          'Đăng nhập',
                          style: TextStyle(color: Colors.white), // White text
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        // White text for contrast
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      child: const Text('Chưa có tài khoản? Đăng ký ngay'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}