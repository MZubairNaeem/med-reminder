// import 'package:appwrite/appwrite.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medreminder/firebase_options.dart';
import 'package:medreminder/notifications/appoinments.dart';
import 'package:medreminder/views/onBoarding/splash.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:uuid/uuid.dart';

var uuid = const Uuid();
NotificationService notificationService = NotificationService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var status = await Permission.notification.status;
  if (status.isDenied) {
    await Permission.notification.request();
  }
  tzdata.initializeTimeZones();
  notificationService.initializeNotifications();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return ProviderScope(
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Med Reminder',
            theme: ThemeData(
              fontFamily: GoogleFonts.poppins().fontFamily,
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                },
              ),
              primarySwatch: const MaterialColor(
                0xff02569B,
                <int, Color>{
                  50: Color(0xff02569B),
                  100: Color(0xff02569B),
                  200: Color(0xff02569B),
                  300: Color(0xff02569B),
                  400: Color(0xff02569B),
                  500: Color(0xff02569B),
                  600: Color(0xff02569B),
                  700: Color(0xff02569B),
                  800: Color(0xff02569B),
                  900: Color(0xff02569B),
                },
              ),
            ),
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}
