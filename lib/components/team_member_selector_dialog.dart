import 'package:flutter/material.dart';
import 'package:orsa_3/models/profile_member.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@NowaGenerated()
class TeamMemberSelectorDialog extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const TeamMemberSelectorDialog({
    required this.selectedMembers,
    required this.onMemberSelected,
    super.key,
  });

  final List<ProfileMember> selectedMembers;

  final Function(ProfileMember) onMemberSelected;

  @override
  State<TeamMemberSelectorDialog> createState() {
    return _TeamMemberSelectorDialogState();
  }
}

@NowaGenerated()
class _TeamMemberSelectorDialogState extends State<TeamMemberSelectorDialog> {
  late TextEditingController searchCtrl;

  late Future<List<ProfileMember>> membersFuture;

  @override
  void initState() {
    super.initState();
    searchCtrl = TextEditingController();
    membersFuture = _fetchMembers();
  }

  Future<List<ProfileMember>> _fetchMembers() async {
    final response = await Supabase.instance.client
        .from('profiles')
        .select()
        .limit(50);
    return (response as List).map((e) => ProfileMember.fromJson(e)).toList();
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return AlertDialog(
      title: const Text('Select Team Members'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Column(
          children: [
            TextField(
              controller: searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search members...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<ProfileMember>>(
                future: membersFuture,
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No members found'));
                  }
                  final search = searchCtrl.text.toLowerCase();
                  final filtered = snapshot.data!
                      .where(
                        (m) =>
                            (m.fullName?.toLowerCase().contains(search) ??
                                false) ||
                            (m.commonName?.toLowerCase().contains(search) ??
                                false),
                      )
                      .toList();
                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text('No matching members found'),
                    );
                  }
                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (ctx, idx) {
                      final member = filtered[idx];
                      final isSelected = widget.selectedMembers.any(
                        (m) => m.id == member.id,
                      );
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colors.primary.withValues(alpha: 0.1)
                              : null,
                          border: Border.all(
                            color: isSelected
                                ? colors.primary
                                : colors.outlineVariant,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colors.primary.withValues(alpha: 0.2),
                            ),
                            child: member.avatarUrl != null
                                ? ClipOval(
                                    child: Image.network(
                                      member.avatarUrl!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Center(
                                    child: Icon(
                                      Icons.person,
                                      color: colors.primary,
                                    ),
                                  ),
                          ),
                          title: Text(
                            member.fullName ?? member.commonName ?? 'Unknown',
                          ),
                          subtitle: member.position != null
                              ? Text(member.position!)
                              : null,
                          trailing: isSelected
                              ? Icon(Icons.check_circle, color: colors.primary)
                              : const Icon(Icons.add_circle_outline),
                          onTap: () {
                            widget.onMemberSelected(member);
                            setState(() {});
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Done'),
        ),
      ],
    );
  }
}
