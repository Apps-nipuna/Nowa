import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class Profile {
  Profile({
    required this.id,
    required this.createdAt,
    this.fullName,
    this.commonName,
    this.avatarUrl,
    this.address,
    this.emailAddress,
    this.phone,
    this.troupNo,
    required this.userRole,
    required this.position,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      createdAt: json['created_at'] as String,
      fullName: json['full_name'] as String?,
      commonName: json['common_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      address: json['address'] as String?,
      emailAddress: json['email_address'] as String?,
      phone: json['phone'] as String?,
      troupNo: json['troup_no'] as String?,
      userRole: json['user_role'] as String,
      position: json['position'] as String,
    );
  }

  final String id;

  final String createdAt;

  final String? fullName;

  final String? commonName;

  final String? avatarUrl;

  final String? address;

  final String? emailAddress;

  final String? phone;

  final String? troupNo;

  final String userRole;

  final String position;
}
