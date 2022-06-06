import 'dart:convert';
import 'dart:developer';
import 'package:doctor_app_connect/Widgets/drconnect_background.dart';
import 'package:doctor_app_connect/screens/otp_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Common/color_select.dart';
import '../Common/urls.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var uuid = const Uuid();
  final myController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    log("DateFormat: " + DateTime.now().toString());

    myController.text = "8984147187";
    myController.addListener(() {
      if (myController.text.length == 10) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DrConnectBackground(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 100,
                  ),
                  SizedBox(
                      height: 280,
                      width: 280,
                      child: Image.asset('assets/images/logo.png')),
                  TextFormField(
                    controller: myController,
                    keyboardType: TextInputType.number,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Mobile number is empty';
                      } else if (text.length < 10) {
                        return 'Enter valid mobile number';
                      }
                      return null;
                    },
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Mobile Number',
                      hintText: 'Enter Mobile',
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
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    height: 40.0,
                    width: 200.0,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          postApiCall();
                        }
                      },
                      child: const Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: ColorSelect.primary,
                        shape: const StadiumBorder(),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }

  Future<void> postApiCall() async {
    String guid = uuid.v1();

    Map<String, String> header = {
      "requestid": guid,
      "Content-type": "application/json",
      "accept": "text/plain",
      "api-version": "1.0"
    };

    Map<String, String> parameters = <String, String>{};
    parameters['phone'] = myController.text;
    var encodedBody = json.encode(parameters);

    http.Response response = await http.post(
      Uri.parse(Api.loginApi),
      headers: header,
      body: encodedBody,
      //encoding: Encoding.getByName("application/json")
    );
    if (response.body.isNotEmpty && response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      log('user_id: ' + jsonResponse);

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userId', jsonResponse);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const OtpPage()),
      );
    }
  }
}
