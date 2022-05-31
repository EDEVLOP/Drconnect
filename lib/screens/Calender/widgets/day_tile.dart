import 'package:flutter/material.dart';
import '../../../Common/color_select.dart';

class DayTile extends StatelessWidget {
  const DayTile({
    Key? key,
    this.title,
    this.onTap,
    this.color,
    this.visibility,
  }) : super(key: key);

  final String? title;
  final Function()? onTap;
  final Color? color;
  final bool? visibility;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: 45,
      child: IgnorePointer(
        ignoring: visibility!,
        child: ElevatedButton(
          onPressed: onTap,
          child: Text(
            title!,
            style: const TextStyle(fontSize: 20),
          ),
          style: ElevatedButton.styleFrom(
            primary: color!,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(width: 1, color: ColorSelect.secondary),
            ),
          ),
        ),
      ),
    );
  }
}
