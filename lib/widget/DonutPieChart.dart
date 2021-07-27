import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import '../entity/ArticleItem.dart';

class DonutPieChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  DonutPieChart(this.seriesList, {this.animate});


  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: animate,
        // Configure the width of the pie slices to 60px. The remaining space in
        // the chart will be left as a hole in the center.
        defaultRenderer: new charts.ArcRendererConfig(arcWidth: 30),
      behaviors: [
        // our title behaviour
        new charts.DatumLegend(
          position: charts.BehaviorPosition.top,
          outsideJustification: charts.OutsideJustification.middleDrawArea,
          horizontalFirst: false,
          cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
          showMeasures: true,
          desiredMaxColumns: 3,
          desiredMaxRows: 2,
          legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
          measureFormatter: (num value) {
            return value == null ? '-' : "$value";
          },
          entryTextStyle: charts.TextStyleSpec(
              color: charts.MaterialPalette.black,
              fontFamily: 'Roboto',
              fontSize: 16),
        ),
      ],

    );
  }

  static List<Color> colors = [
    Colors.amber, Colors.blue, Colors.greenAccent, Colors.pinkAccent, Colors.cyan,
    Colors.red, Colors.grey, Colors.green[700], Colors.brown, Colors.deepPurple
  ];

  static List<charts.Series<ArticleItem, String>> createSampleData(List<ArticleItem> articleItems) {
    int i = 0;
    for (ArticleItem item in articleItems) {
      item.color = colors.elementAt(i);
      i++;
    }
    return [
      new charts.Series<ArticleItem, String>(
        id: 'Articles',
        data: articleItems,
        domainFn: (ArticleItem item, _) => item.name,
        measureFn: (ArticleItem item, _) => item.sum,
        colorFn: (ArticleItem item, _) => charts.ColorUtil.fromDartColor(item.color),
      )
    ];
  }

/// Create one series with sample hard coded data.
  /*static List<charts.Series<LinearSales, int>> _createSampleData() {
    final data = [
      new LinearSales(0, 100),
      new LinearSales(1, 75),
      new LinearSales(2, 25),
      new LinearSales(3, 5),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }*/
}



/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}


