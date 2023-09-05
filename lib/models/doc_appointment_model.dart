import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  String? hospitalName;
  String? doctorName;
  Timestamp? appointmentDateTime;
  String? note;
  String? visitReason;
  // String? prescription;
  bool? status;
  String? id;
  String? uid;

  AppointmentModel(
      {this.hospitalName,
      this.doctorName,
      this.appointmentDateTime,
      this.visitReason,
      // this.prescription,
      this.note,
      this.id,
      this.uid,
      this.status});

  AppointmentModel.fromJson(Map<String, dynamic> json) {
    hospitalName = json['hospitalName'];
    doctorName = json['doctorName'];
    appointmentDateTime = json['appointmentDateTime'];
    visitReason = json['visitReason'];
    // prescription = json['prescription'];
    note = json['note'];
    id = json['id'];
    uid = json['uid'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hospitalName'] = hospitalName;
    data['doctorName'] = doctorName;
    data['appointmentDateTime'] = appointmentDateTime;
    data['id'] = id;
    data['visitReason'] = visitReason;
    // data['prescription'] = prescription;
    data['note'] = note;
    data['uid'] = uid;
    data['status'] = status;
    return data;
  }
}
