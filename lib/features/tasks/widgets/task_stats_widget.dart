import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class TaskStatsWidget extends StatelessWidget {
  const TaskStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: 'Total',
                    value: taskProvider.totalTasks.toString(),
                    icon: Icons.task_alt,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: 'Completed',
                    value: taskProvider.completedTasks.toString(),
                    icon: Icons.done,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: 'Pending',
                    value: taskProvider.pendingTasks.toString(),
                    icon: Icons.pending,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: 'Overdue',
                    value: taskProvider.overdueTasks.toString(),
                    icon: Icons.warning,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white.withValues(alpha: 0.8),
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
