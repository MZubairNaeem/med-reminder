import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:medreminder/firebase_options.dart';
import 'package:medreminder/views/Patient/home/home.dart';
import 'package:medreminder/views/onBoarding/onBoarding.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  String? uuid;
  Future getValidationKey() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var uid = sharedPreferences.getString('uid');
    setState(() {
      print(uid);
      uuid = uid;
    });
  }

  @override
  void initState() {
    getValidationKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return ProviderScope(
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Med Reminder',
            theme: ThemeData(
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
            home: uuid == null ? const OBScreen1() : const Home(),
          ),
        );
      },
    );
  }
}
