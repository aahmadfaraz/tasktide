import 'package:flutter/material.dart';

import '../helpers/pallete.dart';

class StyledText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? align;
  final double? height;
  final int? maxLines;
  const StyledText({
    Key? key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.align,
    this.height,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align ?? TextAlign.start,
      maxLines: maxLines ?? 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        height: height ?? 1.0,
        fontSize: fontSize ?? 16.0,
        color: color ?? Pallete.darkBlue,
        fontWeight: fontWeight ?? FontWeight.w500,
        fontFamily: "Inter",
      ),
    );
  }
}
