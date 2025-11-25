import 'package:flutter/material.dart';
import 'package:orsa_3/models/project_contributor.dart';
import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class ContributorsSection extends StatelessWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const ContributorsSection({
    required this.contributors,
    required this.textTheme,
    required this.colorScheme,
    super.key,
  });

  final List<ProjectContributor> contributors;

  final TextTheme textTheme;

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    if (contributors.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'No contributors yet',
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
      itemCount: contributors.length,
      itemBuilder: (context, index) {
        final contributor = contributors[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: contributor.avatarUrl != null
                      ? Image.network(
                          contributor.avatarUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: colorScheme.primary,
                                child: Icon(
                                  Icons.person,
                                  color: colorScheme.onPrimary,
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
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  contributor.commonName ?? 'Unknown',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
