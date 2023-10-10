import 'package:flutter/material.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:medreminder/views/Patient/home/appoinments/doc_appoinment_tabs/all.dart';
import 'package:medreminder/views/Patient/home/appoinments/doc_appoinment_tabs/missed.dart';
import 'package:medreminder/views/Patient/home/appoinments/doc_appoinment_tabs/upcoming.dart';
import 'package:medreminder/views/Patient/home/appoinments/doc_appointments_add.dart';

// ignore: must_be_immutable
class AppoinmentsList extends StatefulWidget {
  const AppoinmentsList({super.key});

  @override
  State<AppoinmentsList> createState() => _AppoinmentsListState();
}

class _AppoinmentsListState extends State<AppoinmentsList>
    with SingleTickerProviderStateMixin {
  final doctorName = TextEditingController();

  final hospitalName = TextEditingController();

  final note = TextEditingController();

  final visitReason = TextEditingController();

  bool load = true;
  bool val = false;
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
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
      appBar: AppBar(
        title: const Text('Doctor Appointments'),
        centerTitle: true,
        backgroundColor: secondary,
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
                  tabs: const [
                    Tab(text: 'All'),
                    Tab(text: 'Upcoming'),
                    Tab(text: 'Missed'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      AllAppoinments(),
                      UpcomingAppoinments(),
                      MissedAppoinments(),
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
      floatingActionButton: Visibility(
        visible: !load,
        child: FloatingActionButton.extended(
          backgroundColor: secondary,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AppoinmentsAdd()));
          },
          label: const Text('Schedule Appoinment'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}
