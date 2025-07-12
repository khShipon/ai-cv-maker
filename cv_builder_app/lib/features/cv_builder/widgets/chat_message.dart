import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'package:intl/intl.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;
  final DateTime? timestamp;
  final bool isLoading;
  final List<String>? quickActions;
  final Function(String)? onQuickAction;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
    this.timestamp,
    this.isLoading = false,
    this.quickActions,
    this.onQuickAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isUser) ...[_buildAvatar(), const SizedBox(width: 8)],
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isUser ? AppTheme.primaryTeal : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isUser ? 20 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isLoading)
                        _buildLoadingIndicator()
                      else
                        Text(
                          text,
                          style: TextStyle(
                            color: isUser ? Colors.white : AppTheme.darkText,
                            fontSize: 16,
                            height: 1.4,
                          ),
                        ),

                      if (timestamp != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('HH:mm').format(timestamp!),
                          style: TextStyle(
                            color:
                                isUser
                                    ? Colors.white.withValues(alpha: 0.7)
                                    : AppTheme.mediumGray,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (isUser) ...[const SizedBox(width: 8), _buildUserAvatar()],
            ],
          ),

          // Quick action buttons
          if (quickActions != null && quickActions!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  quickActions!.map((action) {
                    return ActionChip(
                      label: Text(action),
                      onPressed: () {
                        // Handle quick action
                        if (onQuickAction != null) {
                          onQuickAction!(action);
                        } else {
                          _handleQuickAction(context, action);
                        }
                      },
                      backgroundColor: AppTheme.primaryTeal.withValues(
                        alpha: 0.1,
                      ),
                      labelStyle: const TextStyle(
                        color: AppTheme.primaryTeal,
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: AppTheme.primaryTeal),
                      ),
                    );
                  }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppTheme.primaryTeal,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryTeal.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(Icons.smart_toy, color: Colors.white, size: 20),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppTheme.mediumGray,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.person, color: Colors.white, size: 20),
    );
  }

  Widget _buildLoadingIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              isUser ? Colors.white : AppTheme.primaryTeal,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'AI is thinking...',
          style: TextStyle(
            color: isUser ? Colors.white : AppTheme.darkText,
            fontSize: 14,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  void _handleQuickAction(BuildContext context, String action) {
    switch (action) {
      case 'Yes, rewrite it':
        // Trigger AI rewrite - this would need to be handled by the parent widget
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Rewriting with AI...')));
        break;
      case 'No, keep as is':
        // Continue without rewriting
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Continuing with original text...')),
        );
        break;
      case 'View CV':
        // Navigate to CV preview
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Opening CV preview...')));
        break;
      case 'Download PDF':
        // Trigger PDF download
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Downloading PDF...')));
        break;
      case 'Create Another CV':
        // Restart the process
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ChatMessage(text: '', isUser: false),
          ),
        );
        break;
      case 'Go to Dashboard':
        // Navigate back to dashboard
        Navigator.of(context).pop();
        break;
    }
  }
}
