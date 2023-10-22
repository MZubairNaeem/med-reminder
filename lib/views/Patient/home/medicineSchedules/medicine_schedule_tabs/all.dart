import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:medreminder/models/med_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AllMedicine extends StatefulWidget {
  MedModel medModel;
  AllMedicine({Key? key, required this.medModel}) : super(key: key);

  @override
  State<AllMedicine> createState() => _MedicineListState();
}

class _MedicineListState extends State<AllMedicine> {
  bool select = false;
  bool checkList = false;
  List<String> selectedMeds = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('medSchedule')
            .doc(widget.medModel.id)
            .collection('intervals')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot doc = snapshot.data!.docs[index];
                DateTime time = doc['time'].toDate();
                String formattedTime = DateFormat.jm().format(time);
                String formattedDate = DateFormat('MMMM dd, yyyy').format(time);
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
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 80.w,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Dose #${index + 1}',
                                        style: TextStyle(
                                          fontSize: 17.sp,
                                          color: primary,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                      Checkbox(
                                        value: doc['status'],
                                        onChanged: (v) {
                                          setState(() {
                                            doc.reference.update({
                                              'status': v,
                                            });
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${widget.medModel.dosageQuantity} ${widget.medModel.medType}s of ${widget.medModel.medName}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  letterSpacing: 0.5,
                                  fontSize: 15.sp,
                                  color: gray,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '$formattedDate $formattedTime',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  letterSpacing: 0.5,
                                  fontSize: 15.sp,
                                  color: gray,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No Appointments Notifications'));
          }
        },
      ),
      // body: Stack(
      //   children: [
      //     Padding(
      //       padding: EdgeInsets.all(16.sp),
      //       child: Consumer(
      //         builder: (context, ref, _) {
      //           final userResult = ref.watch(medProvider);
      //           // ref.refresh(medProvider);
      //           return userResult.when(
      //             data: (med) {
      //               return med.isEmpty
      //                   ? Center(
      //                       child: Text(
      //                         '-- You have no Medicine Schedules --',
      //                         style: TextStyle(
      //                           fontSize: 16.sp,
      //                           fontWeight: FontWeight.bold,
      //                           fontStyle: FontStyle.italic,
      //                         ),
      //                       ),
      //                     )
      //                   : ListView.builder(
      //                       itemCount: med.length,
      //                       itemBuilder: (context, index) {
      //                         return GestureDetector(
      //                           onTap: () {
      //                             Navigator.push(
      //                               context,
      //                               MaterialPageRoute(
      //                                 builder: (context) => MedDetails(
      //                                   medModel: med[index],
      //                                 ),
      //                               ),
      //                             );
      //                           },
      //                           onLongPress: () {
      //                             HapticFeedback.heavyImpact();
      //                             setState(() {
      //                               select = true;
      //                             });
      //                           },
      //                           child: MedicineCard(
      //                             medicineName: med[index].medName!,
      //                             dosage: med[index].dosageQuantity!,
      //                             medicineType: med[index].medType!,
      //                             medicineInterval: med[index].interval!,
      //                             qty: med[index].quantity!,
      //                             onSelect: (p0) {
      //                               setState(() {
      //                                 checkList = p0!;
      //                                 if (checkList) {
      //                                   selectedMeds.add(med[index].id!);
      //                                 } else {
      //                                   selectedMeds.remove(med[index].id!);
      //                                 }
      //                               });
      //                             },
      //                             select: select,
      //                             checkList:
      //                                 selectedMeds.contains(med[index].id!)
      //                                     ? true
      //                                     : false,
      //                             deleteFunction: (context) {
      //                               Med().deleteMed(
      //                                 context,
      //                                 med[index].id!,
      //                               );
      //                               ref.refresh(medProvider);
      //                               ref.refresh(missedMedProvider);
      //                               ref.refresh(takenMedProvider);
      //                               ref.refresh(pendingMedProvider);
      //                             },
      //                             editFunction: (context) async {
      //                               await Navigator.push(
      //                                 context,
      //                                 MaterialPageRoute(
      //                                   builder: (context) =>
      //                                       EditMedicineSchedule(
      //                                     medicineName: med[index].medName!,
      //                                     dosage: med[index].dosageQuantity!,
      //                                     medicineType: med[index].medType!,
      //                                     medicineInterval:
      //                                         med[index].interval!,
      //                                     id: med[index].id!,
      //                                   ),
      //                                 ),
      //                               );

      //                               // if (updatedData != null) {
      //                               //   // Update the medicine data in your data source (e.g., database or provider)
      //                               //   // You can also refresh the UI if necessary
      //                               //   // Example: Update med[index] with the updatedData
      //                               //   setState(() {
      //                               //     med[index].medName =
      //                               //         updatedData['medicineName'];
      //                               //     med[index].dosageQuantity =
      //                               //         updatedData['dosage'];
      //                               //     med[index].medType =
      //                               //         updatedData['medicineType'];
      //                               //     med[index].interval =
      //                               //         updatedData['medicineInterval'];
      //                               //   });
      //                               // }
      //                             },
      //                           ),
      //                         );
      //                       },
      //                     );
      //             },
      //             loading: () => const Text("..."),
      //             error: (error, stackTrace) {
      //               return Text('Error: $error');
      //             },
      //           );
      //         },
      //       ),
      //     ),
      //   ],
      // ),
      // floatingActionButton: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     Visibility(
      //       visible: select,
      //       child: Align(
      //         alignment: Alignment.centerRight,
      //         child: FloatingActionButton(
      //           onPressed: () {
      //             setState(() {
      //               select = false;
      //             });
      //           },
      //           child: const Icon(
      //               Icons.clear), // You can change the icon as needed
      //         ),
      //       ),
      //     ),
      //     SizedBox(height: 2.h),
      //     Visibility(
      //       visible: select,
      //       child: Align(
      //         alignment: Alignment.centerRight,
      //         child: FloatingActionButton(
      //           foregroundColor: Colors.white,
      //           backgroundColor: const Color.fromARGB(255, 221, 42, 30),
      //           onPressed: () {
      //             if (selectedMeds.isEmpty) {
      //               Get.snackbar(
      //                 'Error',
      //                 'No med selected',
      //                 snackPosition: SnackPosition.BOTTOM,
      //                 colorText: Colors.white,
      //                 backgroundColor: Colors.orange,
      //               );
      //               return;
      //             }
      //             showDialog(
      //               context: context,
      //               builder: (context) {
      //                 return AlertDialog(
      //                   title: Text(
      //                     'Delete ${selectedMeds.length} meds?',
      //                     style: TextStyle(
      //                       fontSize: 16.sp,
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //                   ),
      //                   content: Text(
      //                     'Are you sure you want to delete these meds?',
      //                     style: TextStyle(
      //                       fontSize: 14.sp,
      //                     ),
      //                   ),
      //                   actions: [
      //                     TextButton(
      //                       onPressed: () {
      //                         Navigator.pop(context);
      //                       },
      //                       child: Text(
      //                         'Cancel',
      //                         style: TextStyle(
      //                           fontSize: 14.sp,
      //                           fontWeight: FontWeight.bold,
      //                         ),
      //                       ),
      //                     ),
      //                     Consumer(
      //                       builder: (context, ref, _) {
      //                         final userResult = ref.watch(medProvider);
      //                         // ref.refresh(notesProvider);
      //                         return userResult.when(
      //                             data: (notes) {
      //                               return TextButton(
      //                                 onPressed: () async {
      //                                   await Med().deleteMultipleMeds(
      //                                     context,
      //                                     selectedMeds,
      //                                   );
      //                                   setState(() {
      //                                     select = false;
      //                                   });
      //                                   ref.refresh(medProvider);
      //                                   ref.refresh(pendingMedProvider);
      //                                   ref.refresh(takenMedProvider);
      //                                   selectedMeds.clear();
      //                                   // ignore: use_build_context_synchronously
      //                                   Navigator.pop(context);
      //                                 },
      //                                 child: Text(
      //                                   'Delete',
      //                                   style: TextStyle(
      //                                     fontSize: 14.sp,
      //                                     fontWeight: FontWeight.bold,
      //                                   ),
      //                                 ),
      //                               );
      //                             },
      //                             loading: () => const Text("..."),
      //                             error: (error, stackTrace) {
      //                               print('Error: $error');
      //                               return Text('Error: $error');
      //                             });
      //                       },
      //                     ),
      //                   ],
      //                 );
      //               },
      //             );
      //           },
      //           child: const Icon(
      //             Icons.delete_rounded,
      //           ), // You can change the icon as needed
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
