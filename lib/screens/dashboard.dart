import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:developer';
import 'dart:ffi';
import 'package:doctor_app_connect/Common/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:doctor_app_connect/Widgets/drconnect_background.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import '../Common/color_select.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:shimmer/shimmer.dart';

Future<List<Data>> fetchData() async {
  final response =
      await http.get(Uri.parse("https://jsonplaceholder.typicode.com/albums"));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Data.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  late Future<List<Data>> futureData;
  // final CalendarController _controller = CalendarController();
  String? _text = '', _titleText = '';
  bool isLoading = true;

  //...............Calendar............................//
  CalendarFormat _calendarFormat = CalendarFormat.week;

  Map<CalendarFormat, String> availableCalendarFormats = const {
    CalendarFormat.month: 'Month',
    CalendarFormat.twoWeeks: '2 weeks',
    CalendarFormat.week: 'Week'
  };

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  DateTime? currentDay;

  String today = DateFormat("yyyy-MM-dd").format(DateTime.now());

  String? name;
  List<String> specialization = [];
  String experience = '';
  String profileImage = '';

  bool pageJumpingEnabled = false;
  bool pageAnimationEnable = false;

  List weekList = [];

  double centPercent = 100;

  int? bookedData;
  int? monthBooked;
  int? totalData;
  int? monthTotal;
  int? weekBooked;

  List<ChartData> chartData = [
    ChartData('Booked', 0, Colors.cyan),
    ChartData('Total', 100, ColorSelect.grey400),
  ];

  List<MonthlyChartData> monthlyChartData = [
    MonthlyChartData('Booked', 0, Colors.cyan),
    MonthlyChartData('Total', 0, ColorSelect.grey400),
  ];

  List<ChartData1> barData = [
    ChartData1('Mon', 0, ColorSelect.blueShade800),
    ChartData1('Tue', 0, ColorSelect.blueShade800),
    ChartData1('Wed', 0, Color.fromARGB(255, 236, 105, 44)),
    ChartData1('Thur', 0, ColorSelect.blueShade800),
    ChartData1('Fri', 0, ColorSelect.blueShade800),
    ChartData1('Sat', 0, ColorSelect.blueShade800),
    ChartData1('Sun', 0, ColorSelect.blueShade800),
  ];

  String token = '';

  @override
  void initState() {
    Future.delayed(Duration(seconds: 5)).then((value) {
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
    futureData = fetchData();
    getSharedPref();
    getTodaysData();
    getMonthlyData();
    getWeekData();
  }

  @override
  Widget build(BuildContext context) {
    //log("enter " + bookedData.toString());

    void calendarTapped(CalendarTapDetails details) {
      if (details.targetElement == CalendarElement.header) {
        _text = DateFormat('MMMM yyyy').format(details.date!);
        _titleText = 'Header';
      } else if (details.targetElement == CalendarElement.viewHeader) {
        _text = DateFormat('EEEE dd, MMMM yyyy').format(details.date!);
        _titleText = 'View Header';
      } else if (details.targetElement == CalendarElement.calendarCell) {
        _text = DateFormat('dd-MM-yyyy').format(details.date!);
        _titleText = 'Calendar cell';
      }

      //print(" $_text");

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(" $_titleText"),
              content: Text(" $_text"),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('close'))
              ],
            );
          });
    }

    return DrConnectBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: isLoading
              ? Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 3.0, bottom: 3.0, left: 0.0, right: 0.0),
                          child: Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.0),
                                  color: ColorSelect.grey200),
                              child: Shimmer.fromColors(
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                  baseColor: ColorSelect.grey200,
                                  highlightColor: Colors.white)),
                        );
                      }),
                )
              : Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(6.0),
                          color: ColorSelect.grey200),
                      height: 120,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: profileImage != ''
                                  ? profilePictureView(token, profileImage)
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(8),

                                      child: const FadeInImage(
                                          placeholder: AssetImage(
                                              "assets/images/pic2.jpg"),
                                          image: AssetImage(
                                              "assets/images/pic2.jpg")),
                                      // ClipRRect(
                                      //   borderRadius: BorderRadius.circular(6),
                                      // Image(
                                      //   image: AssetImage("assets/images/pic2.jpg"),
                                      // ),
                                    ),
                            ),

                            //...............USER INFO............................//
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16.0, bottom: 6.0),
                                    child: Text(name ?? "",
                                        style: const TextStyle(fontSize: 16)
                                        //.copyWith(color: Colors.white),
                                        ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Text(
                                        specialization.join(', ').toString(),
                                        style: const TextStyle(fontSize: 14)
                                        //.copyWith(color: Colors.white)
                                        ),
                                  ),
                                  Text(experience + " " + "Years",
                                      style: const TextStyle(fontSize: 14)
                                      //.copyWith(color: Colors.white)
                                      ),
                                ],
                              ),
                            )
                          ]),
                    ),
                    SizedBox(
                      height: 160,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(top: 12, left: 12),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                color: Color.fromARGB(46, 114, 241, 171),
                                //color: ColorSelect.grey200,
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: ColorSelect.grey400,
                                //     blurRadius: 5.0, // soften the shadow
                                //     spreadRadius: 2.0, //extend the shadow
                                //     offset: Offset(
                                //       3.0, // Move to right 10  horizontally
                                //       3.0, // Move to bottom 10 Vertically
                                //     ),
                                //   )
                                // ],
                              ),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                  SfCircularChart(
                                    series: <CircularSeries>[
                                      DoughnutSeries<ChartData, String>(
                                        dataSource: chartData,
                                        pointColorMapper: (ChartData data, _) =>
                                            data.color,
                                        xValueMapper: (ChartData data, _) =>
                                            data.x,
                                        yValueMapper: (ChartData data, _) =>
                                            data.y,
                                        startAngle:
                                            230, // Starting angle of doughnut
                                        endAngle: 130,

                                        // Ending angle of doughnut
                                      )
                                    ],
                                  ),
                                  Container(
                                    height: 80,
                                    //color: Colors.grey,
                                    margin: const EdgeInsets.only(bottom: 20.0),
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        Text(
                                          "___",
                                          style: TextStyle(fontSize: 18),
                                          textAlign: TextAlign.right,
                                        ),
                                        Text(
                                          totalData.toString(),
                                          style: TextStyle(fontSize: 15),
                                          textAlign: TextAlign.right,
                                        ),
                                        SizedBox(
                                          height: 13.9,
                                        ),
                                        const Text(
                                          "Today's Appointments",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.right,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 20,
                                    margin: const EdgeInsets.only(bottom: 80.0),
                                    alignment: Alignment.center,
                                    // color: ColorSelect.grey200,
                                    child: Text(
                                      bookedData.toString(),
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // ),
                          ),
                          Expanded(
                            child: Container(
                              margin:
                                  EdgeInsets.only(top: 12, right: 12, left: 12),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                color: Color.fromARGB(45, 229, 187, 110),
                                //color: ColorSelect.grey200,
                                // boxShadow: [

                                //   BoxShadow(

                                //     color: ColorSelect.grey400,
                                //     blurRadius: 5.0, // soften the shadow
                                //     spreadRadius: 2.0, //extend the shadow
                                //     offset: Offset(
                                //       3.0, // Move to right 10  horizontally
                                //       3.0, // Move to bottom 10 Vertically
                                //     ),
                                //   )
                                // ],
                              ),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                  SfCircularChart(
                                    series: <CircularSeries>[
                                      DoughnutSeries<MonthlyChartData, String>(
                                        dataSource: monthlyChartData,
                                        pointColorMapper:
                                            (MonthlyChartData data, _) =>
                                                data.color,
                                        xValueMapper:
                                            (MonthlyChartData data, _) =>
                                                data.x,
                                        yValueMapper:
                                            (MonthlyChartData data, _) =>
                                                data.y,
                                        startAngle:
                                            230, // Starting angle of doughnut
                                        endAngle:
                                            130, // Ending angle of doughnut
                                      )
                                    ],
                                  ),
                                  Container(
                                    height: 80,
                                    margin: const EdgeInsets.only(bottom: 20.0),
                                    alignment: Alignment.center,
                                    //color: ColorSelect.grey200,
                                    child: Column(
                                      children: [
                                        Text(
                                          "___",
                                          style: TextStyle(fontSize: 18),
                                          textAlign: TextAlign.right,
                                        ),
                                        Text(
                                          monthTotal.toString(),
                                          style: TextStyle(fontSize: 15),
                                          textAlign: TextAlign.right,
                                        ),
                                        SizedBox(
                                          height: 13.9,
                                        ),
                                        const Text(
                                          "Monthly Appointments",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.right,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 20,
                                    margin: const EdgeInsets.only(bottom: 80.0),
                                    alignment: Alignment.center,
                                    //color: ColorSelect.grey200,
                                    child: Text(
                                      monthBooked.toString(),
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.fromLTRB(12, 10, 12, 4),
                      //color: ColorSelect.blue,
                      child: Column(children: <Widget>[
                        const Text(
                          "This Week",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          //textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              // border: Border.all(
                              // color: Color.fromARGB(255, 120, 180, 228)),
                              borderRadius: BorderRadius.circular(6.0),
                              color: ColorSelect.grey200,
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 152, 152, 152),
                                  blurRadius: 4.0,
                                  spreadRadius: 1.0,
                                  offset: Offset(1.0,
                                      2.0), // shadow direction: bottom right
                                )
                              ],
                            ),
                            child: SfCartesianChart(
                                margin: const EdgeInsets.only(top: 0),
                                // backgroundColor: ColorSelect.grey200,
                                //borderColor: Colors.black,
                                plotAreaBorderWidth: 0,
                                primaryXAxis: CategoryAxis(
                                  majorGridLines:
                                      const MajorGridLines(width: 0),
                                  axisLine: const AxisLine(width: 0),
                                ),
                                primaryYAxis: NumericAxis(
                                  isVisible: true,
                                  labelAlignment: LabelAlignment.start,
                                  // labelStyle: const TextStyle(fontSize: 0),
                                  // majorGridLines: const MajorGridLines(width: 0),
                                  // axisLine: const AxisLine(width: 1)
                                ),
                                series: <ChartSeries<ChartData1, String>>[
                                  // Renders column chart
                                  ColumnSeries<ChartData1, String>(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(6),
                                          topRight: Radius.circular(6)),
                                      dataSource: barData,
                                      pointColorMapper: (ChartData1 data, _) =>
                                          data.color1,
                                      xValueMapper: (ChartData1 data, _) =>
                                          data.x1,
                                      yValueMapper: (ChartData1 data, _) =>
                                          data.y1)
                                ]),
                          ),
                        )
                      ]),
                    ),
                    Container(
                      alignment: Alignment.center,
                      //color: Colors.amber,
                      //height: 30,
                      margin: const EdgeInsets.fromLTRB(12, 10, 12, 3),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Calender & Appointment",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                    Container(
                      // padding: const EdgeInsets.symmetric(horizontal: 8),
                      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),

                      decoration: BoxDecoration(
                        // border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(6.0),
                        color: ColorSelect.grey200,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 1.0,
                            spreadRadius: 0.0,
                            offset: Offset(
                                1.0, 1.0), // shadow direction: bottom right
                          )
                        ],
                      ),
                      child: TableCalendar(
                        firstDay: DateTime.utc(2010, 10, 16),
                        lastDay: DateTime.utc(2030, 3, 14),
                        focusedDay: DateTime.now(),
                        availableGestures: AvailableGestures.horizontalSwipe,

                        calendarStyle: const CalendarStyle(
                          // Use `CalendarStyle` to customize the UI
                          outsideDaysVisible: false,
                          selectedDecoration: BoxDecoration(
                            color: Color.fromARGB(255, 230, 122, 34),
                            shape: BoxShape.circle,
                          ),

                          todayDecoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),

                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDay, day),
                        // rangeStartDay: _rangeStart,
                        // rangeEndDay: _rangeEnd,
                        calendarFormat: _calendarFormat,
                        pageJumpingEnabled: false,
                        pageAnimationEnabled: false,

                        //rangeSelectionMode: _rangeSelectionMode,
                        onDaySelected: (selectedDay, focusedDay) {
                          if (!isSameDay(_selectedDay, selectedDay)) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                              _rangeStart = null; // Important to clean those
                              _rangeEnd = null;
                              // _rangeSelectionMode = RangeSelectionMode.toggledOff;
                            });

                            print("DATE " + currentDay.toString());
                          }
                        },

                        // onRangeSelected: (start, end, focusedDay) {
                        //   setState(() {
                        //     _selectedDay = null;
                        //     _focusedDay = focusedDay;
                        //     _rangeStart = start;
                        //     _rangeEnd = end;
                        //     _rangeSelectionMode = RangeSelectionMode.toggledOn;
                        //   });
                        // },
                        onFormatChanged: (format) {
                          if (_calendarFormat != format) {
                            setState(() {
                              _calendarFormat = format;
                            });
                          }
                        },
                        onPageChanged: (focusedDay) {
                          _focusedDay = focusedDay;
                        },
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(top: 10, bottom: 0, left: 12),
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Appointment List",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      height: 320,
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                      child: FutureBuilder(
                          future: futureData,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              List<Data> data = snapshot.data;
                              return ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      margin:
                                          const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                      //height: 90,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.blue),
                                        color: ColorSelect.bluegrey100,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      //                   //color: Colors.white,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            margin:
                                                const EdgeInsets.only(left: 6),
                                            padding: const EdgeInsets.all(4.0),
                                            width: 240,
                                            child: Column(
                                              // textDirection: TextDirection.TL,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  data[index].title,
                                                ),
                                                Text(data[index].id.toString() +
                                                    "1234"),
                                                const Text("9am-12pm"),
                                                const Text(
                                                    "Plot no. 251, Sainik School Rd")
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: 8.0, top: 8, bottom: 8),
                                            padding: const EdgeInsets.all(3),
                                            //height: 35,
                                            width: 70,
                                            decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(8.0)),

                                            child:
                                                Column(children: const <Widget>[
                                              Text(
                                                "Total",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                "Booking",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                "8",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ]),

                                            //color: Colors.pinkAccent,
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            } else {
                              if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              }
                              return const CircularProgressIndicator();
                              //           //return Text("");
                            }
                          }),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget profilePictureView(String token, String pimage) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      child: CachedNetworkImage(
          imageUrl: Api.getUploadImageApi + pimage,
          height: MediaQuery.of(context).size.height,
          width: 100.0,
          placeholder: (context, url) => Container(
                child: Image(image: AssetImage("assets/images/pic2.jpg")),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8)),
                //backgroundColor: Colors.white,
                //radius: 10,
              ),
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => const Icon(Icons.error),
          httpHeaders: {"Authorization": "Bearer " + token}),
    );
  }

  Future<void> getSharedPref() async {
    var prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name') ?? "Guest user";
    specialization = prefs.getStringList('specialization') ?? [];
    experience = prefs.getString('experience') ?? "Experience";
    profileImage = prefs.getString('image') ?? '';

    setState(() {});

    log("NAME" + name.toString());
    log("EXP " + experience.toString());
    log("SPE " + specialization.toString());
    log("IMG " + profileImage.toString());
  }

  Future<void> getTodaysData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final userId = prefs.getString('userId') ?? '';

    log("Date  Time  " + today.toString());

    Map<String, String> header = {"Authorization": "Bearer " + token};

    http.Response response = await http.get(
      Uri.parse(Api.dounutChartApi +
          "startDateTime=" +
          today.toString() +
          "&" +
          "endDateTime=" +
          today.toString()),
      headers: header,
    );

    if (response.body.isNotEmpty) {
      var jsonResponse = json.decode(response.body);
      bookedData = (jsonResponse["booked"] ?? 0);
      totalData = (jsonResponse["total"] ?? 0);

      double tbookDetail = double.parse(bookedData.toString()) /
          double.parse(totalData.toString()) *
          centPercent;

      setState(() {
        chartData = [
          ChartData(
              'Booked', double.parse(tbookDetail.toString()), Colors.cyan),
          ChartData('Total', double.parse(centPercent.toString()),
              ColorSelect.grey400),
        ];
      });
    }
  }

  Future<void> getMonthlyData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final userId = prefs.getString('userId') ?? '';

    currentDay = DateTime.now();
    var fday = DateTime(currentDay!.year, currentDay!.month, 1);
    var lday = DateTime(currentDay!.year, currentDay!.month + 1, 0);

    log("DAYS " + fday.toString() + " " + lday.toString());

    Map<String, String> header = {"Authorization": "Bearer " + token};

    http.Response response = await http.get(
      Uri.parse(Api.dounutChartApi +
          "startDateTime=" +
          fday.toString() +
          "&" +
          "endDateTime=" +
          lday.toString()),
      headers: header,
    );

    if (response.body.isNotEmpty) {
      var jsonResponse = json.decode(response.body);
      monthBooked = (jsonResponse["booked"] ?? 0);
      monthTotal = (jsonResponse["total"] ?? 0);

      double bookDetail = double.parse(monthBooked.toString()) /
          double.parse(monthTotal.toString()) *
          centPercent;

      log('Result...= ' + bookDetail.toString());

      setState(() {
        monthlyChartData = [
          MonthlyChartData(
              'Booked', double.parse(bookDetail.toString()), Colors.cyan),
          MonthlyChartData('Total', double.parse(centPercent.toString()),
              ColorSelect.grey400),
        ];
      });
    }
  }

  Future<void> getWeekData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final userId = prefs.getString('userId') ?? '';

    DateTime now = DateTime.now();
    int currentDay1 = now.weekday;
    DateTime firstDayOfWeek = now.subtract(Duration(days: currentDay1 - 1));
    DateTime lastDayOfWeek = now.subtract(Duration(days: currentDay1 - 7));

    Map<String, String> header = {"Authorization": "Bearer " + token};

    http.Response response = await http.get(
      Uri.parse(Api.barGraphChartApi +
          "startDateTime=" +
          firstDayOfWeek.toString() +
          "&" +
          "endDateTime=" +
          lastDayOfWeek.toString()),
      headers: header,
    );

    if (response.body.isNotEmpty) {
      //var jsonResponse = json.decode(response.body);
      var userLeave = jsonDecode(response.body.toString());
      //weekBooked = (jsonResponse["booked"] ?? 0);
      if (response.statusCode == 200) {
        for (Map i in userLeave) {
          var booked = i["booked"].toString();
          //var endTime = i["endDateTime"];

          weekList.add(booked);

          log("BOOKED  " + booked);
        }
        print(weekList[0]);
      }

      setState(() {
        barData = [
          ChartData1('Mon', int.parse(weekList[0]), ColorSelect.blueShade800),
          ChartData1('Tue', int.parse(weekList[1]), ColorSelect.lightblue200),
          ChartData1('Wed', int.parse(weekList[2]),
              Color.fromARGB(240, 241, 150, 108)),
          ChartData1('Thu', int.parse(weekList[3]), ColorSelect.blueShade800),
          ChartData1('Fri', int.parse(weekList[4]), ColorSelect.lightblue200),
          ChartData1('Sat', int.parse(weekList[5]), ColorSelect.blue),
          ChartData1('Sun', int.parse(weekList[6]), ColorSelect.purple)
        ];
      });
    }
    // log("WEEK " + weekBooked.toString());
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}

class MonthlyChartData {
  MonthlyChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}

class ChartData1 {
  ChartData1(this.x1, this.y1, this.color1);
  final String x1;
  final int y1;
  final Color color1;
}

class Data {
  final int userId;
  final int id;
  final String title;

  Data({required this.userId, required this.id, required this.title});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}
