import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Constant/Colors.dart';
import '../widgets/Apptext.dart';
import '../widgets/Textformfield.dart';

class Add_User extends StatefulWidget {
  const Add_User({super.key});

  @override
  State<Add_User> createState() => _Add_UserState();
}

class _Add_UserState extends State<Add_User> {
  final _formfield = GlobalKey<FormState>();

  final entername = TextEditingController();
  final enterage = TextEditingController();

  Future<dynamic> userdetails() async {
    await FirebaseFirestore.instance.collection('User').add({
      "Name": entername.text,
      "Age": enterage.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          backgroundColor: white,
          surfaceTintColor: white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: black,
            ),
          ),
          title: AppText(
              text: "Add A New User",
              size: 20,
              weight: FontWeight.bold,
              textcolor: black),
        ),
        body: Form(
          key: _formfield,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 35.r,
                    child: Image.network(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShB7IwN9gr4q2Tn-1CRfbgANRN-8SWlYMMy9iq467T1A&s"),
                  ),
                ),
                AppText(
                    text: "Name",
                    size: 16,
                    weight: FontWeight.w500,
                    textcolor: Colors.grey),
                SizedBox(
                  height: 5.h,
                ),
                AppTextForm(
                    vertical: 10,
                    horizontal: 15,
                    hintText: '',
                    weight: FontWeight.w400,
                    size: 14,
                    textcolor: black,
                    focusColor: black,
                    enableColor: grey,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Name";
                      }
                    },
                    controller: entername,
                    keybordType: TextInputType.name),
                SizedBox(
                  height: 20.h,
                ),
                AppText(
                    text: "Age",
                    size: 16,
                    weight: FontWeight.w500,
                    textcolor: Colors.grey),
                SizedBox(
                  height: 5.h,
                ),
                AppTextForm(
                    vertical: 5,
                    horizontal: 15,
                    hintText: '',
                    weight: FontWeight.w400,
                    size: 14,
                    textcolor: black,
                    focusColor: black,
                    enableColor: grey,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Age";
                      }
                    },
                    controller: enterage,
                    keybordType: TextInputType.phone),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 40.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade300),
                        child: Center(
                          child: AppText(
                              text: "Cancel",
                              size: 14,
                              weight: FontWeight.w500,
                              textcolor: Colors.grey.shade700),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    InkWell(
                      onTap: () {
                        if (_formfield.currentState!.validate()) {
                          userdetails();
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        height: 40.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue.shade700),
                        child: Center(
                          child: AppText(
                              text: "Save",
                              size: 16,
                              weight: FontWeight.w500,
                              textcolor: white),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
