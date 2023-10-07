import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:medreminder/controllers/providers/patient_list_provider.dart';
import 'package:medreminder/controllers/services/relative_controller.dart';
import 'package:medreminder/views/Patient/auth/login.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types
class Caretaker_Home extends StatefulWidget {
  const Caretaker_Home({super.key});

  @override
  State<Caretaker_Home> createState() => _CaretakerHomeState();
}

class _CaretakerHomeState extends State<Caretaker_Home> {
  bool load = false;
  final List<Tab> tabs = [
    const Tab(text: 'List of Patients'),
    const Tab(text: 'Notifications'),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton(
              color: Colors.white,
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: TextButton(
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.signOut();
                        final SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        sharedPreferences.remove('uid');
                        sharedPreferences.remove('userType');
                        Get.offAll(const Login());
                        Get.snackbar(
                          'Success',
                          "Logged out successfully",
                        );
                      } on FirebaseAuthException catch (e) {
                        Get.snackbar(
                          'Error',
                          e.toString(),
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
              icon: const Icon(
                Icons.more_vert,
                color: Colors
                    .white, // Change this line to set the icon color to white
              ),
            )
          ],
          title: const Text('Caretaker Home'),
          bottom: TabBar(
            tabs: tabs,
          ),
        ),
        body: TabBarView(
          children: [
            Consumer(
              builder: (context, ref, _) {
                final userResult = ref.watch(patientlist);
                // ref.refresh(patientlist);
                return userResult.when(
                    data: (list) {
                      return list.isEmpty
                          ? Center(
                              child: Text(
                                '-- You have no list yet --',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 1.w,
                                    vertical: 1.h,
                                  ),
                                  child: Slidable(
                                    endActionPane: ActionPane(
                                        motion: const StretchMotion(),
                                        children: [
                                          SlidableAction(
                                            label: 'Remove',
                                            backgroundColor: secondary,
                                            onPressed: (value) async {
                                              setState(() {
                                                load = true;
                                              });
                                              await Relative().deleteRelative(
                                                  context, list[index].phone!);
                                              setState(() {
                                                load = false;
                                              });
                                            },
                                            icon: Icons.delete_forever_rounded,
                                            foregroundColor: white,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          )
                                        ]),
                                    child: Card(
                                      elevation: 5,
                                      child: ListTile(
                                        leading: const CircleAvatar(
                                          backgroundColor: secondary,
                                          child: Icon(
                                            Icons.person,
                                            color: white,
                                          ),
                                        ),
                                        title: Text(
                                          list[index].phone!,
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                    },
                    loading: () => const Text("..."),
                    error: (error, stackTrace) {
                      print('Error: $error');
                      return Text('Error: $error');
                    });
              },
            ),
            ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return const Card(
                  elevation: 5,
                  child: ListTile(
                    title: Text('+92 318 00 72 413'),
                    subtitle: Text('Missed 2 doses of medicine'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
