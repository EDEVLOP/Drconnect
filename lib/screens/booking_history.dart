import 'dart:developer';
import 'package:doctor_app_connect/screens/Calender/calendar_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:uuid/uuid.dart';
import '../Common/color_select.dart';
import '../Common/urls.dart';
import '../Models/booking_model.dart';
import '../Widgets/drconnect_background.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class BookingHistoryPage extends StatefulWidget {
  const BookingHistoryPage({Key? key}) : super(key: key);

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  var uuid = const Uuid();

  bool isLoading = false;
  Future? myBookingsList;
  List<BookingModel> bookingsData = [];
  String startDateTimeUpdated = DateTime.now().toString();
  String endDateTimeUpdated = DateTime.now().toString();

  @override
  void initState() {
    super.initState();
    myBookingsList = _fetchBookingsData();
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
          "Manage Appointments",
          style: TextStyle(color: ColorSelect.secondary),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 280,
                    child: IgnorePointer(
                      ignoring: true,
                      child: SfDateRangePicker(
                        todayHighlightColor: ColorSelect.primary,
                        selectionColor: ColorSelect.secondary,
                        startRangeSelectionColor: ColorSelect.secondary,
                        endRangeSelectionColor: ColorSelect.secondary,
                        rangeSelectionColor: ColorSelect.secondary,
                        headerHeight: 40,
                        enableMultiView: false,
                        showTodayButton: false,
                        viewSpacing: 0,
                        showActionButtons: false,
                        enablePastDates: false,
                        // selectionRadius: 20,
                        selectionMode: DateRangePickerSelectionMode.range,
                        // monthViewSettings: const DateRangePickerMonthViewSettings(enableSwipeSelection: false),
                        // extendableRangeSelectionDirection:
                        //     ExtendableRangeSelectionDirection.forward

                        initialSelectedRange: PickerDateRange(
                            DateTime.parse("2022-05-17"),
                            DateTime.parse("2022-05-19")),

                        initialSelectedRanges: [],

                        view: DateRangePickerView.month,
                        monthViewSettings:
                            DateRangePickerMonthViewSettings(blackoutDates: [
                          DateTime(2022, 05, 26),
                          DateTime(2022, 05, 27)
                        ], weekendDays: const [], specialDates: [
                          DateTime(2022, 05, 20),
                          DateTime(2022, 05, 16),
                          DateTime(2022, 05, 17),
                        ], showTrailingAndLeadingDates: true),
                        monthCellStyle: DateRangePickerMonthCellStyle(
                          blackoutDatesDecoration: BoxDecoration(
                              color: Colors.red,
                              border: Border.all(
                                  color: const Color(0xFFF44436), width: 1),
                              shape: BoxShape.circle),
                          weekendDatesDecoration: BoxDecoration(
                              color: const Color(0xFFDFDFDF),
                              border: Border.all(
                                  color: const Color(0xFFB6B6B6), width: 1),
                              shape: BoxShape.circle),
                          specialDatesDecoration: BoxDecoration(
                              color: Colors.amber,
                              border: Border.all(color: Colors.amber, width: 1),
                              shape: BoxShape.circle),
                          blackoutDateTextStyle: const TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.lineThrough),
                          specialDatesTextStyle:
                              const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 0),
                    width: MediaQuery.of(context).size.width,
                    color: ColorSelect.secondary,
                    //height: 40,
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Your Appointments",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: myBookingsList,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 30.0),
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (bookingsData.isEmpty) {
                        return Center(
                          child: Container(
                            margin: const EdgeInsets.all(40),
                            child: Column(
                              children: const [
                                Image(
                                  image:
                                      AssetImage("assets/images/warning.png"),
                                  width: 50,
                                  height: 50,
                                ),
                                Text("No Bookings Done")
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Scrollbar(
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: bookingsData.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(12, 12, 12, 0),
                                  decoration: BoxDecoration(
                                      color: ColorSelect.bluegrey100,
                                      borderRadius:
                                          BorderRadius.circular(12.0)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        margin: const EdgeInsets.only(left: 6),
                                        padding: const EdgeInsets.all(8.0),
                                        width:
                                            MediaQuery.of(context).size.width -
                                                30,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              bookingsData[index]
                                                  .clinicName
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: bookingsData[index]
                                                    .slots!
                                                    .length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int innerIndex) {
                                                  return Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Text(
                                                              "Start Time: " +
                                                                  DateFormat('dd MMMM yyyy').format(DateTime.parse(bookingsData[
                                                                          index]
                                                                      .slots![
                                                                          innerIndex]
                                                                      .startDate
                                                                      .toString())) +
                                                                  " - " +
                                                                  bookingsData[
                                                                          index]
                                                                      .slots![
                                                                          innerIndex]
                                                                      .startTime
                                                                      .toString(),
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300),
                                                            ),
                                                            Text(
                                                              "End Time: " +
                                                                  DateFormat('dd MMMM yyyy').format(DateTime.parse(bookingsData[
                                                                          index]
                                                                      .slots![
                                                                          innerIndex]
                                                                      .endDate
                                                                      .toString())) +
                                                                  " - " +
                                                                  bookingsData[
                                                                          index]
                                                                      .slots![
                                                                          innerIndex]
                                                                      .endTime
                                                                      .toString(),
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            InkWell(
                                                              onTap: () {
                                                                _showEditDialog(
                                                                    index,
                                                                    innerIndex);
                                                              },
                                                              child:
                                                                  const Image(
                                                                image: AssetImage(
                                                                    "assets/images/edit.png"),
                                                                width: 25,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                _deletePop(bookingsData[
                                                                        index]
                                                                    .slots![
                                                                        innerIndex]
                                                                    .id
                                                                    .toString());
                                                              },
                                                              child:
                                                                  const Image(
                                                                image: AssetImage(
                                                                    "assets/images/delete.png"),
                                                                width: 25,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                          ],
                                        ),
                                      ),
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

  Future<void> _fetchBookingsData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    Map<String, String> header = {
      "Accept": "text/plain",
      "api-version": "1.0",
      "Authorization": "Bearer " + token
    };

    http.Response response =
        await http.get(Uri.parse(Api.fetchBookingsApi), headers: header);

    // log("statusCode: "+response.statusCode.toString());
    //  log("dataaa: "+ response.body.toString());
    if (response.statusCode == 200) {
      bookingsData = bookingModelFromJson(response.body);
    }
  }

  void _deletePop(String id) {
    showDialog(
        context: context,
        barrierDismissible: true,
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
                    children: const <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 12, right: 12, top: 8),
                        child: Text(
                          'Yours bookings will be deleted permanently. Do you still want to continue?',
                          textAlign: TextAlign.center,
                        ),
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
                              side:
                                  const BorderSide(color: Colors.red, width: 1),
                            ),
                            child: const Text(
                              "Delete",
                              style: TextStyle(fontSize: 12, color: Colors.red),
                            ),
                            onPressed: () {
                              _deleteBookingApi(id);
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

  void _showEditDialog(int index, int innerIndex) {
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
                            "Do you want to edit bookings?",
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
                            String clinicName =
                                bookingsData[index].clinicName.toString();
                            String clinicId =
                                bookingsData[index].clinicId.toString();
                            String id = bookingsData[index]
                                .slots![innerIndex]
                                .id
                                .toString();
                            String startDate = bookingsData[index]
                                .slots![innerIndex]
                                .startDate
                                .toString();
                            String endDate = bookingsData[index]
                                .slots![innerIndex]
                                .endDate
                                .toString();
                            String startTime = bookingsData[index]
                                .slots![innerIndex]
                                .startTime
                                .toString();
                            String endTime = bookingsData[index]
                                .slots![innerIndex]
                                .endTime
                                .toString();
                            int slot =
                                bookingsData[index].slots![innerIndex].slot!;
                            String slotSelector = bookingsData[index]
                                .slots![innerIndex]
                                .slotSelector
                                .toString();
                            String intervalSelector = bookingsData[index]
                                .slots![innerIndex]
                                .intervalSelector
                                .toString();
                            int numberOfPatients = bookingsData[index]
                                .slots![innerIndex]
                                .numberOfPatients!;
                            List<String>? byDays =
                                bookingsData[index].slots![innerIndex].byDays;

                            Navigator.of(context).pop();
                            var future = Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CalendarPage(
                                      clinicName: clinicName,
                                      clinicId: clinicId,
                                      id: id,
                                      startDate: startDate,
                                      endDate: endDate,
                                      startTime: startTime,
                                      endTime: endTime,
                                      slot: slot,
                                      slotSelector: slotSelector,
                                      intervalSelector: intervalSelector,
                                      numberOfPatients: numberOfPatients,
                                      byDays: byDays),
                                ));

                            future.then((value) {
                              log("REceive: " + value);

                              /// upadte the screen here
                              setState(() {
                                myBookingsList = _fetchBookingsData();
                              });
                            });
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

  Future _deleteBookingApi(String id) async {
    String guid = uuid.v1();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    Map<String, String> header = {
      "requestid": guid,
      "Accept": "text/plain",
      "api-version": "1.0",
      "Authorization": "Bearer " + token
    };

    http.Response response = await http
        .delete(Uri.parse(Api.deleteBookingapi + id), headers: header);

    log("Status Code " + response.statusCode.toString());
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      setState(() {
        myBookingsList = _fetchBookingsData();
      });
    }
  }
}
