import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:pfe/screens/chartmodel.dart';
import 'package:pfe/screens/electricalEnergie.dart';
import 'package:pfe/screens/home_screen.dart';
import 'package:pfe/utils/color.utils.dart';

class Generalenergiescreen extends StatefulWidget {
  const Generalenergiescreen({Key? key}) : super(key: key);

  @override
  State<Generalenergiescreen> createState() => _GeneralenergiescreenState();
}

class _GeneralenergiescreenState extends State<Generalenergiescreen> {
  final List<BarChartModel> data = [
    BarChartModel(year: "Lun", temperature: 32),
    BarChartModel(year: "Mar", temperature: 30),
    BarChartModel(year: "Mer", temperature: 10),
    BarChartModel(year: "Jeu", temperature: 45),
    BarChartModel(year: "Ven", temperature: 36),
    BarChartModel(year: "Sam", temperature: 23),
    BarChartModel(year: "Dim", temperature: 40),
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Energie",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white, // Couleur de la flèche de retour
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("696969"), // hedha couleur l gris
          hexStringToColor("332d4f"), // hedha l couleur l azra9
          // hexStringToColor("01cda9"),
          // hexStringToColor("")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              // Utilisez un Column au lieu d'un Row
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: 60, // Définir la hauteur souhaitée
                        child: TextButton(
                          onPressed: () {
                            // Action pour le premier bouton
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue, // Couleur de fond
                          ),
                          child: Text(
                            "General",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15), // Taille de police plus petite
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: 60, // Définir la hauteur souhaitée
                        child: TextButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      electricalEnergieScreen())),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue, // Couleur de fond
                          ),
                          child: Text(
                            "Electrical energy",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15), // Taille de police plus petite
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: 60, // Définir la hauteur souhaitée
                        child: TextButton(
                          onPressed: () {
                            // Action pour le troisième bouton
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue, // Couleur de fond
                          ),
                          child: Text(
                            "Indoor Climate",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15), // Taille de police plus petite
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "temperature",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ), // Espacement entre les boutons et le graphique
                Container(
                  height: 250,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                  child: charts.BarChart(
                    series,
                    animate: true,
                    domainAxis: const charts.OrdinalAxisSpec(
                      renderSpec: charts.SmallTickRendererSpec(
                        labelStyle:
                            charts.TextStyleSpec(color: charts.Color.white),
                        lineStyle:
                            charts.LineStyleSpec(color: charts.Color.white),
                      ),
                    ),
                    primaryMeasureAxis: const charts.NumericAxisSpec(
                      renderSpec: charts.GridlineRendererSpec(
                        labelStyle:
                            charts.TextStyleSpec(color: charts.Color.white),
                        lineStyle:
                            charts.LineStyleSpec(color: charts.Color.white),
                      ),
                    ),
                  ),
                ),
                Text(
                  "humidité",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Container(
                  height: 250,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                  child: charts.BarChart(
                    series,
                    animate: true,
                    domainAxis: const charts.OrdinalAxisSpec(
                      renderSpec: charts.SmallTickRendererSpec(
                        labelStyle:
                            charts.TextStyleSpec(color: charts.Color.white),
                        lineStyle:
                            charts.LineStyleSpec(color: charts.Color.white),
                      ),
                    ),
                    primaryMeasureAxis: const charts.NumericAxisSpec(
                      renderSpec: charts.GridlineRendererSpec(
                        labelStyle:
                            charts.TextStyleSpec(color: charts.Color.white),
                        lineStyle:
                            charts.LineStyleSpec(color: charts.Color.white),
                      ),
                    ),
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
