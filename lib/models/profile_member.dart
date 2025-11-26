import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class ProfileMember {
  ProfileMember({
    required this.id,
    this.fullName,
    this.commonName,
    this.avatarUrl,
    this.position,
    this.address,
    this.phone,
    this.troupNo,
  });

  factory ProfileMember.fromJson(Map<String, dynamic> json) {
    return ProfileMember(
      id: json['id'] as String,
      fullName: json['full_name'] as String?,
      commonName: json['common_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      position: json['position'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      troupNo: json['troup_no'] as String?,
    );
  }

  final String id;

  final String? fullName;

  final String? commonName;

  final String? avatarUrl;

  final String? position;

  final String? address;

  final String? phone;

  final String? troupNo;
}
