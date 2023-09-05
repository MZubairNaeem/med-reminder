import 'package:cloud_firestore/cloud_firestore.dart';

class NotesModel {
  String? title;
  String? description;
  Timestamp? timestamp;
  bool? status;
  String? id;
  String? uid;

  NotesModel({this.title, this.description, this.timestamp, this.id, this.uid , this.status});

  NotesModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    timestamp = json['timestamp'];
    id = json['id'];
    uid = json['uid'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['timestamp'] = timestamp;
    data['id'] = id;
    data['uid'] = uid;
    data['status'] = status;
    return data;
  }
}
