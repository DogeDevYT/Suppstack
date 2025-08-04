import 'package:flutter/material.dart';

class SupplementCard extends StatelessWidget {
  final String brandName;
  final String productName;
  final String? dosage;
  final bool isTaken; // New property to control the "grayed out" state
  final VoidCallback onCardTap; // Callback for tapping the card
  final ValueChanged<bool?> onToggleTaken; // Callback for the checkbox

  const SupplementCard({
    Key? key,
    required this.brandName,
    required this.productName,
    this.dosage,
    required this.isTaken,
    required this.onCardTap,
    required this.onToggleTaken,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define styles that change based on the 'isTaken' state
    final titleColor = isTaken ? Colors.grey : Colors.black87;
    final subtitleColor = isTaken ? Colors.grey : Colors.black54;
    final textDecoration = isTaken ? TextDecoration.lineThrough : TextDecoration.none;

    return Card(
      elevation: isTaken ? 0 : 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: isTaken ? const Color(0xFFF0F0F0) : Colors.white,
      child: InkWell(
        onTap: onCardTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          child: Row(
            children: [
              // Checkbox on the left
              Checkbox(
                value: isTaken,
                onChanged: onToggleTaken,
                activeColor: Colors.purple,
              ),
              // Expanded text section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      brandName,
                      style: TextStyle(
                        color: subtitleColor,
                        fontWeight: FontWeight.bold,
                        decoration: textDecoration,
                      ),
                    ),
                    Text(
                      productName,
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: textDecoration,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (dosage != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        dosage!,
                        style: TextStyle(
                          color: subtitleColor,
                          decoration: textDecoration,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
              // Arrow icon on the right
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
