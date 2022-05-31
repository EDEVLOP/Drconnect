import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import '../Common/color_select.dart';
import '../Common/urls.dart';
import '../Models/leave_model.dart';
import '../Widgets/drconnect_background.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Calender/widgets/display_field.dart';
import 'Calender/widgets/head_title.dart';

class LeavePage extends StatefulWidget {
  const LeavePage({Key? key}) : super(key: key);

  @override
  State<LeavePage> createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  var uuid = const Uuid();

  int id = 1;
  String radioButtonItem = "FULL DAY";

  final _formKey = GlobalKey<FormState>();
  final reasonLeaveController = TextEditingController();

  FocusNode reasonLeaveFn = FocusNode();

  String startTimeText = "Start time";
  String endTimeText = "End time";
  var startTimeOutlineColor = ColorSelect.secondary;
  var endTimeOutlineColor = ColorSelect.secondary;

  bool selectTimeVisibility = false;
  String startDate = DateFormat('yyyyMMdd').format(DateTime.now());
  String endDate = DateFormat('yyyyMMdd').format(DateTime.now());
  String startTime = "";
  String endTime = "";

  String displayStartDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String displayEndDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  bool isOneDayLeave = true;

  Future? myLeaveList;
  List<LeaveModel> leaveData = [];

  String startDateTimeUpdated = DateTime.now().toString();
  String endDateTimeUpdated = DateTime.now().toString();

  String leaveId = "";
  String reason = "";
  bool isLoading = false;
  bool isEditCLicked = false;

  @override
  void initState() {
    super.initState();
    myLeaveList = _fetchLeaveData();
    log("DateTime: " +
        DateFormat('hh:mm a')
            .format(DateTime.parse("2022-04-30 15:47:00.000Z"))
            .toString());
  }

  @override
  Widget build(BuildContext context) {
    return DrConnectBackground(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(
                'Leave Calender',
                style: TextStyle(color: ColorSelect.secondary),
              ),
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: ColorSelect.secondary),
            ),
            body: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.fromLTRB(8, 8, 0, 0),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Select single or multiple dates",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              )),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 400,
                          child: SfDateRangePicker(
                            todayHighlightColor: ColorSelect.primary,
                            selectionColor: ColorSelect.secondary,
                            startRangeSelectionColor: ColorSelect.secondary,
                            endRangeSelectionColor: ColorSelect.secondary,
                            rangeSelectionColor: ColorSelect.selectedRange,
                            headerHeight: 50,
                            onSelectionChanged: _onSelectionChanged,
                            enableMultiView: false,
                            showTodayButton: false,
                            onSubmit: (Object? value) {
                              if (value != null) {
                                _openDialog();
                              }
                            },

                            viewSpacing: 0,
                            showActionButtons: true,
                            enablePastDates: false,
                            // selectionRadius: 20,
                            selectionMode: DateRangePickerSelectionMode.range,
                            // monthViewSettings: const DateRangePickerMonthViewSettings(enableSwipeSelection: false),
                            // extendableRangeSelectionDirection:
                            //     ExtendableRangeSelectionDirection.forward

                            initialSelectedRange: PickerDateRange(
                                DateTime.parse(startDateTimeUpdated),
                                DateTime.parse(endDateTimeUpdated)),
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
                              "Your Applied Leaves",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                        FutureBuilder(
                          future: myLeaveList,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.only(top: 30.0),
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (leaveData.isEmpty) {
                              return Center(
                                child: Container(
                                  margin: const EdgeInsets.all(40),
                                  child: Column(
                                    children: const [
                                      Image(
                                        image: AssetImage(
                                            "assets/images/warning.png"),
                                        width: 50,
                                        height: 50,
                                      ),
                                      Text("No Leaves Applied")
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Scrollbar(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: leaveData.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            12, 12, 12, 0),
                                        // height: 65,
                                        decoration: BoxDecoration(
                                            color: ColorSelect.bluegrey100,
                                            borderRadius:
                                                BorderRadius.circular(12.0)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 6),
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              width: 240,
                                              child: Column(
                                                // textDirection: TextDirection.ltr,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  const Text(
                                                    "Leave Applied",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  leaveData[index]
                                                              .startDateTime ==
                                                          leaveData[index]
                                                              .endDateTime
                                                      ? Text("On: " +
                                                          DateFormat('dd MMMM yyyy - HH:mm')
                                                              .format(DateTime.parse(
                                                                  leaveData[index]
                                                                      .startDateTime
                                                                      .toString())))
                                                      : Text("From: " +
                                                          DateFormat('dd MMMM yyyy - HH:mm')
                                                              .format(DateTime.parse(
                                                                  leaveData[index]
                                                                      .startDateTime
                                                                      .toString())) +
                                                          " To  " +
                                                          DateFormat('dd MMMM yyyy - HH:mm')
                                                              .format(DateTime.parse(leaveData[index].endDateTime.toString()))),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Note: " +
                                                        leaveData[index]
                                                            .reason
                                                            .toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  right: 8.0),
                                              padding: const EdgeInsets.all(2),
                                              height: 35,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      _showEditDialog(index);
                                                    },
                                                    child: const Image(
                                                      image: AssetImage(
                                                          "assets/images/edit.png"),
                                                      width: 30,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      _deletePop(
                                                          leaveData[index]
                                                              .id
                                                              .toString());
                                                    },
                                                    child: const Image(
                                                      image: AssetImage(
                                                          "assets/images/delete.png"),
                                                      width: 30,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
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
                  )));
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        startDate = DateFormat('yyyyMMdd').format(args.value.startDate);
        endDate = DateFormat('yyyyMMdd').format(args.value.endDate);

        displayStartDate =
            DateFormat('dd-MM-yyyy').format(args.value.startDate);
        displayEndDate = DateFormat('dd-MM-yyyy').format(args.value.endDate);

        if (startDate == endDate) {
          isOneDayLeave = true;
        } else {
          isOneDayLeave = false;
        }

        log(DateFormat('yyyyMMdd').format(args.value.startDate) +
            ", " +
            DateFormat('yyyyMMdd').format(args.value.endDate));
      } else if (args.value is DateTime) {
        // _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        // _dateCount = args.value.length.toString();
      } else {
        //  _rangeCount = args.value.length.toString();
      }
    });
  }

