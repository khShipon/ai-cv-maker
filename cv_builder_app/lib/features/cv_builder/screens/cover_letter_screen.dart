import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/cv_model.dart';
import '../../../core/services/ai_service.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class CoverLetterScreen extends StatefulWidget {
  final CVModel cvData;

  const CoverLetterScreen({super.key, required this.cvData});

  @override
  State<CoverLetterScreen> createState() => _CoverLetterScreenState();
}

class _CoverLetterScreenState extends State<CoverLetterScreen> {
  final TextEditingController _chatController = TextEditingController();
  final TextEditingController _coverLetterController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();

  bool _isGenerating = false;
  List<ChatMessage> _chatMessages = [];
  Map<String, String> _coverLetterData = {};

  // Cover letter template
  static const String _template = '''[Your Name]
[Your Address] | [Your Phone] | [Your Email] | [LinkedIn URL – optional]
[Date]

[Hiring Manager's Name]
[Company Name]
[Company Address]

Subject: Application for [Job Title]

Dear [Hiring Manager's Name],

I am writing to express my interest in the [Job Title] position at [Company Name]. With a background in [Your Field] and proven skills in [Key Skill #1], [Key Skill #2], and [Key Skill #3], I am confident I can make a valuable contribution to your team.

In my previous role at [Previous Company], I [mention one relevant achievement or responsibility – keep it short!], which strengthened my ability to [key result related to the new job].

I admire [Company Name] for [one specific thing you like – culture, mission, project] and I am eager to bring my experience and enthusiasm to your organization.

I have attached my CV for your review. I would welcome the chance to discuss how my skills align with your needs and look forward to the opportunity for an interview.

Thank you for considering my application.

Best regards,
[Your Name]''';

  List<String> _requiredFields = [
    'Your Name',
    'Your Address',
    'Your Phone',
    'Your Email',
    'Job Title',
    'Company Name',
    'Company Address',
    'Hiring Manager\'s Name',
    'Your Field',
    'Key Skill #1',
    'Key Skill #2',
    'Key Skill #3',
    'Previous Company',
    'mention one relevant achievement or responsibility – keep it short!',
    'key result related to the new job',
    'one specific thing you like – culture, mission, project',
  ];

