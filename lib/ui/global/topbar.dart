import 'package:flutter/material.dart';
import 'package:pemob_uas/ui/global/my_text.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Topbar extends StatelessWidget {
  const Topbar(
      {super.key,
      required this.title,
      this.action,
      this.leading,
      this.footer,
      this.titleSize});
  final String title;
  final double? titleSize;
  final Widget? action;
  final Widget? leading;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          leading != null ? 1.h : 2.h,
          action != null || leading != null ? 6.h : 7.h,
          2.h,
          action != null || leading != null ? 1.h : 2.h),
      width: double.infinity,
      decoration: const BoxDecoration(
          gradient:  LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
            Color(0xFF0C57AF),
            Color(0xFF24A4DD),
            Color(0xFF92DEFF),
          ])),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: leading != null
                ? MainAxisAlignment.start
                : MainAxisAlignment.spaceBetween,
            children: [
              leading ?? Container(),
              SizedBox(
                width: leading != null ? 1.h : 0,
              ),
              Expanded(
                child: MyText(
                  title,
                  maxLines: 3,
                  size: titleSize ?? 24,
                  color: Colors.white,
                ),
              ),
              action ?? Container()
            ],
          ),
          footer != null
              ? Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: footer,
                )
              : Container()
        ],
      ),
    );
  }
}
