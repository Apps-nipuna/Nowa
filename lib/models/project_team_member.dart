import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class ProjectTeamMember {
  ProjectTeamMember({
    required this.id,
    required this.projectId,
    required this.userId,
    this.role,
    this.createdAt,
    this.fullName,
    this.avatarUrl,
  });

  factory ProjectTeamMember.fromJson(Map<String, dynamic> json) {
    return ProjectTeamMember(
      id: json['id'] as int,
      projectId: json['project_id'] as int,
      userId: json['user_id'] as String,
      role: json['role'] as String?,
      createdAt: json['created_at'] as String?,
      fullName: json['full_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  final int id;

  final int projectId;

  final String userId;

  final String? role;

  final String? createdAt;

  final String? fullName;

  final String? avatarUrl;
}
