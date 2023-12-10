import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:medreminder/constants/strings/login.dart';
import 'package:medreminder/controllers/services/auth_controller/register_controller.dart';
import 'package:medreminder/views/Patient/auth/email_auth/email_login.dart';
import 'package:medreminder/views/Patient/auth/login.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EmailSignup extends StatefulWidget {
  const EmailSignup({super.key});

  @override
  State<EmailSignup> createState() => _EmailSignupState();
}

class _EmailSignupState extends State<EmailSignup> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final focusNode = FocusNode();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final RegExp emailRegex =
      RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-zA-Z0-9.-]+$');
  bool loading = false;
  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  String user = 'patient';
  bool _user = false;
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
                            onBoardRegText,
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
                    'Enter your email to create an account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: gray,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.sp, horizontal: 15.sp),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      prefixIcon: const Icon(Icons.person_2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      //email regex
                      if (value!.isEmpty) {
                        return 'Please enter your username';
                      } else if (value.length < 3) {
                        return 'Username must be at least 3 characters';
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.sp, horizontal: 15.sp),
                  child: TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
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
                  padding:
                      EdgeInsets.symmetric(vertical: 10.sp, horizontal: 15.sp),
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
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      } else if (!RegExp(
                              r'^(?=.*[A-Z])(?=.*[!@#$%^&*(),.?":{}|<>]).*$')
                          .hasMatch(value)) {
                        if (!RegExp(r'^(?=.*[A-Z])').hasMatch(value)) {
                          return 'Password must contain at least one uppercase letter';
                        } else if (!RegExp(r'^(?=.*[!@#$%^&*(),.?":{}|<>])')
                            .hasMatch(value)) {
                          return 'Password must contain at least one special character';
                        }
                        return 'Password must contain at least one uppercase letter \nand one special character';
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.sp, top: 15.sp),
                  child: Row(
                    children: [
                      Container(
                        width: 30.0, // Adjust the size of the checkbox
                        height: 30.0,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(8.0), // Rounded corners
                          border: Border.all(
                            color: Colors.blue, // Border color
                            width: 2.0, // Border width
                          ),
                        ),
                        child: Checkbox(
                          value: _user,
                          onChanged: (value) {
                            setState(() {
                              _user == false
                                  ? user = 'caretaker'
                                  : user = 'patient';
                              _user = value!;
                              print(user);
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        'Continue as Caretaker',
                        style: GoogleFonts.dmSans(fontSize: 17.sp),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 3.h,
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
                          await RegisterController().register(
                            context: context,
                            email: emailController.text.trim(),
                            password: passController.text.trim(),
                            username: nameController.text.trim(),
                            userType: user,
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
                    //or text

                    SizedBox(
                      height: 1.h,
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
                      'Already have an account?',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: gray,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EmailLogin()),
                            (route) => false);
                      },
                      child: Text(
                        'Login',
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
            ),
          ),
        ),
      ),
    );
  }
}
