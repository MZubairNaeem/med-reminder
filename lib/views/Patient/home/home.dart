import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:medreminder/controllers/providers/doc_appointment_provider.dart';
import 'package:medreminder/controllers/providers/med_provider.dart';
import 'package:medreminder/controllers/providers/notes_provider.dart';
import 'package:medreminder/controllers/providers/relative_list_provider.dart';
import 'package:medreminder/controllers/services/pharmacies.dart';
import 'package:medreminder/views/Patient/auth/login.dart';
import 'package:medreminder/views/Patient/home/appoinments/doc_appointments_list.dart';
import 'package:medreminder/views/Patient/home/medicineSchedules/medicine_list.dart';
import 'package:medreminder/views/Patient/home/notes/notes_list.dart';
import 'package:medreminder/views/Patient/home/notifications/notifications.dart';
import 'package:medreminder/views/Patient/home/notifyRelatives/relative_list.dart';
import 'package:medreminder/widgets/card.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool load = true;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        load = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        backgroundColor: secondary,
        // 3 dots menu
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomeNotification()));
            },
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
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
                      Get.offAll(const Login());
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
      body: Stack(children: [
        Visibility(
          visible: !load,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: CustomCard(
                  text: uid,
                  onTap: () {},
                  height: 30.h,
                  width: double.infinity,
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Notes",
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Icon(
                                          CupertinoIcons.square_list_fill,
                                          size: 16.sp,
                                          color: tertiary,
                                        )
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
                                          height:
                                              5.w, // Using responsive height
                                          decoration: const BoxDecoration(
                                            color: secondary,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Consumer(
                                              builder: (context, ref, _) {
                                                final userResult =
                                                    ref.watch(notesProvider);
                                                ref.refresh(notesProvider);
                                                return userResult.when(
                                                  data: (notes) {
                                                    return Text(
                                                      notes.isNotEmpty
                                                          ? notes.length
                                                              .toString()
                                                          : "0",
                                                      style: TextStyle(
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: white),
                                                    );
                                                  },
                                                  loading: () =>
                                                      const Text("..."),
                                                  error: (error, stackTrace) =>
                                                      Text('Error: $error'),
                                                );
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
                                          height:
                                              5.w, // Using responsive height
                                          decoration: const BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Consumer(
                                              builder: (context, ref, _) {
                                                final userResult = ref.watch(
                                                    completedNotesProvider);
                                                ref.refresh(
                                                    completedNotesProvider);
                                                return userResult.when(
                                                  data: (notes) {
                                                    return Center(
                                                      child: Text(
                                                        notes.isNotEmpty
                                                            ? notes.length
                                                                .toString()
                                                            : "0",
                                                        style: TextStyle(
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: white),
                                                      ),
                                                    );
                                                  },
                                                  loading: () =>
                                                      const Text("..."),
                                                  error: (error, stackTrace) =>
                                                      Text('Error: $error'),
                                                );
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
                                          "Pending",
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          width: 5.w, // Using responsive width
                                          height:
                                              5.w, // Using responsive height
                                          decoration: const BoxDecoration(
                                            color: Colors.orange,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Consumer(
                                              builder: (context, ref, _) {
                                                final userResult = ref.watch(
                                                    pendingNotesProvider);
                                                ref.refresh(
                                                    pendingNotesProvider);
                                                return userResult.when(
                                                    data: (notes) {
                                                      return Center(
                                                        child: Text(
                                                          notes.isNotEmpty
                                                              ? notes.length
                                                                  .toString()
                                                              : "0",
                                                          style: TextStyle(
                                                              fontSize: 16.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: white),
                                                        ),
                                                      );
                                                    },
                                                    loading: () =>
                                                        const Text("..."),
                                                    error: (error, stackTrace) {
                                                      print('Error: $error');
                                                      return Text(
                                                          'Error: $error');
                                                    });
                                              },
                                            ),
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
                              builder: (context) => const MedicineList(),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Medicine Schedules",
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            softWrap: true,
                                          ),
                                        ),
                                        Icon(
                                          CupertinoIcons.bandage,
                                          size: 16.sp,
                                          color: tertiary,
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
                                          height:
                                              5.w, // Using responsive height
                                          decoration: const BoxDecoration(
                                            color: secondary,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Consumer(
                                              builder: (context, ref, _) {
                                                final userResult = ref
                                                    .watch(pendingMedProvider);
                                                ref.refresh(pendingMedProvider);
                                                return userResult.when(
                                                  data: (notes) {
                                                    return Text(
                                                      notes.isNotEmpty
                                                          ? notes.length
                                                              .toString()
                                                          : "0",
                                                      style: TextStyle(
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: white),
                                                    );
                                                  },
                                                  loading: () =>
                                                      const Text("..."),
                                                  error: (error, stackTrace) =>
                                                      Text('Error: $error'),
                                                );
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
                                          "Taken",
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          width: 5.w, // Using responsive width
                                          height:
                                              5.w, // Using responsive height
                                          decoration: const BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Consumer(
                                              builder: (context, ref, _) {
                                                final userResult =
                                                    ref.watch(takenMedProvider);
                                                ref.refresh(takenMedProvider);
                                                return userResult.when(
                                                  data: (notes) {
                                                    return Center(
                                                      child: Text(
                                                        notes.isNotEmpty
                                                            ? notes.length
                                                                .toString()
                                                            : "0",
                                                        style: TextStyle(
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: white),
                                                      ),
                                                    );
                                                  },
                                                  loading: () =>
                                                      const Text("..."),
                                                  error: (error, stackTrace) =>
                                                      Text('Error: $error'),
                                                );
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
                                          "Missed",
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          width: 5.w, // Using responsive width
                                          height:
                                              5.w, // Using responsive height
                                          decoration: const BoxDecoration(
                                            color: Colors.orange,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Consumer(
                                              builder: (context, ref, _) {
                                                final userResult = ref
                                                    .watch(missedMedProvider);
                                                ref.refresh(missedMedProvider);
                                                return userResult.when(
                                                    data: (notes) {
                                                      return Center(
                                                        child: Text(
                                                          notes.isNotEmpty
                                                              ? notes.length
                                                                  .toString()
                                                              : "0",
                                                          style: TextStyle(
                                                              fontSize: 16.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: white),
                                                        ),
                                                      );
                                                    },
                                                    loading: () =>
                                                        const Text("..."),
                                                    error: (error, stackTrace) {
                                                      print('Error: $error');
                                                      return Text(
                                                          'Error: $error');
                                                    });
                                              },
                                            ),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Appoinments",
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Icon(
                                          CupertinoIcons.calendar,
                                          size: 16.sp,
                                          color: tertiary,
                                        )
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
                                          height:
                                              5.w, // Using responsive height
                                          decoration: const BoxDecoration(
                                            color: secondary,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Consumer(
                                              builder: (context, ref, _) {
                                                final userResult = ref
                                                    .watch(appoinmentProvider);
                                                ref.refresh(appoinmentProvider);
                                                return userResult.when(
                                                  data: (appoinment) {
                                                    return Text(
                                                      appoinment.isNotEmpty
                                                          ? appoinment.length
                                                              .toString()
                                                          : "0",
                                                      style: TextStyle(
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: white),
                                                    );
                                                  },
                                                  loading: () =>
                                                      const Text("..."),
                                                  error: (error, stackTrace) =>
                                                      Text('Error: $error'),
                                                );
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
                                          "Upcoming",
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          width: 5.w, // Using responsive width
                                          height:
                                              5.w, // Using responsive height
                                          decoration: const BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Consumer(
                                              builder: (context, ref, _) {
                                                final userResult = ref.watch(
                                                    upcomingAppoinmentProvider);
                                                ref.refresh(
                                                    upcomingAppoinmentProvider);
                                                return userResult.when(
                                                  data: (appointment) {
                                                    return Center(
                                                      child: Text(
                                                        appointment.isNotEmpty
                                                            ? appointment.length
                                                                .toString()
                                                            : "0",
                                                        style: TextStyle(
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: white),
                                                      ),
                                                    );
                                                  },
                                                  loading: () =>
                                                      const Text("..."),
                                                  error: (error, stackTrace) =>
                                                      Text('Error: $error'),
                                                );
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
                                          "Missed",
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          width: 5.w, // Using responsive width
                                          height:
                                              5.w, // Using responsive height
                                          decoration: const BoxDecoration(
                                            color: Colors.orange,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Consumer(
                                              builder: (context, ref, _) {
                                                final userResult = ref.watch(
                                                    missedAppoinmentProvider);
                                                ref.refresh(
                                                    missedAppoinmentProvider);
                                                return userResult.when(
                                                  data: (appoinment) {
                                                    return Center(
                                                      child: Text(
                                                        appoinment.isNotEmpty
                                                            ? appoinment.length
                                                                .toString()
                                                            : "0",
                                                        style: TextStyle(
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: white),
                                                      ),
                                                    );
                                                  },
                                                  loading: () =>
                                                      const Text("..."),
                                                  error: (error, stackTrace) =>
                                                      Text('Error: $error'),
                                                );
                                              },
                                            ),
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
                        CustomCard(
                          text: 'Pharmacy Nearby',
                          onTap: () => PharmaciesController().openGoogleMaps(),
                          height: 20.h,
                          width: 43.w,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Relatives",
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Icon(
                                          CupertinoIcons.person_2_fill,
                                          size: 18.sp,
                                          color: tertiary,
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Total Relatives",
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          width: 5.w, // Using responsive width
                                          height:
                                              5.w, // Using responsive height
                                          decoration: const BoxDecoration(
                                            color: secondary,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Consumer(
                                              builder: (context, ref, _) {
                                                final userResult =
                                                    ref.watch(relativelist);
                                                ref.refresh(relativelist);
                                                return userResult.when(
                                                  data: (relatives) {
                                                    return Text(
                                                      relatives.isNotEmpty
                                                          ? relatives.length
                                                              .toString()
                                                          : "0",
                                                      style: TextStyle(
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: white),
                                                    );
                                                  },
                                                  loading: () =>
                                                      const Text("..."),
                                                  error: (error, stackTrace) =>
                                                      Text('Error: $error'),
                                                );
                                              },
                                            ),
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
                        CustomCard(
                          text: 'Report',
                          onTap: () => print('tapped'),
                          height: 20.h,
                          width: 43.w,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
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
      ]),
    );
  }
}