import 'dart:convert';
import 'dart:developer';
import 'package:doctor_app_connect/Widgets/drconnect_background.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:lottie/lottie.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Common/color_select.dart';
import '../Common/urls.dart';
import 'home_page.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({Key? key}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> with TickerProviderStateMixin {
  OtpFieldController otpController = OtpFieldController();
  late AnimationController _controller;
  int levelClock = 120;
  var _isVisibility = true;
  var _resendOtpVisibility = false;
  var uuid = const Uuid();
  var otp = "";

  List _mySpecialization = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    log("DateFormat" + DateTime(2022, 06, 20).toString());

    _controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds:
                levelClock) // gameData.levelClock is a user entered number elsewhere in the applciation
        );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return DrConnectBackground(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                const SizedBox(
                  height: 70.0,
                ),
                SizedBox(
                  height: 230,
                  width: 230,
                  child: Lottie.asset(
                    'assets/lottie/doctor1.json',
                    repeat: true,
                    reverse: true,
                    animate: true,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                const Text(
                  'Enter 6 digit code',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: SizedBox(
                    height: 50,
                    child: Expanded(
                      child: OTPTextField(
                          otpFieldStyle: OtpFieldStyle(
                              focusBorderColor: ColorSelect.primary, //(here)
                              enabledBorderColor: ColorSelect.secondary),
                          controller: otpController,
                          length: 6,
                          width: MediaQuery.of(context).size.width,
                          textFieldAlignment: MainAxisAlignment.spaceAround,
                          fieldWidth: 50,
                          fieldStyle: FieldStyle.box,
                          outlineBorderRadius: 15,
                          style: const TextStyle(fontSize: 17),
                          onChanged: (pin) {
                            log("Changed: " + pin);
                            otp = pin;
                          },
                          onCompleted: (pin) {
                            log("Completed: " + pin);
                            otp = pin;
                          }),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Countdown(
                          animation: StepTween(
                            begin: levelClock, // THIS IS A USER ENTERED NUMBER
                            end: 0,
                          ).animate(_controller),
                          timerVisibility: _isVisibility,
                          resendOtpVisibility: _resendOtpVisibility,
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(right: 25.0),
                          child: GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("OTP Resend"),
                              ));

                              _controller = AnimationController(
                                  vsync: this,
                                  duration: Duration(
                                      seconds:
                                          levelClock) // gameData.levelClock is a user entered number elsewhere in the applciation
                                  );

                              _controller.forward();

                              setState(() {
                                _isVisibility = true;
                                _resendOtpVisibility = false;
                              });
                            },
                            child: Visibility(
                              visible: _resendOtpVisibility,
                              child: Text(
                                'Resend OTP',
                                style: TextStyle(
                                    fontSize: 12, color: ColorSelect.primary),
                              ),
                            ),
                          ))
                    ]),
                const SizedBox(
                  height: 40.0,
                ),
                SizedBox(
                  height: 40.0,
                  width: 200.0,
                  child: ElevatedButton(
                    onPressed: () {
                      if (otp == "") {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Please enter Otp"),
                        ));
                      } else if (otp.length < 6) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Please enter full Otp"),
                        ));
                      } else {
                        callOtpApi();
                      }
                    },
                    child: const Text(
                      'VERIFY',
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
    ));
  }

  Future<void> callOtpApi() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? '';
    log("prefff: " + userId);
    log("OTPPP: " + otp.toString());

    Map<String, String> header = {
      "Accept": "application/json",
      "Content-type": "application/x-www-form-urlencoded",
    };

    Map<String, String> encodedBody = {
      "grant_type": "password",
      "username": userId,
      "password": otp.toString(),
      "client_id": "postman",
      "client_secret": ""
    };

    http.Response response = await http.post(
      Uri.parse(Api.otpApi),
      headers: header,
      body: encodedBody,
    );
    //   print("responseeee: " + response.body.toString());
    log(response.body);

    if (response.body.isNotEmpty) {
      var jsonResponse = json.decode(response.body)['access_token'];

      getDetailsFromToken(jsonResponse.toString());
    }
  }

  Future<void> getDetailsFromToken(String token) async {
    String normalizedSource = base64Url.normalize(token.split(".")[1]);

    var jsonFromJwt = utf8.decode(base64Url.decode(normalizedSource));
    var isRegistered = json.decode(jsonFromJwt)['IsRegistered'].toString();
    var exp = json.decode(jsonFromJwt)['exp'].toString();

    log('token: ' + token);
    log("Token Expiry: " + exp);
    log("IsRegistered: " + isRegistered);
    // isRegistered="False";  // !for test purpose only remove this line

    if (isRegistered == "True") {
      getUserProfile(token, isRegistered);
    } else if (isRegistered == "False") {
      final prefs = await SharedPreferences.getInstance();

      /// Save data to shared preff
      prefs.setString('token', token);
      prefs.setString('name', "Guest ");
      prefs.setString('phone', "-Mobile number");
      prefs.setString('image', "");
      prefs.setString('isRegistered', isRegistered);
      prefs.setString('experience', "Experience");
      prefs.setStringList('specialization', ["Specialization"]);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (Route<dynamic> route) => route is HomePage);
    }
  }

  Future<void> getUserProfile(String token, String isRegistered) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? '';

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

      String firstName = jsonResponse['firstname'] ?? '';
      String lastName = jsonResponse['lastname'] ?? '';
      String phone = jsonResponse['phone'] ?? '';
      String profileImage = jsonResponse['imageName'] ?? '';
      _mySpecialization = jsonResponse['specializations'] ?? '';
      String experience = jsonResponse['experience'].toString();

      /// Save data to shared preff after getting profile data from Api

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      prefs.setString('name', firstName + " " + lastName);
      prefs.setString('phone', phone);
      prefs.setString('image', profileImage);
      prefs.setString('isRegistered', isRegistered);
      //prefs.setString('specializations', specialization);
      prefs.setStringList(
          'specialization', List<String>.from(_mySpecialization));
      prefs.setString('experience', experience.toString());

      log("EXPPPP " + experience.toString());

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (Route<dynamic> route) => route is HomePage);
    }
  }
}

class Countdown extends AnimatedWidget {
  var timerVisibility;
  var resendOtpVisibility;

  Countdown(
      {Key? key,
      required this.animation,
      required this.timerVisibility,
      required this.resendOtpVisibility})
      : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    // print('animation.value  ${animation.value} ');
    // print('inMinutes ${clockTimer.inMinutes.toString()}');
    // print('inSeconds ${clockTimer.inSeconds.toString()}');
    // print('inSeconds.remainder ${clockTimer.inSeconds.remainder(60).toString()}');

    if (clockTimer.inSeconds == 0) {
      timerVisibility = false;
      resendOtpVisibility = true;
    }

    return Visibility(
      visible: timerVisibility,
      child: Text(
        timerText,
        style: TextStyle(
          fontSize: 12,
          color: ColorSelect.secondary,
        ),
      ),
    );
  }
}
