import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ATSScoreCard extends StatelessWidget {
  final int score;
  final String title;

  const ATSScoreCard({
    super.key,
    required this.score,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              _getScoreColor().withValues(alpha: 0.1),
              _getScoreColor().withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Score circle
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _getScoreColor(),
                  width: 8,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$score',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: _getScoreColor(),
                      ),
                    ),
                    Text(
                      '/100',
                      style: TextStyle(
                        fontSize: 16,
                        color: _getScoreColor(),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkText,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 8),
            
            // Score description
            Text(
              _getScoreDescription(),
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.mediumGray,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            // Progress bar
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: AppTheme.lightGray,
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: score / 100,
                child: Container(
                  decoration: BoxDecoration(
                    color: _getScoreColor(),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor() {
    if (score >= 80) {
      return Colors.green;
    } else if (score >= 60) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String _getScoreDescription() {
    if (score >= 80) {
      return 'Excellent! Your CV is highly ATS-compatible';
    } else if (score >= 60) {
      return 'Good! Some improvements can boost your score';
    } else if (score >= 40) {
      return 'Fair. Several optimizations needed';
    } else {
      return 'Needs improvement. Follow recommendations below';
    }
  }
}
