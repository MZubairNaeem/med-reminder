import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:medreminder/controllers/providers/relative_list_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// ignore: must_be_immutable
class CareTakerNotification extends StatefulWidget {
  String uid;
  String? name;
  CareTakerNotification({
    super.key,
    required this.uid,
    required this.name,
  });

  @override
  State<CareTakerNotification> createState() => _HomeNotificationState();
}

class _HomeNotificationState extends State<CareTakerNotification>
    with SingleTickerProviderStateMixin {
  //form key
  late TabController _tabController;

  bool load = true;
  String a_count = '0';

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        load = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Visibility(
            visible: !load,
            child: Column(
              children: [
                TabBar(
                  isScrollable: true,
                  indicatorColor: secondary,
                  labelColor: gray,
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  controller: _tabController,
                  tabs: [
                    Row(
                      children: [
                        const Tab(text: 'Appointments'),
                        Container(
                          margin: const EdgeInsets.only(left: 5),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: secondary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Consumer(
                            builder: (context, ref, _) {
                              final userResult = ref.watch(
                                  missedRelativeAppoinmentProvider(widget.uid));
                              // ref.refresh(notesProvider);
                              return userResult.when(
                                  data: (appointments) {
                                    return appointments.isEmpty
                                        ? const Center(child: Text('0'))
                                        : Text(
                                            appointments.length.toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
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
                        )
                      ],
                    ),
                    Row(
                      children: [
                        const Tab(text: 'Medicines'),
                        Container(
                          margin: const EdgeInsets.only(left: 5),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: secondary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Consumer(
                            builder: (context, ref, _) {
                              final userResult = ref
                                  .watch(missedRelativeMedProvider(widget.uid));
                              // ref.refresh(notesProvider);
                              return userResult.when(
                                  data: (appointments) {
                                    return appointments.isEmpty
                                        ? const Center(
                                            child: Text(
                                            '0',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ))
                                        : Text(
                                            appointments.length.toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
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
                        )
                      ],
                    )
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      Consumer(
                        builder: (context, ref, _) {
                          final userResult = ref.watch(
                              missedRelativeAppoinmentProvider(widget.uid));
                          // ref.refresh(notesProvider);
                          return userResult.when(
                              data: (appointments) {
                                print(appointments.length);
                                DateTime time = appointments[0]
                                    .appointmentDateTime!
                                    .toDate();
                                String formattedTime =
                                    DateFormat.jm().format(time);
                                String formattedDate =
                                    DateFormat('MMMM dd, yyyy').format(time);
                                return appointments.isEmpty
                                    ? const Center(
                                        child: Text(
                                            'No Appointments Notifications'))
                                    : ListView.builder(
                                        itemCount: appointments.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 4.w,
                                              vertical: 0.1.h,
                                            ),
                                            child: Card(
                                              color: Colors.white,
                                              elevation: 2,
                                              shadowColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 4.w,
                                                  vertical: 2.h,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              SizedBox(
                                                                width: 70.w,
                                                                child: Text(
                                                                  '${widget.name} Missed appointment with ${appointments[index].doctorName!}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        17.sp,
                                                                    color:
                                                                        primary,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .clip,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        // popup menu

                                                        SizedBox(height: 1.h),
                                                        SizedBox(
                                                          width: 65.w,
                                                          height: 4.h,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              //time date and hospital
                                                              '$formattedTime, $formattedDate' +
                                                                  ' at ${appointments[index].hospitalName!}',
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                letterSpacing:
                                                                    0.5,
                                                                fontSize: 15.sp,
                                                                color: gray,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
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
                      Consumer(
                        builder: (context, ref, _) {
                          final userResult =
                              ref.watch(missedRelativeMedProvider(widget.uid));
                          return userResult.when(
                              data: (med) {
                                return med.isEmpty
                                    ? const Center(
                                        child:
                                            Text('No Medicine Notifications'))
                                    : ListView.builder(
                                        itemCount: med.length,
                                        itemBuilder: (context, index) {
                                          DateTime time =
                                              med[index].time!.toDate();
                                          String formattedTime =
                                              DateFormat.jm().format(time);
                                          String formattedDate =
                                              DateFormat('MMMM dd, yyyy')
                                                  .format(time);
                                          return GestureDetector(
                                            onTap: () {},
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 4.w,
                                                vertical: 0.1.h,
                                              ),
                                              child: Card(
                                                color: Colors.white,
                                                elevation: 2,
                                                shadowColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 4.w,
                                                    vertical: 2.h,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        width: 70.w,
                                                        child: Text(
                                                          '${widget.name} Missed medicine ${med[index].dosageQuantity} ${med[index].medType}s of ${med[index].medName!} at $formattedTime on $formattedDate',
                                                          style: TextStyle(
                                                            fontSize: 16.sp,
                                                            color: primary,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
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
          )
        ],
      ),
    );
  }
}
