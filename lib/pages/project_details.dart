import 'package:flutter/material.dart';
import 'package:orsa_3/models/project_model.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:orsa_3/models/project_team_member.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@NowaGenerated()
class ProjectDetails extends StatelessWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const ProjectDetails({required this.project, super.key});

  final ProjectModel project;

  String formatWithSeparator(double? value) {
    if (value == null) {
      return '0';
    }
    final formatted = value!.toStringAsFixed(0);
    final buffer = StringBuffer();
    final chars = formatted.split('');
    for (int i = 0; i < chars.length; i++) {
      if (i > 0 && (chars.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(chars[i]);
    }
    return buffer.toString();
  }

  Future<List<ProjectTeamMember>> fetchTeamMembers() async {
    final response = await Supabase.instance.client
        .from('project_team_members')
        .select('*, profiles(common_name, avatar_url)')
        .eq('project_id', project.id);
    return (response as List).map((item) {
      final profile = item['profiles'] as Map<String, dynamic>?;
      return ProjectTeamMember(
        id: item['id'] as int,
        projectId: item['project_id'] as int,
        userId: item['user_id'] as String,
        role: item['role'] as String?,
        createdAt: item['created_at'] as String?,
        fullName: profile?['common_name'] as String?,
        avatarUrl: profile?['avatar_url'] as String?,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  if (project.afterImageUrl != null)
                    Image.network(
                      project.afterImageUrl!,
                      height: 280,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 280,
                        color: colorScheme.outline,
                        child: Icon(
                          Icons.image_not_supported,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    )
                  else
                    Container(
                      height: 280,
                      color: colorScheme.outline,
                      child: Icon(
                        Icons.image_not_supported,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (project.projectType != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                project.projectType!,
                                style: textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          const SizedBox(height: 8),
                          Text(
                            project.projectName,
                            style: textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About This Project',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      project.description ?? 'No description available',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Team Members',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DataBuilder<List<ProjectTeamMember>>(
                      future: fetchTeamMembers(),
                      builder: (context, members) {
                        if (members.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                'No team members yet',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          );
                        }
                        return SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: members.length,
                            itemBuilder: (context, index) {
                              final member = members[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: colorScheme.shadow
                                                .withValues(alpha: 0.1),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: ClipOval(
                                        child: member.avatarUrl != null
                                            ? Image.network(
                                                member.avatarUrl!,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) => Container(
                                                      color:
                                                          colorScheme.primary,
                                                      child: Icon(
                                                        Icons.person,
                                                        color: colorScheme
                                                            .onPrimary,
                                                      ),
                                                    ),
                                              )
                                            : Container(
                                                color: colorScheme.primary,
                                                child: Icon(
                                                  Icons.person,
                                                  color: colorScheme.onPrimary,
                                                ),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        member.fullName ?? 'Unknown',
                                        style: textTheme.labelSmall?.copyWith(
                                          color: colorScheme.onSurface,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
