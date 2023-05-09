import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class InfoCard extends StatefulWidget {
  InfoCard({
    Key key,
    this.e,
    this.onTap,
    this.onTapCancel,
  }) : super(key: key);

  final Map<String, dynamic> e;
  final VoidCallback onTap;
  final VoidCallback onTapCancel;

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  bool reverseColor = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          reverseColor = !reverseColor;
          widget.onTap();
        });
      },
      onTapUp: (_) {
        setState(() {
          reverseColor = false;
          widget.onTapCancel();
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: reverseColor ? widget.e['color'] : Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          width: MediaQuery.of(context).size.width / 2 - 36,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.e['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: !reverseColor ? widget.e['color'] : Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${(widget.e['value'] * 100).toStringAsFixed(2)}%',
                  style: TextStyle(
                    fontSize: 24,
                    color: !reverseColor ? widget.e['color'] : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
