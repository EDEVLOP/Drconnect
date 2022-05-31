import 'package:flutter/material.dart';

// Manage the background of each screen
class DrConnectBackground extends StatelessWidget {
  final Widget child;
  const DrConnectBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Don't apply padding or margin here, it will be used on the child too
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage("assets/images/backgroundImage.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
