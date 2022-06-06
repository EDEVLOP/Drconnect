import 'dart:async';
import 'dart:developer';
import 'package:doctor_app_connect/Widgets/drconnect_background.dart';
import 'package:doctor_app_connect/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    checkIsLogin();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 4), () {
      if (isLogin == true) {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => const HomePage()),
        // );
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => const HomePage(),
            transitionsBuilder: (c, anim, a2, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 1300),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });

    return DrConnectBackground(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 230,
                  height: 230,
                ),
              ),
            )));
  }

  Future<void> checkIsLogin() async {
    final prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString('token') ?? '';

    if (_token != "") {
      log("alreay login");
      isLogin = true;
    } else {
      isLogin = false;
      log("not login");
    }
  }
}
