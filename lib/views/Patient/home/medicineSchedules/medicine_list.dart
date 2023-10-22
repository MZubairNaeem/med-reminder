import 'package:flutter/material.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:medreminder/models/med_model.dart';
import 'package:medreminder/views/Patient/home/medicineSchedules/medicine_schedule_add.dart';
import 'package:medreminder/views/Patient/home/medicineSchedules/medicine_schedule_tabs/all.dart';
import 'package:medreminder/views/Patient/home/medicineSchedules/medicine_schedule_tabs/missed.dart';
import 'package:medreminder/views/Patient/home/medicineSchedules/medicine_schedule_tabs/pending.dart';
import 'package:medreminder/views/Patient/home/medicineSchedules/medicine_schedule_tabs/taken.dart';

class MedicineList extends StatefulWidget {
  MedModel? medModel;
  MedicineList({Key? key, this.medModel}) : super(key: key);

  @override
  State<MedicineList> createState() => _MedicineListState();
}

class _MedicineListState extends State<MedicineList>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool load = true;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
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
        backgroundColor: secondary,
        centerTitle: true,
        title: const Text("Medicine Schedule"),
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
                    Tab(text: 'Pending'),
                    Tab(text: 'Missed'),
                    Tab(text: 'Taken'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      AllMedicine(
                        medModel: widget.medModel!,
                      ),
                      PendingMedicine(
                        medModel: widget.medModel!,
                      ),
                      MissedMedicine(
                        medModel: widget.medModel!,
                      ),
                      TakenMedicine(
                        medModel: widget.medModel!,
                      )
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: secondary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MedicineSchedule(),
            ),
          );
        },
        label: const Text("Add Medicine"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
