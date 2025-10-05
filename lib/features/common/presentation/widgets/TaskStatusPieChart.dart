import 'package:flutter/material.dart';
import 'dart:math';

const Color primaryColor = Color(0xFF0A2744);
const Color accentColor = Color(0xFF42A5F5);
const Color successColor = Color(0xFF66BB6A);
const Color warningColor = Color(0xFFFFC107);
const Color infoColor = Color(0xFF9E9E9E);
const Color secondaryAccentColor = Color(0xFF1E88E5);

class PieChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final double total;

  PieChartPainter({required this.data, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    double currentAngle = -pi / 2;

    for (var item in data) {
      final value = item['value'] as double;
      final color = item['color'] as Color;
      final sweepAngle = (value / total) * 2 * pi;

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.4;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        currentAngle,
        sweepAngle,
        false,
        paint,
      );

      currentAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}


class TaskStatusPieChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const TaskStatusPieChart({super.key, required this.data});


  double get total => data.fold(0, (sum, item) => sum + item['value']);

  @override
  Widget build(BuildContext context) {
    final chartTotal = total;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.pie_chart, color: primaryColor, size: 24),
                const SizedBox(width: 8),
                Text(
                    'Task Distribution',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor
                    )
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: SizedBox(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Center(
                      child: CustomPaint(
                        size: const Size(100, 100),
                        painter: PieChartPainter(data: data, total: chartTotal),
                        child: Center(
                          child: Text(
                            '${chartTotal.toInt()}',
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10,),

                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(left: 10),
                      physics: const NeverScrollableScrollPhysics(),
                      children: data.map((item) {
                        final percentage = (item['value'] / chartTotal * 100).toStringAsFixed(0);
                        return Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: item['color'] as Color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${item['label']} (${percentage}%)',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}