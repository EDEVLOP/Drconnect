import 'package:doctor_app_connect/Models/clinic_modal.dart';
import 'package:flutter/material.dart';
import '../../../Common/color_select.dart';
import '../../custom_dropdown.dart';

class ClinicNameDropDown extends StatelessWidget {
  const ClinicNameDropDown(
      {Key? key,
      this.dropdownvalue,
      this.disableAllOtherWidgets,
       this.value,
      this.onChanged,
      this.clinicList})
      : super(key: key);

  final ClinicModel? dropdownvalue;
  final bool? disableAllOtherWidgets;
   final String? value;
  final Function(ClinicModel?)? onChanged;
  final List<ClinicModel>? clinicList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: DropdownButtonHideUnderline(
        child: IgnorePointer(
          ignoring: disableAllOtherWidgets!,
          child: DropdownButton2<ClinicModel>( 
            isExpanded: true,
            hint: Row(
              children: const [
                SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Text(
                    'Select clinic',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            items: clinicList!.map<DropdownMenuItem<ClinicModel>>((ClinicModel value) {
                return DropdownMenuItem<ClinicModel>(
                  value: value,
                  child: Text(value.name.toString(), style: TextStyle(color: ColorSelect.black, fontSize: 14)),
                );
              }).toList(),
            value: dropdownvalue,
            onChanged: onChanged!,         
            icon: const Icon(
              Icons.keyboard_arrow_down,
            ),
            iconSize: 25,
            iconEnabledColor: ColorSelect.secondary,
            iconDisabledColor: Colors.grey,
            buttonHeight: 45,
            buttonWidth: 200,
            buttonPadding: const EdgeInsets.only(left: 14, right: 14),
            buttonDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: ColorSelect.secondary,
              ),
              color: ColorSelect.bluegrey50,
            ),
            buttonElevation: 2,
            itemHeight: 40,
            itemPadding: const EdgeInsets.only(left: 14, right: 14),
            dropdownMaxHeight: 200,
            dropdownOverButton: false,
            //........dropdown width...............
            //dropdownWidth: 300,
            dropdownPadding: null,
            dropdownDecoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4)),
              color: Colors.white,
            ),
            dropdownElevation: 8,
            scrollbarRadius: const Radius.circular(40),
            scrollbarThickness: 0,
            scrollbarAlwaysShow: false,
            offset: const Offset(1, 0),
          ),
        ),
      ),
    );
  }
}
