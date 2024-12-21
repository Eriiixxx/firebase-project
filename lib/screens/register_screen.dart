import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/screens/app_colors.dart';
import 'package:flutter_demo/screens/app_icons.dart';
import 'package:flutter_demo/screens/login_screen.dart';
import 'package:flutter_demo/screens/responsive_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backColor,
      body: SizedBox(
        height: height,
        width: width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ResponsiveWidget.isSmallScreen(context) ? const SizedBox() : Expanded(
              child: Container(
                height: height,
                color: AppColors.mainBrownColor,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Expensees',
                        style: GoogleFonts.raleway(
                          fontSize: 48.0,
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Image.asset(
                        'assets/images/YNS Logo1.png',
                        width: 400.0,
                        height: 400.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  width: width * 0.4, // Adjust width as necessary
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Outer Container with text and header
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Let’s Register!',
                              style: GoogleFonts.raleway(
                                fontSize: 25.0,
                                color: AppColors.darkBrownColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Enter your details to register your account.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.raleway(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textColor,
                              ),
                            ),
                            const SizedBox(height: 24.0),
                          ],
                        ),
                        // Inner container with input fields
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: AppColors.backColor,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              // Username input
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Username',
                                  style: GoogleFonts.raleway(
                                    fontSize: 12.0,
                                    color: AppColors.darkBrownColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6.0),
                              Container(
                                height: 50.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  color: AppColors.whiteColor,
                                ),
                                child: TextFormField(
                                  controller: _usernameController,
                                  style: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.darkBrownColor,
                                    fontSize: 12.0,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your username';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: IconButton(
                                      onPressed: () {},
                                      icon: Image.asset(AppIcons.emailIcon),
                                    ),
                                    contentPadding: const EdgeInsets.only(top: 16.0),
                                    hintText: 'Enter Username',
                                    hintStyle: GoogleFonts.raleway(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.darkBrownColor.withOpacity(0.5),
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16.0),

                              // Email input
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Email',
                                  style: GoogleFonts.raleway(
                                    fontSize: 12.0,
                                    color: AppColors.darkBrownColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6.0),
                              Container(
                                height: 50.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  color: AppColors.whiteColor,
                                ),
                                child: TextFormField(
                                  controller: _emailController,
                                  style: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.darkBrownColor,
                                    fontSize: 12.0,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    if (!RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$').hasMatch(value)) {
                                      return 'Enter a valid email address';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: IconButton(
                                      onPressed: () {},
                                      icon: Image.asset(AppIcons.emailIcon),
                                    ),
                                    contentPadding: const EdgeInsets.only(top: 16.0),
                                    hintText: 'Enter Email',
                                    hintStyle: GoogleFonts.raleway(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.darkBrownColor.withOpacity(0.5),
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16.0),


                              // Password input
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Password',
                                  style: GoogleFonts.raleway(
                                    fontSize: 12.0,
                                    color: AppColors.darkBrownColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6.0),
                              Container(
                                height: 50.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  color: AppColors.whiteColor,
                                ),
                                child: TextFormField(
                                  controller: _passwordController,
                                  style: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.darkBrownColor,
                                    fontSize: 12.0,
                                  ),
                                   obscureText: !_isPasswordVisible,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordVisible = !_isPasswordVisible;
                                        });
                                      },
                                    ),
                                    prefixIcon: IconButton(
                                      onPressed: () {},
                                      icon: Image.asset(AppIcons.lockIcon),
                                    ),
                                    contentPadding: const EdgeInsets.only(top: 16.0),
                                    hintText: 'Enter Password',
                                    hintStyle: GoogleFonts.raleway(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.darkBrownColor.withOpacity(0.5),
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16.0),

                              // Confirm Password input
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Confirm Password',
                                  style: GoogleFonts.raleway(
                                    fontSize: 12.0,
                                    color: AppColors.darkBrownColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6.0),
                              Container(
                                height: 50.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  color: AppColors.whiteColor,
                                ),
                                child: TextFormField(
                                  controller: _confirmPasswordController,
                                  style: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.darkBrownColor,
                                    fontSize: 12.0,
                                  ),
                                  obscureText: !_isPasswordVisible,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please confirm your password';
                                    }
                                    if (value != _passwordController.text) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordVisible = !_isPasswordVisible;
                                        });
                                      },
                                    ),
                                    prefixIcon: IconButton(
                                      onPressed: () {},
                                      icon: Image.asset(AppIcons.lockIcon),
                                    ),
                                    contentPadding: const EdgeInsets.only(top: 16.0),
                                    hintText: 'Confirm Password',
                                    hintStyle: GoogleFonts.raleway(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.darkBrownColor.withOpacity(0.5),
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24.0),

                              // Register In button
                              Center(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () async {
                                      if (_formKey.currentState?.validate() ?? false) {
                                        try {
                                          // Create a new user with Firebase
                                          UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                            email: _emailController.text.trim(),
                                            password: _passwordController.text.trim(),
                                          );

                                          // Navigate to the Login screen upon successful registration
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                                          );

                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Registration successful! Please log in.')),
                                          );
                                        } on FirebaseAuthException catch (e) {
                                          // Handle Firebase registration errors
                                          String errorMessage;
                                          if (e.code == 'email-already-in-use') {
                                            errorMessage = 'The email is already in use.';
                                          } else if (e.code == 'weak-password') {
                                            errorMessage = 'The password is too weak.';
                                          } else {
                                            errorMessage = 'An error occurred. Please try again.';
                                          }

                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text(errorMessage)),
                                          );
                                        } catch (e) {
                                          // Handle general errors
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('An unexpected error occurred.')),
                                          );
                                        }
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: Ink(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 70.0, vertical: 18.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16.0),
                                        color: AppColors.mainBrownColor,
                                      ),
                                      child: Text(
                                        'Register',
                                        style: GoogleFonts.raleway(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.whiteColor,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  Text(
                                    'Already have an account?',
                                    style: GoogleFonts.raleway(
                                      fontSize: 12.0,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/');
                                  },
                                  child: Text(
                                    'Login',
                                    style: GoogleFonts.raleway(
                                      fontSize: 12.0,
                                      color: Colors.red[300],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
