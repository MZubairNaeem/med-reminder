import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:medreminder/controllers/services/relative_controller.dart';
import 'package:medreminder/models/user_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SearchRelative extends StatefulWidget {
  const SearchRelative({super.key});

  @override
  State<SearchRelative> createState() => _SearchRelativeState();
}

class _SearchRelativeState extends State<SearchRelative> {
  final searchController = TextEditingController();
  bool load = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: secondary,
          title: const Text(
            "Relatives List",
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(10.sp),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search",
                  fillColor: secondary,
                  focusColor: secondary,
                  // hintStyle: TextStyle(color: AppColors().darKShadowColor),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: secondary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: secondary, width: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // maximumSize: Size(size.width * 0.1, size.height * 0.04),
                  backgroundColor: secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                  setState(() {});
                },
                child: const Text("Search"),
              ),
              SizedBox(
                height: 5.h,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('phone',
                        isGreaterThanOrEqualTo: searchController.text.trim())
                    .where("phone",
                        isNotEqualTo: FirebaseAuth.instance.currentUser!.phoneNumber)
                        
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot? dataSnapshot = snapshot.data;
                      if (dataSnapshot!.docs.isNotEmpty) {
                        Map<String, dynamic>? userMap = dataSnapshot.docs.first
                            .data() as Map<String, dynamic>?;
                        UserModel searchUser = UserModel.fromMap(userMap!);
                        return load
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: secondary,
                                ),
                              )
                            : Card(
                                elevation: 2,
                                // shadowColor: AppColors().primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ListTile(
                                  onTap: () async {
                                    setState(() {
                                      load = true;
                                      //1 second delay
                                      Future.delayed(const Duration(seconds: 1),
                                          () {
                                        setState(() {
                                          load = false;
                                        });
                                      });
                                    });
                                    Relative().addRelative(context,
                                        searchUser.phone!, searchUser.uid!);
                                  },
                                  title: Text(searchUser.phone!),
                                  trailing: Container(
                                    decoration: const BoxDecoration(
                                      color: secondary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: white,
                                    ),
                                  ),
                                ),
                              );
                      } else {
                        return const Center(child: Text("No Results Found"));
                      }
                    } else if (snapshot.hasError) {
                      return const Center(child: Text("An Error Occured"));
                    } else {
                      return const Center(child: Text("No Results Found"));
                    }
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
