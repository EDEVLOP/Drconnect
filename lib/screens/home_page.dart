import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor_app_connect/screens/booking_activity.dart';
import 'package:doctor_app_connect/screens/booking_history.dart';
import 'package:doctor_app_connect/screens/dashboard.dart';
import 'package:doctor_app_connect/screens/package_page.dart';
import 'package:doctor_app_connect/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Common/color_select.dart';
import '../Common/urls.dart';
import 'Calender/calendar_page.dart';
import 'add_clinic_page.dart';
import 'settings_page.dart';
import 'splash_page.dart';
import 'leave_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  late CircularBottomNavigationController _navigationController;
  int selectedPos = 1;
  double bottomNavBarHeight = 60;
  String? token;
  String name = 'Guest user';
  String? phone;
  String image = '';

  List<TabItem> tabItems = List.of([
    TabItem(
        Icons.calendar_month_outlined, "Appointments", ColorSelect.secondary,
        labelStyle: TextStyle(
            color: ColorSelect.secondary,
            fontWeight: FontWeight.bold,
            fontSize: 13)),
    TabItem(Icons.home_outlined, "Home", ColorSelect.secondary,
        labelStyle: TextStyle(
            color: ColorSelect.secondary,
            fontWeight: FontWeight.bold,
            fontSize: 13)),
    TabItem(Icons.person_outline, "Profile", ColorSelect.secondary,
        labelStyle: TextStyle(
            color: ColorSelect.secondary,
            fontWeight: FontWeight.bold,
            fontSize: 13)),
  ]);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _navigationController = CircularBottomNavigationController(selectedPos);
    getSharedPrefs();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    _navigationController.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //do your stuff
      log("resumed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: ColorSelect.secondary),
        title: SizedBox(
            height: 140,
            width: 140,
            child: Image.asset('assets/images/logotitle.png')),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: ColorSelect.secondary,
            ),
            onPressed: () {
              // do something
            },
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: ColorSelect.secondary,
              ),
              accountName: Text(name, style: const TextStyle(fontSize: 14)),
              accountEmail:
                  Text("+91-" + phone!, style: const TextStyle(fontSize: 13)),
              currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: image != ''
                      ? profilePictureView(token!, image)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: const FadeInImage(
                            height: 120.0,
                            width: 120.0,
                            fit: BoxFit.cover,
                            placeholder:
                                AssetImage("assets/images/drprofile.png"),
                            image: AssetImage("assets/images/drprofile.png"),
                          ),
                        )),
            ),
            ListTile(
              title: Text(
                "My Profile",
                style: TextStyle(fontSize: 12, color: ColorSelect.secondary),
              ),
              leading: Icon(
                Icons.account_circle,
                color: ColorSelect.secondary,
              ),
              onTap: () {
                Navigator.of(context).pop();
                var future = Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
                future.then((value) {
                  log(value);
                  getSharedPrefs();
                });
              },
              visualDensity: const VisualDensity(vertical: -3),
            ),
            ExpansionTile(
              title: Text(
                "My Account Info",
                style: TextStyle(fontSize: 12, color: ColorSelect.secondary),
                textAlign: TextAlign.left,
              ),
              leading: Icon(
                Icons.account_balance_outlined,
                color: ColorSelect.secondary,
              ),
              collapsedIconColor: Colors.blue,
              iconColor: Colors.grey,
              //collapsedBackgroundColor: ColorSelect.bluegrey50,
              backgroundColor: ColorSelect.bluegrey50,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 18),
                  child: ListTile(
                    title: Text(
                      "Add Clinic",
                      style:
                          TextStyle(fontSize: 12, color: ColorSelect.secondary),
                    ),
                    leading: Icon(
                      Icons.add_outlined,
                      color: ColorSelect.secondary,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ClinicPage()),
                      );
                    },
                    visualDensity: const VisualDensity(vertical: -3),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 18),
                  child: ListTile(
                    title: Text(
                      "Create Appointments",
                      style:
                          TextStyle(fontSize: 12, color: ColorSelect.secondary),
                    ),
                    leading: Icon(
                      Icons.event_available,
                      color: ColorSelect.secondary,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CalendarPage(
                                clinicName: "",
                                clinicId: "",
                                id: "",
                                startDate: "",
                                endDate: "",
                                startTime: "",
                                endTime: "",
                                slot: 0,
                                slotSelector: "",
                                intervalSelector: "",
                                numberOfPatients: 0,
                                byDays: [])),
                      );
                    },
                    visualDensity: const VisualDensity(vertical: -3),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 18),
                  child: ListTile(
                    title: Text(
                      "Manage Leaves",
                      style:
                          TextStyle(fontSize: 12, color: ColorSelect.secondary),
                    ),
                    leading: Icon(
                      Icons.calendar_month_outlined,
                      color: ColorSelect.secondary,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LeavePage()),
                      );
                    },
                    visualDensity: const VisualDensity(vertical: -3),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 18),
                  child: ListTile(
                    title: Text("Manage Appointments",
                        style: TextStyle(
                            fontSize: 12, color: ColorSelect.secondary)),
                    leading: Icon(
                      Icons.book_online_outlined,
                      color: ColorSelect.secondary,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BookingHistoryPage()),
                      );
                    },
                    visualDensity: const VisualDensity(vertical: -3),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 18),
                  child: ListTile(
                    title: Text(
                      "My Subscriptions",
                      style:
                          TextStyle(fontSize: 12, color: ColorSelect.secondary),
                    ),
                    leading: Icon(
                      Icons.currency_pound_outlined,
                      color: ColorSelect.secondary,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      var future = Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PackagePage()),
                      );
                      future.then((value) {
                        log(value);
                        getSharedPrefs();
                      });
                    },
                    visualDensity: const VisualDensity(vertical: -3),
                  ),
                ),
              ],
            ),

            // ListTile(
            //   tileColor: ColorSelect.bluegrey50,
            //   title: Text(
            //     "My Account Info",
            //     style: TextStyle(fontSize: 12, color: ColorSelect.secondary),
            //   ),
            //   leading: Icon(
            //     Icons.account_balance_outlined,
            //     color: ColorSelect.secondary,
            //   ),
            //   onTap: () {
            //     Navigator.of(context).pop();
            //   },
            //   visualDensity: const VisualDensity(vertical: -3),
            // ),

            ListTile(
              title: Text("Buy Subscriptions and Add-ons ",
                  style: TextStyle(fontSize: 12, color: ColorSelect.secondary)),
              leading: Icon(
                Icons.card_membership_rounded,
                color: ColorSelect.secondary,
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
              visualDensity: const VisualDensity(vertical: -3),
            ),

            ListTile(
              title: Text("Settings",
                  style: TextStyle(fontSize: 12, color: ColorSelect.secondary)),
              leading: Icon(
                Icons.settings,
                color: ColorSelect.secondary,
              ),
              onTap: () {
                Navigator.of(context).pop();
                var future = Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingPage()),
                );
              },
              visualDensity: const VisualDensity(vertical: -3),
            ),
            ListTile(
              title: Text("Help Center",
                  style: TextStyle(fontSize: 12, color: ColorSelect.secondary)),
              leading: Icon(
                Icons.help_center_outlined,
                color: ColorSelect.secondary,
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
              visualDensity: const VisualDensity(vertical: -3),
            ),
            ListTile(
              title: Text("Privacy Policy",
                  style: TextStyle(fontSize: 12, color: ColorSelect.secondary)),
              leading: Icon(
                Icons.policy_outlined,
                color: ColorSelect.secondary,
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
              visualDensity: const VisualDensity(vertical: -3),
            ),
            ListTile(
              title: Text("Log Out",
                  style: TextStyle(fontSize: 12, color: ColorSelect.secondary)),
              leading: Icon(
                Icons.logout_outlined,
                color: ColorSelect.secondary,
              ),
              onTap: () {
                Navigator.of(context).pop();
                _showLogoutDialog();
              },
              visualDensity: const VisualDensity(vertical: -3),
            ),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            child: bodyContainer(),
            padding: EdgeInsets.only(bottom: bottomNavBarHeight),
          ),
          Align(alignment: Alignment.bottomCenter, child: bottomNav())
        ],
      ),
    );
  }

  Widget bodyContainer() {
    Color selectedColor = Colors.white;
    var pagesData = [
      const BookingHistoryActivity(),
      const Dashboard(),
      const SettingPage(),
    ];

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: selectedColor,
      child: Center(
        child: pagesData[selectedPos],
      ),
    );
  }

  Widget bottomNav() {
    return CircularBottomNavigation(
      tabItems,
      controller: _navigationController,
      barHeight: bottomNavBarHeight,
      barBackgroundColor: Colors.white,
      animationDuration: const Duration(milliseconds: 300),
      selectedCallback: (selectedPos) {
        setState(() {
          this.selectedPos = selectedPos!;
          log(_navigationController.value.toString());
        });
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: SizedBox(
              height: 180,
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
                          Text(
                            "Logout",
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            "Are you sure, you want to logout?",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 35.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          highlightColor: ColorSelect.secondary,
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: 45,
                            height: 25,
                            alignment: Alignment.center,
                            // child: InkWell(
                            //   highlightColor: ColorSelect.secondary,
                            //   onTap: () {
                            //     Navigator.of(context).pop();
                            //   },
                            child: Text(
                              "No",
                              style: TextStyle(
                                  fontSize: 15, color: ColorSelect.secondary),
                            ),
                            //),
                          ),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        InkWell(
                          highlightColor: ColorSelect.secondary,
                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();
                            prefs.setString('token', "");
                            prefs.setString('name', "");
                            prefs.setString('phone', "");
                            prefs.setString('image', "");
                            prefs.setString('IsRegistered', "");
                            prefs.setString('specialization', "");
                            prefs.setString('experience', "");
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SplashPage()),
                                (Route<dynamic> route) => route is HomePage);
                          },
                          child: Container(
                            width: 45,
                            height: 25,
                            alignment: Alignment.center,
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                  fontSize: 15, color: ColorSelect.secondary),
                            ),
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

  Widget profilePictureView(String token, String image) {
    return CachedNetworkImage(
        imageUrl: Api.getUploadImageApi + image,
        height: 120.0,
        width: 120.0,
        placeholder: (context, url) => const CircleAvatar(
              child: Image(image: AssetImage("assets/images/drprofile.png")),
              backgroundColor: Colors.white,
              radius: 100,
            ),
        imageBuilder: (context, image) => CircleAvatar(
              backgroundImage: image,
              radius: 100,
            ),
        fit: BoxFit.cover,
        errorWidget: (context, url, error) => const Icon(Icons.error),
        httpHeaders: {"Authorization": "Bearer " + token});
  }

  Future<void> getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    name = prefs.getString('name') ?? 'Guest user';
    phone = prefs.getString('phone') ?? '';
    image = prefs.getString('image') ?? '';

    setState(() {});
  }
}
