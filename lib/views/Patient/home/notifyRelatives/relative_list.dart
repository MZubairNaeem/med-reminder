import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:medreminder/constants/colors/colors.dart';
import 'package:medreminder/controllers/providers/relative_list_provider.dart';
import 'package:medreminder/controllers/services/relative_controller.dart';
import 'package:medreminder/views/Patient/home/notifyRelatives/search_relative.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NotifyRelativeList extends StatefulWidget {
  const NotifyRelativeList({super.key});

  @override
  State<NotifyRelativeList> createState() => _NotifyRelativeListState();
}

class _NotifyRelativeListState extends State<NotifyRelativeList> {
  final searchController = TextEditingController();
  bool load = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: secondary,
          title: const Text(
            "Relatives List",
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SearchRelative())),
              child: Container(
                height: 6.h,
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: gray3,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 5.w,
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: secondary,
                      ),
                      Text('Search'),
                    ],
                  ),
                ),
              ),
            ),
            Consumer(
              builder: (context, ref, _) {
                final userResult = ref.watch(relativelist);
                ref.refresh(relativelist);

                return userResult.when(
                    data: (relative) {
                      return relative.isEmpty
                          ? Center(
                              child: Text(
                                '-- You have no relative added yet --',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                itemCount: relative.length,
                                padding: EdgeInsets.only(left: 2.w, right: 2.w),
                                itemBuilder: (context, index) {
                                  return load
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            color: secondary,
                                          ),
                                        )
                                      : Slidable(
                                          endActionPane: ActionPane(
                                              motion: const StretchMotion(),
                                              children: [
                                                SlidableAction(
                                                  label: 'Remove',
                                                  backgroundColor: secondary,
                                                  onPressed: (value) async {
                                                    // setState(() {
                                                    //   load = true;
                                                    // });
                                                    var result;
                                                    result = await Relative()
                                                        .deleteRelative(
                                                            context,
                                                            relative[index]
                                                                .phone!);
                                                    print(result);
                                                    // setState(() {
                                                    //   load = false;
                                                    // });
                                                  },
                                                  icon: Icons
                                                      .delete_forever_rounded,
                                                  foregroundColor: white,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                )
                                              ]),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 1.w,
                                            ),
                                            child: Card(
                                              elevation: 5,
                                              child: ListTile(
                                                leading: const CircleAvatar(
                                                  backgroundColor: secondary,
                                                  child: Icon(
                                                    Icons.person,
                                                    color: white,
                                                  ),
                                                ),
                                                title: Text(
                                                  relative[index].phone!,
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                subtitle: StreamBuilder(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .where('uid',
                                                          isEqualTo:
                                                              relative[index]
                                                                  .uid)
                                                      .snapshots(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      return Text(
                                                        //user name
                                                        'Username: ${snapshot.data!.docs[0]['username']}',
                                                        style: TextStyle(
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: secondary),
                                                      );
                                                    } else {
                                                      return const Text("...");
                                                    }
                                                  },
                                                ),
                                                trailing: Text(
                                                  '<- Swipe to remove',
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                },
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
        ),
      ),
    );
  }
}
