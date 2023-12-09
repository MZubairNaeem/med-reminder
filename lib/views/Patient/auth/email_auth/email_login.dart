import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:medreminder/constants/strings/login.dart';
import 'package:medreminder/controllers/services/auth_controller/login_controller.dart';
import 'package:medreminder/views/Patient/auth/email_auth/forgot_password.dart';
import 'package:medreminder/views/Patient/auth/email_auth/register.dart';
import 'package:medreminder/views/Patient/auth/login.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EmailLogin extends StatefulWidget {
  const EmailLogin({super.key});

  @override
  State<EmailLogin> createState() => _LoginState();
}

class _LoginState extends State<EmailLogin> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final focusNode = FocusNode();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  bool loading = false;
  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  Container(
                    height: 30.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: secondary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.w),
                        bottomRight: Radius.circular(10.w),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            appName,
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: white,
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          SizedBox(
                            width: 90.w,
                            child: Text(
                              onBoardEmailText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  SizedBox(
                    width: 90.w,
                    child: Text(
                      'Login to your account using your email and password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: gray,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 20.sp, horizontal: 15.sp),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        //email regex
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        } else if (!EmailValidator.validate(value)) {
                          return 'Please enter a valid email';
                        }

                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 10.sp, horizontal: 15.sp),
                    child: TextFormField(
                      controller: passController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        //email regex
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }

                        return null;
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgotPassword()),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: secondary,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 15, left: 15, right: 15),
                    child: SizedBox(
                      width: 100.w,
                      height: 12.w,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            focusNode.unfocus();
                            setState(() {
                              loading = true;
                            });
                            await LoginController().login(
                              context,
                              emailController.text,
                              passController.text,
                            );
                            setState(() {
                              loading = false;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          
                          foregroundColor: white,
                          backgroundColor: secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: loading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: white,
                                ),
                              )
                            : const Text('Continue'),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 2.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 15, left: 15, right: 15),
                        child: SizedBox(
                          width: 100.w,
                          height: 12.w,
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Login()),
                                );
                              },
                              child: Text(
                                'Continue with Phone Number',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ),
                      ),
                      Text(
                        'or',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: gray,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: gray,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EmailSignup()),
                          );
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: secondary,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
