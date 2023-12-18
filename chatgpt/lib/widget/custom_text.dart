import 'dart:ui';

import 'package:flutter/material.dart';

class TKText extends StatelessWidget {
  const TKText({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter(),
      // painter: MyCustomPainter(
      //   text: '人生若只如初见啊双节快乐打瞌睡打开了手机打卡啦手机打卡啦手机打卡啦手机打卡机双打卡垃圾考拉手打',
      //   height: 1.5,
      //   fontSize: 24,
      // ),
      // size: const Size(0, 300),
    );
  }
}

class MyCustomPainter extends CustomPainter {
  // final TextAlign? _textAlign;
  // final TextDirection? _textDirection;
  // final int? _maxLines;
  // final String? _fontFamily;
  final String text;
  final double _fontSize;
  final double? _height;
  // final TextHeightBehavior? _textHeightBehavior;
  // final FontWeight? _fontWeight;
  // final FontStyle? _fontStyle;
  // final StrutStyle? _strutStyle;
  // final String? ellipsis;
  // final Locale? locale;

  final ParagraphStyle _paragraphStyle;

  MyCustomPainter({
    required this.text,
    TextAlign? textAlign,
    TextDirection? textDirection,
    int? maxLines,
    String? fontFamily,
    double? fontSize,
    double? height,
    TextHeightBehavior? textHeightBehavior,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    StrutStyle? strutStyle,
    String? ellipsis,
    Locale? locale,
  })  : _fontSize = fontSize ?? 16,
        _height = height,
        _paragraphStyle = ParagraphStyle(
          textAlign: textAlign,
          textDirection: textDirection,
          maxLines: maxLines,
          fontFamily: fontFamily,
          fontSize: fontSize,
          height: height,
          textHeightBehavior: textHeightBehavior,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          // strutStyle: strutStyle,
          ellipsis: ellipsis,
          locale: locale,
        );

  @override
  void paint(Canvas canvas, Size size) {
    double verticalMargin = 0;
    if (_height != null) {
      verticalMargin = (_fontSize * (_height! - 1)) * 0.5;
    }

    ParagraphBuilder paragraphBuilder = ParagraphBuilder(_paragraphStyle)..addText(text);
    ParagraphConstraints paragraphConstraints = const ParagraphConstraints(width: double.infinity);
    Paragraph paragraph = paragraphBuilder.build()..layout(paragraphConstraints);
    canvas.drawParagraph(paragraph, Offset(0, -verticalMargin));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => this != oldDelegate;
}


class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var textPainter = TextPainter(
      text: const TextSpan(
        text: 'Hello Flutter',
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.black,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    textPainter.paint(canvas, const Offset(0, 0));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => this != oldDelegate;
}
