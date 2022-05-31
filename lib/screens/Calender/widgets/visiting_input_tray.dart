import 'package:doctor_app_connect/screens/Calender/widgets/text_field_with_title.dart';
import 'package:flutter/material.dart';
import '../../../Common/color_select.dart';
import 'display_field.dart';

class VisitingTray extends StatelessWidget {
  const VisitingTray({
    Key? key,
    this.startTimeText,
    this.startTimeOutlineColor,
    this.startTimeOnTap,
    this.endTimeText,
    this.endTimeOutlineColor,
    this.endTimeOnTap,
    this.provideRadio,
    this.radioPatientOnTap,
    this.radioSlotOnTap,
    this.isDeleteIconVisible,
    this.deleteIconPressed,
    this.textFieldValue,
    this.onChangeTextField,
     this.textFieldTitle, this.bottomDisplayText,
  //  this.onSubmit,
  }) : super(key: key);

  final String? startTimeText;
  final Color? startTimeOutlineColor;
  final Function()? startTimeOnTap;
  final Function(String)? onChangeTextField;
  //final Function(String)? onSubmit;
  final String? endTimeText;
  final Color? endTimeOutlineColor;
  final Function()? endTimeOnTap;
  final int? provideRadio;
  final void Function(int)? radioPatientOnTap;
  final Function(int)? radioSlotOnTap;
  final bool? isDeleteIconVisible;
  final Function()? deleteIconPressed;
  final int? textFieldValue;
  final String? textFieldTitle;
  final String? bottomDisplayText;


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 6),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          border: Border.all(color: ColorSelect.secondary),
          borderRadius: BorderRadius.circular(6.0),
          color: ColorSelect.bluegrey100),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Visiting hours",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                  height: 50,
                  width: 50,
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                   
                  ),
                  child: Visibility(
                    visible: isDeleteIconVisible!,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: GestureDetector(
                        onTap: deleteIconPressed!,
                        child: const Image(
                          image: AssetImage("assets/images/delete.png"),
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ),
                  )),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: <Widget>[
              DisplayField(
                textValue: startTimeText,
                borderColor: startTimeOutlineColor,
                height: 45.0,
                width: 125.0,
                onTap: startTimeOnTap,
                textColor: ColorSelect.black,
                text: "From",
                disable: false,
              ),
              const SizedBox(
                width: 8,
              ),
              DisplayField(
                textValue: endTimeText,
                borderColor: endTimeOutlineColor,
                height: 45.0,
                width: 125.0,
                onTap: endTimeOnTap,
                textColor: ColorSelect.black,
                text: "To",
                disable: false,
              )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            "Provide",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Container(
            margin: const EdgeInsets.only(top: 0, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Radio(
                  value: 1,
                  groupValue: provideRadio,
                  activeColor: ColorSelect.secondary,
                  onChanged: (val) {
                    if (val == 1) {
                      int _val = int.tryParse(val.toString()) ?? 0;
                      radioPatientOnTap!(_val);
                    }
                  },
                ),
                const Text(
                  'Number of Patients',
                  style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
                ),
                Radio(
                  value: 2,
                  groupValue: provideRadio,
                  activeColor: ColorSelect.secondary,
                  onChanged: (val) {
                    if (val == 2) {
                      int _val = int.tryParse(val.toString()) ?? 0;
                      radioSlotOnTap!(_val);
                    }
                  },
                ),
                const Text(
                  'Slot time',
                  style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
                margin: const EdgeInsets.only(top: 15, bottom: 8),
                child: textFieldWithTitle(
                  height: 45,
                  width: 130,
                  title: textFieldTitle!,
                  textEditingController: TextEditingController(text: textFieldValue.toString()),              
                  onChanged: onChangeTextField,
                  //onSubmit: onSubmit,
                ),
              ),
         
          const SizedBox(
            height: 13.0,
          ),

Center(child: Text(bottomDisplayText!)),
 const SizedBox(
            height: 13.0,
          ),
        ],
      ),
    );
  }
}
