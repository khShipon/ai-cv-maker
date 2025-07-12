import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/ats_optimization_service.dart';

class SectionAnalysisCard extends StatelessWidget {
  final String sectionName;
  final ATSSectionScore sectionScore;

  const SectionAnalysisCard({
    super.key,
    required this.sectionName,
    required this.sectionScore,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getSectionIcon(),
                  color: _getScoreColor(),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _getSectionDisplayName(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkText,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getScoreColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${sectionScore.score}/${sectionScore.maxScore}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _getScoreColor(),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Progress bar
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: AppTheme.lightGray,
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: sectionScore.score / sectionScore.maxScore,
                child: Container(
                  decoration: BoxDecoration(
                    color: _getScoreColor(),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
            
            // Issues
            if (sectionScore.issues.isNotEmpty) ...[
              const SizedBox(height: 12),
              ...sectionScore.issues.map((issue) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.warning_amber,
                        size: 16,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          issue,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.mediumGray,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getSectionIcon() {
    switch (sectionName) {
      case 'personalInfo':
        return Icons.person;
      case 'experience':
        return Icons.work;
      case 'education':
        return Icons.school;
      case 'skills':
        return Icons.star;
      case 'projects':
        return Icons.code;
      case 'certifications':
        return Icons.verified;
      default:
        return Icons.description;
    }
  }

  String _getSectionDisplayName() {
    switch (sectionName) {
      case 'personalInfo':
        return 'Personal Information';
      case 'experience':
        return 'Work Experience';
      case 'education':
        return 'Education';
      case 'skills':
        return 'Skills';
      case 'projects':
        return 'Projects';
      case 'certifications':
        return 'Certifications';
      default:
        return sectionName;
    }
  }

  Color _getScoreColor() {
    final percentage = sectionScore.score / sectionScore.maxScore;
    if (percentage >= 0.8) {
      return Colors.green;
    } else if (percentage >= 0.6) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