  int _currentFieldIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeCoverLetterData();
    _startConversation();
  }

  @override
  void dispose() {
    _chatController.dispose();
    _coverLetterController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  void _initializeCoverLetterData() {
    final personalInfo =
        widget.cvData.data['personalInfo'] as Map<String, dynamic>? ?? {};

    // Pre-fill data from CV
    _coverLetterData['Your Name'] = personalInfo['name'] ?? '';
    _coverLetterData['Your Email'] = personalInfo['email'] ?? '';
    _coverLetterData['Your Phone'] = personalInfo['phone'] ?? '';
    _coverLetterData['Your Address'] = personalInfo['location'] ?? '';

    // Set current date
    _coverLetterData['Date'] = DateTime.now().toString().split(' ')[0];

    _updateCoverLetterDisplay();
  }

  void _startConversation() {
    _addMessage(
      "👋 Hi! I'm your AI assistant. I'll help you create a professional cover letter using our template.\n\n"
      "I've already filled in some information from your CV. Let's complete the missing details step by step.\n\n"
      "Let's start with the job you're applying for. What is the job title?",
      false,
    );
  }

  void _addMessage(String text, bool isUser) {
    setState(() {
      _chatMessages.add(
        ChatMessage(text: text, isUser: isUser, timestamp: DateTime.now()),
      );
    });

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final message = _chatController.text.trim();
    if (message.isEmpty) return;

    _addMessage(message, true);
    _chatController.clear();

    setState(() {
      _isGenerating = true;
    });

    try {
      await _processUserInput(message);
    } catch (e) {
      _addMessage("Sorry, I encountered an error. Please try again.", false);
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  Future<void> _processUserInput(String input) async {
    // Determine what information we're collecting
    String currentField = _getCurrentMissingField();

    if (currentField.isNotEmpty) {
      _coverLetterData[currentField] = input;
      _updateCoverLetterDisplay();

      // Move to next field or finish
      _currentFieldIndex++;
      String nextField = _getCurrentMissingField();

      if (nextField.isNotEmpty) {
        _addMessage(_getQuestionForField(nextField), false);
      } else {
        _addMessage(
          "🎉 Perfect! Your cover letter is now complete. You can see it in the editor on the right.\n\n"
          "Feel free to ask me to make any changes, like:\n"
          "• 'Make it more formal'\n"
          "• 'Add more enthusiasm'\n"
          "• 'Change the company description'\n"
          "• 'Make the achievement more specific'",
          false,
        );
      }
    } else {
      // Handle corrections and modifications
      await _handleCoverLetterCorrection(input);
    }
  }

  String _getCurrentMissingField() {
    for (String field in _requiredFields) {
      if (!_coverLetterData.containsKey(field) ||
          _coverLetterData[field]!.isEmpty) {
        return field;
      }
    }
    return '';
  }

  String _getQuestionForField(String field) {
    switch (field) {
      case 'Job Title':
        return "What job title are you applying for?";
      case 'Company Name':
        return "What's the name of the company you're applying to?";
      case 'Company Address':
        return "What's the company's address? (You can use 'City, State' if you don't have the full address)";
      case 'Hiring Manager\'s Name':
        return "Do you know the hiring manager's name? If not, just say 'Hiring Manager' or 'Dear Sir/Madam'";
      case 'Your Field':
        return "What's your professional field? (e.g., 'Software Development', 'Marketing', 'Finance')";
      case 'Key Skill #1':
        return "What's your most important skill for this job?";
      case 'Key Skill #2':
        return "What's your second key skill?";
      case 'Key Skill #3':
        return "What's your third key skill?";
      case 'Previous Company':
        return "What's the name of your most recent company?";
      case 'mention one relevant achievement or responsibility – keep it short!':
        return "Tell me about one key achievement or responsibility from your previous role (keep it brief!)";
      case 'key result related to the new job':
        return "What key result or skill did that achievement help you develop that's relevant to this new job?";
      case 'one specific thing you like – culture, mission, project':
        return "What specifically do you admire about this company? (their culture, mission, a project, etc.)";
      default:
        return "Please provide: $field";
    }
  }

  void _updateCoverLetterDisplay() {
    String coverLetter = _template;

    _coverLetterData.forEach((key, value) {
      if (value.isNotEmpty) {
        coverLetter = coverLetter.replaceAll('[$key]', value);
      }
    });

    setState(() {
      _coverLetterController.text = coverLetter;
    });
  }

  Future<void> _handleCoverLetterCorrection(String request) async {
    try {
      final response = await AIService.generateCoverLetterFromPrompt(
        userPrompt:
            "Current cover letter:\n${_coverLetterController.text}\n\nUser request: $request\n\nPlease modify the cover letter according to the user's request and return the complete updated version.",
        cvData: widget.cvData.data,
      );

      setState(() {
        _coverLetterController.text = response;
      });

      _addMessage(
        "✅ I've updated your cover letter based on your request. Check the editor to see the changes!",
        false,
      );
    } catch (e) {
      _addMessage(
        "Sorry, I couldn't process that request. Please try rephrasing it.",
        false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Cover Letter Generator'),
        backgroundColor: AppTheme.primaryTeal,
        foregroundColor: Colors.white,
        actions: [
          if (_coverLetterController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                await Clipboard.setData(
                  ClipboardData(text: _coverLetterController.text),
                );
                if (mounted) {
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      content: Text('Cover letter copied to clipboard!'),
                      backgroundColor: AppTheme.primaryTeal,
                    ),
                  );
                }
              },
              tooltip: 'Copy to clipboard',
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instructions
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
                        Icons.lightbulb_outline,
                        color: AppTheme.primaryTeal,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'How to use AI Cover Letter Generator',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryTeal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Describe what kind of cover letter you need. Be specific about:\n'
                    '• Job title and company name\n'
                    '• Key requirements to highlight\n'
                    '• Tone (formal, friendly, etc.)\n'
                    '• Any specific achievements to mention',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.darkText,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Prompt input
            const Text(
              'Describe your cover letter requirements:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.darkText,
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _promptController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText:
                    'Example: "Create a cover letter for a Software Engineer position at Google. Emphasize my React and Node.js experience. Make it professional but enthusiastic. Mention my project that increased user engagement by 40%."',
                border: const OutlineInputBorder(),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _isGenerating ? null : _generateCoverLetter,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryTeal,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(100, 40),
                    ),
                    child:
                        _isGenerating
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : const Text('Generate'),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Generated cover letter
            const Text(
              'Generated Cover Letter:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.darkText,
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: TextField(
                controller: _coverLetterController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText:
                      'Your AI-generated cover letter will appear here...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ),

            const SizedBox(height: 16),

            // Example prompts
            if (_coverLetterController.text.isEmpty) ...[
              const Text(
                'Example prompts:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.mediumGray,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildExampleChip(
                    'Cover letter for Marketing Manager at startup',
                  ),
                  _buildExampleChip('Formal letter for Senior Developer role'),
                  _buildExampleChip(
                    'Entry-level position, highlight education',
                  ),
                  _buildExampleChip('Career change to UX Design'),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExampleChip(String text) {
    return ActionChip(
      label: Text(text, style: const TextStyle(fontSize: 12)),
      onPressed: () {
        _promptController.text = text;
      },
      backgroundColor: AppTheme.lightGray.withValues(alpha: 0.3),
      side: BorderSide(color: AppTheme.lightGray),
    );
  }
}
