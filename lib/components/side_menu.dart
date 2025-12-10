import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:orsa_3/pages/sign_in_page.dart';
import 'package:orsa_3/pages/my_profile.dart';
import 'package:orsa_3/pages/projects.dart';
import 'package:orsa_3/pages/members.dart';
import 'package:orsa_3/pages/events.dart';
import 'package:orsa_3/pages/memories_home.dart';

@NowaGenerated()
class SideMenu extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() {
    return _SideMenuState();
  }
}

@NowaGenerated()
class _SideMenuState extends State<SideMenu> {
  String avatarUrl = '';

  String commonName = 'User';

  String position = '';

  bool isLoadingProfile = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _handleLogout() async {
    try {
      await Supabase.instance.client.auth.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SignInPage()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error signing out: ${e}')));
      }
    }
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required void Function() onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
        size: 24,
      ),
      title: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      hoverColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                ],
              ),
            ),
            child: isLoadingProfile
                ? Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      avatarUrl.isNotEmpty
                          ? CircleAvatar(
                              radius: 32,
                              backgroundImage: NetworkImage(avatarUrl),
                            )
                          : CircleAvatar(
                              radius: 32,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              child: Text(
                                commonName.isNotEmpty
                                    ? commonName[0].toUpperCase()
                                    : '?',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                      const SizedBox(height: 12),
                      Text(
                        commonName,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (position.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            position,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimary
                                      .withValues(alpha: 0.8),
                                ),
                          ),
                        ),
                    ],
                  ),
          ),
          _buildMenuItem(
            context,
            icon: Icons.home_outlined,
            label: 'Home',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.person_outline,
            label: 'My Profile',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyProfile()),
              );
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.work_outline,
            label: 'Projects',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Projects()),
              );
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.people_outline,
            label: 'Members',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Members()),
              );
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.event_outlined,
            label: 'Events',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Events()),
              );
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.image_outlined,
            label: 'Memories',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MemoriesHome()),
              );
            },
          ),
          const Divider(indent: 16, endIndent: 16),
          _buildMenuItem(
            context,
            icon: Icons.settings_outlined,
            label: 'Settings',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: _handleLogout,
              icon: const Icon(Icons.logout),
              label: const Text('Log Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchUserProfile() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;
      if (userId == null || userId.isEmpty) {
        if (mounted) {
          setState(() {
            isLoadingProfile = false;
          });
        }
        return;
      }
      final response = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      if (mounted && response != null) {
        setState(() {
          final data = response as Map<String, dynamic>? ?? {};
          avatarUrl = (data['avatar_url'] as String?) ?? '';
          commonName = (data['common_name'] as String?) ?? 'User';
          position = (data['position'] as String?) ?? '';
          isLoadingProfile = false;
        });
      }
    } catch (e) {
      print('Error fetching profile: ${e}');
      if (mounted) {
        setState(() {
          isLoadingProfile = false;
        });
      }
    }
  }
}
