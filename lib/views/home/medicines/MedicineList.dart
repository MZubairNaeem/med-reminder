import 'package:flutter/material.dart';
import 'package:medreminder/views/home/medicines/MedicineSchedule.dart';

class MedicineList extends StatefulWidget {
  const MedicineList({super.key});

  @override
  State<MedicineList> createState() => _MedicineListState();
}

class _MedicineListState extends State<MedicineList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Medicine Schedule"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to MedicineList screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MedicineSchedule()),
          );
        },
        child: Icon(Icons.add),
      ),
      body: Column(),
    );
  }
}
