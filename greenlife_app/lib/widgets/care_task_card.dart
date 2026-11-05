import 'package:flutter/material.dart';
import 'package:greenlife_app/models/care_task.dart';

class CareTaskCard extends StatelessWidget {
  final CareTask task;

  const CareTaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final color = task.isCompleted
        ? const Color(0xFF74B97D)
        : const Color(0xFFEAB349);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withAlpha(28),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              task.isCompleted ? Icons.check : Icons.notifications_active,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${task.plantName} • ${task.type}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF5F6F62),
                  ),
                ),
              ],
            ),
          ),
          Text(
            task.dueDate,
            style: const TextStyle(fontSize: 11, color: Color(0xFF6C7A70)),
          ),
        ],
      ),
    );
  }
}
