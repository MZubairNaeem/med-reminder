import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:medreminder/controllers/providers/med_provider.dart';
import 'package:medreminder/controllers/services/med_controller.dart';
import 'package:medreminder/views/Patient/home/medicineSchedules/Edit_Medicine.dart';
import 'package:medreminder/views/Patient/home/medicineSchedules/medicine_list.dart';
import 'package:medreminder/views/Patient/home/medicineSchedules/medicine_schedule_add.dart';
import 'package:medreminder/widgets/med_card.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AllMeds extends StatefulWidget {
  const AllMeds({Key? key}) : super(key: key);

  @override
  State<AllMeds> createState() => _MedicineListState();
}

class _MedicineListState extends State<AllMeds> {
  bool select = false;
  bool checkList = false;
  List<String> selectedMeds = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondary,
        centerTitle: true,
        title: const Text("All Medicines"),
      ),
      body: Stack(
        children: [
          Padding(
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
                              '-- You have no Medicines added yet --',
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
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MedicineList(
                                        medModel: med[index],
                                      ),
                                    ),
                                  );
                                },
                                onLongPress: () {
                                  HapticFeedback.heavyImpact();
                                  setState(() {
                                    select = true;
                                  });
                                },
                                child: MedicineCard(
                                  medicineName: med[index].medName!,
                                  dosage: med[index].dosageQuantity!,
                                  medicineType: med[index].medType!,
                                  medicineInterval: med[index].interval!,
                                  qty: med[index].quantity!,
                                  onSelect: (p0) {
                                    setState(() {
                                      checkList = p0!;
                                      if (checkList) {
                                        selectedMeds.add(med[index].id!);
                                      } else {
                                        selectedMeds.remove(med[index].id!);
                                      }
                                    });
                                  },
                                  select: select,
                                  checkList:
                                      selectedMeds.contains(med[index].id!)
                                          ? true
                                          : false,
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
                                          medicineInterval:
                                              med[index].interval!,
                                          id: med[index].id!,
                                        ),
                                      ),
                                    );
                                  },
                                ),
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Visibility(
            visible: select,
            child: Align(
              alignment: Alignment.centerRight,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    select = false;
                  });
                },
                child: const Icon(
                    Icons.clear), // You can change the icon as needed
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Visibility(
            visible: select,
            child: Align(
              alignment: Alignment.centerRight,
              child: FloatingActionButton(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 221, 42, 30),
                onPressed: () {
                  if (selectedMeds.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'No med selected',
                      snackPosition: SnackPosition.BOTTOM,
                      colorText: Colors.white,
                      backgroundColor: Colors.orange,
                    );
                    return;
                  }
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          'Delete ${selectedMeds.length} meds?',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: Text(
                          'Are you sure you want to delete these meds?',
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Consumer(
                            builder: (context, ref, _) {
                              final userResult = ref.watch(medProvider);
                              // ref.refresh(notesProvider);
                              return userResult.when(
                                  data: (notes) {
                                    return TextButton(
                                      onPressed: () async {
                                        await Med().deleteMultipleMeds(
                                          context,
                                          selectedMeds,
                                        );
                                        setState(() {
                                          select = false;
                                        });
                                        ref.refresh(medProvider);
                                        ref.refresh(pendingMedProvider);
                                        ref.refresh(takenMedProvider);
                                        selectedMeds.clear();
                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
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
                        ],
                      );
                    },
                  );
                },
                child: const Icon(
                  Icons.delete_rounded,
                ), // You can change the icon as needed
              ),
            ),
          ),
          Visibility(
            visible: !select,
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton.extended(
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
            ),
          ),
        ],
      ),
    );
  }
}
