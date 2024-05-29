import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:pfe/screens/chartmodel.dart';

class test extends StatelessWidget {
  test({Key? key}) : super(key: key);
  final List<BarChartModel> data = [
    BarChartModel(
      year: "Lun",
      temperature: 25,
    ),
    BarChartModel(
      year: "Mar",
      temperature: 30,
    ),
    BarChartModel(
      year: "Mer",
      temperature: 10,
    ),
    BarChartModel(
      year: "Jeu",
      temperature: 45,
    ),
    BarChartModel(
      year: "Ven",
      temperature: 36,
    ),
    BarChartModel(
      year: "Sam",
      temperature: 23,
    ),
    BarChartModel(
      year: "Dim",
      temperature: 40,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<charts.Series<BarChartModel, String>> series = [
      charts.Series(
        id: "temperature",
        data: data,
        domainFn: (BarChartModel series, _) => series.year,
        measureFn: (BarChartModel series, _) => series.temperature,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bar Chart"),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: Container(
        height: 300,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        child: charts.BarChart(
          series,
          animate: true,
        ),
      ),
    );
  }
}
