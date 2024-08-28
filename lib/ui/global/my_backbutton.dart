import 'package:flutter/material.dart';

class MyBackButton extends StatelessWidget {
  const MyBackButton({super.key, this.iconColor, this.onBack});
  final Color? iconColor;
  final Function()? onBack;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onBack ?? () => Navigator.pop(context),
        icon: Icon(
          Icons.arrow_back,
          color: iconColor ?? Colors.white,
        ));
  }
}
