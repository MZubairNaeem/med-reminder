// import 'package:appwrite/appwrite.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:medreminder/firebase_options.dart';
import 'package:medreminder/views/onBoarding/splash.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:uuid/uuid.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

var uuid = const Uuid();
Future<void> main() async {
  //
  WidgetsFlutterBinding.ensureInitialized();
  //
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //firebase messaging initialization and background handler
  final fcm = FirebaseMessaging.instance.getToken().then((value) => {
        prefs.setString('fcm', value!),
        print(value),
      });

  FirebaseMessaging.onBackgroundMessage(
    _firebaseMessagingBackgroundHandler,
  );
  await FlutterForegroundTask();

  // Listen for foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Handling a foreground message ${message.messageId}');
    print(message.notification!.title);
    print(message.notification!.body);
    Get.snackbar('Minder Alert', 'Time to take your medicine');
  });

  tzdata.initializeTimeZones();
  var status = await Permission.notification.status;
  if (status.isDenied) {
    await Permission.notification.request();
  }
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
              progressIndicatorTheme: ProgressIndicatorThemeData(
                color: secondary,
              ),
              iconTheme: IconThemeData(color: Colors.white),
              appBarTheme: const AppBarTheme(
                iconTheme: const IconThemeData(color: white),
              ),
              fontFamily: GoogleFonts.poppins().fontFamily,
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                },
              ),
              primaryColor: Colors.blue,
              useMaterial3: false,
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
