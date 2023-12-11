import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:medreminder/controllers/providers/get_patients.dart';
import 'package:medreminder/controllers/providers/patient_list_provider.dart';
import 'package:medreminder/controllers/services/relative_controller.dart';
import 'package:medreminder/views/Caretaker/home/notification.dart';
import 'package:medreminder/views/Patient/auth/email_auth/email_login.dart';
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
  TextEditingController name = TextEditingController();

  @override
  void initState() {
    //refreshing the data
    Future.delayed(const Duration(milliseconds: 500), () async {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot<Map<String, dynamic>> doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      //if username not equal to null
      if (doc.data()!['username'] == '@username') {
        Get.defaultDialog(
          title: 'Enter Username',
          content: TextFormField(
            controller: name,
            decoration: const InputDecoration(
              hintText: 'Enter Username',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .update({
                    'username': name.text.trim(),
                  }).then((value) => {
                            name.clear(),
                            Get.back(),
                            Get.back(),
                          });
                } catch (e) {
                  Get.snackbar('Error', e.toString());
                }
              },
              child: const Text('Save'),
            ),
            // TextButton(
            //   onPressed: () {
            //     Get.back();
            //   },
            //   child: const Text('Cancel'),
            // )
          ],
        );
        setState(() {
          load = false;
        });
      } else {
        // Get.snackbar('Success', 'Welcome ${doc.data()!['username']}');
        setState(() {
          load = false;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      // ignore: use_build_context_synchronously
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EmailLogin(),
                          ),
                          (route) => false);
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
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final patientsList = ref.watch(patientlistforrelative);
          ref.refresh(patientlist);
          return patientsList.when(
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
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CareTakerNotification(
                                      uid: list[index].uid!,
                                      name: list[index].username!),
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 1.w,
                                vertical: 0.2.h,
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
                                              context, list[index].username!);
                                          setState(() {
                                            load = false;
                                          });
                                        },
                                        icon: Icons.delete_forever_rounded,
                                        foregroundColor: white,
                                        borderRadius: BorderRadius.circular(6),
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
                                      list[index].credentials!,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .where('uid',
                                              isEqualTo: list[index].uid!)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(
                                            //user name
                                            'Username: ${snapshot.data!.docs[0]['username']}',
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold,
                                                color: secondary),
                                          );
                                        } else {
                                          return const Text("...");
                                        }
                                      },
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
    );
  }
}
