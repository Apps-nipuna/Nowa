import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:orsa_3/models/project_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:orsa_3/components/project_card.dart';

@NowaGenerated()
class Projects extends StatelessWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const Projects({super.key});

  Future<List<ProjectModel>> fetchProjects() async {
    final response = await Supabase.instance.client
        .from('projects')
        .select()
        .order('created_at', ascending: false);
    return (response as List)
        .map((item) => ProjectModel.fromJson(item))
        .toList();
  }

  Future<bool> _checkUserPermissions() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final response = await Supabase.instance.client
            .from('profiles')
            .select('user_role, position')
            .eq('id', user.id)
            .single();
        final userRole = response['user_role'] as String? ?? '';
        final position = response['position'] as String? ?? '';
        return userRole == 'admin' ||
            position == 'President' ||
            position == 'Secretary';
      }
      return false;
    } catch (e) {
      print('Error checking permissions: ${e}');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Text(
                    'Projects',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: DataBuilder<List<ProjectModel>>(
                future: fetchProjects(),
                builder: (context, projects) {
                  if (projects.isEmpty) {
                    return Center(
                      child: Text(
                        'No projects yet',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: projects.length,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) =>
                        ProjectCard(project: projects[index]),
                  );
                },
              ),
            ),
            const SizedBox(height: 70),
          ],
        ),
      ),
      floatingActionButton: FutureBuilder<bool>(
        future: _checkUserPermissions(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data == true) {
            return FloatingActionButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('New project action'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
