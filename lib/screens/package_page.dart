import 'package:accordion/controllers.dart';
import 'package:doctor_app_connect/Widgets/drconnect_background.dart';
import 'package:flutter/material.dart';
import '../Common/color_select.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:accordion/accordion.dart';

class PackagePage extends StatefulWidget {
  const PackagePage({Key? key}) : super(key: key);

  @override
  State<PackagePage> createState() => PackagePageState();
}

class PackagePageState extends State<PackagePage> {
  bool loading = true;
  bool isLoading = true;
  String month = "";
  bool _showContent = false;
  double _animatedHeight = 100.0;

  bool isOpen = false;
  final _loremIpsum = 'vgvsxtyfsyctfdcvhdgv';
  final _headerStyle = const TextStyle(
      color: Color(0x000000), fontSize: 15, fontWeight: FontWeight.bold);
  final _contentStyleHeader = const TextStyle(
      color: Color(0x000000), fontSize: 14, fontWeight: FontWeight.w700);
  final _contentStyle = const TextStyle(
      color: Color(0x000000), fontSize: 14, fontWeight: FontWeight.normal);

  @override
  Widget build(BuildContext context) {
    return DrConnectBackground(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(
                'My Cards',
                style: TextStyle(color: ColorSelect.secondary),
              ),
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: ColorSelect.secondary),
            ),
            body: SingleChildScrollView(
              child: Container(
                child: Column(children: [
                  // Card(
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(10),
                  // ),
                  //elevation: 3,
                  // Card(
                  //   elevation: 3,
                  //   margin: const EdgeInsets.only(left: 12, right: 12, top: 10),
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(10),
                  //   ),

                  Container(
                    margin: const EdgeInsets.only(left: 12, right: 12, top: 10),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                        // image: const DecorationImage(
                        //   image: AssetImage("assets/images/cardbg.jpg"),
                        //   fit: BoxFit.cover,
                        // ),

                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Colors.blue,
                              Colors.blueGrey,
                            ]),
                        border: Border.all(color: Colors.blue)),
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DOCTOR CONNECT STANDARD',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text(
                          'This is a standard package for this app.',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),

                        Theme(
                          data: Theme.of(context).copyWith(
                              unselectedWidgetColor: Colors.white,
                              disabledColor: Colors.blue),
                          child: Row(
                            children: [
                              const Text(
                                'Validity :',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              RadioButton(
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  activeColor: Colors.limeAccent,
                                  description: '1 Month',
                                  value: "1 Month",
                                  groupValue: month,
                                  onChanged: (value) {
                                    setState(() {
                                      month = value.toString();
                                    });
                                  }),
                              const SizedBox(
                                width: 8,
                              ),
                              RadioButton(
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                ),
                                activeColor: Colors.limeAccent,
                                description: '12 Month',
                                value: "12 Month",
                                groupValue: month,
                                onChanged: (value) {
                                  setState(() {
                                    month = value.toString();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: const [
                            Text(
                              'Price :',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Rs 2500',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),

                        Container(
                          margin: const EdgeInsets.only(
                              top: 8, bottom: 3, right: 10),
                          alignment: Alignment.topRight,
                          child: SizedBox(
                            height: 28,
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
                              ),
                              onPressed: () {},
                              child: const Text("BUY NOW"),
                            ),
                          ),
                        ),

                        Container(
                          child: ExpansionTile(
                            expandedCrossAxisAlignment:
                                CrossAxisAlignment.stretch,
                            title: Text(
                              'View more',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                height: 1,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            collapsedIconColor: Colors.white,
                            iconColor: Colors.white,

                            //subtitle: Text('Expand this tile to see its contents'),
                            // Contents
                            children: [
                              ListTile(
                                leading: Icon(
                                  Icons.check_circle_outline_outlined,
                                  color: ColorSelect.primary,
                                ),
                                title: Text(
                                  'Access control IP address whitelisting',
                                  style: TextStyle(color: Colors.white),
                                ),
                                minVerticalPadding: 3,
                                horizontalTitleGap: 3,
                                visualDensity: VisualDensity(vertical: -3),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.check_circle_outline_outlined,
                                  color: ColorSelect.primary,
                                ),
                                title: Text(
                                    'Language customization at a patient level',
                                    style: TextStyle(color: Colors.white)),
                                minVerticalPadding: 3,
                                horizontalTitleGap: 3,
                                visualDensity: VisualDensity(vertical: -3),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.check_circle_outline_outlined,
                                  color: ColorSelect.primary,
                                ),
                                title: Text('Advanced reports',
                                    style: TextStyle(color: Colors.white)),
                                minVerticalPadding: 3,
                                horizontalTitleGap: 3,
                                visualDensity: VisualDensity(vertical: -3),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.check_circle_outline_outlined,
                                  color: ColorSelect.primary,
                                ),
                                title: Text('Unlimited doctors',
                                    style: TextStyle(color: Colors.white)),
                                minVerticalPadding: 3,
                                horizontalTitleGap: 3,
                                visualDensity: VisualDensity(vertical: -3),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.check_circle_outline_outlined,
                                  color: ColorSelect.primary,
                                ),
                                title: Text('Treatment communications',
                                    style: TextStyle(color: Colors.white)),
                                minVerticalPadding: 3,
                                horizontalTitleGap: 3,
                                visualDensity: VisualDensity(vertical: -3),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.check_circle_outline_outlined,
                                  color: ColorSelect.primary,
                                ),
                                title: Text('1000 Promotional SMSes',
                                    style: TextStyle(color: Colors.white)),
                                minVerticalPadding: 3,
                                horizontalTitleGap: 3,
                                visualDensity: VisualDensity(vertical: -3),
                              ),
                            ],
                          ),
                        ),

                        // AnimatedContainer(
                        //   duration: const Duration(milliseconds: 120),
                        //   child: new Text(
                        //     "Toggle Me gghhsg hhshgsfsfsddsfsfsgg",
                        //     style: TextStyle(color: Colors.white),
                        //   ),
                        //   height: _animatedHeight,
                        // ),
                      ],
                    ),
                  ),
                ]),
              ),
            )));
  }
}
