import 'dart:math';
import 'dart:typed_data';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HeartChart extends StatelessWidget {
  final Stream<Uint8List> input;
  const HeartChart({Key? key, required this.input}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allData = List<int>.empty(growable: true);
    return StreamBuilder<Uint8List>(
        stream: input,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            allData.addAll(snapshot.data!);
            const length = 24;
            if (allData.length > length)
              allData.removeRange(0, allData.length - length);
            final vals = List.filled(length, 0);
            for (int i = 0; i < min(length, allData.length); i++) {
              vals[length - 1 - i] = allData[allData.length - 1 - i];
            }
            final spots = List<FlSpot>.empty(growable: true);
            for (var i = 0; i < length; i++) {
              spots.add(FlSpot(i.toDouble(), vals[i].toDouble()));
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      belowBarData: BarAreaData(
                        show: true,
                        colors: [
                          Theme.of(context).accentColor.withOpacity(0.03),
                          Theme.of(context).accentColor.withOpacity(0.1),
                        ],
                      ),
                      isCurved: true,
                      curveSmoothness: 0.1,
                      preventCurveOverShooting: true,
                      colors: [
                        Theme.of(context).accentColor.withOpacity(0.2),
                        Theme.of(context).accentColor,
                      ],
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                      spots: spots,
                    )
                  ],
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: const Color(0x22ffffff),
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: const Color(0x22ffffff),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: SideTitles(
                      showTitles: false,
                      reservedSize: 22,
                      // textStyle: const TextStyle(
                      //     color: Color(0xff68737d),
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 16),
                    ),
                    leftTitles: SideTitles(
                      showTitles: true, interval: 20,
                      // textStyle: const TextStyle(
                      //     color: Color(0xff67727d),
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 15),
                    ),
                  ),
                  minY: 0,
                  maxY: 250,
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: const Color(0xff37434d),
                      width: 1,
                    ),
                  ),
                ),
                swapAnimationDuration: Duration(milliseconds: 0),
              ),
            );
          }
          return Container();
        });
  }
}
