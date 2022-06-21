import 'package:doctor_app_connect/Common/color_select.dart';
import 'package:doctor_app_connect/Widgets/drconnect_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting_Page extends StatefulWidget {
  const Setting_Page({Key? key}) : super(key: key);

  @override
  State<Setting_Page> createState() => Setting_PageState();
}

class Setting_PageState extends State<Setting_Page> {
  final changePhoneNumber = TextEditingController();

  String? phone_no;

  @override
  void initState() {
    super.initState();

    getSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    return DrConnectBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            "Settings",
            style: TextStyle(color: ColorSelect.secondary),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: ColorSelect.secondary),
        ),
        body: Container(
          margin: EdgeInsets.fromLTRB(12, 10, 12, 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Change your Number",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: changePhoneNumber,
                onChanged: (value) {
                  if (value.length == 10) {
                    FocusManager.instance.primaryFocus?.unfocus();
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
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  //suffixText: '*',
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
                      borderSide: BorderSide(color: ColorSelect.primary)),
                  hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 30),
                child: SizedBox(
                  width: 180,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: ColorSelect.primary,
                      shape: const StadiumBorder(),
                    ),
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  Future<void> getSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    phone_no = prefs.getString('phone') ?? '';

    setState(() {
      changePhoneNumber.text = phone_no.toString();
    });
  }
}
