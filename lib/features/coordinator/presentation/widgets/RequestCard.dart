import 'package:dhap_flutter_project/data/model/request_model.dart';
import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF0A2744);
const Color accentColor = Color(0xFF42A5F5);

class RequestCard extends StatelessWidget {
  final Request request;
  final Function(String) onResponseTap;

  const RequestCard({
    super.key,
    required this.request,
    required this.onResponseTap,
  });

  @override
  Widget build(BuildContext context) {
    String formatQuantity(int quantity) {
      if (quantity >= 1000) {
        return '${(quantity / 1000).toStringAsFixed(1)}K';
      }
      return quantity.toString();
    }

    String badgeLabel;
    Color badgeColor;
    if (request.responseIds.isEmpty) {
      badgeLabel = '0';
      badgeColor = Colors.grey;
    } else if (request.responseIds.length > 99) {
      badgeLabel = '99+';
      badgeColor = Colors.red;
    } else {
      badgeLabel = '${request.responseIds.length}';
      badgeColor = Colors.red;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    request.resource,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    onResponseTap(request.id);
                  },
                  child: Badge(
                    isLabelVisible: request.responseIds.isNotEmpty,
                    label: Text(
                      badgeLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    alignment: Alignment.topRight,
                    backgroundColor: badgeColor,
                    padding: const EdgeInsets.all(5),
                    child: const Icon(
                      Icons.reply,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 10,)
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.description,
                  style: TextStyle(
                    color: primaryColor.withAlpha((0.8 * 255).round()),
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Divider(height: 16),
                _buildInfoRow(
                  icon: Icons.numbers,
                  label: 'Required',
                  value: formatQuantity(request.quantity),
                  color: Colors.red.shade700,
                ),
                _buildInfoRow(
                  icon: Icons.location_on,
                  label: 'Address',
                  value: request.address,
                  color: primaryColor,
                ),
                // _buildInfoRow(
                //   icon: Icons.info,
                //   label: 'Status',
                //   value: request.status,
                //   color: request.status == 'Pending' ? Colors.orange.shade700 : Colors.green.shade700,
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: color),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}