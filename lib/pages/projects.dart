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
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
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
          ],
        ),
      ),
    );
  }
}
