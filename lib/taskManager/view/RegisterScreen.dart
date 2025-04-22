import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../db/UserDatabase.dart';
import '../model/UserModel.dart';
import 'package:taskmanager/main.dart';
import 'dart:developer' as developer; // Thêm để ghi log

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  // Hàm kiểm tra định dạng email
  String? _validateEmail(String? value) {
    developer.log('Validating email: $value', name: 'RegisterScreen');
    if (value == null || value.isEmpty) {
      developer.log('Email validation failed: Email is empty', name: 'RegisterScreen');
      return 'Vui lòng nhập email';
    }
    // Biểu thức chính quy chặt chẽ để kiểm tra email
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      developer.log('Email validation failed: Invalid format for $value', name: 'RegisterScreen');
      return 'Vui lòng nhập email hợp lệ (ví dụ: user@domain.com)';
    }
    developer.log('Email validation passed for $value', name: 'RegisterScreen');
    return null;
  }

  Future<void> _register() async {
    developer.log('Attempting to register', name: 'RegisterScreen');
    if (_formKey.currentState!.validate()) {
      developer.log('Form validation passed', name: 'RegisterScreen');
      try {
        final users = await UserDatabase.instance.getAllUsers();
        if (users.any((user) => user.username == _usernameController.text)) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tên đăng nhập đã tồn tại')),
            );
          }
          developer.log('Registration failed: Username already exists', name: 'RegisterScreen');
          return;
        }

        // Kiểm tra email đã tồn tại chưa
        if (users.any((user) => user.email == _emailController.text)) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Email đã được sử dụng')),
            );
          }
          developer.log('Registration failed: Email already used', name: 'RegisterScreen');
          return;
        }

        final user = User(
          id: const Uuid().v4(),
          username: _usernameController.text,
          password: _passwordController.text,
          email: _emailController.text,
          createdAt: DateTime.now(),
          lastActive: DateTime.now(),
        );

        await UserDatabase.instance.insertUser(user);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đăng ký thành công! Vui lòng đăng nhập')),
          );
          developer.log('Registration successful for user: ${user.username}', name: 'RegisterScreen');
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Đã có lỗi xảy ra: $e')),
          );
          developer.log('Registration error: $e', name: 'RegisterScreen');
        }
      }
    } else {
      developer.log('Form validation failed', name: 'RegisterScreen');
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeSwitching = ThemeSwitchingWidget.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng ký'),
        actions: [
          IconButton(
            icon: Icon(themeSwitching.isDarkMode ? Icons.brightness_7 : Icons.brightness_4),
            onPressed: themeSwitching.toggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Tên đăng nhập'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên đăng nhập';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Mật khẩu'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  }
                  if (value.length < 6) {
                    return 'Mật khẩu phải có ít nhất 6 ký tự';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
                autovalidateMode: AutovalidateMode.onUserInteraction, // Xác thực ngay khi người dùng nhập
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _register,
                child: const Text('Đăng ký'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}