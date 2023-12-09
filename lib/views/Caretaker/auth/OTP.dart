import 'package:flutter/material.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:medreminder/constants/strings/login.dart';
import 'package:medreminder/controllers/services/caretaker_auth_controller.dart';
import 'package:pinput/pinput.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// ignore: must_be_immutable
class OTPVerification extends StatefulWidget {
  int? token;
  String? phoneNo;
  String? verificationId;
  OTPVerification({super.key, this.token, this.phoneNo, this.verificationId});

  @override
  State<OTPVerification> createState() => _OTPVerification();
}

class _OTPVerification extends State<OTPVerification> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: tertiary),
      ),
    );
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
                      'We will send you an SMS with a 6-digit verification code.',
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
                  Directionality(
                    // Specify direction if desired
                    textDirection: TextDirection.ltr,
                    child: Pinput(
                      length: 6,
                      controller: pinController,
                      focusNode: focusNode,
                      androidSmsAutofillMethod:
                          AndroidSmsAutofillMethod.smsUserConsentApi,
                      listenForMultipleSmsOnAndroid: true,
                      defaultPinTheme: defaultPinTheme,
                      separatorBuilder: (index) => const SizedBox(width: 8),
                      hapticFeedbackType: HapticFeedbackType.lightImpact,
                      onCompleted: (pin) {
                        debugPrint('onCompleted: $pin');
                      },
                      onChanged: (value) {
                        debugPrint('onChanged: $value');
                      },
                      cursor: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 9),
                            width: 22,
                            height: 1,
                            color: primary,
                          ),
                        ],
                      ),
                      focusedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: primary),
                        ),
                      ),
                      submittedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          color: gray3,
                          borderRadius: BorderRadius.circular(19),
                          border: Border.all(color: primary),
                        ),
                      ),
                      errorPinTheme: defaultPinTheme.copyBorderWith(
                        border: Border.all(color: Colors.redAccent),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 90.w,
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
                          Auth_.verifyCode(
                            context,
                            widget.phoneNo.toString(),
                            widget.verificationId.toString(),
                            pinController.text,
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
