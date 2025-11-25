import 'package:flutter/material.dart';
import 'package:orsa_3/models/project_model.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:dio/dio.dart';
import 'package:orsa_3/models/project_team_member.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:orsa_3/models/project_file.dart';
import 'package:orsa_3/models/project_task.dart';
import 'package:orsa_3/models/project_contributor.dart';
import 'package:orsa_3/components/contributors_section.dart';

@NowaGenerated()
class ProjectDetails extends StatelessWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const ProjectDetails({required this.project, super.key});

  final ProjectModel project;

  Future<void> downloadFile(
    BuildContext context,
    String fileName,
    String fileUrl,
  ) async {
    try {
      final dio = Dio();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Downloading: ${fileName}'),
            duration: const Duration(seconds: 1),
          ),
        );
      }
      final fileName_safe = fileName.replaceAll(RegExp('[<>:"/\\\\|?*]'), '_');
      final filePath = '/tmp/${fileName_safe}';
      await dio.download(fileUrl, filePath);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Downloaded: ${fileName}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Download failed: ${e.toString()}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
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

  Future<List<ProjectFile>> fetchProjectFiles() async {
    final response = await Supabase.instance.client
        .from('project_files')
        .select()
        .eq('project_id', project.id);
    return (response as List)
        .map((item) => ProjectFile.fromJson(item))
        .toList();
  }

  Color getStatusColor(String status, ColorScheme colorScheme) {
    switch (status.toLowerCase()) {
      case 'completed':
        return colorScheme.primary;
      case 'in_progress':
      case 'in progress':
        return const Color(0xffffa500);
      case 'pending':
        return colorScheme.outline;
      default:
        return colorScheme.outline;
    }
  }

  String getStatusDisplay(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'COMPLETED';
      case 'in_progress':
      case 'in progress':
        return 'IN PROGRESS';
      case 'pending':
        return 'PENDING';
      default:
        return status.toUpperCase();
    }
  }

  Future<List<ProjectTask>> fetchProjectTasks() async {
    final response = await Supabase.instance.client
        .from('project_tasks')
        .select()
        .eq('project_id', project.id)
        .order('id', ascending: true);
    return (response as List)
        .map((item) => ProjectTask.fromJson(item))
        .toList();
  }

  Future<List<ProjectContributor>> fetchContributors() async {
    final response = await Supabase.instance.client
        .from('project_contributions')
        .select('*, profiles(common_name, avatar_url)')
        .eq('project_id', project.id)
        .order('contribution_date', ascending: false);
    return (response as List).map((item) {
      final profile = item['profiles'] as Map<String, dynamic>?;
      return ProjectContributor(
        id: item['id'] as int,
        projectId: item['project_id'] as int,
        userId: item['user_id'] as String,
        amount: (item['amount'] as num).toDouble(),
        contributionDate: item['contribution_date'] as String?,
        phoneNumber: item['phone_number'] as String?,
        status: item['status'] as String?,
        commonName: profile?['common_name'] as String?,
        avatarUrl: profile?['avatar_url'] as String?,
      );
    }).toList();
  }

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

  Widget buildBudgetSection(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    if (project.budgetGoal == null || project.budgetGoal! <= 0) {
      return const SizedBox.shrink();
    }
    final budgetProgress = (project.budgetCollected ?? 0) / project.budgetGoal!;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Budget Progress',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Budget Collected',
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '${(budgetProgress * 100).toStringAsFixed(0)}%',
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              alignment: Alignment.center,
              children: [
                LinearProgressIndicator(
                  value: budgetProgress.clamp(0, 1),
                  minHeight: 32,
                  backgroundColor: colorScheme.outline.withValues(alpha: 0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colorScheme.primary,
                  ),
                ),
                Text(
                  'LKR ${formatWithSeparator(project.budgetCollected)} / ${formatWithSeparator(project.budgetGoal)}',
                  style: textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Contribute button tapped'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Contribute',
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Project Files',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DataBuilder<List<ProjectFile>>(
                      future: fetchProjectFiles(),
                      builder: (context, files) {
                        if (files.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                'No files available',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: files.length,
                          itemBuilder: (context, index) {
                            final file = files[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: colorScheme.outline.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.file_present,
                                    color: colorScheme.primary,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      file.fileName,
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.onSurface,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  GestureDetector(
                                    onTap: () {
                                      downloadFile(
                                        context,
                                        file.fileName,
                                        file.fileUrl,
                                      );
                                    },
                                    child: Text(
                                      'Download',
                                      style: textTheme.labelMedium?.copyWith(
                                        color: colorScheme.primary,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                        decorationColor: colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
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
                      'Task List',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DataBuilder<List<ProjectTask>>(
                      future: fetchProjectTasks(),
                      builder: (context, tasks) {
                        if (tasks.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                'No tasks available',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            final statusColor = getStatusColor(
                              task.status,
                              colorScheme,
                            );
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      task.taskName,
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.onSurface,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    getStatusDisplay(task.status),
                                    style: textTheme.labelSmall?.copyWith(
                                      color: statusColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
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
                      'Contributors',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DataBuilder<List<ProjectContributor>>(
                      future: fetchContributors(),
                      builder: (context, contributors) => ContributorsSection(
                        contributors: contributors,
                        textTheme: textTheme,
                        colorScheme: colorScheme,
                      ),
                    ),
                  ],
                ),
              ),
              buildBudgetSection(context, colorScheme, textTheme),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
