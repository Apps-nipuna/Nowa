import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class ProjectModel {
  ProjectModel({
    required this.id,
    required this.projectName,
    this.projectType,
    this.afterImageUrl,
    this.description,
    this.budgetGoal,
    this.budgetCollected,
    this.totalTasks,
    this.completedTasks,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as int,
      projectName: json['project_name'] as String,
      projectType: json['project_type'] as String?,
      afterImageUrl: json['image_after_url'] as String?,
      description: json['description'] as String?,
      budgetGoal: (json['budget_goal'] as num?)?.toDouble(),
      budgetCollected: (json['budget_collected'] as num?)?.toDouble(),
      totalTasks: json['total_tasks'] as int?,
      completedTasks: json['completed_tasks'] as int?,
    );
  }

  final int id;

  final String projectName;

  final String? projectType;

  final String? afterImageUrl;

  final String? description;

  final double? budgetGoal;

  final double? budgetCollected;

  final int? totalTasks;

  final int? completedTasks;
}
