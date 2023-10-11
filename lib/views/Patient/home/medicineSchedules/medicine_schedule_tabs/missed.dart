import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medreminder/controllers/providers/med_provider.dart';
import 'package:medreminder/controllers/services/med_controller.dart';
import 'package:medreminder/views/Patient/home/medicineSchedules/Edit_Medicine.dart';
import 'package:medreminder/widgets/med_card.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MissedMedicine extends StatefulWidget {
  const MissedMedicine({Key? key}) : super(key: key);

  @override
  State<MissedMedicine> createState() => _MedicineListState();
}

class _MedicineListState extends State<MissedMedicine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 4.0,
              right: 4.0,
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: Text(
                '<== Swipe left for more options',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.sp),
            child: Consumer(
              builder: (context, ref, _) {
                final userResult = ref.watch(missedMedProvider);
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
                              return MedicineCard(
                                medicineName: med[index].medName!,
                                dosage: med[index].dosageQuantity!,
                                medicineType: med[index].medType!,
                                medicineInterval: med[index].interval!,
                                qty: med[index].quantity!,
                                deleteFunction: (context) {
                                  Med().deleteMed(
                                    context,
                                    med[index].id!,
                                  );
                                    ref.refresh(medProvider);
                                  ref.refresh(missedMedProvider);
                                  ref.refresh(takenMedProvider);
                                  ref.refresh(pendingMedProvider);
                                },
                                editFunction: (context) async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditMedicineSchedule(
                                        medicineName: med[index].medName!,
                                        dosage: med[index].dosageQuantity!,
                                        medicineType: med[index].medType!,
                                        medicineInterval: med[index].interval!,
                                        id: med[index].id!,
                                      ),
                                    ),
                                  );

                                  // if (updatedData != null) {
                                  //   // Update the medicine data in your data source (e.g., database or provider)
                                  //   // You can also refresh the UI if necessary
                                  //   // Example: Update med[index] with the updatedData
                                  //   setState(() {
                                  //     med[index].medName =
                                  //         updatedData['medicineName'];
                                  //     med[index].dosageQuantity =
                                  //         updatedData['dosage'];
                                  //     med[index].medType =
                                  //         updatedData['medicineType'];
                                  //     med[index].interval =
                                  //         updatedData['medicineInterval'];
                                  //   });
                                  // }
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
        ],
      ),
    );
  }
}
