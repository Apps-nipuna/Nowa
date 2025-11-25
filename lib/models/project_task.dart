import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class ProjectTask {
  ProjectTask({
    required this.id,
    required this.projectId,
    required this.taskName,
    required this.status,
  });

  factory ProjectTask.fromJson(Map<String, dynamic> json) {
    return ProjectTask(
      id: json['id'] as int,
      projectId: json['project_id'] as int,
      taskName: json['task_name'] as String,
      status: json['status'] as String,
    );
  }

  final int id;

  final int projectId;

  final String taskName;

  final String status;
}
