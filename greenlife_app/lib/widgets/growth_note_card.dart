import 'package:flutter/material.dart';
import 'package:greenlife_app/models/growth_note.dart';

class GrowthNoteCard extends StatelessWidget {
  final GrowthNote note;
  final VoidCallback? onTap;
  final bool isSelected;

  const GrowthNoteCard({
    super.key,
    required this.note,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected ? const Color(0xFF2F6A4F) : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                note.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2F4E4),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  note.date,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF2F6A4F),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            note.plantName,
            style: const TextStyle(fontSize: 12, color: Color(0xFF5F6F62)),
          ),
          const SizedBox(height: 12),
          Text(
            note.summary,
            style: const TextStyle(height: 1.6, color: Color(0xFF324437)),
          ),
        ],
      ),
    );

    if (onTap == null) {
      return card;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: card,
      ),
    );
  }
}
