import 'dart:convert';
import 'dart:developer';
import 'package:doctor_app_connect/Models/clinic_modal.dart';
import 'package:doctor_app_connect/Widgets/drconnect_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../Common/color_select.dart';
import '../Common/urls.dart';
import '../Models/location_modal.dart';



class ClinicPage extends StatefulWidget {
  const ClinicPage({Key? key}) : super(key: key);

  @override
  ClinicState createState() => ClinicState();
}

class ClinicState extends State<ClinicPage> {
  var uuid = const Uuid();

  Future? myClinicList;
  List<ClinicModel> clinicData = [];
  LocationModel? locationData;
  var editClinicId = "";
  bool isLoading = true;

  bool isEditIconClicked = false;

  final clinicNameController = TextEditingController();
  final addressController = TextEditingController();
  final pincodeController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final phoneController = TextEditingController();
  final feesController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    myClinicList = _fetchClinicData();

    phoneController.addListener(() {
      if (phoneController.text.length == 10) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
    });

    pincodeController.addListener(() {
      if (pincodeController.text.length == 6) {
        FocusManager.instance.primaryFocus?.unfocus();
        if (isEditIconClicked == false) {
          _dialogPop();
        }
      }
    });

  }

  @override
  void dispose() {
    clinicNameController.dispose();
    addressController.dispose();
    pincodeController.dispose();
    cityController.dispose();
    stateController.dispose();
    phoneController.dispose();
    feesController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DrConnectBackground(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: ColorSelect.secondary),
        title: Text(
          "Add Clinic",
          style: TextStyle(color: ColorSelect.secondary),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0),
                      child: TextFormField(
                        controller: clinicNameController,
                        // onChanged: (_) {
                        //   _formKey.currentState!.validate();
                        // },
                        keyboardType: TextInputType.text,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Clinic name is empty';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Clinic Name *',

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
                          fillColor: Colors.white,
                          //hintText: 'Enter clinic',
                          hintStyle:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0),
                      child: TextFormField(
                        controller: addressController,
                        // onChanged: (_) {
                        //   _formKey.currentState!.validate();
                        // },
                        keyboardType: TextInputType.text,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Address is empty';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Address *',
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
                              color: ColorSelect.primary,
                            ),
                          ),
                          hintStyle:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8),
                      child: TextFormField(
                        controller: pincodeController,
                        keyboardType: TextInputType.number,
                        // onChanged: (_) {
                        //   _formKey.currentState!.validate();
                        // },
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Pincode is empty';
                          } else if (text.length < 6) {
                            return 'Pincode must be atleast 6 digit';
                          }
                          return null;
                        },
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          LengthLimitingTextInputFormatter(6),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Postal Code *',
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
                              borderSide:
                                  BorderSide(color: ColorSelect.primary)),
                          hintStyle:
                              const TextStyle(fontSize: 16, color: Colors.grey),
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
                                padding: const EdgeInsets.only(right: 4),
                                child: TextFormField(
                                  controller: cityController,
                                  // onChanged: (_) {
                                  //   _formKey.currentState!.validate();
                                  // },
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
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
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: TextFormField(
                                  controller: stateController,
                                  // onChanged: (_) {
                                  //   _formKey.currentState!.validate();
                                  // },
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
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
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8),
                      child: TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.number,
                        // onChanged: (_) {
                        //   _formKey.currentState!.validate();
                        // },
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Phone is empty';
                          } else if (text.length < 10) {
                            return 'Phone number must be atleast 10 digit';
                          }
                          return null;
                        },
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Phone number',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: ColorSelect.secondary,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorSelect.primary)),
                          hintStyle:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8),
                      child: TextFormField(
                        controller: feesController,
                        keyboardType: TextInputType.number,
                        // onChanged: (_) {
                        //   _formKey.currentState!.validate();
                        // },
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Fees is empty';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Fees *',
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
                          hintStyle:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(ColorSelect.primary),
                          overlayColor: MaterialStateProperty.all(Colors.grey),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          fixedSize:
                              MaterialStateProperty.all(const Size(200, 40)),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (isEditIconClicked == false) {
                              addClinicApi();
                            } else {
                              editClinicApi(editClinicId);
                            }
                          }
                        },
                        child: const Text("Submit")),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 0),
              width: MediaQuery.of(context).size.width,
              color: ColorSelect.secondary,
              height: 40,
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Your Clinics",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            FutureBuilder(
              future: myClinicList,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 30.0),
                    child: CircularProgressIndicator(),
                  );
                }
                if (clinicData.isEmpty) {
                  return Center(
                    child: Container(
                      margin: const EdgeInsets.all(40),
                      child: Column(
                        children: const [
                          Image(
                            image: AssetImage("assets/images/warning.png"),
                            width: 50,
                            height: 50,
                          ),
                          Text("No Clinics Added")
                        ],
                      ),
                    ),
                  );
                } else {
                  return Scrollbar(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: clinicData.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                            height: 65,
                            decoration: BoxDecoration(
                                color: ColorSelect.bluegrey100,
                                borderRadius: BorderRadius.circular(12.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(left: 6),
                                  padding: const EdgeInsets.all(4.0),
                                  width: 240,
                                  child: Column(
                                    textDirection: TextDirection.ltr,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        clinicData[index].name!,
                                      ),
                                      Text(clinicData[index].address!.city!),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 8.0),
                                  padding: const EdgeInsets.all(2),
                                  height: 35,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          _deletePop(
                                              clinicData[index].name.toString(),
                                              clinicData[index].id.toString());
                                        },
                                        child: const Image(
                                          image: AssetImage(
                                              "assets/images/delete.png"),
                                          width: 30,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          isEditIconClicked = true;
                                          editClinicId =
                                              clinicData[index].id.toString();
                                          _showEditDialog(index);
                                          clinicNameController.clear();
                                          addressController.clear();
                                          pincodeController.clear();
                                          cityController.clear();
                                          stateController.clear();
                                          phoneController.clear();
                                          feesController.clear();
                                        },
                                        child: const Image(
                                          image: AssetImage(
                                              "assets/images/edit.png"),
                                          width: 30,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                  );
                }
              },
            ),
            const SizedBox(
              height: 10.0,
            )
          ],
        ),
      ),
    ));
  }

  Future<void> addClinicApi() async {
    String guid = uuid.v1();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    Map<String, String> header = {
      "requestid": guid,
      "Accept": "*/*",
      "api-version": "1.0",
      "Content-type": "application/json",
      "Authorization": "Bearer " + token
    };

    var encodedBody = json.encode({
      "name": clinicNameController.text,
      "address": {
        "line1": addressController.text,
        "city": cityController.text,
        "state": stateController.text,
        "country": "India",
        "phoneNumber": phoneController.text,
        "postalCode": pincodeController.text
      },
      "fees": int.parse(feesController.text)
    });

    http.Response response = await http.post(Uri.parse(Api.addClinicApi),
        headers: header,
        body: encodedBody);

    if (response.statusCode == 201) {
      log("Response" + response.body);

      setState(() {
        myClinicList = _fetchClinicData();
      });
      _successPop(clinicNameController.text);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text("Clinic update failed"),
      ));
    }
  }


  Future<LocationModel> _locationApi() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

  Map<String, String> header = {     
      "Accept": "text/plain",
      "api-version": "1.0",    
      "Authorization": "Bearer " + token
    };

    http.Response response = await http.get(Uri.parse(
        Api.getAreaByPincode + pincodeController.text + "/1/30"),
        headers: header);

    if (response.statusCode == 200) {
      log("Response " + response.body);
      locationData = locationModelFromJson(response.body);
    }
    return locationData!;
  }

  void _dialogPop() {
    showDialog(
        context: context,
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
                                    itemCount:
                                        locationData!.data!.length,
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
                                            cityController.text =
                                                locationData!
                                                    .data![index]
                                                    .area.toString();
                                                  
                                            stateController.text =
                                                locationData!
                                                    .data![index]
                                                    .state.toString().toLowerCase();
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
                                                          .data![index]
                                                          .area.toString(),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color.fromARGB(
                                                          255, 81, 80, 80)),
                                                ),
                                                 Text("State : " + locationData!
                                                         .data![index].state.toString().toLowerCase()
                                                        
                                                         ),
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

  void _showEditDialog(int index) {
    showDialog(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: SizedBox(
              height: 150,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          // Text(
                          //   "Logout",
                          //   style: TextStyle(fontSize: 20),
                          // ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Do you want to edit ?",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 55.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "No",
                            style: TextStyle(
                                fontSize: 15, color: ColorSelect.secondary),
                          ),
                        ),
                        const SizedBox(
                          width: 40.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            clinicNameController.text = clinicData[index].name!;
                            addressController.text =
                                clinicData[index].address!.line1!;
                            pincodeController.text =
                                clinicData[index].address!.postalCode!;
                            cityController.text =
                                clinicData[index].address!.city!;
                            stateController.text =
                                clinicData[index].address!.state!;
                            phoneController.text =
                                clinicData[index].address!.phoneNumber!;
                            feesController.text =
                                clinicData[index].fees.toString();
                          },
                          child: Text(
                            "Yes",
                            style: TextStyle(
                                fontSize: 15, color: ColorSelect.secondary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _successPop(String clinicName) {
    showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: SizedBox(
              height: 270,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: ColorSelect.primary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                    ),
                    height: 40,
                    child: const Center(
                      child: Text(
                        "Success",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0, bottom: 2.0),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Image.asset(
                        'assets/images/SuccessImg.png',
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        clinicName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 12, right: 12),
                        child: Text(
                            'Clinic Added Successfully. Choose the further action.'),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 12, right: 12, top: 12),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: Colors.blue, width: 1),
                              ),
                              child: const Text(
                                "Add Another Clinic",
                                style:
                                    TextStyle(fontSize: 12, color: Colors.blue),
                                textAlign: TextAlign.center,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                clinicNameController.clear();
                                addressController.clear();
                                pincodeController.clear();
                                cityController.clear();
                                stateController.clear();
                                phoneController.clear();
                                feesController.clear();
                                isEditIconClicked = false;
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.only(right: 2),
                                side: const BorderSide(
                                    color: Colors.blue, width: 1),
                              ),
                              child: const Text(
                                "Next",
                                style: TextStyle(fontSize: 12),
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ]),
                  ),

                  Container(
                    margin:
                        const EdgeInsets.only(top: 10.0, right: 14.0, left: 10),
                    alignment: Alignment.center,
                    width: 100,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: ColorSelect.primary),
                    child: GestureDetector(
                      child: const Text(
                        "OK",
                        //textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onTap: () => {
                        log("message"),
                        Navigator.of(context).pop(),
                        clinicNameController.clear(),
                        addressController.clear(),
                        pincodeController.clear(),
                        cityController.clear(),
                        stateController.clear(),
                        phoneController.clear(),
                        feesController.clear(),
                        isEditIconClicked = false
                      },
                    ),
                  ),
                  //),
                  //),
                ],
              ),
            ),
          );
        });
  }

  void _deletePop(String name, String id) {
    showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!

        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: SizedBox(
              height: 260,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(8.0),
                      ),
                    ),
                    height: 40,
                    child: const Center(
                      child: Text(
                        "Delete",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0, bottom: 2.0),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Image.asset(
                        'assets/images/deleteIcon.png',
                        width: 70,
                        height: 70,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 12, right: 12, top: 8),
                        child: Text(
                            'This clinics will delete permanently.Do you still want to continue?'),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 12, right: 12, top: 12),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                //backgroundColor: Colors.red,
                                side: const BorderSide(
                                    color: Colors.green, width: 1),
                              ),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.green),
                                textAlign: TextAlign.center,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                isEditIconClicked = false;
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              //backgroundColor: Colors.red,
                              padding: const EdgeInsets.only(right: 2),
                              side:
                                  const BorderSide(color: Colors.red, width: 1),
                            ),
                            child: const Text(
                              "Delete",
                              style: TextStyle(fontSize: 12, color: Colors.red),
                            ),
                            onPressed: () {
                              _deleteClinicApi(id);
                              Navigator.of(context).pop();
                            },
                          )),
                        ]),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future _deleteClinicApi(String id) async {
    String guid = uuid.v1();
    //print("Clinic Id " + id);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    Map<String, String> header = {
      "requestid": guid,
      "Accept": "*/*",
      "api-version": "1.0",
      "Authorization": "Bearer " + token
    };

    http.Response response =
        await http.delete(Uri.parse(Api.deleteClinicapi + id), headers: header);
    if (response.statusCode == 200) {
      FocusManager.instance.primaryFocus?.unfocus();
      setState(() {
        myClinicList = _fetchClinicData();
        clinicNameController.clear();
        addressController.clear();
        pincodeController.clear();
        cityController.clear();
        stateController.clear();
        phoneController.clear();
        feesController.clear();

        isEditIconClicked = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text("Clinic delete successfully"),
      ));
      log("Response" + response.body);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text("Clinic delete failed"),
      ));
    }
  }

  Future editClinicApi(String id) async {
    String guid = uuid.v1();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    Map<String, String> header = {
      "requestid": guid,
      "Accept": "*/*",
      "api-version": "1.0",
      "Content-type": "application/json",
      "Authorization": "Bearer " + token
    };

    var encodedBody = json.encode({
      "name": clinicNameController.text,
      "address": {
        "line1": addressController.text,
        "city": cityController.text,
        "state": stateController.text,
        "country": "India",
        "phoneNumber": phoneController.text,
        "postalCode": pincodeController.text
      },
      "fees": int.parse(feesController.text)
    });

    http.Response response = await http.put(Uri.parse(Api.editClinicApi + id),
        headers: header, body: encodedBody);

    //print("Status Code " + response.statusCode.toString());
    if (response.statusCode == 200) {
      isEditIconClicked = false;
      setState(() {
        myClinicList = _fetchClinicData();
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text("Clinic updated successfully"),
      ));

      clinicNameController.clear();
      addressController.clear();
      pincodeController.clear();
      cityController.clear();
      stateController.clear();
      phoneController.clear();
      feesController.clear();
      log("Response" + response.body);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text("Clinic upadte failed"),
      ));
    }
  }

  Future<void> _fetchClinicData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    Map<String, String> header = {
      "Accept": "*/*",
      "api-version": "1.0",
      "Authorization": "Bearer " + token
    };

    http.Response response =
        await http.get(Uri.parse(Api.fetchClinicDataApi), headers: header);

    if (response.statusCode == 200) {
      //final jsonResponse = json.decode(response.body);
      clinicData = clinicModelFromJson(response.body);
    }
  }


}
