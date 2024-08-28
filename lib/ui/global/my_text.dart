import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyText extends StatelessWidget {
  const MyText(
    this.data, {
    super.key,
    this.size,
    this.weight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isItalic,
  });
  final String data;
  final double? size;
  final FontWeight? weight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? isItalic;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: GoogleFonts.poppins(
          fontSize: size ?? 14,
          fontWeight: weight ?? FontWeight.normal,
          color: color ?? Colors.black,
          fontStyle: isItalic ?? false ? FontStyle.italic : FontStyle.normal),
      textAlign: textAlign,
      maxLines: maxLines ?? 1,
      overflow: overflow,
    );
  }
}
