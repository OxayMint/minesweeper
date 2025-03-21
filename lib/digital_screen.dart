import 'dart:async';

import 'package:flutter/material.dart';

class DigitalScreen extends StatefulWidget {
  DigitalScreen({
    super.key,
    required this.text,
    required this.digitsCount,
    this.timerMode = false,
    this.timerStarted = false,
  }) {
    backgroundText = String.fromCharCodes(
      List.generate(digitsCount, (index) => '8'.runes.first),
    );
  }

  final String text;
  final int digitsCount;
  final bool timerMode, timerStarted;
  late String backgroundText;

  @override
  State<DigitalScreen> createState() => _DigitalScreenState();
}

class _DigitalScreenState extends State<DigitalScreen> {
  int secondsPassed = 0;
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (widget.timerStarted) {
          secondsPassed++;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.digitsCount * 20 + 32,
      decoration: BoxDecoration(
        color: Colors.black,

        // color: Color(0xffb9b9b9),
        border: Border(
          right: BorderSide(width: 4, color: Color(0xfffcfcfc)),
          bottom: BorderSide(width: 4, color: Color(0xfffcfcfc)),
          top: BorderSide(width: 4, color: Color(0xff757575)),
          left: BorderSide(width: 4, color: Color(0xff757575)),
        ),
      ),
      // padding: EdgeInsets.all(8),
      // padding: EdgeInsets.zero,
      child: Center(
        child: Stack(
          alignment: Alignment.centerRight,
          // fit: StackFit.expand,
          children: [
            Text(
              widget.backgroundText,
              textAlign: TextAlign.right,
              overflow: TextOverflow.visible,
              style: TextStyle(
                fontFamily: 'Digital7',
                fontSize: 40,
                // color: Color(0xff00ff00),
                color: Color(0x45ff0000),
              ),
              strutStyle: StrutStyle(
                forceStrutHeight: true,
                height: 1, // Adjust as needed
                fontSize: 40,
              ),
            ),
            // RichText(
            //   text: TextSpan(
            //     // style: TextStyle(
            //     //   fontFamily: 'DS-DIGI',
            //     //   fontSize: 40,
            //     //   color: Color(0xffff0000),
            //     // ),
            //     children:
            //         (widget.timerMode ? secondsPassed.toString() : widget.text)
            //             .split('')
            //             .map((char) {
            //               return WidgetSpan(
            //                 child: SizedBox(
            //                   width: 20.5,
            //                   child: Text(
            //                     char,
            //                     textAlign: TextAlign.right,

            //                     style: TextStyle(
            //                       fontFamily: 'DS-DIGI',
            //                       fontSize: 40,
            //                       letterSpacing: 0,
            //                       color: Color(0xffff0000),
            //                     ),
            //                   ),
            //                 ),
            //               );
            //             })
            //             .toList(),
            //   ),
            // ),
            Text(
              textAlign: TextAlign.right,
              (widget.timerMode ? secondsPassed.toString() : widget.text),
              // .replaceAll('1', '1'),
              style: TextStyle(
                fontFamily: 'Digital7',
                fontSize: 40,
                color: Color(0xffff0000),
                // fontFeatures: [FontFeature.tabularFigures()],
                height: 1,
              ),
              strutStyle: StrutStyle(
                forceStrutHeight: true,
                height: 1, // Adjust as needed
                fontSize: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
