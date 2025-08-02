import 'dart:ui';

import 'package:atenamove/config/globalVariable.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
// final String fontFamily;
  final TextOverflow? overflow;
  final String stringText;
  final TextAlign textAlign;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final FontStyle fontStyle;
  final double? height;
  final int? maxLines;
  final bool fromCenter;
  final TextDecoration? decoration;
  final double? decorationThickness;
  final Color? decorationColor;
  final Paint? foreground;
  final TextDirection? textDirection;
  final double? letterSpacing;
  final List<FontFeature>? fontFeature;
  CustomText(
    this.stringText, {
// this. fontFamily = GoogleFonts.openSans,
    this.textAlign = TextAlign.start,
    this.overflow,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w500,
    this.color = Colors.black,
    this.fontStyle = FontStyle.normal,
    this.height,
    this.maxLines,
    this.fromCenter = false,
    this.decoration,
    this.decorationThickness,
    this.decorationColor,
    this.foreground,
    this.textDirection,
    this.letterSpacing,
    this.fontFeature,
  });

  @override
  Widget build(BuildContext context) {
    return 
        Text(
          stringText,
          textAlign: textAlign,
          overflow: overflow,
          maxLines: maxLines,
          textDirection: textDirection,
          style: GlobalVariable.getTextStyle(TextStyle(
            letterSpacing: letterSpacing,
            fontSize: GlobalVariable.ratioFontSize(context) * (fontSize ?? 14),
            fontWeight: fontWeight,
            color: color,
            fontFeatures: fontFeature,
            fontStyle: fontStyle,
            height: height,
            foreground: foreground,
            decoration: decoration,
            decorationThickness: decorationThickness,
          ), 
          ),
    ); 
  }
}
