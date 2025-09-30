import 'package:flutter/material.dart';
import 'dart:math';

const Color primaryColor = Color(0xFF0A2744);
const Color accentColor = Color(0xFF42A5F5);
const Color successColor = Color(0xFF66BB6A);
const Color warningColor = Color(0xFFFFC107);
const Color infoColor = Color(0xFF9E9E9E);
const Color secondaryAccentColor = Color(0xFF1E88E5);
class ResourceRequestBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String unitLabel;

  const ResourceRequestBarChart({super.key, required this.data, required this.unitLabel});

  double get maxAmount => data.fold(0.0, (max, item) => max > item['value'] ? max : item['value'].toDouble());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Resource Request Volume ($unitLabel)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
          const SizedBox(height: 15),
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((item) {
                final double barHeightFactor = item['value'] / maxAmount;
                final barColor = item['color'] as Color;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Bar Label
                        Text(
                          item['value'].toString(),
                          style: TextStyle(fontSize: 12, color: primaryColor),
                        ),
                        const SizedBox(height: 4),
                        // Bar
                        Expanded(
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Container(
                                  height: constraints.maxHeight * barHeightFactor * 0.9, // 90% of max height
                                  decoration: BoxDecoration(
                                    color: barColor,
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // X-Axis Label
                        Text(
                          item['label'] as String,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}