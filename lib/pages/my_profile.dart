import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@NowaGenerated()
class MyProfile extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() {
    return _MyProfileState();
  }
}

@NowaGenerated()
class _MyProfileState extends State<MyProfile> {
  late Future<Map<String, dynamic>?> profileFuture;

  @override
  void initState() {
    super.initState();
    profileFuture = _fetchCurrentUserProfile();
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: profileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return Center(
                child: Text(
                  'Unable to load profile',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }
            final profile = snapshot.data;
            final avatarUrl = profile?['avatar_url'] as String?;
            final commonName = profile?['common_name'] as String? ?? 'User';
            final fullName = profile?['full_name'] as String?;
            final position = profile?['position'] as String? ?? '';
            final userRole = profile?['user_role'] as String? ?? '';
            final emailAddress =
                Supabase.instance.client.auth.currentUser?.email;
            final phone = profile?['phone'] as String?;
            final address = profile?['address'] as String?;
            final troupNo = profile?['troup_no'] as String?;
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Transform.translate(
                          offset: const Offset(0, -60),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.surface,
                                width: 4,
                              ),
                            ),
                            child: avatarUrl != null
                                ? CircleAvatar(
                                    radius: 60,
                                    backgroundImage: NetworkImage(avatarUrl!),
                                  )
                                : CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer,
                                    child: Text(
                                      commonName.isNotEmpty
                                          ? commonName[0].toUpperCase()
                                          : '?',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onPrimaryContainer,
                                          ),
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          commonName,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        if (fullName != null && fullName.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            fullName,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            position.isNotEmpty ? position : userRole,
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (emailAddress != null ||
                            phone != null ||
                            address != null) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                if (emailAddress != null &&
                                    emailAddress.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _buildInfoRow(
                                      context,
                                      'Email',
                                      emailAddress,
                                      Icons.email_outlined,
                                    ),
                                  ),
                                if (phone != null && phone.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _buildInfoRow(
                                      context,
                                      'Phone',
                                      phone,
                                      Icons.phone_outlined,
                                    ),
                                  ),
                                if (address != null && address.isNotEmpty)
                                  _buildInfoRow(
                                    context,
                                    'Address',
                                    address,
                                    Icons.location_on_outlined,
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                        if (troupNo != null && troupNo.isNotEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Troop Number',
                                  style: Theme.of(context).textTheme.labelMedium
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSecondaryContainer,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  troupNo,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSecondaryContainer,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<Map<String, dynamic>?> _fetchCurrentUserProfile() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        return null;
      }
      final userId = user.id;
      final response = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return response as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }
}
