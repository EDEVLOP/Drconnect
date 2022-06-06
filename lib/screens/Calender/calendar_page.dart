import 'dart:developer';
import 'package:doctor_app_connect/Models/visiting_tray_model.dart';
import 'package:doctor_app_connect/screens/Calender/widgets/display_field.dart';
import 'package:doctor_app_connect/screens/Calender/widgets/day_tile.dart';
import 'package:doctor_app_connect/screens/Calender/widgets/dropdown_clinic_name.dart';
import 'package:doctor_app_connect/screens/Calender/widgets/head_title.dart';
import 'package:doctor_app_connect/screens/Calender/widgets/visiting_input_tray.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Common/urls.dart';
import '../../Models/clinic_modal.dart';
import '../../Widgets/drconnect_background.dart';
import '../../Common/color_select.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'widgets/calendar_header.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class CalendarPage extends StatefulWidget {
  final String? clinicName;
  final String? clinicId;
  final String? id;
  final String? startDate;
  final String? endDate;
  final String? startTime;
  final String? endTime;
  final int? slot;
  final String? slotSelector;
  final String? intervalSelector;
  final int? numberOfPatients;
  final List<String>? byDays;

  const CalendarPage(
      {Key? key,
      this.clinicName,
      this.clinicId,
      this.id,
      this.startDate,
      this.endDate,
      this.startTime,
      this.endTime,
      this.slot,
      this.slotSelector,
      this.intervalSelector,
      this.numberOfPatients,
      this.byDays})
      : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  var uuid = const Uuid();
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    getAllMyClinicList();
    getDataFromPreviousScreen();
  }

  int id = 1;
  int intervalSelection = 1;
  int? provideRadio;
  String radioButtonItem = "WEEKLY";
  String radioButtonVisitingTray = "Automatic";
  var daysList = <String>[];
  var rruleList = [];
  String interval = "1";
  bool daysTrayVisibility = true;
  bool loading = true;

  bool disableAllOtherWidgets = false;
  bool disableRadioWeekly = false;
  bool disableRadioFortnightly = false;
  bool disableRadioMonthly = false;

  var clinicList = <String>[];

  List<ClinicModel>? clinicData;
  bool isLoading = true;
  ClinicModel? dropdownvalue;

  int idRadioDialog = 6;

  String radioButtonItemDialog = 'Date';

  var days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  var daysInSingleWord = [
    {"toShow": "S", "value": "SU"},
    {"toShow": "M", "value": "MO"},
    {"toShow": "T", "value": "TU"},
    {"toShow": "W", "value": "WE"},
    {"toShow": "T", "value": "TH"},
    {"toShow": "F", "value": "FR"},
    {"toShow": "S", "value": "SA"},
  ];
  String dropdownvalueDialogDays = "Mon";

  var menu = ["First", "Second", "Third", "Fourth"];
  String dropdownvalueMenu = "First";

  var dates = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '31',
  ];
  String dropdownvalueDialogDates = '1';

  bool disableDateDropdown = false;
  bool disableDaysDropdown = true;
  bool disableMenuDropdown = true;

  var lineTwoColour = ColorSelect.base;
  var lineOneColour = ColorSelect.black;
  var startDateBorderColor = ColorSelect.secondary;
  var endDateBorderColor = ColorSelect.secondary;
  var startTimeBorderColor = ColorSelect.secondary;
  var endTimeBorderColor = ColorSelect.secondary;

  //String selectedMonthlyDropdownMenu = "BYSETPOS=" "1";
  String selectedMonthlyDropdownMenu = "1";
  String selectedMonthlyDropdownDays = "MO";
  String selectedMonthlyDropdownValue = "BYDAY=" "1MO";
  String displayStartDate = "Start date";
  String displayEndDate = "End date";
  String startDateValue = "";
  String endDateValue = "";

  String displayStartTime = "Start time";
  String displayEndTime = "End time";

  bool addAnotherTimeVisibility = true;

  var visitingTrayList = [
    VisitingTrayModel(),
  ];

  var listOfRules = [];
  bool isMySelectedDaysEmpty = false;

  var weeklyRadioActiveColor = ColorSelect.secondary;
  var fortnightlyRadioActiveColor = ColorSelect.secondary;
  var monthlyRadioActiveColor = ColorSelect.secondary;

  int startYear = 0;
  int startMonth = 0;
  int startDate = 0;
  int endYear = 0;
  int endMonth = 0;
  int endDate = 0;
  int difference = 0;

  String? rRRule;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context, "back pressed from calendar");
          return Future.value(false);
        },
        child: DrConnectBackground(
            child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: ColorSelect.secondary),
            title: Text(
              "Create Appointments",
              style: TextStyle(color: ColorSelect.secondary),
            ),
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Column(
                        children: [
                          const CalendarHeader(),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              margin: const EdgeInsets.only(top: 10, bottom: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Visibility(
                                    visible: !isEditMode,
                                    child: const HeadTitle(
                                      title: "Clinic Name* :",
                                    ),
                                  ),
                                  Visibility(
                                    visible: !isEditMode,
                                    child: ClinicNameDropDown(
                                        clinicList: clinicData,
                                        disableAllOtherWidgets:
                                            disableAllOtherWidgets,
                                        dropdownvalue: dropdownvalue,
                                        onChanged: (ClinicModel? value) {
                                          setState(() {
                                            dropdownvalue = value;
                                            log("ClinicName: " +
                                                value!.name.toString());
                                            log("ClinicId: " +
                                                value.id.toString());
                                          });
                                        }),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 17, bottom: 10),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: ColorSelect.secondary),
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        color: ColorSelect.bluegrey100),
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const HeadTitle(
                                              title: "Set Clinic Date"),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              DisplayField(
                                                textValue: displayStartDate,
                                                borderColor:
                                                    startDateBorderColor,
                                                height: 45.0,
                                                width: 125.0,
                                                onTap: () {
                                                  _selectDate(context, "start");
                                                },
                                                textColor: ColorSelect.black,
                                                text: "From",
                                                disable: disableAllOtherWidgets,
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              DisplayField(
                                                textValue: displayEndDate,
                                                borderColor: endDateBorderColor,
                                                height: 45.0,
                                                width: 125.0,
                                                onTap: () {
                                                  _selectDate(context, "end");
                                                },
                                                textColor: ColorSelect.black,
                                                text: "To",
                                                disable: disableAllOtherWidgets,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          )
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: daysTrayVisibility,
                            child: Row(
                              key: const Key("loading"),
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: List.generate(
                                daysInSingleWord.length,
                                (index) => DayTile(
                                  visibility: disableAllOtherWidgets,
                                  color: daysList.contains(
                                          daysInSingleWord[index]['value'])
                                      ? ColorSelect.secondary
                                      : ColorSelect.base,
                                  title: daysInSingleWord[index]['toShow']!,
                                  onTap: () {
                                    if (daysList.contains(
                                        daysInSingleWord[index]['value'])) {
                                      daysList.remove(
                                          daysInSingleWord[index]['value']);
                                    } else {
                                      daysList.add(
                                          daysInSingleWord[index]['value']!);
                                    }
                                    setState(() {});
                                  },
                                ),
                              ).toList(),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8, bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                IgnorePointer(
                                  ignoring: disableRadioWeekly,
                                  child: Radio(
                                    activeColor: weeklyRadioActiveColor,
                                    value: 1,
                                    groupValue: id,
                                    onChanged: (val) {
                                      setState(() {
                                        radioButtonItem = 'WEEKLY';
                                        id = 1;
                                        intervalSelection = 1;
                                        interval = "1";
                                        daysTrayVisibility = true;
                                      });
                                    },
                                  ),
                                ),
                                const Text(
                                  'WEEKLY',
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                IgnorePointer(
                                  ignoring: disableRadioFortnightly,
                                  child: Radio(
                                    value: 2,
                                    groupValue: id,
                                    activeColor: fortnightlyRadioActiveColor,
                                    onChanged: (val) {
                                      setState(() {
                                        radioButtonItem = 'WEEKLY';
                                        id = 2;
                                        intervalSelection = 2;
                                        interval = "2";
                                        daysTrayVisibility = true;
                                      });
                                    },
                                  ),
                                ),
                                const Text(
                                  'FORTNIGHTLY',
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                IgnorePointer(
                                  ignoring: disableRadioMonthly,
                                  child: Radio(
                                    value: 3,
                                    groupValue: id,
                                    activeColor: monthlyRadioActiveColor,
                                    onChanged: (val) {
                                      setState(() {
                                        radioButtonItem = 'MONTHLY';
                                        id = 3;
                                        intervalSelection = 3;
                                        daysTrayVisibility = false;
                                        _monthlyDialog();
                                        rruleList.clear();
                                        interval = "1";
                                      });
                                    },
                                  ),
                                ),
                                const Text(
                                  'MONTHLY',
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            // key: const Key("trays"),
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: List.generate(
                              visitingTrayList.length,
                              (index) => VisitingTray(
                                isDeleteIconVisible:
                                    visitingTrayList.length > 1 ? true : false,
                                textFieldValue:
                                    visitingTrayList[index].textFieldValue,
                                textFieldTitle:
                                    visitingTrayList[index].provideRadio == 1
                                        ? visitingTrayList[index]
                                            .textFieldTitle = "Patients"
                                        : visitingTrayList[index]
                                            .textFieldTitle = "Slot time",
                                bottomDisplayText:
                                    visitingTrayList[index].provideRadio == 1
                                        ? visitingTrayList[index]
                                                .bottomDisplayText
                                                .toString() +
                                            " Minutes per patient"
                                        : visitingTrayList[index]
                                                .bottomDisplayText
                                                .toString() +
                                            " Number of patients",
                                // onSubmit: log,

                                onChangeTextField: (val) {
                                  visitingTrayList[index].textFieldValue =
                                      int.parse(val);
                                  if (visitingTrayList[index].provideRadio ==
                                      1) {
                                    calculateSlotTime(index);
                                  } else if (visitingTrayList[index]
                                          .provideRadio ==
                                      2) {
                                    calculateNumberOfPatients(index);
                                  }
                                },

                                deleteIconPressed: () {
                                  for (var element in visitingTrayList) {
                                    log(element.toJson().toString());
                                  }
                                  visitingTrayList.removeAt(index);
                                  for (var element in visitingTrayList) {
                                    log(element.toJson().toString());
                                  }

                                  if (visitingTrayList.length < 3) {
                                    addAnotherTimeVisibility = true;
                                  }

                                  if (visitingTrayList.length == 1) {
                                    disableAllOtherWidgets = false;

                                    if (difference < 7) {
                                      disableRadioWeekly = true;
                                      disableRadioFortnightly = true;
                                      disableRadioMonthly = true;
                                    } else {
                                      disableRadioWeekly = false;
                                      disableRadioFortnightly = false;
                                      disableRadioMonthly = false;
                                    }
                                  }
                                  setState(() {});
                                },
                                startTimeText:
                                    visitingTrayList[index].startTime,
                                startTimeOutlineColor: startTimeBorderColor,
                                startTimeOnTap: () {
                                  _selectTime(context, "start", index);
                                },

                                endTimeText: visitingTrayList[index].endTime,
                                endTimeOutlineColor: endTimeBorderColor,
                                endTimeOnTap: () {
                                  _selectTime(context, "end", index);
                                },
                                provideRadio:
                                    visitingTrayList[index].provideRadio,

                                radioPatientOnTap: (val) {
                                  setState(() {
                                    visitingTrayList[index].provideRadio = 1;
                                    visitingTrayList[index].textFieldTitle =
                                        "Patients";
                                    visitingTrayList[index].textFieldValue = 0;
                                    visitingTrayList[index].bottomDisplayText =
                                        0;

                                    log("Patient taped");
                                  });
                                },
                                radioSlotOnTap: (val) {
                                  setState(() {
                                    visitingTrayList[index].provideRadio = 2;
                                    visitingTrayList[index].textFieldTitle =
                                        "Slot time";
                                    visitingTrayList[index].textFieldValue = 0;
                                    visitingTrayList[index].bottomDisplayText =
                                        0;
                                    log("Slot taped");
                                  });
                                },
                              ),
                            ).toList(),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  visitingTrayList.add(VisitingTrayModel());
                                  disableAllOtherWidgets = true;
                                  disableRadioWeekly = true;
                                  disableRadioFortnightly = true;
                                  disableRadioMonthly = true;
                                  if (visitingTrayList.length == 3) {
                                    addAnotherTimeVisibility = false;
                                  }
                                });
                              },
                              child: Visibility(
                                visible: addAnotherTimeVisibility,
                                child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                      color: ColorSelect.primary,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: const Text(
                                    "+ Add Another Time",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 25, bottom: 10),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    ColorSelect.primary),
                                overlayColor:
                                    MaterialStateProperty.all(Colors.grey),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                fixedSize: MaterialStateProperty.all(
                                  const Size(200, 40),
                                ),
                              ),
                              onPressed: () {
                                if (isEditMode == true) {
                                  /// update rule
                                  //  if (startDateValue == "") {
                                  //     setState(() {
                                  //       startDateBorderColor = Colors.red;
                                  //     });
                                  //   } else if (endDateValue == "") {
                                  //     setState(() {
                                  //       endDateBorderColor = Colors.red;
                                  //     });
                                  //   } else {
                                  //     listOfRules.clear();

                                  //     for (var element in visitingTrayList) {
                                  //       log(element.toJson().toString());
                                  //       String startTime =
                                  //           element.startTime!.replaceAll(RegExp(':'), '') +
                                  //               "00Z";
                                  //       String endTime =
                                  //           element.endTime!.replaceAll(RegExp(':'), '') +
                                  //               "00Z";
                                  //       generateRRule(startTime, endTime,
                                  //           element.textFieldValue, element.provideRadio.toString(), element.bottomDisplayText!);
                                  //     }

                                  //     if (isMySelectedDaysEmpty == true) {
                                  //       ScaffoldMessenger.of(context)
                                  //           .showSnackBar(const SnackBar(
                                  //         content: Text('Please select days to continue'),
                                  //       ));
                                  //     } else {
                                  //       log(listOfRules.toString());
                                  //       updateCalendarData();
                                  //     }
                                  //   }

                                  Navigator.pop(
                                      context, "back pressed from calendar");
                                  // Future.value(false);

                                } else {
                                  if (dropdownvalue == null) {
                                    /// post rule
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text('Please select clinic'),
                                    ));
                                  } else if (startDateValue == "") {
                                    setState(() {
                                      startDateBorderColor = Colors.red;
                                    });
                                  } else if (endDateValue == "") {
                                    setState(() {
                                      endDateBorderColor = Colors.red;
                                    });
                                  } else {
                                    listOfRules.clear();

                                    for (var element in visitingTrayList) {
                                      log(element.toJson().toString());
                                      String startTime = element.startTime!
                                              .replaceAll(RegExp(':'), '') +
                                          "00Z";
                                      String endTime = element.endTime!
                                              .replaceAll(RegExp(':'), '') +
                                          "00Z";
                                      generateRRule(
                                          startTime,
                                          endTime,
                                          element.textFieldValue,
                                          element.provideRadio.toString(),
                                          element.bottomDisplayText!);
                                    }

                                    if (isMySelectedDaysEmpty == true) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            'Please select days to continue'),
                                      ));
                                    } else {
                                      log(listOfRules.toString());
                                      postCalendarData();
                                    }
                                  }
                                }
                              },
                              child: const Text("Submit"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        )));
  }

  void _monthlyDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              insetPadding: const EdgeInsets.all(25),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: SizedBox(
                height: 140,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Radio(
                            value: 6,
                            groupValue: idRadioDialog,
                            onChanged: (val) {
                              setState(() {
                                radioButtonItemDialog = 'Date';
                                disableDateDropdown = false;
                                disableDaysDropdown = true;
                                disableMenuDropdown = true;
                                lineTwoColour = ColorSelect.base;
                                lineOneColour = ColorSelect.black;
                                idRadioDialog = 6;
                              });
                            },
                          ),
                          Text(
                            'Date',
                            style:
                                TextStyle(fontSize: 14.0, color: lineOneColour),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          IgnorePointer(
                            ignoring: disableDateDropdown,
                            child: DropdownButton(
                              value: dropdownvalueDialogDates,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              style:
                                  TextStyle(color: lineOneColour, fontSize: 14),
                              // Array list of items
                              items: dates.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownvalueDialogDates = newValue!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Of Every Month",
                            style:
                                TextStyle(fontSize: 14.0, color: lineOneColour),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Radio(
                            value: 7,
                            groupValue: idRadioDialog,
                            onChanged: (val) {
                              setState(() {
                                radioButtonItemDialog = 'Days';
                                idRadioDialog = 7;
                                disableDateDropdown = true;
                                disableDaysDropdown = false;
                                disableMenuDropdown = false;
                                lineTwoColour = ColorSelect.black;
                                lineOneColour = ColorSelect.base;
                              });
                            },
                          ),
                          Text(
                            'The',
                            style:
                                TextStyle(fontSize: 14.0, color: lineTwoColour),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          IgnorePointer(
                            ignoring: disableMenuDropdown,
                            child: DropdownButton(
                              value: dropdownvalueMenu,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              style:
                                  TextStyle(color: lineTwoColour, fontSize: 14),
                              // Array list of items
                              items: menu.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownvalueMenu = newValue!;
                                  if (dropdownvalueMenu == "First") {
                                    // selectedMonthlyDropdownMenu =
                                    //     "BYSETPOS=" "1";
                                    selectedMonthlyDropdownMenu = "1";
                                    selectedMonthlyDropdownValue = "BYDAY="
                                        "1$selectedMonthlyDropdownDays";
                                  } else if (dropdownvalueMenu == "Second") {
                                    //  selectedMonthlyDropdownMenu = "BYSETPOS=" "2";
                                    selectedMonthlyDropdownMenu = "2";
                                    selectedMonthlyDropdownValue = "BYDAY="
                                        "2$selectedMonthlyDropdownDays";
                                  } else if (dropdownvalueMenu == "Third") {
                                    //  selectedMonthlyDropdownMenu = "BYSETPOS=" "3";
                                    selectedMonthlyDropdownMenu = "3";
                                    selectedMonthlyDropdownValue = "BYDAY="
                                        "3$selectedMonthlyDropdownDays";
                                  } else if (dropdownvalueMenu == "Fourth") {
                                    //  selectedMonthlyDropdownMenu = "BYSETPOS=" "4";
                                    selectedMonthlyDropdownMenu = "4";
                                    selectedMonthlyDropdownValue = "BYDAY="
                                        "4$selectedMonthlyDropdownDays";
                                  }
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 13,
                          ),
                          IgnorePointer(
                            ignoring: disableDaysDropdown,
                            child: DropdownButton(
                              value: dropdownvalueDialogDays,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              style:
                                  TextStyle(color: lineTwoColour, fontSize: 14),
                              // Array list of items
                              items: days.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownvalueDialogDays = newValue!;

                                  if (dropdownvalueDialogDays == "Mon") {
                                    selectedMonthlyDropdownDays = "MO";
                                    selectedMonthlyDropdownValue = "BYDAY="
                                        "${selectedMonthlyDropdownMenu}MO";
                                  } else if (dropdownvalueDialogDays == "Tue") {
                                    selectedMonthlyDropdownDays = "TU";
                                    selectedMonthlyDropdownValue = "BYDAY="
                                        "${selectedMonthlyDropdownMenu}TU";
                                  } else if (dropdownvalueDialogDays == "Wed") {
                                    selectedMonthlyDropdownDays = "WE";
                                    selectedMonthlyDropdownValue = "BYDAY="
                                        "${selectedMonthlyDropdownMenu}WE";
                                  } else if (dropdownvalueDialogDays == "Thu") {
                                    selectedMonthlyDropdownDays = "TH";
                                    selectedMonthlyDropdownValue = "BYDAY="
                                        "${selectedMonthlyDropdownMenu}TH";
                                  } else if (dropdownvalueDialogDays == "Fri") {
                                    selectedMonthlyDropdownDays = "FR";
                                    selectedMonthlyDropdownValue = "BYDAY="
                                        "${selectedMonthlyDropdownMenu}FR";
                                  } else if (dropdownvalueDialogDays == "Sat") {
                                    selectedMonthlyDropdownDays = "SA";
                                    selectedMonthlyDropdownValue = "BYDAY="
                                        "${selectedMonthlyDropdownMenu}SA";
                                  } else if (dropdownvalueDialogDays == "Sun") {
                                    selectedMonthlyDropdownDays = "SU";
                                    selectedMonthlyDropdownValue = "BYDAY="
                                        "${selectedMonthlyDropdownMenu}SU";
                                  }
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Of Every Month",
                            style:
                                TextStyle(fontSize: 14.0, color: lineTwoColour),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  Future<void> _selectDate(
      BuildContext context, String fromClickedField) async {
    DateTime currentDate = DateTime.now();
    String newCurrentDate = "";
    String newCurrentMonth = "";
    String newCurrentYear = "";

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: currentDate.subtract(const Duration(days: 0)),
      lastDate: currentDate.add(const Duration(days: 90)),
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

    if (pickedDate != null && pickedDate != currentDate) {
      setState(() async {
        currentDate = pickedDate;
        newCurrentYear = currentDate.year.toString();

        if (currentDate.day < 10) {
          newCurrentDate = "0" + currentDate.day.toString();
        } else {
          newCurrentDate = currentDate.day.toString();
        }

        /// format date with 0 at first position if single digit

        if (currentDate.month < 10) {
          newCurrentMonth = "0" + currentDate.month.toString();
        } else {
          newCurrentMonth = currentDate.month.toString();
        }

        /// format month with 0 at first position if single digit
        if (fromClickedField == "start") {
          setState(() {
            startDateBorderColor = ColorSelect.secondary;
            displayStartDate =
                newCurrentYear + "-" + newCurrentMonth + "-" + newCurrentDate;
          });
          startDateValue = newCurrentYear + newCurrentMonth + newCurrentDate;
          startYear = int.parse(newCurrentYear);
          startMonth = int.parse(newCurrentMonth);
          startDate = int.parse(newCurrentDate);
          findDiffrenceBtnDates();
        } else if (fromClickedField == "end") {
          setState(() {
            endDateBorderColor = ColorSelect.secondary;
            displayEndDate =
                newCurrentYear + "-" + newCurrentMonth + "-" + newCurrentDate;
          });
          endDateValue = newCurrentYear + newCurrentMonth + newCurrentDate;
          endYear = int.parse(newCurrentYear);
          endMonth = int.parse(newCurrentMonth);
          endDate = int.parse(newCurrentDate);
          findDiffrenceBtnDates();
        }
      });
    }
  }

  _selectTime(BuildContext context1, String fromClickedField, int index) async {
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

        /// format time with 0 at first position if single digit
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

        if (fromClickedField == "start") {
          setState(() {
            startTimeBorderColor = ColorSelect.secondary;
            displayStartTime = newCurrentHour + ":" + newCurrentMinute;
            visitingTrayList[index].startTime = displayStartTime;

            if (visitingTrayList[index].provideRadio == 1) {
              calculateSlotTime(index);
            } else if (visitingTrayList[index].provideRadio == 2) {
              calculateNumberOfPatients(index);
            }
          });
        } else if (fromClickedField == "end") {
          setState(() {
            endTimeBorderColor = ColorSelect.secondary;
            displayEndTime = newCurrentHour + ":" + newCurrentMinute;
            visitingTrayList[index].endTime = displayEndTime;
            if (visitingTrayList[index].provideRadio == 1) {
              calculateSlotTime(index);
            } else if (visitingTrayList[index].provideRadio == 2) {
              calculateNumberOfPatients(index);
            }
          });
        }
      });
    } else {
      String newCurrentHour = selectedTime.hour as String;
      String newCurrentMinute = selectedTime.minute as String;

      /// format time with 0 at first position if single digit
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

      if (fromClickedField == "start") {
        setState(() {
          startTimeBorderColor = ColorSelect.secondary;
          displayStartTime = newCurrentHour + ":" + newCurrentMinute;
          visitingTrayList[index].startTime = displayStartTime;

          if (visitingTrayList[index].provideRadio == 1) {
            calculateSlotTime(index);
          } else if (visitingTrayList[index].provideRadio == 2) {
            calculateNumberOfPatients(index);
          }
        });
      } else if (fromClickedField == "end") {
        setState(() {
          endTimeBorderColor = ColorSelect.secondary;
          displayEndTime = newCurrentHour + ":" + newCurrentMinute;
          visitingTrayList[index].endTime = displayEndTime;

          if (visitingTrayList[index].provideRadio == 1) {
            calculateSlotTime(index);
          } else if (visitingTrayList[index].provideRadio == 2) {
            calculateNumberOfPatients(index);
          }
        });
      }
    }
  }

  Future<void> getAllMyClinicList() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    Map<String, String> header = {
      "Accept": "*/*",
      "Authorization": 'Bearer ' + token
    };

    http.Response response = await http.get(
      Uri.parse(Api.fetchClinicDataApi),
      headers: header,
    );

    if (response.body.isNotEmpty) {
      //var jsonResponse = json.decode(response.body);
      setState(() {
        clinicData = clinicModelFromJson(response.body);
        log("clinic" + response.body);
        isLoading = false;
      });
    }
  }

  void findDiffrenceBtnDates() {
    if (startDate != 0 && endDate != 0) {
      log("Start: " +
          startYear.toString() +
          startMonth.toString() +
          startDate.toString());
      log("Endd: " +
          endYear.toString() +
          endMonth.toString() +
          endDate.toString());
      final fromDate = DateTime(startYear, startMonth, startDate);
      final toDate = DateTime(endYear, endMonth, endDate);
      difference = toDate.difference(fromDate).inDays;
      log("DaysInDiff: " + difference.toString());
      if (difference < 7) {
        daysTrayVisibility = false;
        weeklyRadioActiveColor = ColorSelect.base;
        fortnightlyRadioActiveColor = ColorSelect.base;
        monthlyRadioActiveColor = ColorSelect.base;
        disableRadioWeekly = true;
        disableRadioFortnightly = true;
        disableRadioMonthly = true;

        radioButtonItem = "DAILY";
        interval = "1";
        intervalSelection = 0;
      } else {
        daysTrayVisibility = true;
        weeklyRadioActiveColor = ColorSelect.secondary;
        fortnightlyRadioActiveColor = ColorSelect.secondary;
        monthlyRadioActiveColor = ColorSelect.secondary;
        disableRadioWeekly = false;
        disableRadioFortnightly = false;
        disableRadioMonthly = false;

        radioButtonItem = "WEEKLY";
        interval = "1";
        id = 1;
        intervalSelection = 1;
      }
    }
  }

  void generateRRule(String? startTime, String? endTime, int? textFieldValue,
      String? provideRadio, int textDisplay) {
    String days = daysList.join(',');
    String frequency = "FREQ=" + radioButtonItem;
    String selectedDays = "BYDAY=" + days;
    String selectedInterval = "INTERVAL=" + interval;
    String byMonthDay = "BYMONTHDAY=" + dropdownvalueDialogDates;
    String endDateTime = "UNTIL=" + endDateValue + "T" + endTime!;
    String startDateTime =
        "X-EWSOFTWARE-DTSTART=" + startDateValue + "T" + startTime!;
    String visitingRadioSelection = "NumberOfPatients";
    int noOfPatients = textFieldValue!;
    int noOfSlots = textDisplay;

    if (provideRadio == "1") {
      visitingRadioSelection = "NumberOfPatients";
      noOfPatients = textFieldValue;
      noOfSlots = textDisplay;
    } else if (provideRadio == "2") {
      visitingRadioSelection = "SlotTime";
      noOfPatients = textDisplay;
      noOfSlots = textFieldValue;
    }

    if (difference < 7) {
      rruleList.clear();
      rruleList.add(frequency);
      rruleList.add(selectedInterval);
      rruleList.add(endDateTime);
      rruleList.add(startDateTime);
    } else if (id == 3) {
      isMySelectedDaysEmpty = false;
      if (idRadioDialog == 6) {
        rruleList.clear();
        rruleList.add(frequency);
        rruleList.add(endDateTime);
        rruleList.add(startDateTime);
        rruleList.add(byMonthDay);
        rruleList.add(selectedInterval);
      } else if (idRadioDialog == 7) {
        rruleList.clear();
        rruleList.add(frequency);
        rruleList.add(endDateTime);
        rruleList.add(startDateTime);
        //rruleList.add(selectedMonthlyDropdownMenu);
        rruleList.add(selectedMonthlyDropdownValue);
        rruleList.add(selectedInterval);
      }
    } else {
      if (daysList.isEmpty) {
        isMySelectedDaysEmpty = true;
      } else {
        isMySelectedDaysEmpty = false;
        rruleList.clear();
        rruleList.add(frequency);
        rruleList.add(endDateTime);
        rruleList.add(startDateTime);
        rruleList.add(selectedDays);
        rruleList.add(selectedInterval);
      }
    }

    String rRule = rruleList.join(';');
    rRRule = rRule;

    listOfRules.add({
      "rule": "${rRule}",
      "patients": noOfPatients,
      "intervalSelector": intervalSelection,
      "slot": noOfSlots,
      "slotSelector": "${visitingRadioSelection}"
    });
  }

  void calculateSlotTime(int index) {
    String? startTime = visitingTrayList[index].startTime;
    String? endTime = visitingTrayList[index].endTime;
    int? noOfPatients = visitingTrayList[index].textFieldValue;

    if (startTime != "Start time" &&
        endTime != "End time" &&
        noOfPatients != 0) {
      var format = DateFormat("HH:mm");
      var start = format.parse(startTime!);
      var end = format.parse(endTime!);

      if (start.isAfter(end)) {
        visitingTrayList[index].bottomDisplayText = 0;
        //  end = end.add(const Duration(days: 1));
        //  Duration diff = end.difference(start);
        //  final hours = diff.inHours;
        //  final minutes = diff.inMinutes % 60;
        //  log('$hours hours $minutes minutes');
        //     visitingTrayList[index].slotTime = minutes.toString();
      } else if (end.isAfter(start)) {
        Duration diff = end.difference(start);
        final hours = diff.inHours;
        final minutes = diff.inMinutes % 60;
        log('$hours hours $minutes minutes');
        int slotTime = diff.inMinutes ~/ noOfPatients!;
        log('min: ' + diff.inMinutes.toString());
        log('patiets: ' + noOfPatients.toString());
        log('slot: ' + slotTime.toString());
        visitingTrayList[index].bottomDisplayText = slotTime;
      } else if (startTime == endTime) {
        visitingTrayList[index].bottomDisplayText = 0;
      }
    }
  }

  void calculateNumberOfPatients(int index) {
    String? startTime = visitingTrayList[index].startTime;
    String? endTime = visitingTrayList[index].endTime;
    int? slotTime = visitingTrayList[index].textFieldValue;

    if (startTime != "Start time" && endTime != "End time" && slotTime != 0) {
      var format = DateFormat("HH:mm");
      var start = format.parse(startTime!);
      var end = format.parse(endTime!);

      if (start.isAfter(end)) {
        visitingTrayList[index].bottomDisplayText = 0;
      } else if (end.isAfter(start)) {
        Duration diff = end.difference(start);
        final hours = diff.inHours;
        final minutes = diff.inMinutes % 60;
        log('$hours hours $minutes minutes');
        int noOfPatients = diff.inMinutes ~/ slotTime!;
        log('min: ' + diff.inMinutes.toString());
        log('slot: ' + slotTime.toString());
        log('patiets: ' + noOfPatients.toString());

        visitingTrayList[index].bottomDisplayText = noOfPatients;
      } else if (startTime == endTime) {
        visitingTrayList[index].bottomDisplayText = 0;
      }
    }
  }

  Future<void> postCalendarData() async {
    String guid = uuid.v1();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    Map<String, String> header = {
      "requestId": guid,
      "Accept": "text/plain",
      "api-version": "1.0",
      "Content-type": "application/json",
      "Authorization": "Bearer " + token
    };

    var encodedBody = json.encode({
      "clinicId": dropdownvalue!.id.toString(),
      "clinicName": dropdownvalue!.name.toString(),
      "items": listOfRules
    });

    http.Response response = await http.post(Uri.parse(Api.postCalendarApi),
        headers: header, body: encodedBody);

    log("Body: " + encodedBody);
    log("StatusCode: " + response.statusCode.toString());
    if (response.statusCode == 201) {
      log("Success Post Calendar");
      Navigator.pop(context);
    } else if (response.statusCode == 409) {
      var jsonResponse = json.decode(response.body);
      var error = jsonResponse['errors']['DomainValidations'][0];
      log("Error: " + error.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: ColorSelect.error,
        content: Text(error),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: ColorSelect.error,
        content: const Text("Failed to update"),
      ));
    }
  }

  Future<void> updateCalendarData() async {
    String guid = uuid.v1();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    Map<String, String> header = {
      "requestId": guid,
      "Accept": "text/plain",
      "api-version": "1.0",
      "Content-type": "application/json",
      "Authorization": "Bearer " + token
    };

    var encodedBody = json.encode({
      "clinicId": widget.clinicId,
      "clinicName": widget.clinicName,
      "items": listOfRules
    });

    http.Response response = await http.put(
        Uri.parse(Api.putCalendarApi + widget.id.toString()),
        headers: header,
        body: encodedBody);

    log("Body: " + encodedBody);
    log("StatusCode: " + response.statusCode.toString());
    if (response.statusCode == 201) {
      log("Success update Calendar");
      Navigator.pop(context);
    } else if (response.statusCode == 409) {
      var jsonResponse = json.decode(response.body);
      var error = jsonResponse['errors']['DomainValidations'][0];
      log("Error: " + error.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: ColorSelect.error,
        content: Text(error),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: ColorSelect.error,
        content: const Text("Failed to update"),
      ));
    }
  }

  void getDataFromPreviousScreen() {
    if (widget.clinicName != "") {
      isEditMode = true;
      addAnotherTimeVisibility = false;

      displayStartDate = widget.startDate!;

      DateTime formatStart = DateTime.parse(widget.startDate!);
      startYear = formatStart.year;
      startMonth = formatStart.month;
      startDate = formatStart.day;

      String newCurrentStartYear = formatStart.year.toString();
      String newCurrentStartMonth = formatStart.month.toString();
      String newCurrentStartDate = formatStart.month.toString();

      if (startMonth < 10) {
        /// format month with 0 at first position if single digit
        newCurrentStartMonth = "0" + startMonth.toString();
      } else {
        newCurrentStartMonth = startMonth.toString();
      }

      if (startDate < 10) {
        /// format date with 0 at first position if single digit
        newCurrentStartDate = "0" + startDate.toString();
      } else {
        newCurrentStartDate = startDate.toString();
      }

      startDateValue =
          newCurrentStartYear + newCurrentStartMonth + newCurrentStartDate;

      displayEndDate = widget.endDate!;
      DateTime formatEnd = DateTime.parse(widget.endDate!);
      endYear = formatEnd.year;
      endMonth = formatEnd.month;
      endDate = formatEnd.day;

      String newCurrentEndYear = formatEnd.year.toString();
      String newCurrentEndMonth = formatEnd.month.toString();
      String newCurrentEndDate = formatEnd.month.toString();

      if (endMonth < 10) {
        /// format month with 0 at first position if single digit
        newCurrentEndMonth = "0" + endMonth.toString();
      } else {
        newCurrentEndMonth = endMonth.toString();
      }

      if (endDate < 10) {
        /// format date with 0 at first position if single digit
        newCurrentEndDate = "0" + endDate.toString();
      } else {
        newCurrentEndDate = endDate.toString();
      }

      endDateValue = newCurrentEndYear + newCurrentEndMonth + newCurrentEndDate;

      if (widget.intervalSelector != "") {
        if (widget.intervalSelector == "1") {
          radioButtonItem = 'WEEKLY';
          id = 1;
          intervalSelection = 1;
          interval = "1";
          daysTrayVisibility = true;
        } else if (widget.intervalSelector == "2") {
          radioButtonItem = 'WEEKLY';
          id = 2;
          intervalSelection = 2;
          interval = "2";
          daysTrayVisibility = true;
        } else if (widget.intervalSelector == "3") {
          radioButtonItem = 'MONTHLY';
          id = 3;
          intervalSelection = 3;
          daysTrayVisibility = false;
          interval = "1";
        } else if (widget.intervalSelector == "0") {
          daysTrayVisibility = false;
          weeklyRadioActiveColor = ColorSelect.base;
          fortnightlyRadioActiveColor = ColorSelect.base;
          monthlyRadioActiveColor = ColorSelect.base;
          disableRadioWeekly = true;
          disableRadioFortnightly = true;
          disableRadioMonthly = true;

          radioButtonItem = "DAILY";
          interval = "1";
          intervalSelection = 0;
        }
      }

      log("Days: " + widget.byDays.toString());
      List<String> newFormattedDaysList = [];
      for (int i = 0; i < widget.byDays!.length; i++) {
        newFormattedDaysList
            .add(widget.byDays![i].toUpperCase().substring(0, 2));
      }
      log("newDays: " + newFormattedDaysList.toString());
      daysList = newFormattedDaysList;

      int selection = 1;
      if (widget.slotSelector != "") {
        if (widget.slotSelector == "NumberOfPatients") {
          selection = 1;
        } else {
          selection = 2;
        }
      }
      log("patients: " + widget.numberOfPatients!.toString());

      int textFieldValue = 0;
      int bottomDisplayText = 0;
      if (selection == 1) {
        textFieldValue = widget.numberOfPatients!;
        bottomDisplayText = widget.slot!;
      } else if (selection == 2) {
        textFieldValue = widget.slot!;
        bottomDisplayText = widget.numberOfPatients!;
      }

      String startTime = widget.startTime!;
      String endTime = widget.endTime!;

      visitingTrayList = [
        VisitingTrayModel(
            startTime: startTime.substring(0, 5),
            endTime: endTime.substring(0, 5),
            provideRadio: selection,
            textFieldValue: textFieldValue,
            bottomDisplayText: bottomDisplayText),
      ];
    }
  }
}
