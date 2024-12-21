import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/screens/app_colors.dart';
import 'package:flutter_demo/screens/app_icons.dart';
import 'package:flutter_demo/screens/responsive_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Successful!')),
      );
      // Navigate to the next screen
      Navigator.pushReplacementNamed(context, '/dashboard'); // Adjust route
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
    }
  }





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
                        'YNS Dental Care',
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Outer Container with text and header
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Let’s Log In',
                            style: GoogleFonts.raleway(
                              fontSize: 25.0,
                              color: AppColors.darkBrownColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Enter your details to log in to your account.',
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
                                controller: emailController,
                                style: GoogleFonts.raleway(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.darkBrownColor,
                                  fontSize: 12.0,
                                ),
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
                                controller: passwordController,
                                style: GoogleFonts.raleway(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.darkBrownColor,
                                  fontSize: 12.0,
                                ),
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  suffixIcon: IconButton(
                                    onPressed: () {},
                                    icon: Image.asset(AppIcons.eyeIcon),
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
                            const SizedBox(height: 24.0),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Forgot Password?',
                                  style: GoogleFonts.raleway(
                                    fontSize: 12.0,
                                    color: AppColors.mainBrownColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24.0),
                            // Sign In button
                            Center(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: _login,
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: Ink(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 70.0, vertical: 18.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      color: AppColors.mainBrownColor,
                                    ),
                                    child: Text(
                                      'Sign In',
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
                          ],
                        ),
                      ),
                    ],
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
