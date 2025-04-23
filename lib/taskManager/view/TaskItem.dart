import 'package:flutter/material.dart';
import '../model/TaskModel.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;
  final VoidCallback onToggleComplete;
  final VoidCallback onTap;

  const TaskItem({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onToggleComplete,
    required this.onTap,
  });

  Color _getPriorityColor() {
    switch (task.priority) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusDisplay(TaskStatus status) {
    switch (status) {
      case TaskStatus.chuaLam:
        return 'Chưa làm';
      case TaskStatus.dangLam:
        return 'Đang làm';
      case TaskStatus.hoanThanh:
        return 'Hoàn thành';
      case TaskStatus.daHuy:
        return 'Đã hủy';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          Icons.circle,
          color: _getPriorityColor(),
          size: 20,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            decoration: task.completed ? TextDecoration.lineThrough : null,
            color: task.completed ? Colors.grey : Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        subtitle: Text(
          'Trạng thái: ${_getStatusDisplay(task.status)}',
          style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7)),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                task.completed ? Icons.check_box : Icons.check_box_outline_blank,
                color: task.completed ? Colors.green : Colors.grey,
              ),
              onPressed: onToggleComplete,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}