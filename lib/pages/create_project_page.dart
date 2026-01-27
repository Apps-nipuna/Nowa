import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:orsa_3/components/team_member_selector_dialog.dart';
import 'package:orsa_3/models/profile_member.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@NowaGenerated()
class CreateProjectPage extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const CreateProjectPage({super.key});

  @override
  State<CreateProjectPage> createState() {
    return _CreateProjectPageState();
  }
}

@NowaGenerated()
class _CreateProjectPageState extends State<CreateProjectPage> {
  late TextEditingController imageCtrl;

  late TextEditingController projectNameCtrl;

  late TextEditingController projectTypeCtrl;

  late TextEditingController descriptionCtrl;

  late TextEditingController budgetCtrl;

  String? uploadedImagePath;

  List<ProfileMember> selectedTeamMembers = [];

  String? uploadedFileName;

  String? uploadedFilePath;

  List<String> projectTasks = [];

  late TextEditingController taskInputCtrl;

  Widget _buildImageUploadSection() {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Project Image',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        if (uploadedImagePath == null)
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: BoxDecoration(
                border: Border.all(
                  color: colors.primary.withValues(alpha: 0.3),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 48,
                    color: colors.primary.withValues(alpha: 0.6),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tap to upload image',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.primary.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.primary, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(uploadedImagePath!, fit: BoxFit.cover),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      uploadedImagePath = null;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildField(
    String label,
    String hint,
    IconData icon,
    TextEditingController ctrl, {
    int lines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          maxLines: lines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: lines > 1
                ? Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Icon(icon),
                  )
                : Icon(icon),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final result = await showMediaPicker(
      context: context,
      mediaType: MediaType.image,
    );
    if (result.isNotEmpty) {
      setState(() {
        uploadedImagePath = result.first.path;
      });
    }
  }

  void _removeTeamMember(String memberId) {
    setState(() {
      selectedTeamMembers.removeWhere((member) => member.id == memberId);
    });
  }

  Widget _buildTeamMembersSection() {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Team Members',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        if (selectedTeamMembers.isEmpty)
          GestureDetector(
            onTap: _showTeamMemberSelector,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: colors.primary.withValues(alpha: 0.3),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    color: colors.primary.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Add team members',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.primary.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Column(
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: selectedTeamMembers
                    .map(
                      (member) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.1),
                          border: Border.all(color: colors.primary),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (member.avatarUrl != null)
                              ClipOval(
                                child: Image.network(
                                  member.avatarUrl!,
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.cover,
                                ),
                              )
                            else
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colors.primary.withValues(alpha: 0.5),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            const SizedBox(width: 8),
                            Text(
                              member.fullName ?? member.commonName ?? 'Unknown',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => _removeTeamMember(member.id),
                              child: Icon(
                                Icons.close,
                                size: 16,
                                color: colors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _showTeamMemberSelector,
                child: Text(
                  '+ Add more members',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Future<void> _showTeamMemberSelector() async {
    showDialog(
      context: context,
      builder: (ctx) => TeamMemberSelectorDialog(
        selectedMembers: selectedTeamMembers,
        onMemberSelected: (member) {
          setState(() {
            if (!selectedTeamMembers.any((m) => m.id == member.id)) {
              selectedTeamMembers.add(member);
            }
          });
        },
      ),
    );
  }

  Future<void> _pickFile() async {
    final result = await showMediaPicker(context: context);
    if (result.isNotEmpty) {
      final file = result.first;
      setState(() {
        uploadedFilePath = file.path;
        uploadedFileName = file.name;
      });
    }
  }

  void _clearUploadedFile() {
    setState(() {
      uploadedFileName = null;
      uploadedFilePath = null;
    });
  }

  Widget _buildFileUploadSection() {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Project File',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        if (uploadedFileName == null)
          GestureDetector(
            onTap: _pickFile,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: colors.primary.withValues(alpha: 0.3),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.attach_file,
                    size: 40,
                    color: colors.primary.withValues(alpha: 0.6),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to upload file',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.primary.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.1),
              border: Border.all(color: colors.primary),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: colors.primary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'File selected',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.primary.withValues(alpha: 0.7),
                        ),
                      ),
                      Text(
                        uploadedFileName!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _clearUploadedFile,
                  child: Icon(Icons.close, color: colors.primary, size: 20),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _addTask(String taskName) {
    if (taskName.trim().isNotEmpty && !projectTasks.contains(taskName.trim())) {
      setState(() {
        projectTasks.add(taskName.trim());
        taskInputCtrl.clear();
      });
    }
  }

  void _removeTask(String taskName) {
    setState(() {
      projectTasks.remove(taskName);
    });
  }

  Widget _buildTasksSection() {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Project Tasks',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: taskInputCtrl,
                decoration: InputDecoration(
                  hintText: 'Enter task name',
                  prefixIcon: const Icon(Icons.task_alt),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colors.primary, width: 2),
                  ),
                ),
                onSubmitted: (value) => _addTask(value),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () => _addTask(taskInputCtrl.text),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (projectTasks.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              border: Border.all(
                color: colors.primary.withValues(alpha: 0.2),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'No tasks added yet',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.primary.withValues(alpha: 0.5),
                ),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: projectTasks.length,
            itemBuilder: (ctx, idx) {
              final task = projectTasks[idx];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.08),
                  border: Border.all(
                    color: colors.primary.withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_box_outline_blank,
                      color: colors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        task,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _removeTask(task),
                      child: Icon(Icons.close, color: colors.error, size: 20),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    projectNameCtrl = TextEditingController();
    projectTypeCtrl = TextEditingController();
    descriptionCtrl = TextEditingController();
    budgetCtrl = TextEditingController();
    taskInputCtrl = TextEditingController();
  }

  @override
  void dispose() {
    projectNameCtrl.dispose();
    projectTypeCtrl.dispose();
    descriptionCtrl.dispose();
    budgetCtrl.dispose();
    taskInputCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colors.primary,
                      colors.primary.withValues(alpha: 0.7),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Create New Project',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Share your vision and start making an impact',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildField(
                      'Project Name *',
                      'Enter project name',
                      Icons.edit,
                      projectNameCtrl,
                    ),
                    const SizedBox(height: 24),
                    _buildField(
                      'Project Type',
                      'e.g., Community, Education',
                      Icons.category,
                      projectTypeCtrl,
                    ),
                    const SizedBox(height: 24),
                    _buildField(
                      'Description',
                      'Describe your project...',
                      Icons.description,
                      descriptionCtrl,
                      lines: 4,
                    ),
                    const SizedBox(height: 24),
                    _buildField(
                      'Budget Goal',
                      'Enter budget amount',
                      Icons.attach_money,
                      budgetCtrl,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 24),
                    _buildImageUploadSection(),
                    const SizedBox(height: 24),
                    _buildFileUploadSection(),
                    const SizedBox(height: 24),
                    _buildTeamMembersSection(),
                    const SizedBox(height: 24),
                    _buildTasksSection(),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitProject,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Create Project',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
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

  Future<void> _submitProject() async {
    if (projectNameCtrl.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter project name')));
      return;
    }
    try {
      final projectData = {
        'project_name': projectNameCtrl.text,
        'project_type': projectTypeCtrl.text.isEmpty
            ? null
            : projectTypeCtrl.text,
        'description': descriptionCtrl.text.isEmpty
            ? null
            : descriptionCtrl.text,
        'budget_goal': budgetCtrl.text.isEmpty
            ? null
            : double.tryParse(budgetCtrl.text),
        'image_after_url': uploadedImagePath,
        'budget_collected': 0,
        'total_tasks': projectTasks.length,
        'completed_tasks': 0,
      };
      final projectResponse = await Supabase.instance.client
          .from('projects')
          .insert([projectData])
          .select();
      if (projectResponse.isNotEmpty) {
        final projectId = projectResponse[0]['id'] as int;
        for (final member in selectedTeamMembers) {
          await Supabase.instance.client.from('project_team_members').insert({
            'project_id': projectId,
            'user_id': member.id,
          });
        }
        if (uploadedFilePath != null && uploadedFileName != null) {
          try {
            final fileName =
                '${projectId}_${DateTime.now().millisecondsSinceEpoch}_${uploadedFileName}';
            await Supabase.instance.client.storage
                .from('project_files')
                .upload(fileName, uploadedFilePath!);
            final fileUrl = Supabase.instance.client.storage
                .from('project_files')
                .getPublicUrl(fileName);
            await Supabase.instance.client.from('project_files').insert({
              'project_id': projectId,
              'file_name': uploadedFileName,
              'file_url': fileUrl,
            });
          } catch (fileError) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Warning: File upload failed. Error: ${fileError}',
                  ),
                ),
              );
            }
          }
        }
        for (final task in projectTasks) {
          await Supabase.instance.client.from('project_tasks').insert({
            'project_id': projectId,
            'task_name': task,
            'status': 'Pending',
          });
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Project created successfully!')),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error creating project: ${e}')));
      }
    }
  }
}
