import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:medreminder/models/med_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MissedMedicine extends StatefulWidget {
  MedModel medModel;
  MissedMedicine({Key? key, required this.medModel}) : super(key: key);

  @override
  State<MissedMedicine> createState() => _MedicineListState();
}

class _MedicineListState extends State<MissedMedicine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('medSchedule')
            .doc(widget.medModel.id)
            .collection('intervals')
            .where('status', isEqualTo: false)
            .where('time', isLessThanOrEqualTo: DateTime.now())
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
    );
  }
}
