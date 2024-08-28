import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pemob_uas/core/models/currency_model.dart';
import 'package:pemob_uas/ui/global/my_text.dart';

class CurrencyChart extends StatelessWidget {
  const CurrencyChart({super.key, required this.rates});

  final List<CurrencyRate> rates;

  @override
  Widget build(BuildContext context) {
    return LineChart(LineChartData(
        lineBarsData: [
          LineChartBarData(
              spots: rates
                  .map(
                    (e) => FlSpot(double.parse(e.date.split('-')[2]), e.rate),
                  )
                  .toList(),
              isCurved: true,
              dotData: const FlDotData(show: true))
        ],
        titlesData: FlTitlesData(
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(
                sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.isNaN || value.isInfinite) {
                  return const Text(
                      ''); // Return an empty text if value is NaN or Infinity
                }

                int index = value.toInt();

                // Check if the index is within the valid range of the list
                if (index >= 0 && index < rates.length) {
                  return Text(rates[index].date.split('-')[2]);
                } else {
                  return const Text(
                      ''); // Return an empty string if the index is out of bounds
                }
              },
            )))));
  }
}
