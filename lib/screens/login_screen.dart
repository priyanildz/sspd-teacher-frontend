import 'package:flutter/material.dart';
import 'package:teacher_portal/screens/home_screen.dart';
import 'package:teacher_portal/services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // ✅ Predefined credentials
  // final String _correctUsername = "admin";
  // final String _correctPassword = "Admin@123";

  // ✅ Password visibility state
  bool _isPasswordVisible = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      String username = _usernameController.text.trim();
      String password = _passwordController.text.trim();

      try {
        final response = await ApiService.login(username, password);
        if (response['success']) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'])),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Server error")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ✅ Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/background.jpg", // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),

          // ✅ Logo in Top-Left Corner
          Positioned(
            top: 40,
            left: 20,
            child: Image.asset(
              "assets/logo.jpeg", // Replace with your logo path
              width: 100, // Adjust size as needed
            ),
          ),

          // ✅ Login Form
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "SSPD SMS",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // ✅ Ensure text is visible on background
                    ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField(_usernameController, "Username"),
                        const SizedBox(height: 10),
                        _buildPasswordField(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    ),
                    child: const Text(
                      "Log in",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.black)),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          style: const TextStyle(color: Colors.black), // ✅ Text color for visibility
          decoration: InputDecoration(
            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            filled: true,
            fillColor: Colors.white.withOpacity(0.2), // ✅ Transparent field
          ),
          validator: (value) => value!.isEmpty ? "Enter your $label" : null,
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Password", style: TextStyle(fontSize: 16, color: Colors.black)),
        const SizedBox(height: 5),
        TextFormField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          style: const TextStyle(color: Colors.black), // ✅ Text color for visibility
          decoration: InputDecoration(
            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            filled: true,
            fillColor: Colors.white.withOpacity(0.2), // ✅ Transparent field
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.black, // ✅ Ensure icon is visible
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
          validator: (value) => value!.isEmpty ? "Enter your Password" : null,
        ),
      ],
    );
  }
}
