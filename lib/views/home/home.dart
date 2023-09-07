import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:medreminder/controllers/providers/doc_appointment_provider.dart';
import 'package:medreminder/controllers/providers/notes_provider.dart';
import 'package:medreminder/views/home/appoinments/doc_appointments_list.dart';
import 'package:medreminder/views/home/medicines/MedicineList.dart';
import 'package:medreminder/views/home/medicines/MedicineSchedule.dart';
import 'package:medreminder/views/home/notes/notes_list.dart';
import 'package:medreminder/widgets/card.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        backgroundColor: secondary,
      ),
      body: CustomScrollView(
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                      height: 5.w, // Using responsive height
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
                                                      ? notes.length.toString()
                                                      : "0",
                                                  style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: white),
                                                );
                                              },
                                              loading: () => const Text("..."),
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
                                      height: 5.w, // Using responsive height
                                      decoration: const BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Consumer(
                                          builder: (context, ref, _) {
                                            final userResult = ref
                                                .watch(completedNotesProvider);
                                            ref.refresh(completedNotesProvider);
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
                                              loading: () => const Text("..."),
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
                                      height: 5.w, // Using responsive height
                                      decoration: const BoxDecoration(
                                        color: Colors.orange,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Consumer(
                                          builder: (context, ref, _) {
                                            final userResult =
                                                ref.watch(pendingNotesProvider);
                                            ref.refresh(pendingNotesProvider);
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
                                              loading: () => const Text("..."),
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
                            child: Center(child: Text('Medicines Schedule'))),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                      height: 5.w, // Using responsive height
                                      decoration: const BoxDecoration(
                                        color: secondary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Consumer(
                                          builder: (context, ref, _) {
                                            final userResult =
                                                ref.watch(appoinmentProvider);
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
                                              loading: () => const Text("..."),
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
                                      height: 5.w, // Using responsive height
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
                                              loading: () => const Text("..."),
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
                                      height: 5.w, // Using responsive height
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
                                              loading: () => const Text("..."),
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
                      onTap: () => print('tapped'),
                      height: 20.h,
                      width: 43.w,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomCard(
                      text: 'Notify Relative',
                      onTap: () => print('tapped'),
                      height: 20.h,
                      width: 43.w,
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
    );
  }
}
