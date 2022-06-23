import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../Common/color_select.dart';

class TextFieldWithTitle extends StatelessWidget {
  const TextFieldWithTitle({
    Key? key,
    required this.title,
    required this.height,
    required this.onChanged,
    this.width,
    this.textEditingController,
    this.onSubmit,
  }) : super(key: key);

  final String title;
  final double height;
  final double? width;
  final TextEditingController? textEditingController;
  final Function(String)? onChanged;
  final Function(String)? onSubmit;

  @override
  Widget build(BuildContext context) {
    textEditingController!.selection = TextSelection.fromPosition(
        TextPosition(offset: textEditingController!.text.length));

    return Row(
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(
          width: 5,
        ),
        SizedBox(
          width: width,
          height: height,
          child: TextField(
            onChanged: onChanged,
            controller: textEditingController,
            inputFormatters: [
              LengthLimitingTextInputFormatter(3),
            ],
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 14.0),
            onSubmitted: onSubmit,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: const OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: ColorSelect.secondary,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: ColorSelect.primary,
                  )),
            ),
          ),
        ),
      ],
    );
  }
}
