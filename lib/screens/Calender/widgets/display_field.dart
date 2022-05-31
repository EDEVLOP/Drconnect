import 'package:flutter/material.dart';

class DisplayField extends StatelessWidget {
  const DisplayField(
      {Key? key,
      this.textValue,
      this.onTap,
      this.borderColor,
      required this.height,
      required this.width,
      this.textColor,
      this.text,
      required this.disable})
      : super(key: key);

  final String? textValue;
  final String? text;
  final Function()? onTap;
  final Color? borderColor;
  final Color? textColor;
  final double height;
  final double width;
  final bool disable;

  @override
  Widget build(BuildContext context) {
    return  Row(
      children: <Widget>[
        const Padding(padding: EdgeInsets.all(5)),
        Text(text!),
        SizedBox(
          width: width,
          child: Container(
            margin: const EdgeInsets.only(left: 3),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: borderColor!),
                borderRadius: BorderRadius.circular(8)),
            height: height,
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: onTap,
              child: IgnorePointer(
                ignoring: disable,
                child: Text(
                  textValue!,
                  style: TextStyle(color: textColor),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
