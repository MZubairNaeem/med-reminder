import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:medreminder/controllers/providers/med_provider.dart';
import 'package:medreminder/controllers/services/med_controller.dart';
import 'package:medreminder/views/Patient/home/medicineSchedules/Edit_Medicine.dart';
import 'package:medreminder/views/Patient/home/medicineSchedules/medicine_schedule_add.dart';
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
                          return MedicineCard(
                            medicineName: med[index].medName!,
                            dosage: med[index].dosageQuantity!,
                            medicineType: med[index].medType!,
                            medicineInterval: med[index].interval!,
                            deleteFunction: (context) {
                              ref.refresh(medProvider);
                              Med().deleteMed(
                                context,
                                med[index].id!,
                              );
                            },
                            editFunction: (context) async {
                              final updatedData = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditMedicineSchedule(
                                    medicineName: med[index].medName!,
                                    dosage: med[index].dosageQuantity!,
                                    medicineType: med[index].medType!,
                                    medicineInterval: med[index].interval!,
                                  ),
                                ),
                              );

                              if (updatedData != null) {
                                // Update the medicine data in your data source (e.g., database or provider)
                                // You can also refresh the UI if necessary
                                // Example: Update med[index] with the updatedData
                                setState(() {
                                  med[index].medName =
                                      updatedData['medicineName'];
                                  med[index].dosageQuantity =
                                      updatedData['dosage'];
                                  med[index].medType =
                                      updatedData['medicineType'];
                                  med[index].interval =
                                      updatedData['medicineInterval'];
                                });
                              }
                            },
                          );
                        },
                      );
              },
              loading: () => const Text("..."),
              error: (error, stackTrace) {
                return Text('Error: $error');
              },
            );
          },
        ),
      ),
    );
  }
}
