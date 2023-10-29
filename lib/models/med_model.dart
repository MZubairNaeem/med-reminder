import 'package:cloud_firestore/cloud_firestore.dart';

class MedModel {
  String? medName;
  String? medType;
  Timestamp? medCreated;
  Timestamp? startTimeDate;
  String? dosageQuantity;
  String? interval;
  String? quantity;
  bool? status;
  String? id;
  String? uid;
  Timestamp? time;

  MedModel({
    this.medName,
    this.medType,
    this.medCreated,
    this.startTimeDate,
    this.dosageQuantity,
    this.interval,
    this.quantity,
    this.status,
    this.id,
    this.uid,
this.time,
  });

  MedModel.fromJson(Map<String, dynamic> json) {
    medName = json['medName'];
    medType = json['medType'];
    medCreated = json['medCreated'];
    startTimeDate = json['startTimeDate'];

    dosageQuantity = json['dosageQuantity'];

    interval = json['interval'];
    quantity = json['quantity'];
    status = json['status'];
    id = json['id'];
    uid = json['uid'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['medName'] = medName;
    data['medType'] = medType;
    data['medCreated'] = medCreated;
    data['startTimeDate'] = startTimeDate;
    data['dosageQuantity'] = dosageQuantity;
    data['interval'] = interval;
    data['quantity'] = quantity;
    data['status'] = status;
    data['id'] = id;
    data['uid'] = uid;
    data['time'] = time;
    return data;
  }
}
