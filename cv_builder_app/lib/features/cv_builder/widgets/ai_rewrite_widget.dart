import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/ai_service.dart';

class AIRewriteWidget extends StatefulWidget {
  final String initialText;
  final String jobTitle;
  final String sectionType;
  final Function(String) onRewritten;

  const AIRewriteWidget({
    super.key,
    required this.initialText,
    required this.jobTitle,
    required this.sectionType,
    required this.onRewritten,
  });

  @override
  State<AIRewriteWidget> createState() => _AIRewriteWidgetState();
}

class _AIRewriteWidgetState extends State<AIRewriteWidget> {
  final TextEditingController _textController = TextEditingController();
  bool _isRewriting = false;
  String? _rewrittenText;

  @override
  void initState() {
    super.initState();
    _textController.text = widget.initialText;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _rewriteWithAI() async {
    if (_textController.text.trim().isEmpty) return;

    setState(() {
      _isRewriting = true;
      _rewrittenText = null;
    });

    try {
      final rewritten = await AIService.rewriteCVEntry(
        roughInput: _textController.text,
        jobTitle: widget.jobTitle,
        context: widget.sectionType,
      );

      setState(() {
        _rewrittenText = rewritten;
      });
    } catch (e) {
      if (mounted) {
        String errorMessage;
        Color backgroundColor;

        if (e is ValidationException) {
          errorMessage = 'AI Feedback: ${e.message}';
          backgroundColor = Colors.orange;
        } else {
          errorMessage = 'Failed to rewrite: $e';
          backgroundColor = Colors.red;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: backgroundColor,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    } finally {
      setState(() {
        _isRewriting = false;
      });
    }
  }

  void _acceptRewrite() {
    if (_rewrittenText != null) {
      _textController.text = _rewrittenText!;
      widget.onRewritten(_rewrittenText!);
      setState(() {
        _rewrittenText = null;
      });
    }
  }

  void _rejectRewrite() {
    setState(() {
      _rewrittenText = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Input field with AI button
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: _getSectionLabel(),
                  hintText: _getSectionHint(),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon:
                        _isRewriting
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Icon(Icons.auto_fix_high),
                    onPressed: _isRewriting ? null : _rewriteWithAI,
                    tooltip: 'Rewrite with AI',
                  ),
                ),
                onChanged: (value) {
                  widget.onRewritten(value);
                },
              ),
            ),
          ],
        ),

        // AI rewrite suggestion
        if (_rewrittenText != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryTeal.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primaryTeal.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_fix_high,
                      color: AppTheme.primaryTeal,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'AI Suggestion',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryTeal,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _rewrittenText!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.darkText,
                      height: 1.4,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _rejectRewrite,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppTheme.mediumGray),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Keep Original',
                          style: TextStyle(color: AppTheme.mediumGray),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: _acceptRewrite,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryTeal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text('Use AI Version'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],

        // Tips
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.tips_and_updates, size: 16, color: AppTheme.mediumGray),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                'Tip: Write in simple terms, AI will make it professional and ATS-friendly',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.mediumGray,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getSectionLabel() {
    switch (widget.sectionType) {
      case 'experience':
        return 'Work Experience';
      case 'skills':
        return 'Skills';
      case 'summary':
        return 'Professional Summary';
      case 'education':
        return 'Education';
      case 'projects':
        return 'Projects';
      default:
        return 'Content';
    }
  }

  String _getSectionHint() {
    switch (widget.sectionType) {
      case 'experience':
        return 'e.g., "Worked in marketing, did ads, got good results"';
      case 'skills':
        return 'e.g., "Good with computers, know JavaScript, team player"';
      case 'summary':
        return 'e.g., "Software developer with 5 years experience"';
      case 'education':
        return 'e.g., "Computer Science degree from XYZ University"';
      case 'projects':
        return 'e.g., "Built a website for local business"';
      default:
        return 'Enter your content here...';
    }
  }
}
