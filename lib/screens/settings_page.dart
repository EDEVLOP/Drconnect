import 'package:flutter/material.dart';


class BookingsPage extends StatelessWidget {
  const BookingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:  Center(
        child: Text("Bookings page", style: TextStyle(color: Colors.black),),
      
      ),
    );
  }
}


class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:  Center(
        child: Text("Home page", style: TextStyle(color: Colors.black),),
      
      ),
    );
  }
}


class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:  Center(
        child: Text("Settings page", style: TextStyle(color: Colors.black),),
      
      ),
    );
  }
}