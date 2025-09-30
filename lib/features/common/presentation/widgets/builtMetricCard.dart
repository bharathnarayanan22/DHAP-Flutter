// import 'package:flutter/material.dart';
//
// class MetricCard extends StatelessWidget {
//   final String title;
//   final int value;
//   final IconData icon;
//   final Color color;
//
//   const MetricCard({
//     super.key,
//     required this.title,
//     required this.value,
//     required this.icon,
//     required this.color,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     double baseFontSize = screenWidth < 500 ? 13 : 16;
//     double valueFontSize = screenWidth < 500 ? 18 : 20;
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             padding: EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFF0A2744), Color(0xFF0958B1)],
//               ),
//               borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(icon, color: Colors.white, size: 20),
//                 SizedBox(width: 8),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: baseFontSize,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           Container(
//             padding: EdgeInsets.all(12),
//
//             child: Center(
//               child: Text(
//                 value.toString(),
//                 style: TextStyle(
//                   fontSize: valueFontSize,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  final String title;
  final int value;
  final IconData icon;
  final Color color;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0A2744), Color(0xFF0958B1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 18),
                const SizedBox(width: 6),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Center(
              child: Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0A2744),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
