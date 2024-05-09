import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_machine_test/Constant/Colors.dart';
import 'package:flutter_machine_test/widgets/Apptext.dart';
import 'package:flutter_machine_test/widgets/Textformfield.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class Homeee extends StatefulWidget {
  const Homeee({Key? key});

  @override
  State<Homeee> createState() => _HomeeeState();
}

class _HomeeeState extends State<Homeee> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  String imageUrl = '';

  late CollectionReference _items;
  late Query _query;

  late ScrollController _scrollController;
  bool _loading = false;
  List<DocumentSnapshot> _data = [];
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _items = FirebaseFirestore.instance.collection("Upload_Items");
    _query = _items.orderBy('name');
    _scrollController = ScrollController()..addListener(_scrollListener);
    _loadData();
  }

  void _scrollListener() {
    if (!_loading && _scrollController.position.extentAfter < 500 && _hasMore) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    QuerySnapshot querySnapshot;

    if (_data.isNotEmpty) {
      querySnapshot = await _query
          .startAfterDocument(_data[_data.length - 1])
          .limit(10)
          .get();
    } else {
      querySnapshot = await _query.limit(10).get();
    }

    if (querySnapshot.docs.length < 10) {
      _hasMore = false;
    }

    setState(() {
      _loading = false;
      _data.addAll(querySnapshot.docs);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: black,
        title: Row(
          children: [
            Icon(
              Icons.location_pin,
              color: white,
            ),
            AppText(
              text: " Nilambur",
              size: 18,
              weight: FontWeight.w400,
              textcolor: white,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: _showBottomSheet,
              icon: Icon(
                Icons.filter_list,
                color: white,
              ),
            ),
          ),
        ],
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _query = _items
                      .orderBy('name')
                      .startAt([value]).endAt([value + '\uf8ff']);
                  _data.clear();
                  _hasMore = true;
                  _loadData();
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(90),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(90),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(90),
                ),
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: AppText(
              text: "Users lists",
              size: 18,
              weight: FontWeight.w500,
              textcolor: black,
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _data.length + (_hasMore ? 1 : 0),
              itemBuilder: (BuildContext context, int index) {
                if (index < _data.length) {
                  return _buildListItem(index);
                } else {
                  return _buildLoader();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(90)),
        onPressed: () {
          _create();
        },
        backgroundColor: black,
        child: Icon(
          Icons.add,
          color: white,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildListItem(int index) {
    Map thisItems = _data[index].data() as Map;
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 5.0,
              offset: const Offset(1.1, 1.1),
            ),
          ],
        ),
        child: Center(
          child: ListTile(
            title: AppText(
              text: "${thisItems['name']}",
              size: 18,
              weight: FontWeight.w500,
              textcolor: black,
            ),
            subtitle: AppText(
              text: "Age : ${thisItems['number']}",
              size: 16,
              weight: FontWeight.w400,
              textcolor: black,
            ),
            leading: CircleAvatar(
              radius: 27,
              child: thisItems.containsKey('image')
                  ? ClipOval(
                      child: Image.network(
                        "${thisItems['image']}",
                        fit: BoxFit.cover,
                        height: 70,
                        width: 70,
                      ),
                    )
                  : const CircleAvatar(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoader() {
    return _loading
        ? Center(child: CircularProgressIndicator())
        : SizedBox.shrink();
  }

  String _imageUrl = '';

  bool? _above60Selected;
  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: "    Sort",
                  size: 20,
                  weight: FontWeight.bold,
                  textcolor: black,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  children: [
                    Radio(
                      value: null,
                      groupValue: _above60Selected,
                      onChanged: (value) {
                        setState(() {
                          _above60Selected = value as bool?;
                          _query = _items.orderBy('name');
                          _data.clear();
                          _hasMore = true;
                          _loadData();
                        });
                      },
                    ),
                    AppText(
                      text: "All",
                      size: 18,
                      weight: FontWeight.w400,
                      textcolor: black,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: true,
                      groupValue: _above60Selected,
                      onChanged: (value) {
                        setState(() {
                          _above60Selected = value as bool?;
                          _query = _items.where('number', isGreaterThan: 60);
                          _data.clear();
                          _hasMore = true;
                          _loadData();
                        });
                      },
                    ),
                    AppText(
                      text: "Age : Elder",
                      size: 18,
                      weight: FontWeight.w400,
                      textcolor: black,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: false,
                      groupValue: _above60Selected,
                      onChanged: (value) {
                        setState(() {
                          _above60Selected = value as bool?;
                          _query =
                              _items.where('number', isLessThanOrEqualTo: 60);
                          _data.clear();
                          _hasMore = true;
                          _loadData();
                        });
                      },
                    ),
                    AppText(
                      text: "Age : Younger",
                      size: 18,
                      weight: FontWeight.w400,
                      textcolor: black,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
              top: 20,
              right: 20,
              left: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                  text: "Add A New User",
                  size: 18,
                  weight: FontWeight.w500,
                  textcolor: black),
              SizedBox(
                height: 20.h,
              ),
              Center(
                  child: IconButton(
                      onPressed: () async {
                        final file = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (file == null) return;

                        String fileName =
                            DateTime.now().microsecondsSinceEpoch.toString();

                        Reference referenceRoot =
                            FirebaseStorage.instance.ref();
                        Reference referenceDireImages =
                            referenceRoot.child('images');
                        Reference referenceImageaToUpload =
                            referenceDireImages.child(fileName);

                        try {
                          await referenceImageaToUpload
                              .putFile(File(file.path));

                          imageUrl =
                              await referenceImageaToUpload.getDownloadURL();
                        } catch (error) {}
                      },
                      icon: const Icon(Icons.camera_alt))),

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
                  controller: _nameController,
                  keybordType: TextInputType.name),
              SizedBox(
                height: 10.h,
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
                  controller: _numberController,
                  keybordType: TextInputType.phone),
              const SizedBox(
                height: 10,
              ),
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
                    onTap: () async {
                      final String name = _nameController.text;
                      final int? number = int.tryParse(_numberController.text);
                      if (number != null) {
                        await _items.add({
                          "name": name,
                          "number": number,
                          "image": _imageUrl,
                        });
                        _nameController.text = '';
                        _numberController.text = '';
                        Navigator.of(context).pop();
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
        );
      },
    );
  }
}