  void _openDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
                insetPadding: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: SingleChildScrollView(
                  child: SizedBox(
                    // height: 350,
                    width: double.infinity,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const SizedBox(
                            height: 15,
                          ),
                          isOneDayLeave
                              ? Text(
                                  "You have selected leave on $displayStartDate",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: ColorSelect.greyBlack,
                                      fontWeight: FontWeight.w300),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "You have selected leave from $displayStartDate to $displayEndDate",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: ColorSelect.greyBlack,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Radio(
                                activeColor: ColorSelect.secondary,
                                value: 1,
                                groupValue: id,
                                onChanged: (val) {
                                  setState(() {
                                    radioButtonItem = 'FULL DAY';
                                    id = 1;
                                    selectTimeVisibility = false;
                                  });
                                },
                              ),
                              const Text(
                                'FULL DAY',
                                style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Radio(
                                value: 2,
                                groupValue: id,
                                activeColor: ColorSelect.secondary,
                                onChanged: (val) {
                                  setState(() {
                                    radioButtonItem = 'CUSTOM';
                                    id = 2;
                                    selectTimeVisibility = true;
                                  });
                                },
                              ),
                              const Text(
                                'CUSTOM',
                                style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Visibility(
                            visible: selectTimeVisibility,
                            child: Container(
                              margin: const EdgeInsets.only(left: 8, right: 8),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: ColorSelect.secondary),
                                  borderRadius: BorderRadius.circular(6.0),
                                  color: ColorSelect.bluegrey100),
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  const HeadTitle(title: "Set time"),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      DisplayField(
                                        textValue: startTimeText,
                                        borderColor: startTimeOutlineColor,
                                        height: 45.0,
                                        width: 100.0,
                                        onTap: () {
                                          _selectTime(
                                              context, "start", setState);
                                        },
                                        textColor: ColorSelect.black,
                                        text: "From",
                                        disable: false,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      DisplayField(
                                        textValue: endTimeText,
                                        borderColor: endTimeOutlineColor,
                                        height: 45.0,
                                        width: 100.0,
                                        onTap: () {
                                          _selectTime(context, "end", setState);
                                        },
                                        textColor: ColorSelect.black,
                                        text: "To",
                                        disable: false,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              style: const TextStyle(fontSize: 13),
                              focusNode: reasonLeaveFn,
                              controller: reasonLeaveController,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  reasonLeaveFn.requestFocus();
                                  return 'Leave reason is empty';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Reason for leave?',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: ColorSelect.secondary,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: ColorSelect.primary,
                                )),
                                hintStyle: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                        "CANCEL",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: ColorSelect.primary,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                const SizedBox(
                                  width: 30,
                                ),
                                InkWell(
                                    onTap: () {
                                      if (radioButtonItem == 'CUSTOM') {
                                        if (startTime == "") {
                                          setState(() {
                                            startTimeOutlineColor = Colors.red;
                                          });
                                        } else if (endTime == "") {
                                          setState(() {
                                            endTimeOutlineColor = Colors.red;
                                          });
                                        } else {
                                          generateRrule("Custom");
                                        }
                                      } else {
                                        generateRrule("Full");
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                        "SUBMIT",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: ColorSelect.primary,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
          });
        });
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
                          'This leave will delete permanently. Do you still want to continue?',
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
                              _deleteLeaveApi(id);
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

  void _showEditDialog(int index) {
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
                            "Do you want to edit leave?",
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
                            Navigator.of(context).pop();
                            setState(() {
                              isLoading = true;
                              isEditCLicked = true;

                              leaveId = leaveData[index].id.toString();
                              startDateTimeUpdated =
                                  leaveData[index].startDateTime.toString();
                              endDateTimeUpdated =
                                  leaveData[index].endDateTime.toString();
                              reasonLeaveController.text =
                                  leaveData[index].reason.toString();

                              displayStartDate = DateFormat('dd-MM-yyyy')
                                  .format(DateTime.parse(leaveData[index]
                                      .startDateTime
                                      .toString()));
                              displayEndDate = DateFormat('dd-MM-yyyy').format(
                                  DateTime.parse(
                                      leaveData[index].endDateTime.toString()));

                              if (displayStartDate == displayEndDate) {
                                isOneDayLeave = true;
                              } else {
                                isOneDayLeave = false;
                              }

                              startDate = DateFormat('yyyyMMdd').format(
                                  DateTime.parse(leaveData[index]
                                      .startDateTime
                                      .toString()));
                              endDate = DateFormat('yyyyMMdd').format(
                                  DateTime.parse(
                                      leaveData[index].endDateTime.toString()));

                              startTimeText = DateFormat('hh:mm').format(
                                  DateTime.parse(leaveData[index]
                                      .startDateTime
                                      .toString()));
                              endTimeText = DateFormat('hh:mm').format(
                                  DateTime.parse(
                                      leaveData[index].endDateTime.toString()));

                              startTime = DateFormat('hhmm').format(
                                      DateTime.parse(leaveData[index]
                                          .startDateTime
                                          .toString())) +
                                  "00Z";
                              endTime = DateFormat('hhmm').format(
                                      DateTime.parse(leaveData[index]
                                          .endDateTime
                                          .toString())) +
                                  "00Z";

                              if (startTimeText == "12:00" &&
                                  endTimeText == "12:00") {
                                radioButtonItem = 'FULL DAY';
                                id = 1;
                                selectTimeVisibility = false;
                              } else {
                                radioButtonItem = 'CUSTOM';
                                id = 2;
                                selectTimeVisibility = true;
                              }
                            });

                            Future.delayed(const Duration(milliseconds: 300),
                                () {
                              setState(() {
                                isLoading = false;
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

  _selectTime(BuildContext context1, String fromClickedField,
      StateSetter setState) async {
    TimeOfDay selectedTime = TimeOfDay.now();
    final timeOfDay = await showTimePicker(
      context: context1,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorSelect.secondary, // header background color
              onPrimary: Colors.black, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: ColorSelect.secondary, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (timeOfDay != null) {
      setState(() {
        String newCurrentHour = "";
        String newCurrentMinute = "";

        if (timeOfDay.hour < 10) {
          newCurrentHour = "0" + timeOfDay.hour.toString();
        } else {
          newCurrentHour = timeOfDay.hour.toString();
        }

        /// format time with 0 at first position if single digit

        if (timeOfDay.minute < 10) {
          newCurrentMinute = "0" + timeOfDay.minute.toString();
        } else {
          newCurrentMinute = timeOfDay.minute.toString();
        }

        /// format time with 0 at first position if single digit

        if (fromClickedField == "start") {
          setState(() {
            startTimeOutlineColor = ColorSelect.secondary;
            startTimeText = newCurrentHour + ":" + newCurrentMinute;
            startTime = newCurrentHour + newCurrentMinute + "00Z";
          });
        } else if (fromClickedField == "end") {
          setState(() {
            endTimeOutlineColor = ColorSelect.secondary;
            endTimeText = newCurrentHour + ":" + newCurrentMinute;
            endTime = newCurrentHour + newCurrentMinute + "00Z";
          });
        }
      });
    } else {
      String newCurrentHour = selectedTime.hour as String;
      String newCurrentMinute = selectedTime.minute as String;

      if (selectedTime.hour < 10) {
        newCurrentHour = "0" + selectedTime.hour.toString();
      } else {
        newCurrentHour = selectedTime.hour.toString();
      }

      /// format time with 0 at first position if single digit

      if (selectedTime.minute < 10) {
        newCurrentMinute = "0" + selectedTime.minute.toString();
      } else {
        newCurrentMinute = selectedTime.minute.toString();
      }

      /// format time with 0 at first position if single digit

      if (fromClickedField == "start") {
        setState(() {
          startTimeOutlineColor = ColorSelect.secondary;
          startTimeText = newCurrentHour + ":" + newCurrentMinute;
          startTime = newCurrentHour + newCurrentMinute + "00Z";
        });
      } else if (fromClickedField == "end") {
        setState(() {
          endTimeOutlineColor = ColorSelect.secondary;
          endTimeText = newCurrentHour + ":" + newCurrentMinute;
          endTime = newCurrentHour + newCurrentMinute + "00Z";
        });
      }
    }
  }

  void generateRrule(String holidayType) {
    if (holidayType == "Custom") {
      String rRule =
          "FREQ=HOURLY;INTERVAL=1;UNTIL=${endDate}T$endTime;X-EWSOFTWARE-DTSTART=${startDate}T$startTime";
      if (isEditCLicked == true) {
        putLeaveApi(rRule);
      } else {
        postLeaveApi(rRule);
      }
    } else {
      String rRule =
          "FREQ=DAILY;INTERVAL=1;UNTIL=${endDate}T000000Z;X-EWSOFTWARE-DTSTART=${startDate}T000000Z";
      if (isEditCLicked == true) {
        putLeaveApi(rRule);
      } else {
        postLeaveApi(rRule);
      }
    }
  }

  Future<void> postLeaveApi(String rRule) async {
    String guid = uuid.v1();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    Map<String, String> header = {
      "requestid": guid,
      "Content-type": "application/json",
      "accept": "text/plain",
      "Authorization": "Bearer " + token,
      "api-version": "1.0"
    };

    var encodedBody =
        json.encode({"rule": rRule, "reason": reasonLeaveController.text});
    log(rRule);

    http.Response response = await http.post(
      Uri.parse(Api.applyLeaveApi),
      headers: header,
      body: encodedBody,
    );

    log("StatusPost: " + response.statusCode.toString());
    if (response.statusCode == 201) {
      var jsonResponse = json.decode(response.body);
      log('LeavePostResponse: ' + jsonResponse);
      Navigator.of(context).pop();
      setState(() {
        myLeaveList = _fetchLeaveData(); // refresh leave list
      });
    } else if (response.statusCode == 400) {
      var jsonResponse = json.decode(response.body);
      var error = jsonResponse['errors']['DomainValidations'][0];
      log("Error: " + error.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: ColorSelect.error,
        content: Text(error),
      ));
    }
  }

  Future<void> _fetchLeaveData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    Map<String, String> header = {
      "Accept": "text/plain",
      "api-version": "1.0",
      "Authorization": "Bearer " + token
    };

    http.Response response =
        await http.get(Uri.parse(Api.fetchLeaveDataApi), headers: header);

    // print("statusCodeLeave: " + response.statusCode.toString());

    if (response.statusCode == 200) {
      leaveData = leaveModelFromJson(response.body);
    }

    // print(leaveData);
  }

  Future _deleteLeaveApi(String id) async {
    String guid = uuid.v1();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    Map<String, String> header = {
      "requestid": guid,
      "Accept": "text/plain",
      "api-version": "1.0",
      "Authorization": "Bearer " + token
    };

    http.Response response =
        await http.delete(Uri.parse(Api.deleteLeaveapi + id), headers: header);

    // print("Status Code " + response.statusCode.toString());
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      setState(() {
        myLeaveList = _fetchLeaveData();
      });
    }
  }

  Future<void> putLeaveApi(String rRule) async {
    String guid = uuid.v1();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    Map<String, String> header = {
      "requestid": guid,
      "Content-type": "application/json",
      "accept": "*/*",
      "Authorization": "Bearer " + token,
      "api-version": "1.0"
    };

    var encodedBody =
        json.encode({"rule": rRule, "reason": reasonLeaveController.text});
    log(rRule);

    http.Response response = await http.put(
      Uri.parse(Api.updateLeaveapi + leaveId),
      headers: header,
      body: encodedBody,
    );

    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      isEditCLicked = false;
      Navigator.of(context).pop();
      setState(() {
        myLeaveList = _fetchLeaveData(); // refresh leave list
      });
    } else if (response.statusCode == 400) {
      var jsonResponse = json.decode(response.body);
      var error = jsonResponse['errors']['DomainValidations'][0];
      log("Error: " + error.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: ColorSelect.error,
        content: Text(error),
      ));
    }
  }
}
