import 'package:flutter/material.dart';
import 'package:orsa_3/models/profile_member.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@NowaGenerated()
class PublicProfile extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const PublicProfile({required this.userId, super.key});

  final String userId;

  @override
  State<PublicProfile> createState() {
    return _PublicProfileState();
  }
}

@NowaGenerated()
class _PublicProfileState extends State<PublicProfile> {
  late Future<ProfileMember> profileFuture;

  @override
  void initState() {
    super.initState();
    profileFuture = _fetchProfile();
  }

  Future<ProfileMember> _fetchProfile() async {
    final response = await Supabase.instance.client
        .from('profiles')
        .select()
        .eq('id', widget.userId);
    final list = response as List;
    if (list.isEmpty) {
      throw Exception('Profile not found');
    }
    return ProfileMember.fromJson(list[0] as Map<String, dynamic>);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<ProfileMember>(
          future: profileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text('Error: ${snapshot.error}'),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: Text('Member not found'));
            }
            final profile = snapshot.data;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.2),
                          blurRadius: 16,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: profile?.avatarUrl != null
                        ? ClipOval(
                            child: Image.network(
                              profile!.avatarUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => Container(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primaryContainer,
                                child: Icon(
                                  Icons.person,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 60,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            child: Icon(
                              Icons.person,
                              color: Theme.of(context).colorScheme.primary,
                              size: 60,
                            ),
                          ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Text(
                          profile?.commonName ?? 'Member',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        if (profile?.fullName != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              profile!.fullName!,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        if (profile?.address != null &&
                            profile!.address!.isNotEmpty)
                          _buildDetailCard(
                            context,
                            Icons.location_on,
                            'Address',
                            profile!.address!,
                          ),
                        if (profile?.address != null &&
                            profile!.address!.isNotEmpty)
                          const SizedBox(height: 16),
                        if (profile?.phone != null &&
                            profile!.phone!.isNotEmpty)
                          _buildDetailCard(
                            context,
                            Icons.phone,
                            'Phone Number',
                            profile!.phone!,
                          ),
                        if (profile?.phone != null &&
                            profile!.phone!.isNotEmpty)
                          const SizedBox(height: 16),
                        if (profile?.troupNo != null &&
                            profile!.troupNo!.isNotEmpty)
                          _buildDetailCard(
                            context,
                            Icons.badge,
                            'Troop No',
                            profile!.troupNo!,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailCard(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
