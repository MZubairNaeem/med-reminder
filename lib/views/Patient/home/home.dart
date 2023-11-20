import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:gif/gif.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:medreminder/controllers/providers/doc_appointment_provider.dart';
import 'package:medreminder/controllers/providers/med_provider.dart';
import 'package:medreminder/controllers/services/pharmacies.dart';
import 'package:medreminder/views/Patient/auth/email_auth/email_login.dart';
import 'package:medreminder/views/Patient/home/appoinments/doc_appointments_list.dart';
import 'package:medreminder/views/Patient/home/medicineSchedules/medicine_list.dart';
import 'package:medreminder/views/Patient/home/notes/notes_list.dart';
import 'package:medreminder/views/Patient/home/notifications/notifications.dart';
import 'package:medreminder/views/Patient/home/notifyRelatives/relative_list.dart';
import 'package:medreminder/views/Patient/home/reports/report.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  bool load = true;
  dynamic note;
  dynamic completedNotes;
  dynamic pendingNotes;
  dynamic appoinment;
  dynamic upcomingAppoinment;
  dynamic missedAppoinment;
  dynamic pendingMed;
  dynamic takenMed;
  dynamic missedMed;
  final name = TextEditingController();

  @override
  void initState() {
    _controller = GifController(vsync: this);
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
    //check if user has username or not
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // Add a listener to trigger the rotation every time the animation completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
      }
    });

    // Start the rotation animation
    // _controller.forward();
    super.initState();
  }

  late final GifController _controller;
  late AnimationController controller;

  // GifController _controller = GifController(vsync: this);
  @override
  Widget build(BuildContext context) {
    var notificationCount = 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minder Alert'),
        backgroundColor: secondary,
        // 3 dots menu
        actions: [
          // Consumer(
          //   builder: (context, ref, _) {
          //     final userResult = ref.watch(notesProvider);
          //     // ref.refresh(notesProvider);
          //     return userResult.when(
          //       data: (notes) {
          //         return IconButton(
          //           onPressed: () {
          //             setState(() {
          //               load = true;
          //             });
          //             note = ref.refresh(notesProvider);
          //             completedNotes = ref.refresh(completedNotesProvider);
          //             pendingNotes = ref.refresh(pendingNotesProvider);
          //             appoinment = ref.refresh(appoinmentProvider);
          //             upcomingAppoinment =
          //                 ref.refresh(upcomingAppoinmentProvider);
          //             missedAppoinment = ref.refresh(missedAppoinmentProvider);
          //             pendingMed = ref.refresh(pendingMedProvider);
          //             takenMed = ref.refresh(takenMedProvider);
          //             missedMed = ref.refresh(missedMedProvider);
          //             Future.delayed(const Duration(milliseconds: 500), () {
          //               setState(() {
          //                 load = false;
          //               });
          //             });
          //           },
          //           icon: const Icon(
          //             Icons.refresh,
          //             color: Colors.white,
          //           ),
          //         );
          //       },
          //       loading: () => const Text("..."),
          //       error: (error, stackTrace) => Text('Error: $error'),
          //     );
          //   },
          // ),
          // IconButton(
          //   onPressed: () {
          //     // notificationService.sendNotification('title', 'body');
          //     FlutterBackgroundService().invoke('setAsBackground');
          //     print('object');
          //   },
          //   icon: const Icon(
          //     Icons.notifications,
          //     color: Colors.white,
          //   ),
          // ),
          Consumer(
            builder: (context, ref, _) {
              final userResult = ref.watch(missedMedProvider);
              final res = ref.watch(missedAppoinmentProvider);
              return userResult.when(
                  data: (med) {
                    res.when(
                        data: (appoinment) {
                          notificationCount = appoinment.length + med.length;
                        },
                        loading: () => const Text("..."),
                        error: (error, stackTrace) {
                          print('Error: $error');
                          return Text('Error: $error');
                        });
                    return IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeNotification(),
                          ),
                        );
                      },
                      icon: Stack(
                        children: [
                          const Icon(
                            Icons.notifications,
                            color: Colors.white,
                            size: 30,
                          ),
                          if (notificationCount > 0)
                            Positioned(
                              right: 0.0,
                              child: SizedBox(
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                  child: Text(
                                    notificationCount.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                  loading: () => const Text("..."),
                  error: (error, stackTrace) {
                    print('Error: $error');
                    return Text('Error: $error');
                  });
            },
          ),

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
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.message!),
                        ),
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.sp),
              child: SizedBox(
                width: 95.w,
                height: 30.h,
                child: Card(
                  elevation: 2,
                  shadowColor: secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.w),
                  ),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('medSchedule')
                        .where('uid',
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        // Use a Map to track the status of each medicine
                        Map<String, List<bool>> medicineStatusMap = {};

                        // Iterate through the documents in the snapshot
                        snapshot.data?.docs.forEach((doc) {
                          var medName = doc['medName'];
                          var medStatus = doc['status'];

                          if (medName != null && medStatus != null) {
                            // Initialize the status list if not already set
                            medicineStatusMap.putIfAbsent(medName, () => []);

                            // Add the status to the list
                            medicineStatusMap[medName]!.add(medStatus);
                          }
                        });

                        // Filter medicines where all status values are true
                        List<String> filteredMedicines = medicineStatusMap
                            .entries
                            .where((entry) =>
                                entry.value.every((status) => status == true))
                            .map((entry) => entry.key)
                            .toList();

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemCount: min(filteredMedicines.length,
                                5), // Limit to 3 medicines
                            itemBuilder: (context, index) {
                              var medName = filteredMedicines[index];
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 50.w,
                                    child: Text(
                                      'Refill: ${medName.toUpperCase()}',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Gif(
                                    height: 5.h,
                                    width: 20.w,
                                    image: const AssetImage(
                                        "lib/constants/assets/refresh.gif"),
                                    controller:
                                        _controller, // if duration and fps is null, original gif fps will be used.
                                    //fps: 30,
                                    //duration: const Duration(seconds: 3),
                                    autostart: Autostart.loop,
                                    placeholder: (context) =>
                                        const Text('Loading...'),
                                    onFetchCompleted: () {
                                      _controller.reset();
                                      _controller.forward();
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      } else {
                        return const Text("...");
                      }
                    },
                  ),
                ),
              ),
            ),
            // Horizontal scrollable containers
            // SizedBox(
            //   width: 100.w,
            //   height: 30.h,
            //   child: ListView.builder(
            //     scrollDirection: Axis.horizontal,
            //     itemCount: 1,
            //     itemBuilder: (context, index) {
            //       return
            //     },
            //   ),
            // ),
            // Grid of containers (3 by 2)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotesList(),
                        ),
                      ),
                      child: Card(
                        margin: EdgeInsets.all(3.w),
                        elevation: 2,
                        shadowColor: secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.w),
                        ),
                        child: SizedBox(
                          height: 20.h,
                          width: 43.w,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "Notes",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Image.asset(
                                      'lib/constants/assets/notes.png',
                                      width: 18.sp,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Totel Notes",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      width: 5.w, // Using responsive width
                                      height: 5.w, // Using responsive height
                                      decoration: const BoxDecoration(
                                        color: secondary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('notes')
                                              .where('uid',
                                                  isEqualTo: FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                snapshot.data!.docs.length
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: white),
                                              );
                                            } else {
                                              return const Text("...");
                                            }
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Completed",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      width: 5.w, // Using responsive width
                                      height: 5.w, // Using responsive height
                                      decoration: const BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('notes')
                                              .where('uid',
                                                  isEqualTo: FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid)
                                              .where('status', isEqualTo: true)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                snapshot.data!.docs.length
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: white),
                                              );
                                            } else {
                                              return const Text("...");
                                            }
                                          },
                                        ),
                                        // child: Consumer(
                                        //   builder: (context, ref, _) {
                                        //     final userResult = ref.watch(
                                        //         completedNotesProvider);
                                        //     // ref.refresh(
                                        //     //     completedNotesProvider);
                                        //     return userResult.when(
                                        //       data: (notes) {
                                        //         return Center(
                                        //           child: Text(
                                        //             notes.isNotEmpty
                                        //                 ? notes.length
                                        //                     .toString()
                                        //                 : "0",
                                        //             style: TextStyle(
                                        //                 fontSize: 16.sp,
                                        //                 fontWeight:
                                        //                     FontWeight
                                        //                         .bold,
                                        //                 color: white),
                                        //           ),
                                        //         );
                                        //       },
                                        //       loading: () =>
                                        //           const Text("..."),
                                        //       error: (error,
                                        //               stackTrace) =>
                                        //           Text('Error: $error'),
                                        //     );
                                        //   },
                                        // ),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Pending",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      width: 5.w, // Using responsive width
                                      height: 5.w, // Using responsive height
                                      decoration: const BoxDecoration(
                                        color: Colors.orange,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('notes')
                                              .where('uid',
                                                  isEqualTo: FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid)
                                              .where('status', isEqualTo: false)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                snapshot.data!.docs.length
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: white),
                                              );
                                            } else {
                                              return const Text("...");
                                            }
                                          },
                                        ),
                                        // child: Consumer(
                                        //   builder: (context, ref, _) {
                                        //     final userResult = ref.watch(
                                        //         pendingNotesProvider);
                                        //     // ref.refresh(
                                        //     //     pendingNotesProvider);
                                        //     return userResult.when(
                                        //         data: (notes) {
                                        //           return Center(
                                        //             child: Text(
                                        //               notes.isNotEmpty
                                        //                   ? notes.length
                                        //                       .toString()
                                        //                   : "0",
                                        //               style: TextStyle(
                                        //                   fontSize:
                                        //                       16.sp,
                                        //                   fontWeight:
                                        //                       FontWeight
                                        //                           .bold,
                                        //                   color: white),
                                        //             ),
                                        //           );
                                        //         },
                                        //         loading: () =>
                                        //             const Text("..."),
                                        //         error: (error,
                                        //             stackTrace) {
                                        //           print(
                                        //               'Error: $error');
                                        //           return Text(
                                        //               'Error: $error');
                                        //         });
                                        //   },
                                        // ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MedicineList(),
                        ),
                      ),
                      child: Card(
                        margin: EdgeInsets.all(3.w),
                        elevation: 2,
                        shadowColor: secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.w),
                        ),
                        child: SizedBox(
                          height: 20.h,
                          width: 43.w,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Medicine Schedules",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                    Image.asset(
                                      'lib/constants/assets/med.png',
                                      width: 18.sp,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Pending",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      width: 5.w, // Using responsive width
                                      height: 5.w, // Using responsive height
                                      decoration: const BoxDecoration(
                                        color: secondary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('medSchedule')
                                              .where('uid',
                                                  isEqualTo: FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid)
                                              .where('status', isEqualTo: false)
                                              .where('time',
                                                  isGreaterThan:
                                                      Timestamp.now())
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                snapshot.data!.docs.length
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: white),
                                              );
                                            } else {
                                              return const Text("...");
                                            }
                                          },
                                        ),
                                        // child: Consumer(
                                        //   builder: (context, ref, _) {
                                        //     final userResult =
                                        //         ref.watch(
                                        //             pendingMedProvider);
                                        //     // ref.refresh(pendingMedProvider);
                                        //     return userResult.when(
                                        //       data: (notes) {
                                        //         return Text(
                                        //           notes.isNotEmpty
                                        //               ? notes.length
                                        //                   .toString()
                                        //               : "0",
                                        //           style: TextStyle(
                                        //               fontSize: 16.sp,
                                        //               fontWeight:
                                        //                   FontWeight
                                        //                       .bold,
                                        //               color: white),
                                        //         );
                                        //       },
                                        //       loading: () =>
                                        //           const Text("..."),
                                        //       error: (error,
                                        //               stackTrace) =>
                                        //           Text('Error: $error'),
                                        //     );
                                        //   },
                                        // ),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Taken",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      width: 5.w, // Using responsive width
                                      height: 5.w, // Using responsive height
                                      decoration: const BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('medSchedule')
                                              .where('uid',
                                                  isEqualTo: FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid)
                                              .where('status', isEqualTo: true)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                snapshot.data!.docs.length
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: white),
                                              );
                                            } else {
                                              return const Text("...");
                                            }
                                          },
                                        ),
                                        // child: Consumer(
                                        //   builder: (context, ref, _) {
                                        //     final userResult =
                                        //         ref.watch(
                                        //             takenMedProvider);
                                        //     // ref.refresh(takenMedProvider);
                                        //     return userResult.when(
                                        //       data: (notes) {
                                        //         return Center(
                                        //           child: Text(
                                        //             notes.isNotEmpty
                                        //                 ? notes.length
                                        //                     .toString()
                                        //                 : "0",
                                        //             style: TextStyle(
                                        //                 fontSize: 16.sp,
                                        //                 fontWeight:
                                        //                     FontWeight
                                        //                         .bold,
                                        //                 color: white),
                                        //           ),
                                        //         );
                                        //       },
                                        //       loading: () =>
                                        //           const Text("..."),
                                        //       error: (error,
                                        //               stackTrace) =>
                                        //           Text('Error: $error'),
                                        //     );
                                        //   },
                                        // ),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Missed",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      width: 5.w, // Using responsive width
                                      height: 5.w, // Using responsive height
                                      decoration: const BoxDecoration(
                                        color: Colors.orange,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('medSchedule')
                                              .where('uid',
                                                  isEqualTo: FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid)
                                              .where('status', isEqualTo: false)
                                              .where('time',
                                                  isLessThan: Timestamp.now())
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                snapshot.data!.docs.length
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: white),
                                              );
                                            } else {
                                              return const Text("...");
                                            }
                                          },
                                        ),
                                        // child: Consumer(
                                        //   builder: (context, ref, _) {
                                        //     final userResult =
                                        //         ref.watch(
                                        //             missedMedProvider);
                                        //     // ref.refresh(missedMedProvider);
                                        //     return userResult.when(
                                        //         data: (notes) {
                                        //           return Center(
                                        //             child: Text(
                                        //               notes.isNotEmpty
                                        //                   ? notes.length
                                        //                       .toString()
                                        //                   : "0",
                                        //               style: TextStyle(
                                        //                   fontSize:
                                        //                       16.sp,
                                        //                   fontWeight:
                                        //                       FontWeight
                                        //                           .bold,
                                        //                   color: white),
                                        //             ),
                                        //           );
                                        //         },
                                        //         loading: () =>
                                        //             const Text("..."),
                                        //         error: (error,
                                        //             stackTrace) {
                                        //           print(
                                        //               'Error: $error');
                                        //           return Text(
                                        //               'Error: $error');
                                        //         });
                                        //   },
                                        // ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AppoinmentsList(),
                        ),
                      ),
                      child: Card(
                        margin: EdgeInsets.all(3.w),
                        elevation: 2,
                        shadowColor: secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.w),
                        ),
                        child: SizedBox(
                          height: 20.h,
                          width: 43.w,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "Appoinments",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Image.asset(
                                      'lib/constants/assets/calender.png',
                                      width: 18.sp,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "All Appoinments",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      width: 5.w, // Using responsive width
                                      height: 5.w, // Using responsive height
                                      decoration: const BoxDecoration(
                                        color: secondary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('appointments')
                                              .where('uid',
                                                  isEqualTo: FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                snapshot.data!.docs.length
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: white),
                                              );
                                            } else {
                                              return const Text("...");
                                            }
                                          },
                                        ),
                                        // child: Consumer(
                                        //   builder: (context, ref, _) {
                                        //     final userResult =
                                        //         ref.watch(
                                        //             appoinmentProvider);
                                        //     // ref.refresh(appoinmentProvider);
                                        //     return userResult.when(
                                        //       data: (appoinment) {
                                        //         return Text(
                                        //           appoinment.isNotEmpty
                                        //               ? appoinment
                                        //                   .length
                                        //                   .toString()
                                        //               : "0",
                                        //           style: TextStyle(
                                        //               fontSize: 16.sp,
                                        //               fontWeight:
                                        //                   FontWeight
                                        //                       .bold,
                                        //               color: white),
                                        //         );
                                        //       },
                                        //       loading: () =>
                                        //           const Text("..."),
                                        //       error: (error,
                                        //               stackTrace) =>
                                        //           Text('Error: $error'),
                                        //     );
                                        //   },
                                        // ),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Upcoming",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      width: 5.w, // Using responsive width
                                      height: 5.w, // Using responsive height
                                      decoration: const BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('appointments')
                                              .where('uid',
                                                  isEqualTo: FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid)
                                              .orderBy('appointmentDateTime',
                                                  descending: false)
                                              .where('appointmentDateTime',
                                                  isGreaterThan:
                                                      Timestamp.now())
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                snapshot.data!.docs.length
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: white),
                                              );
                                            } else {
                                              return const Text("...");
                                            }
                                          },
                                        ),
                                        // child: Consumer(
                                        //   builder: (context, ref, _) {
                                        //     final userResult = ref.watch(
                                        //         upcomingAppoinmentProvider);
                                        //     // ref.refresh(
                                        //     //     upcomingAppoinmentProvider);
                                        //     return userResult.when(
                                        //       data: (appointment) {
                                        //         return Center(
                                        //           child: Text(
                                        //             appointment
                                        //                     .isNotEmpty
                                        //                 ? appointment
                                        //                     .length
                                        //                     .toString()
                                        //                 : "0",
                                        //             style: TextStyle(
                                        //                 fontSize: 16.sp,
                                        //                 fontWeight:
                                        //                     FontWeight
                                        //                         .bold,
                                        //                 color: white),
                                        //           ),
                                        //         );
                                        //       },
                                        //       loading: () =>
                                        //           const Text("..."),
                                        //       error: (error,
                                        //               stackTrace) =>
                                        //           Text('Error: $error'),
                                        //     );
                                        //   },
                                        // ),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Missed",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      width: 5.w, // Using responsive width
                                      height: 5.w, // Using responsive height
                                      decoration: const BoxDecoration(
                                        color: Colors.orange,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('appointments')
                                              .where('uid',
                                                  isEqualTo: FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid)
                                              .where('appointmentDateTime',
                                                  isLessThan: Timestamp.now())
                                              .where('status', isEqualTo: false)
                                              .orderBy('appointmentDateTime',
                                                  descending: false)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                snapshot.data!.docs.length
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: white),
                                              );
                                            } else {
                                              return const Text("...");
                                            }
                                          },
                                        ),
                                        // child: Consumer(
                                        //   builder: (context, ref, _) {
                                        //     final userResult = ref.watch(
                                        //         missedAppoinmentProvider);
                                        //     // ref.refresh(
                                        //     //     missedAppoinmentProvider);
                                        //     return userResult.when(
                                        //       data: (appoinment) {
                                        //         return Center(
                                        //           child: Text(
                                        //             appoinment
                                        //                     .isNotEmpty
                                        //                 ? appoinment
                                        //                     .length
                                        //                     .toString()
                                        //                 : "0",
                                        //             style: TextStyle(
                                        //                 fontSize: 16.sp,
                                        //                 fontWeight:
                                        //                     FontWeight
                                        //                         .bold,
                                        //                 color: white),
                                        //           ),
                                        //         );
                                        //       },
                                        //       loading: () =>
                                        //           const Text("..."),
                                        //       error: (error,
                                        //               stackTrace) =>
                                        //           Text('Error: $error'),
                                        //     );
                                        //   },
                                        // ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => PharmaciesController().openGoogleMaps(),
                      child: Card(
                        margin: EdgeInsets.all(3.w),
                        elevation: 2,
                        shadowColor: secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.w),
                        ),
                        child: SizedBox(
                          height: 20.h,
                          width: 43.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                'lib/constants/assets/map.png',
                                width: 20.w,
                              ),
                              Text(
                                "Pharmacy Nearby",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // CustomCard(
                    //   text: 'Pharmacy Nearby',
                    //   onTap: () => PharmaciesController().openGoogleMaps(),
                    //   height: 20.h,
                    //   width: 43.w,
                    // ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotifyRelativeList(),
                        ),
                      ),
                      child: Card(
                        margin: EdgeInsets.all(3.w),
                        elevation: 2,
                        shadowColor: secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.w),
                        ),
                        child: SizedBox(
                          height: 20.h,
                          width: 43.w,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  'lib/constants/assets/relative.png',
                                  width: 20.w,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Care Takers",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Image.asset(
                                      'lib/constants/assets/realtive-icon.png',
                                      width: 18.sp,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total CareTakers",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      width: 5.w, // Using responsive width
                                      height: 5.w, // Using responsive height
                                      decoration: const BoxDecoration(
                                        color: secondary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('relative')
                                              .where('uid',
                                                  isEqualTo: FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                snapshot.data!.docs.length
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: white),
                                              );
                                            } else {
                                              return const Text("...");
                                            }
                                          },
                                        ),
                                        // child: Consumer(
                                        //   builder: (context, ref, _) {
                                        //     final userResult =
                                        // ref.watch(relativelist);
                                        //     // ref.refresh(relativelist);
                                        //     return userResult.when(
                                        //       data: (relatives) {
                                        //         return Text(
                                        //           relatives.isNotEmpty
                                        //               ? relatives.length
                                        //                   .toString()
                                        //               : "0",
                                        //           style: TextStyle(
                                        //               fontSize: 16.sp,
                                        //               fontWeight:
                                        //                   FontWeight
                                        //                       .bold,
                                        //               color: white),
                                        //         );
                                        //       },
                                        //       loading: () =>
                                        //           const Text("..."),
                                        //       error: (error,
                                        //               stackTrace) =>
                                        //           Text('Error: $error'),
                                        //     );
                                        //   },
                                        // ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Report(),
                          ),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.all(3.w),
                        elevation: 2,
                        shadowColor: secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.w),
                        ),
                        child: SizedBox(
                          height: 20.h,
                          width: 43.w,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      16.0), // Adjust the radius as needed
                                  child: Image.asset(
                                    'lib/constants/assets/report.jpg',
                                    width: 20.w,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Report",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Image.asset(
                                      'lib/constants/assets/medlist.png',
                                      width: 18.sp,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
//       body: RefreshIndicator(
//         onRefresh: () {
//           //refresh data using RefreshData class
//           // const RefreshData().refreshData(context);
//           return Future.delayed(const Duration(milliseconds: 500), () {
//             setState(() {
//               load = false;
//             });
//           });
//         },
//         child: Stack(
//           children: [
//             Visibility(
//               visible: !load,
//               child: CustomScrollView(
//                 slivers: [
//                   SliverToBoxAdapter(
//                     child: Padding(
//                       padding: EdgeInsets.all(10.sp),
//                       child: SizedBox(
//                         width: 80.w,
//                         height: 30.h,
//                         child: Card(
//                           elevation: 2,
//                           shadowColor: secondary,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5.w),
//                           ),
//                           child: StreamBuilder(
//                             stream: FirebaseFirestore.instance
//                                 .collection('medSchedule')
//                                 .where('uid',
//                                     isEqualTo:
//                                         FirebaseAuth.instance.currentUser!.uid)
//                                 .snapshots(),
//                             builder: (context, snapshot) {
//                               if (snapshot.hasData) {
//                                 // Use a Map to track the status of each medicine
//                                 Map<String, List<bool>> medicineStatusMap = {};

//                                 // Iterate through the documents in the snapshot
//                                 snapshot.data?.docs.forEach((doc) {
//                                   var medName = doc['medName'];
//                                   var medStatus = doc['status'];

//                                   if (medName != null && medStatus != null) {
//                                     // Initialize the status list if not already set
//                                     medicineStatusMap.putIfAbsent(
//                                         medName, () => []);

//                                     // Add the status to the list
//                                     medicineStatusMap[medName]!.add(medStatus);
//                                   }
//                                 });

//                                 // Filter medicines where all status values are true
//                                 List<String> filteredMedicines =
//                                     medicineStatusMap.entries
//                                         .where((entry) => entry.value
//                                             .every((status) => status == true))
//                                         .map((entry) => entry.key)
//                                         .toList();

//                                 return ListView.builder(
//                                   itemCount: filteredMedicines.length,
//                                   itemBuilder: (context, index) {
//                                     var medName = filteredMedicines[index];
//                                     return Text(
//                                       medName,
//                                       style: TextStyle(
//                                         fontSize: 16.sp,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     );
//                                   },
//                                 );
//                               } else {
//                                 return const Text("...");
//                               }
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SliverToBoxAdapter(
//                     child: Column(
//
//             ),
//             Visibility(
//               visible: load,
//               child: const Center(
//                 child: CircularProgressIndicator(
//                   color: tertiary,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
