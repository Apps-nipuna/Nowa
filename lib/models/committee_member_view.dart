import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class CommitteeMemberView {
  CommitteeMemberView({
    required this.year,
    required this.position,
    required this.commonName,
    this.avatarUrl,
  });

  factory CommitteeMemberView.fromJson(Map<String, dynamic> json) {
    return CommitteeMemberView(
      year: json['year'] as int,
      position: json['position'] as String,
      commonName: json['common_name'] as String,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  final int year;

  final String position;

  final String commonName;

  final String? avatarUrl;
}
