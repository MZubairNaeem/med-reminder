// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:medreminder/constants/strings/login.dart';
import 'package:medreminder/controllers/services/caretaker_auth_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CareTakerLogin extends StatefulWidget {
  const CareTakerLogin({super.key});

  @override
  State<CareTakerLogin> createState() => _CareTakerLogin();
}

class _CareTakerLogin extends State<CareTakerLogin> {
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
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, primary],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 45.sp),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                        width: 85.w,
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
              Padding(
                padding: EdgeInsets.all(18.sp),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 90.w,
                      child: Text(
                        smsOTP,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17.sp,
                          color: white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    SizedBox(
                      width: 90.w,
                      child: InternationalPhoneNumberInput(
                        inputDecoration: InputDecoration(
                          hintText: 'Phone number', // Set your hint text here
                          hintStyle: TextStyle(
                              color:
                                  Colors.white), // Set hint text color to white

                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    Colors.white), // Set border color to white
                          ),
                        ),
                        textStyle: TextStyle(
                          color: white,
                        ),
                        cursorColor: white,
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
                        selectorTextStyle:
                            TextStyle(color: white, fontSize: 17.sp),
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
                      height: 5.h,
                    ),
                    SizedBox(
                      width: 90.w,
                      height: 6.h,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            focusNode.unfocus();
                            setState(() {
                              loading = true;
                            });
                            await Auth_.sendCode(context, phoneNo.toString());
                            setState(() {
                              loading = false;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          primary: const Color.fromARGB(
                              255, 25, 47, 64), // Change button color
                        ),
                        child: loading
                            ? const Center(
                                child: CircularProgressIndicator(
                                color: white,
                              ))
                            : Text(
                                'Continue',
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  color: white,
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
    );
  }
}
