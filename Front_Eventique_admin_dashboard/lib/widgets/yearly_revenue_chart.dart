import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import '/models/revenue_model.dart';

class YearlyRevenueChart extends StatelessWidget {
  final List<charts.Series<Revenue, String>> seriesList;
  final bool animate;
  final Function(String)? onSelectionChanged;

  YearlyRevenueChart(this.seriesList,
      {required this.animate, this.onSelectionChanged});

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
      selectionModels: [
        charts.SelectionModelConfig(
          type: charts.SelectionModelType.info,
          changedListener: (charts.SelectionModel<String> model) {
            if (model.hasDatumSelection) {
              onSelectionChanged?.call(model.selectedDatum[0].datum.month);
            }
          },
        ),
      ],
      domainAxis: charts.OrdinalAxisSpec(
        viewport: charts.OrdinalViewport('Jan', 4),
      ),
      behaviors: [
        charts.SlidingViewport(),
        charts.PanAndZoomBehavior(),
      ],
    );
  }

  static List<charts.Series<Revenue, String>> createSampleData() {
    final data = [
      Revenue('Jan', 5000),
      Revenue('Feb', 25000),
      Revenue('Mar', 10000),
      Revenue('Apr', 7500),
      Revenue('May', 30000),
      Revenue('Jun', 20000),
      Revenue('Jul', 15000),
      Revenue('Aug', 25000),
      Revenue('Sep', 10000),
      Revenue('Oct', 5000),
      Revenue('Nov', 15000),
      Revenue('Dec', 20000),
    ];

    return [
      charts.Series<Revenue, String>(
        id: 'Revenue',
        colorFn: (Revenue revenue, int? index) {
          if (index != null && index % 2 == 0) {
            return charts.Color.fromHex(code: '#570E57');
          } else {
            return charts.Color.fromHex(code: '#570E57').darker;
          }
        },
        domainFn: (Revenue revenue, _) => revenue.month,
        measureFn: (Revenue revenue, _) => revenue.revenue,
        data: data,
      )
    ];
  }
}
