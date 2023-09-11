import 'package:cloud_firestore/cloud_firestore.dart';

class MedModel {
  String? medName;
  String? medType;
  Timestamp? medCreated;
  Timestamp? startTimeDate;
  String? dosageQuantity;
  String? interval;
  bool? status;
  String? id;
  String? uid;

  MedModel({
    this.medName,
    this.medType,
    this.medCreated,
    this.startTimeDate,
    this.dosageQuantity,
    this.interval,
    this.status,
    this.id,
    this.uid,
  });

  MedModel.fromJson(Map<String, dynamic> json) {
    medName = json['medName'];
    medType = json['medType'];
    medCreated = json['medCreated'];
    startTimeDate = json['startTimeDate'];

    dosageQuantity = json['dosageQuantity'];
    interval = json['interval'];
    status = json['status'];
    id = json['id'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['medName'] = medName;
    data['medType'] = medType;
    data['medCreated'] = medCreated;
    data['startTimeDate'] = startTimeDate;
    data['dosageQuantity'] = dosageQuantity;
    data['interval'] = interval;
    data['status'] = status;
    data['id'] = id;
    data['uid'] = uid;
    return data;
  }
}
