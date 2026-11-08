class CareTask {
  final String id;
  final String title;
  final String plantName;
  final String type;
  final String dueDate;
  final bool isCompleted;
  final DateTime? dueAt;

  const CareTask({
    required this.id,
    required this.title,
    required this.plantName,
    required this.type,
    required this.dueDate,
    this.isCompleted = false,
    this.dueAt,
  });
}