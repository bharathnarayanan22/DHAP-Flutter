import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const Color primaryColor = Color(0xFF0A2744);
const Color accentColor = Color(0xFF42A5F5);

class StatusFilterSegment extends StatefulWidget {
  final ValueChanged<String> onStatusChanged;
  final String selectedStatus;

  const StatusFilterSegment({
    super.key,
    required this.onStatusChanged,
    required this.selectedStatus,
  });

  @override
  State<StatusFilterSegment> createState() => _StatusFilterSegmentState();
}

class _StatusFilterSegmentState extends State<StatusFilterSegment> {
  final List<String> statuses = ["All", "In Progress", "In Verification", "Completed"];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final segmentWidth = constraints.maxWidth / statuses.length;

      return SegmentedButton<String>(
        segments: statuses
            .map(
              (status) => ButtonSegment<String>(
            value: status,
            label: SizedBox(
              width: segmentWidth,
              child: Center(
                child: Text(
                  status,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        )
            .toList(),
        selected: {widget.selectedStatus},
        onSelectionChanged: (newSelection) {
          widget.onStatusChanged(newSelection.first);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                (states) {
              if (states.contains(MaterialState.selected)) {
                return primaryColor;
              }
              return Colors.white;
            },
          ),
          foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                (states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.white;
              }
              return primaryColor;
            },
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: primaryColor, width: 1.5),
            ),
          ),
        ),
      );
    });
  }
}