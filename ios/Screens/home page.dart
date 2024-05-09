import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_machine_test/Constant/Colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/Apptext.dart';
import 'Add new user.dart';

class Home_Sreen extends StatefulWidget {
  Home_Sreen({Key? key});

  @override
  State<Home_Sreen> createState() => _Home_SreenState();
}

class _Home_SreenState extends State<Home_Sreen> {
  var searchName = "";
  bool sortByAgeAscending = true; // Default sort order

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CircleAvatar(
        backgroundColor: Colors.black,
        radius: 35.r,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Add_User(),
              ),
            );
          },
          backgroundColor: black,
          child: Icon(
            Icons.add,
            color: white,
            size: 30,
          ),
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: SizedBox(
          height: 40,
          child: TextField(
            onChanged: (value) {
              setState(() {
                searchName = value;
              });
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(90),
                    borderSide: BorderSide.none),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: black),
                  borderRadius: BorderRadius.circular(90),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: black),
                  borderRadius: BorderRadius.circular(90),
                ),
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                )),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Container(
              height: 40.h,
              width: 40.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: black),
              child: IconButton(
                  onPressed: () {
                    _showBottomSheet();
                  },
                  icon: Icon(
                    Icons.filter_list_rounded,
                    color: white,
                  )),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('User')
              .orderBy('Name')
              .startAt([searchName]).endAt([searchName + "\uf8ff"]).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            var users = snapshot.data!.docs;
            users.sort((a, b) {
              int ageA = int.parse(a['Age']);
              int ageB = int.parse(b['Age']);
              if (sortByAgeAscending) {
                return ageA.compareTo(ageB);
              } else {
                return ageB.compareTo(ageA);
              }
            });

            return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  var data = users[index];
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Container(
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 5.0,
                              offset: const Offset(0.0, 5.0)),
                        ],
                      ),
                      child: Center(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Image.network(
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShB7IwN9gr4q2Tn-1CRfbgANRN-8SWlYMMy9iq467T1A&s"),
                            radius: 30,
                          ),
                          title: AppText(
                            text: data['Name'],
                            size: 18,
                            weight: FontWeight.w500,
                            textcolor: black,
                          ),
                          subtitle: AppText(
                            text: "Age : ${data['Age']}",
                            size: 16,
                            weight: FontWeight.w400,
                            textcolor: black,
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          // Adjust the height of the bottom sheet as needed
          height: 230,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: "Sort",
                  size: 20,
                  weight: FontWeight.bold,
                  textcolor: black,
                ),
                InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.circle_outlined),
                      ),
                      AppText(
                        text: "All",
                        size: 18,
                        weight: FontWeight.w400,
                        textcolor: black,
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      sortByAgeAscending = !sortByAgeAscending;
                    });
                  },
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.circle_outlined),
                      ),
                      AppText(
                        text: "Age : Elder",
                        size: 18,
                        weight: FontWeight.w400,
                        textcolor: black,
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      sortByAgeAscending = !sortByAgeAscending;
                    });
                  },
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.circle_outlined),
                      ),
                      AppText(
                        text: "Age : Younger",
                        size: 18,
                        weight: FontWeight.w400,
                        textcolor: black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
