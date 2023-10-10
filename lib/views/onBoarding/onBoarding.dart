import 'package:flutter/material.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:medreminder/constants/strings/on_boarding.dart';
import 'package:medreminder/views/Patient/auth/email_auth/email_login.dart';
import 'package:medreminder/widgets/progress_circle.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OBScreen1 extends StatefulWidget {
  const OBScreen1({super.key});

  @override
  State<OBScreen1> createState() => _OBScreen1State();
}

class _OBScreen1State extends State<OBScreen1> {
  bool load = false;

  @override
  void initState() {
    // Future.delayed(const Duration(milliseconds: 500), () {
    //   setState(() {
    //     load = false;
    //   });
    // });
    super.initState();
  }

  int currentTextIndex = 0;
  double progress = 0.33;
  List<String> onBoardingImages = [
    ob1,
    ob2,
    ob3,
  ];
  List<String> onBoardingTitle = [
    onBoardingTitle1,
    onBoardingTitle2,
    onBoardingTitle3,
  ];
  List<String> onBoardingSubTitle = [
    onBoardingSubTitle1,
    onBoardingSubTitle2,
    onBoardingSubTitle3,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Stack(
        children: [
          Visibility(
            visible: !load,
            child: SafeArea(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EmailLogin(),
                          ),
                        );
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: secondary,
                          fontSize: 20.sp,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(1, 0),
                                  end: const Offset(0, 0),
                                ).animate(animation),
                                child: child,
                              );
                            },
                            child: Image.asset(
                              onBoardingImages[currentTextIndex],
                              key: ValueKey<int>(currentTextIndex),
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(1, 0),
                                  end: const Offset(0, 0),
                                ).animate(animation),
                                child: child,
                              );
                            },
                            child: Text(
                              onBoardingTitle[currentTextIndex],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              key: ValueKey<int>(currentTextIndex),
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          //animated switcher
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            child: Text(
                              onBoardingSubTitle[currentTextIndex],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: gray2,
                              ),
                              key: ValueKey<int>(currentTextIndex),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: OnboardingArrowWithCircle(
                        progress: progress,
                        onTap: () {
                          setState(() {
                            if (currentTextIndex < onBoardingTitle.length - 1) {
                              progress += 0.33;
                              currentTextIndex++;
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EmailLogin(),
                                ),
                              );
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: load,
            child: const Center(
              child: CircularProgressIndicator(
                color: tertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
