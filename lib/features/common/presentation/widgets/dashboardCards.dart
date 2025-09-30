import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashboardCard extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String description;
  final IconData? icon;
  final VoidCallback? onTap;

  const DashboardCard({
    super.key,
    required this.imageAsset,
    required this.title,
    required this.description,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSvg = imageAsset.endsWith('.svg');
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF0A2744).withOpacity(0.25),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 6,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (icon != null)
                          Icon(icon, color: Color(0xFF0A2744), size: 28),
                        if (icon != null) const SizedBox(width: 8),

                        Text(
                          title,
                          style: const TextStyle(
                            color: Color(0xFF0A2744),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF0A2744),
                      size: 18,
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFF0A2744),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: isSvg
                          ? SvgPicture.asset(
                              imageAsset,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              imageAsset,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        description,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
