import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class ProjectFile {
  ProjectFile({
    required this.id,
    required this.projectId,
    required this.fileName,
    required this.fileUrl,
    this.createdAt,
  });

  factory ProjectFile.fromJson(Map<String, dynamic> json) {
    return ProjectFile(
      id: json['id'] as int,
      projectId: json['project_id'] as int,
      fileName: json['file_name'] as String,
      fileUrl: json['file_url'] as String,
      createdAt: json['created_at'] as String?,
    );
  }

  final int id;

  final int projectId;

  final String fileName;

  final String fileUrl;

  final String? createdAt;
}
