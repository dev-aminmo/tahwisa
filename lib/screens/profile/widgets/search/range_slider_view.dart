import 'package:flutter/material.dart';
import 'package:tahwisa/style/my_colors.dart';

class RangeSliderView extends StatelessWidget {
  const RangeSliderView({Key key, this.values, this.onChangeRangeValues})
      : super(key: key);

  final Function(RangeValues) onChangeRangeValues;
  final RangeValues values;

/*
  @override
  void initState() {
    _values = widget.values;
    super.initState();
  }
*/

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: values.start.round(),
                    child: const SizedBox(),
                  ),
                  Container(
                    width: 54,
                    child: Text(
                      values.start.toStringAsFixed(1),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 5 - values.start.round(),
                    child: const SizedBox(),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: values.end.round(),
                    child: const SizedBox(),
                  ),
                  Container(
                    width: 54,
                    child: Text(
                      values.end.toStringAsFixed(1),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 5 - values.end.round(),
                    child: const SizedBox(),
                  ),
                ],
              ),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              rangeThumbShape: CustomRangeThumbShape(),
              // activeTickMarkColor: MyColors.lightGreen,
              //   activeTrackColor: MyColors.lightGreen,
              //disabledActiveTrackColor: MyColors.gray,
            ),
            child: RangeSlider(
                values: values,
                min: 0.0,
                max: 5.0,
                activeColor: MyColors.lightGreen,
                inactiveColor: Colors.grey.withOpacity(0.4),
                divisions: 50,
                onChanged: onChangeRangeValues),
          ),
          /*      MaterialButton(
              child: Text("TTC"),
              onPressed: () => setState(() {
                    print("clicked");
                    _values = const RangeValues(1.5, 2.5);
                    print(_values);
                  }))*/
        ],
      ),
    );
  }
}

class CustomRangeThumbShape extends RangeSliderThumbShape {
  static const double _thumbSize = 20.0;
  static const double _disabledThumbSize = 20.0;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return isEnabled
        ? const Size.fromRadius(_thumbSize)
        : const Size.fromRadius(_disabledThumbSize);
  }

  static final Animatable<double> sizeTween = Tween<double>(
    begin: _disabledThumbSize,
    end: _thumbSize,
  );

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    @required Animation<double> activationAnimation,
    @required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool isOnTop,
    bool isPressed,
    @required SliderThemeData sliderTheme,
    TextDirection textDirection = TextDirection.ltr,
    Thumb thumb = Thumb.start,
  }) {
    final Canvas canvas = context.canvas;
    final ColorTween colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );

    final double size = _thumbSize * sizeTween.evaluate(enableAnimation);
    Path thumbPath;
    switch (textDirection) {
      case TextDirection.rtl:
        switch (thumb) {
          case Thumb.start:
            thumbPath = _rightTriangle(size, center);
            break;
          case Thumb.end:
            thumbPath = _leftTriangle(size, center);
            break;
        }
        break;
      case TextDirection.ltr:
        switch (thumb) {
          case Thumb.start:
            thumbPath = _leftTriangle(size, center);
            break;
          case Thumb.end:
            thumbPath = _rightTriangle(size, center);
            break;
        }
        break;
    }

    canvas.drawPath(
        Path()
          ..addOval(Rect.fromPoints(Offset(center.dx + 12, center.dy + 12),
              Offset(center.dx - 12, center.dy - 12)))
          ..fillType = PathFillType.evenOdd,
        Paint()
          ..color = Colors.black.withOpacity(0.5)
          ..maskFilter =
              MaskFilter.blur(BlurStyle.normal, convertRadiusToSigma(8)));

    final Paint cPaint = Paint();
    cPaint..color = Colors.white;
    cPaint..strokeWidth = 14 / 2;
    canvas.drawCircle(Offset(center.dx, center.dy), 12, cPaint);
    cPaint..color = colorTween.evaluate(enableAnimation);
    canvas.drawCircle(Offset(center.dx, center.dy), 10, cPaint);
    canvas.drawPath(thumbPath, Paint()..color = Colors.white);
  }

  double convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }

  Path _rightTriangle(double size, Offset thumbCenter, {bool invert = false}) {
    final Path thumbPath = Path();
    final double sign = invert ? -1.0 : 1.0;
    thumbPath.moveTo(thumbCenter.dx + 5 * sign, thumbCenter.dy);
    thumbPath.lineTo(thumbCenter.dx - 3 * sign, thumbCenter.dy - 5);
    thumbPath.lineTo(thumbCenter.dx - 3 * sign, thumbCenter.dy + 5);
    thumbPath.close();
    return thumbPath;
  }

  Path _leftTriangle(double size, Offset thumbCenter) =>
      _rightTriangle(size, thumbCenter, invert: true);
}
