import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:medreminder/controllers/providers/doc_appointment_provider.dart';
import 'package:medreminder/controllers/providers/med_provider.dart';
import 'package:medreminder/controllers/providers/notes_provider.dart';
import 'package:medreminder/controllers/providers/relative_list_provider.dart';
import 'package:medreminder/controllers/services/pharmacies.dart';
import 'package:medreminder/views/Patient/auth/email_auth/email_login.dart';
import 'package:medreminder/views/Patient/home/appoinments/doc_appointments_list.dart';
import 'package:medreminder/views/Patient/home/medicineSchedules/medicine_list.dart';
import 'package:medreminder/views/Patient/home/notes/notes_list.dart';
import 'package:medreminder/views/Patient/home/notifications/notifications.dart';
import 'package:medreminder/views/Patient/home/notifyRelatives/relative_list.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  @override
  void initState() {
    //refreshing the data
    note;
    completedNotes;
    pendingNotes;
    appoinment;
    upcomingAppoinment;
    missedAppoinment;
    pendingMed;
    takenMed;
    missedMed;
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
        title: const Text('Minder Alert'),
        backgroundColor: secondary,
        // 3 dots menu
        actions: [
          Consumer(
            builder: (context, ref, _) {
              final userResult = ref.watch(notesProvider);
              // ref.refresh(notesProvider);
              return userResult.when(
                data: (notes) {
                  return IconButton(
                    onPressed: () {
                      setState(() {
                        load = true;
                      });
                      note = ref.refresh(notesProvider);
                      completedNotes = ref.refresh(completedNotesProvider);
                      pendingNotes = ref.refresh(pendingNotesProvider);
                      appoinment = ref.refresh(appoinmentProvider);
                      upcomingAppoinment =
                          ref.refresh(upcomingAppoinmentProvider);
                      missedAppoinment = ref.refresh(missedAppoinmentProvider);
                      pendingMed = ref.refresh(pendingMedProvider);
                      takenMed = ref.refresh(takenMedProvider);
                      missedMed = ref.refresh(missedMedProvider);
                      Future.delayed(const Duration(milliseconds: 500), () {
                        setState(() {
                          load = false;
                        });
                      });
                    },
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                  );
                },
                loading: () => const Text("..."),
                error: (error, stackTrace) => Text('Error: $error'),
              );
            },
          ),
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
      body: RefreshIndicator(
        onRefresh: () {
          //refresh data using RefreshData class
          // const RefreshData().refreshData(context);
          return Future.delayed(const Duration(milliseconds: 500), () {
            setState(() {
              load = false;
            });
          });
        },
        child: Stack(
          children: [
            Visibility(
              visible: !load,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(10.sp),
                      child: Container(
                        width: 80.w,
                        height: 30.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              5.w), // Adjust the radius as needed
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(
                                  0, 3), // Adjust the shadow position as needed
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              16.0), // Same radius as the BoxDecoration
                          child: Image.asset(
                            'lib/constants/assets/home.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
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
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "Notes",
                                              style: TextStyle(
                                                fontSize: 18.sp,
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
                                              width:
                                                  5.w, // Using responsive width
                                              height: 5
                                                  .w, // Using responsive height
                                              decoration: const BoxDecoration(
                                                color: secondary,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Consumer(
                                                  builder: (context, ref, _) {
                                                    final userResult = ref
                                                        .watch(notesProvider);
                                                    // ref.refresh(notesProvider);
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
                                                                  FontWeight
                                                                      .bold,
                                                              color: white),
                                                        );
                                                      },
                                                      loading: () =>
                                                          const Text("..."),
                                                      error: (error,
                                                              stackTrace) =>
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
                                              width:
                                                  5.w, // Using responsive width
                                              height: 5
                                                  .w, // Using responsive height
                                              decoration: const BoxDecoration(
                                                color: Colors.green,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Consumer(
                                                  builder: (context, ref, _) {
                                                    final userResult = ref.watch(
                                                        completedNotesProvider);
                                                    // ref.refresh(
                                                    //     completedNotesProvider);
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
                                                      error: (error,
                                                              stackTrace) =>
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
                                              width:
                                                  5.w, // Using responsive width
                                              height: 5
                                                  .w, // Using responsive height
                                              decoration: const BoxDecoration(
                                                color: Colors.orange,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Consumer(
                                                  builder: (context, ref, _) {
                                                    final userResult = ref.watch(
                                                        pendingNotesProvider);
                                                    // ref.refresh(
                                                    //     pendingNotesProvider);
                                                    return userResult.when(
                                                        data: (notes) {
                                                          return Center(
                                                            child: Text(
                                                              notes.isNotEmpty
                                                                  ? notes.length
                                                                      .toString()
                                                                  : "0",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: white),
                                                            ),
                                                          );
                                                        },
                                                        loading: () =>
                                                            const Text("..."),
                                                        error: (error,
                                                            stackTrace) {
                                                          print(
                                                              'Error: $error');
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
                                              MainAxisAlignment.spaceEvenly,
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
                                              width:
                                                  5.w, // Using responsive width
                                              height: 5
                                                  .w, // Using responsive height
                                              decoration: const BoxDecoration(
                                                color: secondary,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Consumer(
                                                  builder: (context, ref, _) {
                                                    final userResult =
                                                        ref.watch(
                                                            pendingMedProvider);
                                                    // ref.refresh(pendingMedProvider);
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
                                                                  FontWeight
                                                                      .bold,
                                                              color: white),
                                                        );
                                                      },
                                                      loading: () =>
                                                          const Text("..."),
                                                      error: (error,
                                                              stackTrace) =>
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
                                              width:
                                                  5.w, // Using responsive width
                                              height: 5
                                                  .w, // Using responsive height
                                              decoration: const BoxDecoration(
                                                color: Colors.green,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Consumer(
                                                  builder: (context, ref, _) {
                                                    final userResult =
                                                        ref.watch(
                                                            takenMedProvider);
                                                    // ref.refresh(takenMedProvider);
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
                                                      error: (error,
                                                              stackTrace) =>
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
                                              width:
                                                  5.w, // Using responsive width
                                              height: 5
                                                  .w, // Using responsive height
                                              decoration: const BoxDecoration(
                                                color: Colors.orange,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Consumer(
                                                  builder: (context, ref, _) {
                                                    final userResult =
                                                        ref.watch(
                                                            missedMedProvider);
                                                    // ref.refresh(missedMedProvider);
                                                    return userResult.when(
                                                        data: (notes) {
                                                          return Center(
                                                            child: Text(
                                                              notes.isNotEmpty
                                                                  ? notes.length
                                                                      .toString()
                                                                  : "0",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: white),
                                                            ),
                                                          );
                                                        },
                                                        loading: () =>
                                                            const Text("..."),
                                                        error: (error,
                                                            stackTrace) {
                                                          print(
                                                              'Error: $error');
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
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "Appoinments",
                                              style: TextStyle(
                                                fontSize: 18.sp,
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
                                              width:
                                                  5.w, // Using responsive width
                                              height: 5
                                                  .w, // Using responsive height
                                              decoration: const BoxDecoration(
                                                color: secondary,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Consumer(
                                                  builder: (context, ref, _) {
                                                    final userResult =
                                                        ref.watch(
                                                            appoinmentProvider);
                                                    // ref.refresh(appoinmentProvider);
                                                    return userResult.when(
                                                      data: (appoinment) {
                                                        return Text(
                                                          appoinment.isNotEmpty
                                                              ? appoinment
                                                                  .length
                                                                  .toString()
                                                              : "0",
                                                          style: TextStyle(
                                                              fontSize: 16.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: white),
                                                        );
                                                      },
                                                      loading: () =>
                                                          const Text("..."),
                                                      error: (error,
                                                              stackTrace) =>
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
                                              width:
                                                  5.w, // Using responsive width
                                              height: 5
                                                  .w, // Using responsive height
                                              decoration: const BoxDecoration(
                                                color: Colors.green,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Consumer(
                                                  builder: (context, ref, _) {
                                                    final userResult = ref.watch(
                                                        upcomingAppoinmentProvider);
                                                    // ref.refresh(
                                                    //     upcomingAppoinmentProvider);
                                                    return userResult.when(
                                                      data: (appointment) {
                                                        return Center(
                                                          child: Text(
                                                            appointment
                                                                    .isNotEmpty
                                                                ? appointment
                                                                    .length
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
                                                      error: (error,
                                                              stackTrace) =>
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
                                              width:
                                                  5.w, // Using responsive width
                                              height: 5
                                                  .w, // Using responsive height
                                              decoration: const BoxDecoration(
                                                color: Colors.orange,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Consumer(
                                                  builder: (context, ref, _) {
                                                    final userResult = ref.watch(
                                                        missedAppoinmentProvider);
                                                    // ref.refresh(
                                                    //     missedAppoinmentProvider);
                                                    return userResult.when(
                                                      data: (appoinment) {
                                                        return Center(
                                                          child: Text(
                                                            appoinment
                                                                    .isNotEmpty
                                                                ? appoinment
                                                                    .length
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
                                                      error: (error,
                                                              stackTrace) =>
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
                            GestureDetector(
                              onTap: () =>
                                  PharmaciesController().openGoogleMaps(),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Image.asset(
                                        'lib/constants/assets/map.png',
                                        width: 20.w,
                                      ),
                                      Text(
                                        "Pharmacy Nearby",
                                        style: TextStyle(
                                          fontSize: 18.sp,
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
                                  builder: (context) =>
                                      const NotifyRelativeList(),
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
                                        Image.asset(
                                          'lib/constants/assets/relative.png',
                                          width: 20.w,
                                        ),
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
                                              "Total Relatives",
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Container(
                                              width:
                                                  5.w, // Using responsive width
                                              height: 5
                                                  .w, // Using responsive height
                                              decoration: const BoxDecoration(
                                                color: secondary,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Consumer(
                                                  builder: (context, ref, _) {
                                                    final userResult =
                                                        ref.watch(relativelist);
                                                    // ref.refresh(relativelist);
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
                                                                  FontWeight
                                                                      .bold,
                                                              color: white),
                                                        );
                                                      },
                                                      loading: () =>
                                                          const Text("..."),
                                                      error: (error,
                                                              stackTrace) =>
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
                            Card(
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
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            16.0), // Adjust the radius as needed
                                        child: Image.asset(
                                          'lib/constants/assets/report.jpg',
                                          width: 20.w,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Report",
                                            style: TextStyle(
                                              fontSize: 18.sp,
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
          ],
        ),
      ),
    );
  }
}

class RefreshData extends ConsumerWidget {
  const RefreshData({super.key});

  //refreshing the data
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final note = ref.refresh(notesProvider);
    final completedNotes = ref.refresh(completedNotesProvider);
    final pendingNotes = ref.refresh(pendingNotesProvider);
    final appoinment = ref.refresh(appoinmentProvider);
    final upcomingAppoinment = ref.refresh(upcomingAppoinmentProvider);
    final missedAppoinment = ref.refresh(missedAppoinmentProvider);
    final pendingMed = ref.refresh(pendingMedProvider);
    final takenMed = ref.refresh(takenMedProvider);
    final missedMed = ref.refresh(missedMedProvider);

    return note.when(
      data: (notes) {
        return completedNotes.when(
          data: (completedNotes) {
            return pendingNotes.when(
              data: (pendingNotes) {
                return appoinment.when(
                  data: (appoinment) {
                    return upcomingAppoinment.when(
                      data: (upcomingAppoinment) {
                        return missedAppoinment.when(
                          data: (missedAppoinment) {
                            return pendingMed.when(
                              data: (pendingMed) {
                                return takenMed.when(
                                  data: (takenMed) {
                                    return missedMed.when(
                                      data: (missedMed) {
                                        return const Text('Refreshed');
                                      },
                                      loading: () => const Text("..."),
                                      error: (error, stackTrace) =>
                                          Text('Error: $error'),
                                    );
                                  },
                                  loading: () => const Text("..."),
                                  error: (error, stackTrace) =>
                                      Text('Error: $error'),
                                );
                              },
                              loading: () => const Text("..."),
                              error: (error, stackTrace) =>
                                  Text('Error: $error'),
                            );
                          },
                          loading: () => const Text("..."),
                          error: (error, stackTrace) => Text('Error: $error'),
                        );
                      },
                      loading: () => const Text("..."),
                      error: (error, stackTrace) => Text('Error: $error'),
                    );
                  },
                  loading: () => const Text("..."),
                  error: (error, stackTrace) => Text('Error: $error'),
                );
              },
              loading: () => const Text("..."),
              error: (error, stackTrace) => Text('Error: $error'),
            );
          },
          loading: () => const Text("..."),
          error: (error, stackTrace) => Text('Error: $error'),
        );
      },
      loading: () => const Text("..."),
      error: (error, stackTrace) => Text('Error: $error'),
    );
  }
}
