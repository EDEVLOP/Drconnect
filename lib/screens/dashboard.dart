import 'dart:convert';
import 'dart:developer';
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
  //Color? _headerColor, _viewHeaderColor, _calendarColor;

  //...............Calendar............................//
  CalendarFormat _calendarFormat = CalendarFormat.month;

  Map<CalendarFormat, String> availableCalendarFormats = const {
    //CalendarFormat.month: 'Month',
    //CalendarFormat.twoWeeks: '2 weeks',
    CalendarFormat.week: 'Week'
  };

  //RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
  // .toggledOn; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  String? name;
  List<String> specialization = [];
  String experience = '';

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
    getSharedPref();
    getLeaveData();
  }

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('David', 45, ColorSelect.lightblue200),
      ChartData('Steve', 55, const Color.fromARGB(255, 51, 240, 30)),
      ChartData('Jack', 34, ColorSelect.blueShade800),
      ChartData('Others', 22, Colors.cyan)
    ];

    final List<ChartData1> barData = [
      ChartData1('Mon', 8, ColorSelect.blueShade800),
      ChartData1('Tue', 7, ColorSelect.lightblue200),
      ChartData1('Wed', 9, ColorSelect.grey400),
      ChartData1('Thu', 10, ColorSelect.blueShade800),
      ChartData1('Fri', 8, ColorSelect.lightblue200),
      ChartData1('Sat', 5, ColorSelect.lightblue200),
      ChartData1('Sun', 8, ColorSelect.bluegrey100)
    ];

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
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(6.0),
                    //color: const Color(0xd7e2e5e3)
                    color: ColorSelect.grey200),
                height: 110,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(14),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: const Image(
                            image: AssetImage("assets/images/pic2.jpg"),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 16.0, bottom: 6.0),
                              child: Text(name ?? "",
                                  style: const TextStyle(fontSize: 16)
                                  //.copyWith(color: Colors.white),
                                  ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Text(specialization.join(', ').toString(),
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
                //color: ColorSelect.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      //   child: Container(
                      // color: ColorSelect.greenshade900,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          SfCircularChart(
                            series: <CircularSeries>[
                              DoughnutSeries<ChartData, String>(
                                  dataSource: chartData,
                                  pointColorMapper: (ChartData data, _) =>
                                      data.color,
                                  xValueMapper: (ChartData data, _) => data.x,
                                  yValueMapper: (ChartData data, _) => data.y,
                                  startAngle: 230, // Starting angle of doughnut
                                  endAngle: 130 // Ending angle of doughnut
                                  )
                            ],
                          ),
                          Container(
                            height: 20,
                            margin: const EdgeInsets.only(bottom: 10.0),
                            alignment: Alignment.center,
                            //color: ColorSelect.grey200,
                            child: const Text(
                              "Today's Booking",
                              style: TextStyle(fontSize: 15),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          Container(
                            height: 20,
                            margin: const EdgeInsets.only(bottom: 70.0),
                            alignment: Alignment.center,
                            //color: ColorSelect.grey200,
                            child: const Text(
                              "10",
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      // ),
                    ),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          SfCircularChart(
                            series: <CircularSeries>[
                              DoughnutSeries<ChartData, String>(
                                  dataSource: chartData,
                                  pointColorMapper: (ChartData data, _) =>
                                      data.color,
                                  xValueMapper: (ChartData data, _) => data.x,
                                  yValueMapper: (ChartData data, _) => data.y,
                                  startAngle: 230, // Starting angle of doughnut
                                  endAngle: 130 // Ending angle of doughnut
                                  )
                            ],
                          ),
                          Container(
                            height: 20,
                            margin: const EdgeInsets.only(bottom: 10.0),
                            alignment: Alignment.center,
                            //color: ColorSelect.grey200,
                            child: const Text(
                              "Monthly Booking",
                              style: TextStyle(fontSize: 15),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          Container(
                            height: 20,
                            margin: const EdgeInsets.only(bottom: 70.0),
                            alignment: Alignment.center,
                            //color: ColorSelect.grey200,
                            child: const Text(
                              "400",
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
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
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(6.0),
                          //color: const Color(0xd7e2e5e3)
                          color: ColorSelect.grey200),
                      child: SfCartesianChart(
                          margin: const EdgeInsets.only(top: 0),
                          // backgroundColor: ColorSelect.grey200,
                          //borderColor: Colors.black,
                          plotAreaBorderWidth: 0,
                          primaryXAxis: CategoryAxis(
                            majorGridLines: const MajorGridLines(width: 0),
                            axisLine: const AxisLine(width: 0),
                          ),
                          primaryYAxis: NumericAxis(
                              isVisible: false,
                              labelStyle: const TextStyle(fontSize: 0),
                              majorGridLines: const MajorGridLines(width: 0),
                              axisLine: const AxisLine(width: 0)),
                          series: <ChartSeries<ChartData1, String>>[
                            // Renders column chart
                            ColumnSeries<ChartData1, String>(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    topRight: Radius.circular(6)),
                                dataSource: barData,
                                pointColorMapper: (ChartData1 data, _) =>
                                    data.color1,
                                xValueMapper: (ChartData1 data, _) => data.x1,
                                yValueMapper: (ChartData1 data, _) => data.y1)
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
              Container(
                // padding: const EdgeInsets.symmetric(horizontal: 8),
                margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                // decoration: BoxDecoration(
                //     border: Border.all(color: Colors.blue),
                //     borderRadius: BorderRadius.circular(6.0),
                //     color: ColorSelect.grey200),
                child: TableCalendar(
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: DateTime.now(),

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

                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  // rangeStartDay: _rangeStart,
                  // rangeEndDay: _rangeEnd,
                  calendarFormat: _calendarFormat,

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
                      DateTime currentDay = DateTime.now();
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
                margin: const EdgeInsets.only(top: 10, bottom: 0, left: 12),
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
                height: 250,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: FutureBuilder(
                    future: futureData,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        List<Data> data = snapshot.data;
                        return ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                //height: 90,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blue),
                                  color: ColorSelect.bluegrey100,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                //                   //color: Colors.white,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(left: 6),
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

                                      child: Column(children: const <Widget>[
                                        Text(
                                          "Total",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          "Booking",
                                          style: TextStyle(color: Colors.white),
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

  Future<void> getSharedPref() async {
    var prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name') ?? '';
    specialization = prefs.getStringList('specialization') ?? [];
    experience = prefs.getString('experience') ?? '';

    setState(() {});

    log("NAME" + name.toString());
    log("EXP " + experience.toString());
    log("SPE " + specialization.toString());
  }

  Future<void> getLeaveData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final userId = prefs.getString('userId') ?? '';

    Map<String, String> header = {
      "Accept": "*/*",
      "Authorization": "Bearer " + token
    };

    http.Response response = await http.get(
      Uri.parse(Api.dashboardLeaveData + "2022-05-29" + "&" + "2022-05-29"),
      headers: header,
    );

    if (response.body.isNotEmpty) {
      var jsonResponse = json.decode(response.body);
      log('message ' + jsonResponse.toString());
    }
  }
}

// class DateFormat {
//   DateFormat(String s);

//   format(DateTime s) {}
// }

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}

class ChartData1 {
  ChartData1(this.x1, this.y1, this.color1);
  final String x1;
  final double y1;
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
