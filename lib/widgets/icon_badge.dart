import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconBadge extends StatelessWidget {
  const IconBadge({
    this.size,
    this.borderColor,
    this.category,
  });
  final double size;
  final Color borderColor;
  final Map category;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: Image.asset(
          "assets/" + getImage() + ".png",
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }

  String getImage() {
    switch (category['name']) {
      case 'Entertainement':
        return 'Entertainement40';
      case 'Social & Lifestyle':
        return 'Lifestyle40';
      case 'Beauty & Health':
        return 'Beauty40';
      case 'Other':
        return 'Other40';
      default:
        return '';
    }
  }
}
