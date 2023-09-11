import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:medreminder/controllers/providers/med_provider.dart';
import 'package:medreminder/controllers/services/med_controller.dart';
import 'package:medreminder/views/home/medicineSchedules/medicine_schedule_add.dart';
import 'package:medreminder/widgets/med_card.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MedicineList extends StatefulWidget {
  const MedicineList({Key? key}) : super(key: key);

  @override
  State<MedicineList> createState() => _MedicineListState();
}

class _MedicineListState extends State<MedicineList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondary,
        centerTitle: true,
        title: const Text("Medicine Schedule"),
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
      body: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Consumer(
          builder: (context, ref, _) {
            final userResult = ref.watch(medProvider);
            // ref.refresh(medProvider);
            return userResult.when(
                data: (med) {
                  return med.isEmpty
                      ? Center(
                          child: Text(
                            '-- You have no Medicine Schedules --',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: med.length,
                          itemBuilder: (context, index) {
                            // DateTime time = notes[index].timestamp!.toDate();
                            // DateTime now = DateTime.now();
                            // String formattedTime = DateFormat.jm().format(time);
                            // String formattedDate =
                            //     DateFormat.yMd().format(time);
                            return MedicineCard(
                              medicineName: med[index].medName!,
                              dosage: med[index].dosageQuantity!,
                              medicineType: med[index].medType!,
                              medicineInterval: med[index].interval!,
                              deleteFunction: (context) {
                                // ignore: unused_result
                                ref.refresh(medProvider);
                                Med().deleteMed(
                                  context,
                                  med[index].id!,
                                );
                              },
                            );
                          });
                },
                loading: () => const Text("..."),
                error: (error, stackTrace) {
                  return Text('Error: $error');
                });
          },
        ),
      ),
    );
  }
}
