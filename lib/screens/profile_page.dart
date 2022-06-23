import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:doctor_app_connect/Widgets/drconnect_background.dart';
import 'package:doctor_app_connect/screens/home_page.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../Common/color_select.dart';
import '../Common/urls.dart';
import '../Models/location_modal.dart';
import 'custom_dropdown.dart';
import 'package:intl/intl.dart' as intl;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  String? dropdownvalue;
  var uuid = const Uuid();

  LocationModel? locationData;

  String? token;
  String? isRegistered;
  String? number;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final experienceController = TextEditingController();
  final mciMumberController = TextEditingController();
  final phoneController = TextEditingController();
  final yearController = TextEditingController();
  final emailController = TextEditingController();
  final aboutController = TextEditingController();
  final addressLineOneController = TextEditingController();
  final addressLineTwoController = TextEditingController();
  final addressLandmarkController = TextEditingController();
  final pincodeController = TextEditingController();
  final locationController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  // FocusNode firstNameFn = FocusNode();
  // FocusNode lastNameFn = FocusNode();
  // FocusNode expeFn = FocusNode();
  // FocusNode mciFn = FocusNode();
  // FocusNode yearFn = FocusNode();
  // FocusNode phoneFn = FocusNode();
  // FocusNode emailFn = FocusNode();
  // FocusNode line1Fn = FocusNode();
  // FocusNode line2Fn = FocusNode();
  // FocusNode line3Fn = FocusNode();
  // FocusNode pincodeFn = FocusNode();
  // FocusNode cityFn = FocusNode();
  // FocusNode stateFn = FocusNode();
  // FocusNode countryFn = FocusNode();

  final ImagePicker _picker = ImagePicker();
  File? displayFileImage;
  String imageUrl = "";

  List _myDegrees = [];
  List _mySpecialization = [];
  String? _myMci;

  String? specialization = "new special";
  String? experienceYear;

  var degreeList = [];
  var councilList = [];
  var departmentList = [];
  bool isLoading = true;
  bool enableTextFieldPhone = true;
  bool enableTextFieldcountry = false;
  bool enableTextFieldstate = true;

  @override
  void initState() {
    super.initState();
    countryController.text = "India";

    getSharedPrefs();
    apiFetchParallel();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    experienceController.dispose();
    mciMumberController.dispose();
    phoneController.dispose();
    yearController.dispose();
    emailController.dispose();
    addressLineOneController.dispose();
    addressLineTwoController.dispose();
    addressLandmarkController.dispose();
    pincodeController.dispose();
    locationController.dispose();
    stateController.dispose();
    countryController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String currentYear = intl.DateFormat('yyyy').format(now);

    return WillPopScope(
        onWillPop: () {
          log('message 1');
          getSharedPrefs();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const HomePage()), // this mymainpage is your page to refresh
            (Route<dynamic> route) => false,
          );

          return Future.value(false);
        },
        child: DrConnectBackground(
            child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              "Profile",
              style: TextStyle(color: ColorSelect.secondary),
            ),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: ColorSelect.secondary),
          ),
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Form(
                  key: _formKey,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: Column(children: <Widget>[
                          Center(
                            child: GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                      width: 1, color: ColorSelect.secondary),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.withOpacity(0.5),
                                      spreadRadius: 3,
                                      blurRadius: 10,
                                      offset: const Offset(
                                          0, 0), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: profilePictureView(token!)),
                              ),
                              onTap: () {
                                Get.bottomSheet(Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.white,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(20.0),
                                          bottomRight: Radius.circular(0),
                                          topLeft: Radius.circular(20.0),
                                          bottomLeft: Radius.circular(0))),
                                  height: 150,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                final XFile? pickedFile =
                                                    await _picker.pickImage(
                                                        source:
                                                            ImageSource.camera);
                                                Navigator.pop(context);
                                                if (pickedFile != null) {
                                                  setState(() {
                                                    displayFileImage =
                                                        File(pickedFile.path);
                                                  });
                                                }
                                              },
                                              child: Column(
                                                children: [
                                                  Image.asset(
                                                    'assets/images/camera.png',
                                                    width: 50,
                                                    height: 50,
                                                  ),
                                                  const Text("Camera")
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                final XFile? pickedFile =
                                                    await _picker.pickImage(
                                                        source: ImageSource
                                                            .gallery);
                                                Navigator.pop(context);
                                                if (pickedFile != null) {
                                                  setState(() {
                                                    displayFileImage =
                                                        File(pickedFile.path);
                                                  });
                                                }
                                              },
                                              child: Column(
                                                children: [
                                                  Image.asset(
                                                    'assets/images/gallery.png',
                                                    width: 50,
                                                    height: 50,
                                                  ),
                                                  const Text("Gallery")
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 12, bottom: 25),
                            width: MediaQuery.of(context).size.width,
                            color: ColorSelect.secondary,
                            height: 40,
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                "Personal Details",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: TextFormField(
                                      // inputFormatters: [
                                      //   // only accept letters from a to z
                                      //   FilteringTextInputFormatter(
                                      //       RegExp(r'[a-zA-Z]'),
                                      //       allow: true)
                                      // ],
                                      controller: firstNameController,
                                      // onChanged: (_) {
                                      //   _formKey.currentState!.validate();
                                      // },
                                      validator: (text) {
                                        if (text == null || text.isEmpty) {
                                          // firstNameFn.requestFocus();
                                          return 'First name is empty';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'First name *',
                                        suffixText: '*',
                                        suffixStyle: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        enabledBorder: OutlineInputBorder(
                                          //borderRadius: BorderRadius.circular(25.0),
                                          borderSide: BorderSide(
                                            color: ColorSelect.secondary,
                                            width: 1.0,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ColorSelect.primary)),
                                        hintStyle: const TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                        border: const OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: TextFormField(
                                      // inputFormatters: [
                                      //   // only accept letters from a to z
                                      //   FilteringTextInputFormatter(
                                      //       RegExp(r'[a-zA-Z]'),
                                      //       allow: true)
                                      // ],
                                      controller: lastNameController,
                                      // onChanged: (_) {
                                      //   _formKey.currentState!.validate();
                                      // },
                                      validator: (text) {
                                        if (text == null || text.isEmpty) {
                                          // lastNameFn.requestFocus();
                                          return 'Last name is empty';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Last name *',
                                        suffixText: '*',
                                        suffixStyle: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: ColorSelect.secondary,
                                            width: 1.0,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ColorSelect.primary)),
                                        hintStyle: const TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                        border: const OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8),
                            child: Container(
                              padding: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: ColorSelect.secondary),
                                  borderRadius: BorderRadius.circular(5)),
                              child: DropdownButtonHideUnderline(
                                child: MultiSelectFormField(
                                  //  maxLength: 5,
                                  //  filterable: true,
                                  // required: true,
                                  validator: (value) {
                                    if (value == null || value.length == 0) {
                                      return 'Please select one or more options';
                                    } else if (value.length > 5) {
                                      return 'Please select up to 5 options';
                                    }

                                    return null;
                                  },
                                  autovalidate:
                                      AutovalidateMode.onUserInteraction,
                                  chipBackGroundColor: ColorSelect.secondary,
                                  chipLabelStyle:
                                      const TextStyle(color: Colors.white),
                                  checkBoxActiveColor: ColorSelect.secondary,
                                  checkBoxCheckColor: Colors.white,
                                  dialogShapeBorder:
                                      const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.0)),
                                  ),
                                  title: const Text(
                                    "Degree *(max selection 5)",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  dataSource: degreeList,
                                  textField: 'name',
                                  valueField: 'id',
                                  okButtonLabel: 'OK',
                                  cancelButtonLabel: 'CANCEL',
                                  initialValue: _myDegrees,
                                  onSaved: (value) {
                                    if (value == null) return;
                                    setState(() {
                                      _myDegrees = value;
                                    });
                                    log("selectedOnes: " +
                                        _myDegrees.toString());
                                  },
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8),
                            child: Container(
                              padding: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: ColorSelect.secondary),
                                  borderRadius: BorderRadius.circular(5)),
                              child: MultiSelectFormField(
                                validator: (value) {
                                  if (value == null || value.length == 0) {
                                    return 'Please select one or more options';
                                  } else if (value.length > 3) {
                                    return 'Please select up to 3 options';
                                  }

                                  return null;
                                },
                                autovalidate:
                                    AutovalidateMode.onUserInteraction,
                                chipBackGroundColor: ColorSelect.secondary,
                                chipLabelStyle:
                                    const TextStyle(color: Colors.white),
                                checkBoxActiveColor: ColorSelect.secondary,
                                checkBoxCheckColor: Colors.white,
                                dialogShapeBorder: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                ),
                                title: const Text(
                                  "Specialization *(max selection 3)",
                                  style: TextStyle(fontSize: 14),
                                ),
                                dataSource: departmentList,
                                textField: 'name',
                                valueField: 'id',
                                okButtonLabel: 'OK',
                                cancelButtonLabel: 'CANCEL',
                                initialValue: _mySpecialization,
                                onSaved: (value) {
                                  if (value == null) return;
                                  setState(() {
                                    _mySpecialization = value;
                                  });
                                  log("selectedOnes: " +
                                      _mySpecialization.toString());
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8),
                            child: TextFormField(
                              controller: experienceController,
                              //  focusNode: expeFn,
                              // onChanged: (_) {
                              //   _formKey.currentState!.validate();
                              // },
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  // expeFn.requestFocus();
                                  return 'Experience is empty';
                                } else if (int.parse(text) > 50) {
                                  return 'Experience cannot be more than 50 yrs';
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Experience',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: ColorSelect.secondary,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: ColorSelect.primary)),
                                hintStyle: const TextStyle(
                                    fontSize: 16, color: Colors.grey),
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              // padding: const EdgeInsets.all(1),
                              // decoration: BoxDecoration(
                              //     border: Border.all(color: ColorSelect.secondary),
                              //     borderRadius: BorderRadius.circular(5)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  isExpanded: true,
                                  hint: Row(
                                    children: const [
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Select Council',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  items: councilList
                                      .map((list) => DropdownMenuItem<String>(
                                            value: list,
                                            child: Text(
                                              list,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                //fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ))
                                      .toList(),
                                  value: _myMci,
                                  onChanged: (value) {
                                    setState(() {
                                      _myMci = value as String;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                  ),
                                  iconSize: 25,
                                  iconEnabledColor: Colors.blue,
                                  iconDisabledColor: Colors.grey,
                                  buttonHeight: 65,
                                  buttonWidth: 200,
                                  buttonPadding: const EdgeInsets.only(
                                      left: 14, right: 14),
                                  buttonDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.blue,
                                    ),
                                    color: Colors.white,
                                  ),
                                  buttonElevation: 2,
                                  itemHeight: 40,
                                  itemPadding: const EdgeInsets.only(
                                      left: 14, right: 14),
                                  dropdownMaxHeight: 200,
                                  dropdownOverButton: false,
                                  //........dropdown width...............
                                  //dropdownWidth: 300,
                                  dropdownPadding: null,
                                  dropdownDecoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                        topLeft: Radius.circular(4),
                                        topRight: Radius.circular(4)),
                                    color: Colors.white,
                                  ),
                                  dropdownElevation: 8,
                                  scrollbarRadius: const Radius.circular(40),
                                  scrollbarThickness: 0,
                                  scrollbarAlwaysShow: false,
                                  offset: const Offset(1, 0),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: TextFormField(
                                      controller: mciMumberController,
                                      // focusNode: mciFn,
                                      keyboardType: TextInputType.number,
                                      // onChanged: (_) {
                                      //   _formKey.currentState!.validate();
                                      // },
                                      validator: (text) {
                                        if (text == null || text.isEmpty) {
                                          //  mciFn.requestFocus();
                                          return 'MCI number is empty';
                                        } else if (int.parse(text) == 000) {
                                          return 'Please enter valid MCI number';
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'MCI Number *',
                                        suffixText: '*',
                                        suffixStyle: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: ColorSelect.secondary,
                                            width: 1.0,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ColorSelect.primary)),
                                        hintStyle: const TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                        border: const OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: TextFormField(
                                      controller: yearController,
                                      //  focusNode: yearFn,
                                      keyboardType: TextInputType.number,
                                      // onChanged: (_) {
                                      //   _formKey.currentState!.validate();
                                      // },
                                      validator: (text) {
                                        if (text == null || text.isEmpty) {
                                          // yearFn.requestFocus();
                                          return 'Year is empty';
                                        } else if (text.length < 4) {
                                          return 'Year must have 4 digits';
                                        } else if (int.parse(text) >
                                            int.parse(currentYear)) {
                                          return 'Enter less than current year';
                                        } else {
                                          return null;
                                        }
                                      },
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]')),
                                        LengthLimitingTextInputFormatter(4),
                                      ],
                                      decoration: InputDecoration(
                                        labelText: 'Year *',
                                        suffixText: '*',
                                        suffixStyle: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.blue,
                                            width: 1.0,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ColorSelect.primary)),
                                        hintText: "ex-1990",
                                        hintStyle: const TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                        border: const OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: TextFormField(
                                      enabled: enableTextFieldPhone,
                                      // focusNode: phoneFn,
                                      controller: phoneController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        //_formKey.currentState!.validate();
                                        if (value.length == 10) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        }
                                      },
                                      validator: (text) {
                                        if (text == null || text.isEmpty) {
                                          //  phoneFn.requestFocus();
                                          return 'Mobile number is empty';
                                        } else if (text.length < 10) {
                                          return 'Enter valid mobile number';
                                        } else {
                                          return null;
                                        }
                                      },
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]')),
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      decoration: InputDecoration(
                                        labelText: 'Mobile No.',
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: ColorSelect.secondary,
                                            width: 1.0,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ColorSelect.primary)),
                                        hintStyle: const TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                        border: const OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: TextFormField(
                                      controller: emailController,
                                      //  focusNode: emailFn,
                                      // onChanged: (_) {
                                      //   _formKey.currentState!.validate();
                                      // },
                                      validator: (text) {
                                        if (text == null || text.isEmpty) {
                                          //   emailFn.requestFocus();
                                          return 'Email is empty';
                                        } else if (!RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(text)) {
                                          return 'Enter valid email';
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Email ID *',
                                        suffixText: '*',
                                        suffixStyle: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: ColorSelect.secondary,
                                            width: 1.0,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ColorSelect.primary)),
                                        hintStyle: const TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                        border: const OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8),
                            child: TextFormField(
                              controller: aboutController,
                              //  focusNode: expeFn,
                              // onChanged: (_) {s
                              //   _formKey.currentState!.validate();
                              // },
                              // validator: (text) {
                              //   if (text == null || text.isEmpty) {
                              //     // expeFn.requestFocus();
                              //     return 'Experience is empty';
                              //   } else if (int.parse(text) > 50) {
                              //     return 'Experience cannot be more than 50 yrs';
                              //   } else {
                              //     return null;
                              //   }
                              // },
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: InputDecoration(
                                labelText: 'About Doctor',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: ColorSelect.secondary,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: ColorSelect.primary)),
                                hintStyle: const TextStyle(
                                    fontSize: 16, color: Colors.grey),
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 12, bottom: 12),
                            width: MediaQuery.of(context).size.width,
                            color: ColorSelect.secondary,
                            height: 40,
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                "Address Details",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8.0),
                            child: TextFormField(
                              controller: addressLineOneController,
                              // inputFormatters: [
                              //   // only accept letters from a to z
                              //   FilteringTextInputFormatter(RegExp(r'[a-zA-Z]'),
                              //       allow: true)
                              // ],
                              // onChanged: (_) {
                              //   _formKey.currentState!.validate();
                              // },
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  //   line1Fn.requestFocus();
                                  return 'Line 1 is empty';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Line 1*',
                                suffixText: '*',
                                suffixStyle: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: ColorSelect.secondary,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: ColorSelect.primary)),
                                hintStyle: const TextStyle(
                                    fontSize: 16, color: Colors.grey),
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8),
                            child: TextFormField(
                              //  focusNode: line2Fn,
                              controller: addressLineTwoController,
                              // inputFormatters: [
                              //   // only accept letters from a to z
                              //   FilteringTextInputFormatter(RegExp(r'[a-zA-Z]'),
                              //       allow: true)
                              // ],
                              // onChanged: (_) {
                              //   _formKey.currentState!.validate();
                              // },
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  //  line2Fn.requestFocus();
                                  return 'Line 2 is empty';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Line 2*',
                                suffixText: '*',
                                suffixStyle: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: ColorSelect.secondary,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: ColorSelect.primary)),
                                hintStyle: const TextStyle(
                                    fontSize: 16, color: Colors.grey),
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8),
                            child: TextFormField(
                              // focusNode: line3Fn,
                              controller: addressLandmarkController,
                              keyboardType: TextInputType.text,
                              // onChanged: (_) {
                              //   _formKey.currentState!.validate();
                              // },
                              // validator: (text) {
                              //   if (text == null || text.isEmpty) {
                              //     // line3Fn.requestFocus();
                              //     return 'Line 3 is empty';
                              //   }
                              //   return null;
                              // },
                              decoration: InputDecoration(
                                labelText: 'Landmark',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: ColorSelect.secondary,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: ColorSelect.primary)),
                                hintStyle: const TextStyle(
                                    fontSize: 16, color: Colors.grey),
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: TextFormField(
                                      controller: pincodeController,
                                      //  focusNode: pincodeFn,
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        // _formKey.currentState!.validate();
                                        if (value.length == 6) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          _dialogPop();
                                        }
                                      },
                                      validator: (text) {
                                        if (text == null || text.isEmpty) {
                                          //   pincodeFn.requestFocus();
                                          return 'Pincode is empty';
                                        } else if (text.length < 6) {
                                          //   pincodeFn.requestFocus();
                                          return 'Enter valid Pincode';
                                        }
                                        return null;
                                      },
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]')),
                                        LengthLimitingTextInputFormatter(6),
                                      ],
                                      decoration: InputDecoration(
                                        labelText: 'Postal code *',
                                        suffixText: '*',
                                        suffixStyle: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: ColorSelect.secondary,
                                            width: 1.0,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ColorSelect.primary)),
                                        hintStyle: const TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                        border: const OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: TextFormField(
                                      //   focusNode: cityFn,
                                      controller: locationController,
                                      // onChanged: (_) {
                                      //   _formKey.currentState!.validate();
                                      // },
                                      validator: (text) {
                                        if (text == null || text.isEmpty) {
                                          //    cityFn.requestFocus();
                                          return 'Location is empty';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Location *',
                                        suffixText: '*',
                                        suffixStyle: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: ColorSelect.secondary,
                                            width: 1.0,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ColorSelect.primary)),
                                        hintStyle: const TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                        border: const OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: TextFormField(
                                      enabled: enableTextFieldstate,
                                      //   focusNode: stateFn,
                                      controller: stateController,
                                      // onChanged: (_) {
                                      //   _formKey.currentState!.validate();
                                      // },
                                      validator: (text) {
                                        if (text == null || text.isEmpty) {
                                          //      stateFn.requestFocus();
                                          return 'State is empty';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'State *',
                                        suffixText: '*',
                                        suffixStyle: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: ColorSelect.secondary,
                                            width: 1.0,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ColorSelect.primary)),
                                        hintStyle: const TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                        border: const OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: TextFormField(
                                      enabled: enableTextFieldcountry,
                                      //   focusNode: countryFn,
                                      controller: countryController,
                                      // onChanged: (_) {
                                      //   _formKey.currentState!.validate();
                                      // },
                                      validator: (text) {
                                        if (text == null || text.isEmpty) {
                                          //    countryFn.requestFocus();
                                          return 'Country is empty';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Country',
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: ColorSelect.secondary,
                                            width: 1.0,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ColorSelect.primary)),
                                        hintStyle: const TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                        border: const OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    ColorSelect.primary),
                                overlayColor:
                                    MaterialStateProperty.all(Colors.grey),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                                fixedSize: MaterialStateProperty.all(
                                  const Size(200, 40),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  if (_myMci == null) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text("Please select council"),
                                    ));
                                  } else {
                                    showLoaderDialog(context);
                                    if (displayFileImage == null) {
                                      postDataApi(imageUrl, context);
                                    } else {
                                      uploadImageApi(context);
                                    }
                                  }
                                }
                              },
                              child: const Text("Submit"),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
        )));
  }

  Widget profilePictureView(String token) {
    if (displayFileImage == null) {
      if (imageUrl == "") {
        return ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: const FadeInImage(
              height: 120.0,
              width: 120.0,
              fit: BoxFit.cover,
              placeholder: AssetImage("assets/images/drprofile.png"),
              image: AssetImage("assets/images/drprofile.png"),
            ));
      } else {
        return ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: FadeInImage(
              height: 120.0,
              width: 120.0,
              fit: BoxFit.cover,
              placeholder: const AssetImage("assets/images/drprofile.png"),
              image: NetworkImage(Api.getUploadImageApi + imageUrl,
                  headers: {"Authorization": "Bearer " + token}),
            ));
      }
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: Image.file(
          displayFileImage!,
          width: 120.0,
          height: 120.0,
          fit: BoxFit.cover,
        ),
      );
    }
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 30),
              child: const Text(
                "Updating...",
                style: TextStyle(fontSize: 15),
              )),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _dialogPop() {
    showDialog(
        context: this.context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: SizedBox(
              height: 350,
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                      margin: const EdgeInsets.only(top: 10),
                      height: 30,
                      //color: Colors.amber,
                      child: const Text(
                        "Choose Area",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                  FutureBuilder(
                    future: _locationApi(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      log("snapDataa: " + snapshot.data.toString());
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 280,
                          child: Center(
                              child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: CircularProgressIndicator())),
                        );
                      }

                      return SizedBox(
                        height: 280,
                        child: snapshot.data == null
                            ? const Center(child: Text("No Location Found!"))
                            : Scrollbar(
                                child: ListView.builder(
                                    itemCount: locationData!.data!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            6, 8, 6, 0),
                                        //height: 65,
                                        // decoration: BoxDecoration(
                                        //     color: ColorSelect.bluegrey100,
                                        //     borderRadius: BorderRadius.circular(12.0)),
                                        //color: Colors.white,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                            locationController.text =
                                                locationData!.data![index].area
                                                    .toString();
                                            stateController.text = locationData!
                                                .data![index].state
                                                .toString()
                                                .toLowerCase();
                                          },
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(left: 6),
                                            //padding: const EdgeInsets.all(4.0),
                                            width: 240,
                                            child: Column(
                                              textDirection: TextDirection.ltr,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  "Location : " +
                                                      locationData!
                                                          .data![index].area
                                                          .toString(),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color.fromARGB(
                                                          255, 81, 80, 80)),
                                                ),
                                                Text("State : " +
                                                    locationData!
                                                        .data![index].state
                                                        .toString()
                                                        .toLowerCase()),
                                                const Divider(
                                                    color: Colors.grey),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    })),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> getAllDegrees() async {
    // setState(() {
    //   isLoading = true;
    // });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    // List<User> users = [];

    Map<String, String> header = {
      "Accept": "*/*",
      "Authorization": "Bearer " + token
    };

    http.Response response = await http.get(
      Uri.parse(Api.getAllDegreesApi),
      headers: header,
    );
    if (response.body.isNotEmpty) {
      var jsonResponse = json.decode(response.body);
      // print('Responseee: ' + jsonResponse.toString());

      for (var i in jsonResponse) {
        // var id = i["id"];
        var name = i["name"];

        Map<String, String> list = {
          "name": name,
          "id": name,
        };

        degreeList.add(list);
      }
      //  print("DegreeData: " + degreeList.toString());
      getAllCouncil();
    }
    //  Utility.closeDialog();
    // setState(() {
    //   isLoading = false;
    // });
  }

  Future<void> getAllCouncil() async {
    var councilnamelist = [];

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    Map<String, String> header = {
      "Accept": "*/*",
      "Authorization": "Bearer " + token
    };

    http.Response response = await http.get(
      Uri.parse(Api.getAllCouncilApi),
      headers: header,
    );
    if (response.body.isNotEmpty) {
      var jsonResponse = json.decode(response.body);

      for (var i in jsonResponse) {
        // var id = i["id"];
        var name = i["name"];

        councilnamelist.add(name);
      }
      setState(() {
        councilList = councilnamelist;
      });
      // print("CouncilData: " + councilList.toString());
    }
  }

  Future<void> getAllDepartment() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    Map<String, String> header = {
      "Accept": "*/*",
      "Authorization": "Bearer " + token
    };

    http.Response response = await http.get(
      Uri.parse(Api.getAllDepartmentApi),
      headers: header,
    );
    if (response.body.isNotEmpty) {
      var jsonResponse = json.decode(response.body);

      for (var i in jsonResponse) {
        // var id = i["id"];
        var name = i["name"];

        Map<String, String> list = {
          "name": name,
          "id": name,
        };

        departmentList.add(list);
      }

      // print("DepartmentData: " + departmentList.toString());
    }
  }

  Future<void> getUserProfile() async {
    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final userId = prefs.getString('userId') ?? '';
    //print("userid in reg: " + userId);
    //print("token in reg: " + token);

    Map<String, String> header = {
      "Accept": "*/*",
      "Authorization": "Bearer " + token
    };

    http.Response response = await http.get(
      Uri.parse(Api.getUserProfileApi + userId),
      headers: header,
    );
    log("ResponseBody" + response.body);

    if (response.body.isNotEmpty) {
      var jsonResponse = json.decode(response.body);

      experienceYear = jsonResponse['experience'].toString();

      firstNameController.text = jsonResponse['firstname'] ?? '';
      lastNameController.text = jsonResponse['lastname'] ?? '';
      phoneController.text = jsonResponse['phone'] ?? '';
      emailController.text = jsonResponse['email'] ?? '';
      imageUrl = jsonResponse['imageName'] ?? '';
      experienceController.text = jsonResponse['experience'].toString();
      _myDegrees = jsonResponse['degrees'] ?? '';
      _mySpecialization = jsonResponse['specializations'] ?? '';
      _myMci = null;

      /// initialize null to dropdown value for no selection

      if (jsonResponse['address'] != null) {
        addressLineOneController.text = jsonResponse['address']['line1'] ?? '';
        addressLineTwoController.text = jsonResponse['address']['line2'] ?? '';
        addressLandmarkController.text = jsonResponse['address']['line3'] ?? '';
        locationController.text = jsonResponse['address']['city'] ?? '';
        stateController.text = jsonResponse['address']['state'] ?? '';
        countryController.text = jsonResponse['address']['country'] ?? '';
        pincodeController.text = jsonResponse['address']['postalCode'] ?? '';
      }

      if (jsonResponse['councilMapping'] != null) {
        mciMumberController.text =
            jsonResponse['councilMapping']['mciNumber'] ?? '';
        yearController.text = jsonResponse['councilMapping']['year'].toString();
        _myMci = jsonResponse['councilMapping']['council'];
      }

      setState(() {
        isLoading = false;
        enableTextFieldPhone = false;
        enableTextFieldcountry = false;
        enableTextFieldstate = false;
      });

      // final prefs = await SharedPreferences.getInstance();
      // prefs.setString(
      //     'name', jsonResponse['firstname'] + " " + jsonResponse['lastname']);
      // prefs.setString('Specialization', jsonResponse['specializations']);
      // prefs.setString('experience', jsonResponse['experience'].toString());
    }
  }

  Future<void> uploadImageApi(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    Map<String, String> header = {"Authorization": "Bearer " + token};

    var stream =
        // ignore: deprecated_member_use
        http.ByteStream(DelegatingStream.typed(displayFileImage!.openRead()));
    var length = await displayFileImage!.length();

    var multipartFile = http.MultipartFile('file', stream, length,
        filename: basename(displayFileImage!.path));

    var uri = Uri.parse(Api.uploadImageApi);
    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll(header);
    request.files.add(multipartFile);

    var response = await request.send();
    //("Upload img " + response.statusCode.toString());
    if (response.statusCode == 202) {
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        String imageUrl = value;
        //print("ImgUrl " + imageUrl);
        postDataApi(imageUrl, context);
      });
    }
  }

  Future<void> postDataApi(String imageName, BuildContext context) async {
    String guid = uuid.v1();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final userId = prefs.getString('userId') ?? '';
    //print("regtoken: " + token);
    //print("reguserid: " + userId);
    //print("guid: " + guid);

    Map<String, String> header = {
      "requestid": guid,
      "Accept": "/",
      "api-version": "1.0",
      "Content-type": "application/json",
      "Authorization": "Bearer " + token
    };

    var encodedBody = json.encode({
      "specializations": _mySpecialization,
      "experience": int.parse(experienceController.text),
      "degrees": _myDegrees,
      "councilMapping": {
        "council": _myMci,
        "mciNumber": mciMumberController.text,
        "year": int.parse(yearController.text)
      },
      "kycs": [],
      "address": {
        "line1": addressLineOneController.text,
        "line2": addressLineTwoController.text,
        "line3": addressLandmarkController.text,
        "city": locationController.text,
        "state": stateController.text,
        "country": countryController.text,
        "postalCode": pincodeController.text
      },
      "id": guid,
      "firstname": firstNameController.text,
      "lastname": lastNameController.text,
      "phone": phoneController.text,
      "email": emailController.text,
      "imageName": imageName
    });

    http.Response response = await http.put(
        Uri.parse(Api.postDoctorDetailApi + userId),
        headers: header,
        body: encodedBody);

    Navigator.pop(context);

    if (response.statusCode == 200) {
      /// Save all data in shared preferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(
          'name', firstNameController.text + " " + lastNameController.text);
      prefs.setString('phone', phoneController.text);
      prefs.setString('image', imageName);
      prefs.setString('isRegistered', "True");
      prefs.setStringList(
          'specialization',
          List<String>.from(
              _mySpecialization)); // TO BE STORED AS ARRAY this line did the trick
      prefs.setString('experience', experienceController.text); //yup got it

      log("EXP" + experienceController.text);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: ColorSelect.green,
        content: const Text("Profile updated"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: ColorSelect.error,
        content: const Text("Profile update failed"),
      ));
    }
    final prefsf = await SharedPreferences.getInstance();
    String ex = prefsf.getString('experience').toString();
    log('MES  ' + ex);
  }

  Future<void> apiFetchParallel() async {
    await Future.wait([getAllDegrees(), getAllCouncil(), getAllDepartment()])
        .then((v) {})
        .whenComplete(() {
      if (isRegistered == "False") {
        setState(() {
          _myMci = null;
          isLoading = false;
          //enableTextFieldPhone = true;
        });
      } else {
        getUserProfile();
      }
    });
  }

  Future<LocationModel> _locationApi() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    Map<String, String> header = {
      "Accept": "text/plain",
      "api-version": "1.0",
      "Authorization": "Bearer " + token
    };

    http.Response response = await http.get(
        Uri.parse(Api.getAreaByPincode + pincodeController.text + "/1/30"),
        headers: header);

    if (response.statusCode == 200) {
      log("Response " + response.body);
      locationData = locationModelFromJson(response.body);
    }
    return locationData!;
  }

  Future<void> getSharedPrefs() async {
    log('message 2');
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    isRegistered = prefs.getString('isRegistered') ?? '';
    number = prefs.getString('phone') ?? '';
    log('Response essage' + prefs.getString('experience').toString());

    setState(() {
      phoneController.text = number.toString();
      enableTextFieldPhone = false;
    });
  }
}
