import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:medreminder/constants/strings/login.dart';
import 'package:medreminder/controllers/services/auth_controller.dart';
import 'package:medreminder/views/Caretaker/auth/login.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final focusNode = FocusNode();
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'PK';
  PhoneNumber number = PhoneNumber(isoCode: 'PK');
  final RegExp mobileRegex = RegExp(r'^\d{10}$');
  String? phoneNo;
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
        body: Form(
          key: formKey,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                              onBoardText,
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
                      smsOTP,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: gray,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  SizedBox(
                    width: 90.w,
                    child: InternationalPhoneNumberInput(
                      onInputChanged: (PhoneNumber number) {
                        phoneNo = number.phoneNumber;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your number';
                        }

                        return null;
                      },
                      selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.DROPDOWN,
                      ),
                      ignoreBlank: true,
                      autoValidateMode: AutovalidateMode.disabled,
                      selectorTextStyle: const TextStyle(color: gray),
                      initialValue: number,
                      textFieldController: controller,
                      formatInput: true,
                      focusNode: focusNode,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      inputBorder: const OutlineInputBorder(),
                      onSaved: (PhoneNumber number) {
                        print('On Saved: $number');
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // Navigate to CareTakerLogin() when the button is pressed
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CareTakerLogin()),
                        );
                      },
                      child: Text(
                        'Login as Caretaker',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
                child: Align(
                  alignment: Alignment.bottomCenter,
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
                          await Auth.sendCode(context, phoneNo.toString());
                          setState(() {
                            loading = false;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: loading
                          ? const Center(
                              child: CircularProgressIndicator(
                              color: white,
                            ))
                          : const Text('Continue'),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
