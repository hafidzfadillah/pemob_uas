import 'package:flutter/material.dart';
import 'package:pemob_uas/ui/global/my_text.dart';
import 'package:pemob_uas/ui/global/styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Future showModalSheet(context, height, child) async {
  final rsp = await showModalBottomSheet(
    enableDrag: true,
    isScrollControlled: true,
    showDragHandle: true,
    context: context,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(2.h), topRight: Radius.circular(2.h))),
    builder: (context) {
      return SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
              height: height, padding: EdgeInsets.all(2.h), child: child),
        ),
      );
    },
  );

  return rsp;
}

Future showConfirmationDialog(
      BuildContext context, String title, String msg) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: MyText(
            title,
            weight: FontWeight.w600,
            size: 18,
          ),
          content: MyText(
            msg,
            maxLines: 4,
          ),
          actions: <Widget>[
            TextButton(
              child: const MyText(
                'Batal',
                color: primaryColor,
              ),
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor, elevation: 0),
              child: const MyText(
                'Ya',
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );

    return result != null && result;
  }