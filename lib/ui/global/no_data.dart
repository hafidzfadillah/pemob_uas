import 'package:flutter/material.dart';
import 'package:pemob_uas/ui/global/my_text.dart';

class NoData extends StatelessWidget {
  const NoData({super.key, required this.onClick, this.label});
  final Function() onClick;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MyText(label ?? 'Data not found'),
        const SizedBox(
          height: 16,
        ),
        OutlinedButton(onPressed: onClick, child: const MyText('Refresh'))
      ],
    );
  }
}
