import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_day3/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordShowen = false;
  bool _isConfirmShowen = false;
  bool _isLoading = false;

  // void _register() async {
  //   if (_nameController.text.isNotEmpty &&
  //       _emailController.text.isNotEmpty &&
  //       _passwordController.text.isNotEmpty) {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     prefs.setString('name', _nameController.text);
  //     prefs.setString('email', _emailController.text);
  //     prefs.setString('password', _passwordController.text);

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("${_nameController.text} is registered succefully"),
  //       ),
  //     );

  //     Future.delayed(Duration(milliseconds: 500));

  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => LoginPage()),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(
  //           "Input the details",
  //           style: TextStyle(color: Colors.red),
  //         ),
  //       ),
  //     );
  //   }
  // }

  String? _validateUsername(String? name) {
    if (name == null || name.isEmpty) return "Please enter your name";
    if (name.length < 3) return "Username must be more than 3 characters";
    return null;
  }

  String? _validateEmail(String? email) {
    if (email == null || email.isEmpty) return "Please enter your email";
    final emailRegEx = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegEx.hasMatch(email)) return "Please enter a valid email";
    return null;
  }

  String? _validatePhone(String? phone) {
    if (phone == null || phone.isEmpty) {
      return "Please enter your phone number";
    }
    final phoneRegEx = RegExp(r'^(010|011|012|015)[0-9]{8}$');
    if (!phoneRegEx.hasMatch(phone)) {
      return "Please enter a valid phone number";
    }
    return null;
  }

  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Please enter your password";
    }
    if (password.length < 8) {
      return "Password must be at least 8 characters";
    }
    return null;
  }

  String? _validateConfirmPassword(String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return "Please confirm your password";
    }
    if (confirmPassword != _passwordController.text) {
      return "Passwords don't match";
    }
    return null;
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      await credential.user?.updateDisplayName(_nameController.text.trim());
      await FirebaseFirestore.instance
          .collection("users")
          .doc(credential.user!.uid)
          .set({
            "name": _nameController.text.trim(),
            "email": _emailController.text.trim(),
            "phone": _phoneController.text.trim(),
            "total_spent": 0,
            "cart": [],
            "wishlist": [],
            "createdAt": FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$_nameController is registered")),
        );
        _nameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _phoneController.clear();
        _confirmPasswordController.clear();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String message = _getMessageError(e.code);
        debugPrint(e.code);
        _showDialog(message);
        setState(() => _isLoading = false);
      }
      setState(() => _isLoading = false);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _getMessageError(String message) {
    switch (message) {
      case "email-already-in-use":
        return "This email is already used";
      case "invalid-email":
        return "Please enter a valid email";
      case "weak-password":
        return "Weak Password";
      case "operation-not-allowed":
        return "Registration not allowed, try again!";
      default:
        return "Error occured, try again!";
    }
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Column(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(height: 8),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Welcome back! Please enter your details.",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Name",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      validator: _validateUsername,
                      controller: _nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.teal, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.person),
                        hintText: "Enter your name",
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Email",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      validator: _validateEmail,
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.teal, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.email),
                        hintText: "Enter your email",
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Phone Number",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      validator: _validatePhone,
                      controller: _phoneController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.teal, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.phone),
                        hintText: "Enter your phone number",
                        counterText: "",
                      ),
                      keyboardType: TextInputType.phone,
                      maxLength: 11,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Password",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      validator: _validatePassword,
                      controller: _passwordController,
                      obscureText: !_isPasswordShowen,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.teal, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.lock),
                        hintText: "Enter your password",
                        suffixIcon: IconButton(
                          onPressed: () => setState(() {
                            _isPasswordShowen = !_isPasswordShowen;
                          }),
                          icon: Icon(
                            _isPasswordShowen
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (_confirmPasswordController.text.isNotEmpty) {
                          _formKey.currentState!.validate();
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Confirm Password",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      validator: _validateConfirmPassword,
                      controller: _confirmPasswordController,
                      obscureText: !_isConfirmShowen,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.teal, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.lock),
                        hintText: "Confirm your password",
                        suffixIcon: IconButton(
                          onPressed: () => setState(() {
                            _isConfirmShowen = !_isConfirmShowen;
                          }),
                          icon: Icon(
                            _isConfirmShowen
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (_confirmPasswordController.text.isNotEmpty) {
                          _formKey.currentState!.validate();
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        elevation: 2,
                      ),
                      child: _isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: Text(
                            "Log In",
                            style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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
