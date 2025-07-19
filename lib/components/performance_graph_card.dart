import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:classbridge/model/student_performance.dart';

class PerformanceGraphCard extends StatelessWidget {
  final SubjectPerformance performance;

  const PerformanceGraphCard({
    Key? key,
    required this.performance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  performance.subjectName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getAverageColor(performance.averageScore),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Avg: ${performance.averageScore.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        reservedSize: 30,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= performance.scores.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Test ${value.toInt() + 1}',
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  minX: 0,
                  maxX: (performance.scores.length - 1).toDouble(),
                  minY: 0,
                  maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                      spots: performance.scores
                          .asMap()
                          .entries
                          .map((entry) => FlSpot(
                                entry.key.toDouble(),
                                entry.value.score,
                              ))
                          .toList(),
                      isCurved: true,
                      color: Theme.of(context).primaryColor,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: performance.scores
            .asMap()
            .entries
            .map(
              (entry) => Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getScoreColor(entry.value.score),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${entry.value.testName}: ${entry.value.score.toStringAsFixed(1)}%',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 90) return Colors.green;
    if (score >= 80) return Colors.lightGreen;
    if (score >= 70) return Colors.yellow.shade700;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  Color _getAverageColor(double average) {
    if (average >= 90) return Colors.green;
    if (average >= 80) return Colors.lightGreen;
    if (average >= 70) return Colors.yellow.shade700;
    if (average >= 60) return Colors.orange;
    return Colors.red;
  }
}