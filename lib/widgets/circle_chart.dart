import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:personal_expenses_2/widgets/icon_badge.dart';
import 'package:personal_expenses_2/widgets/info_cards.dart';

class CircleChart extends StatefulWidget {
  final List listOfTransactions;

  CircleChart({
    @required this.listOfTransactions,
  }) {}

  @override
  State<CircleChart> createState() => _CircleChartState();
}

class _CircleChartState extends State<CircleChart> {
  List myList = [];

  getColor(category){
    switch (category['name']) {
      case 'Entertainement':
        return  Colors.blue;
      case 'Social & Lifestyle':
        return Colors.purple;
      case 'Beauty & Health':
        return Colors.red;
      case 'Other':
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  int touchedIndex = -1;

  //initState will run the makeList() functions when this widget is loaded
  @override
  void initState() {
    super.initState();
    makeList();
  }

  // This function will make a list of map with the name of the category, the color of the category, the value of the category and the category itself
  makeList() {
    int cpt;
    int total = widget.listOfTransactions.length;
    while (widget.listOfTransactions.isNotEmpty) {
      var first = widget.listOfTransactions[0];
      cpt = 0;
      for (int j = 0; j < widget.listOfTransactions.length; j++) {
        if (widget.listOfTransactions[j].category['name'] ==
            first.category['name']) {
          cpt += 1;
        }
      }
      widget.listOfTransactions.removeWhere((element) {
        return element.category['name'] == first.category['name'];
      });
      myList.add({
        'name': first.category['name'],
        'color': getColor(first.category),
        'value': (cpt / total),
        'category': first.category,
      });
    }
  }

  onTap(int index) {
    setState(() {
      touchedIndex = index;
    });
  }

  onTapCancel() {
    setState(() {
      touchedIndex = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
              children: List.generate(
            myList.length,
            (index) => InfoCard(
              onTap: () => onTap(index),
              e: myList[index],
              onTapCancel: onTapCancel,
            ),
          )),
          SizedBox(height: 60),
          AspectRatio(
            aspectRatio: 1.3,
            child: AspectRatio(
              aspectRatio: 1,
              // This is the PieChart from the fl_chart package
              // https://pub.dev/packages/fl_chart
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex =
                            pieTouchResponse.touchedSection.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  centerSpaceRadius: 0,
                  sectionsSpace: 1,
                  //Generate the pie chart sections
                  sections: List.generate(
                    myList.length,
                    (i) {
                      final isTouched = i == touchedIndex;
                      return PieChartSectionData(
                        radius: isTouched ? 160 : 150,
                        value: myList[i]['value'],
                        color: myList[i]['color'],
                        showTitle: false,
                        badgePositionPercentageOffset: .98,
                        badgeWidget: IconBadge(
                          size: 40,
                          category: myList[i]['category'],
                          borderColor: Colors.grey.withOpacity(0.2),
                        ),
                        borderSide: isTouched
                            ? const BorderSide(color: Colors.white)
                            : BorderSide(color: Colors.white.withOpacity(0.3)),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
