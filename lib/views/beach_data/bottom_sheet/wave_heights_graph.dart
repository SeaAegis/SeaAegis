import 'package:flutter/material.dart';
import 'package:seaaegis/testApi/tester1.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class TideChartBottomSheet extends StatelessWidget {
  final List<BeachConditions> conditionList;
  final List<TideData> tideData = [
    TideData(DateTime(2023, 9, 23, 2), 10),
    TideData(DateTime(2023, 9, 23, 6), 4),
    TideData(DateTime(2023, 9, 23, 10), 1),
    TideData(DateTime(2023, 9, 23, 14), 5),
    TideData(DateTime(2023, 9, 23, 18), 2),
    TideData(DateTime(2023, 9, 24, 2), 8),
  ];

  TideChartBottomSheet({super.key, required this.conditionList});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Tide Forecast',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 350,
            child: SfCartesianChart(
              primaryXAxis: const DateTimeAxis(
                title: AxisTitle(text: 'Time'),
                interval: 1,
                labelRotation: -75,
                intervalType: DateTimeIntervalType.hours,
                majorGridLines: MajorGridLines(width: 0),
                edgeLabelPlacement: EdgeLabelPlacement.shift,
              ),
              primaryYAxis: const NumericAxis(
                labelFormat: '{value} ft',
                minimum: 0,
                maximum: 10,
                interval: 1,
              ),
              series: <CartesianSeries>[
                SplineAreaSeries<BeachConditions, DateTime>(
                  dataSource: conditionList.sublist(0, 10),
                  color: Colors.blue.withOpacity(0.5),
                  borderColor: Colors.blue,
                  borderWidth: 2,
                  xValueMapper: (BeachConditions data, _) => data.time,
                  yValueMapper: (BeachConditions data, _) =>
                      (data.waveHeightM * 3.29),
                  dataLabelSettings: const DataLabelSettings(
                    angle: -55,
                    isVisible: true, // Enable data labels
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    labelAlignment: ChartDataLabelAlignment.top, // Positioning
                  ),
                  markerSettings: const MarkerSettings(
                      isVisible: true,
                      borderColor: Colors.white,
                      color: Colors.red,
                      borderWidth: 2,
                      width: 10,
                      height: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TideData {
  final DateTime time;
  final double height;

  TideData(this.time, this.height);
}
