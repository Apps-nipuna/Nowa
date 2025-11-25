import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class ProjectContributor {
  ProjectContributor({
    required this.id,
    required this.projectId,
    required this.userId,
    required this.amount,
    this.contributionDate,
    this.phoneNumber,
    this.status,
    this.commonName,
    this.avatarUrl,
  });

  factory ProjectContributor.fromJson(Map<String, dynamic> json) {
    return ProjectContributor(
      id: json['id'] as int,
      projectId: json['project_id'] as int,
      userId: json['user_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      contributionDate: json['contribution_date'] as String?,
      phoneNumber: json['phone_number'] as String?,
      status: json['status'] as String?,
      commonName: json['common_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  final int id;

  final int projectId;

  final String userId;

  final double amount;

  final String? contributionDate;

  final String? phoneNumber;

  final String? status;

  final String? commonName;

  final String? avatarUrl;
}
