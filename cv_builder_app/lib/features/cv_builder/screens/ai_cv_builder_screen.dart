import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/ai_service.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/models/cv_model.dart';
import '../widgets/chat_message.dart';
import '../widgets/progress_indicator_widget.dart';
import '../widgets/quick_response_chips.dart';
import 'manual_cv_builder_screen.dart';
import 'package:uuid/uuid.dart';

class AICVBuilderScreen extends StatefulWidget {
  const AICVBuilderScreen({super.key});

  @override
  State<AICVBuilderScreen> createState() => _AICVBuilderScreenState();
}

class _AICVBuilderScreenState extends State<AICVBuilderScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  int _currentStep = 0;
  bool _isLoading = false;
  bool _waitingForRewriteChoice = false;
  Map<String, dynamic> _cvData = {};

  final List<CVBuilderStep> _steps = [
    CVBuilderStep(
      id: 'welcome',
      question:
          "Hi! I'm your AI CV assistant. I'll help you create a professional, ATS-optimized CV. What's your name?",
      type: StepType.text,
      key: 'name',
    ),
    CVBuilderStep(
      id: 'job_title',
      question:
          "Great to meet you! What job title or position are you applying for?",
      type: StepType.text,
      key: 'jobTitle',
      suggestions: [
        'Software Engineer',
        'Product Manager',
        'Data Scientist',
        'Marketing Manager',
      ],
    ),
    CVBuilderStep(
      id: 'experience_level',
      question: "How many years of professional experience do you have?",
      type: StepType.choice,
      key: 'experienceLevel',
      options: [
        'Entry Level (0-2 years)',
        'Mid Level (3-5 years)',
        'Senior Level (6-10 years)',
        'Executive (10+ years)',
      ],
    ),
    CVBuilderStep(
      id: 'contact_info',
      question:
          "Let me get your contact information. What's your email address?",
      type: StepType.text,
      key: 'email',
    ),
    CVBuilderStep(
      id: 'phone',
      question: "What's your phone number?",
      type: StepType.text,
      key: 'phone',
    ),
    CVBuilderStep(
      id: 'location',
      question: "Where are you located? (City, State/Country)",
      type: StepType.text,
      key: 'location',
    ),
    CVBuilderStep(
      id: 'skills',
      question:
          "What are your key skills? Please list your most relevant technical and soft skills.",
      type: StepType.text,
      key: 'skills',
      suggestions: [
        'JavaScript',
        'Python',
        'Project Management',
        'Communication',
      ],
    ),
    CVBuilderStep(
      id: 'education',
      question:
          "Tell me about your education. What's your highest degree and from which institution?",
      type: StepType.text,
      key: 'education',
    ),
    CVBuilderStep(
      id: 'experience',
      question:
          "Now let's talk about your work experience. Can you describe your most recent or relevant job experience?",
      type: StepType.text,
      key: 'experience',
    ),
    CVBuilderStep(
      id: 'generate',
      question:
          "Perfect! I have all the information I need. Let me generate your professional CV now.",
      type: StepType.action,
      key: 'generate',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startConversation();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _startConversation() {
    _addMessage(
      ChatMessage(
        text: _steps[_currentStep].question,
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  void _addMessage(ChatMessage message) {
    setState(() {
      _messages.add(message);
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleUserInput(String input) {
    if (input.trim().isEmpty) return;

    // Add user message
    _addMessage(
      ChatMessage(text: input, isUser: true, timestamp: DateTime.now()),
    );

    // Store the data
    final currentStep = _steps[_currentStep];
    _cvData[currentStep.key] = input;

    _messageController.clear();

    // For experience and skills, offer AI rewrite but continue automatically
    if (currentStep.key == 'experience' || currentStep.key == 'skills') {
      _offerAIRewrite(input, currentStep.key);
    } else {
      _processNextStep();
    }
  }

  Future<void> _offerAIRewrite(String userInput, String sectionKey) async {
    setState(() {
      _waitingForRewriteChoice = true;
    });

    // Show AI rewrite option
    _addMessage(
      ChatMessage(
        text:
            "Would you like me to polish and optimize this for ATS compatibility?",
        isUser: false,
        timestamp: DateTime.now(),
        quickActions: ['Yes, rewrite it', 'No, keep as is'],
        onQuickAction:
            (action) => _handleRewriteChoice(action, userInput, sectionKey),
      ),
    );

    // Auto-continue after 3 seconds if no response
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _waitingForRewriteChoice) {
        _handleRewriteChoice('No, keep as is', userInput, sectionKey);
      }
    });
  }

  void _handleRewriteChoice(
    String choice,
    String originalText,
    String sectionKey,
  ) {
    if (!_waitingForRewriteChoice) return; // Already handled

    setState(() {
      _waitingForRewriteChoice = false;
    });

    if (choice == 'Yes, rewrite it') {
      _rewriteWithAI(originalText, sectionKey);
    } else {
      // Keep original and continue
      _addMessage(
        ChatMessage(
          text: "Got it! I'll keep your original text as is.",
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
      _processNextStep();
    }
  }

  Future<void> _rewriteWithAI(String originalText, String sectionKey) async {
    setState(() {
      _isLoading = true;
    });

    try {
      _addMessage(
        ChatMessage(
          text:
              "🤖 Rewriting your input to be more professional and ATS-friendly...",
          isUser: false,
          timestamp: DateTime.now(),
          isLoading: true,
        ),
      );

      final jobTitle = _cvData['jobTitle'] ?? 'Professional';
      final rewrittenText = await AIService.rewriteCVEntry(
        roughInput: originalText,
        jobTitle: jobTitle,
        context: sectionKey,
      );

      // Update the stored data with rewritten version
      _cvData[sectionKey] = rewrittenText;

      _addMessage(
        ChatMessage(
          text:
              "✨ Here's the polished version:\n\n\"$rewrittenText\"\n\nThis version is optimized for ATS systems and uses professional language.",
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );

      _processNextStep();
    } catch (e) {
      _addMessage(
        ChatMessage(
          text:
              "❌ Sorry, I couldn't rewrite that right now. Let's continue with your original text.",
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
      _processNextStep();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleQuickResponse(String response) {
    _handleUserInput(response);
  }

  Future<void> _processNextStep() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(
      const Duration(milliseconds: 1000),
    ); // Simulate AI thinking

    setState(() {
      _currentStep++;
      _isLoading = false;
    });

    if (_currentStep < _steps.length) {
      final nextStep = _steps[_currentStep];

      if (nextStep.type == StepType.action) {
        await _generateCV();
      } else {
        _addMessage(
          ChatMessage(
            text: nextStep.question,
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      }
    }
  }

  Future<void> _generateCV() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Show generating message
      _addMessage(
        ChatMessage(
          text: "🤖 Generating your professional CV...",
          isUser: false,
          timestamp: DateTime.now(),
          isLoading: true,
        ),
      );

      // Create CV model with collected data (fallback approach)
      const uuid = Uuid();
      final cv = CVModel(
        id: uuid.v4(),
        title: '${_cvData['name']} - ${_cvData['jobTitle']}',
        status: 'ready',
        lastEdited: DateTime.now(),
        created: DateTime.now(),
        data: {
          'personalInfo': {
            'name': _cvData['name'] ?? '',
            'email': _cvData['email'] ?? '',
            'phone': _cvData['phone'] ?? '',
            'location': _cvData['location'] ?? '',
            'summary': _generateSummary(),
            'photo': null, // Will be added in editor
          },
          'experience': _parseExperience(_cvData['experience'] ?? ''),
          'education': _parseEducation(_cvData['education'] ?? ''),
          'skills': _parseSkills(_cvData['skills'] ?? ''),
          'projects': [],
          'certifications': [],
        },
      );

      // Save CV
      await LocalStorageService.saveCV(cv);

      // Show success message and navigate to editor
      _addMessage(
        ChatMessage(
          text:
              "✅ Your CV has been generated successfully! Opening the editor where you can add a photo and make final adjustments.",
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );

      // Navigate to CV editor after a short delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ManualCVBuilderScreen(existingCV: cv),
            ),
          );
        }
      });

      // Show completion options
      _addMessage(
        ChatMessage(
          text: "What would you like to do next?",
          isUser: false,
          timestamp: DateTime.now(),
          quickActions: [
            'View CV',
            'Download PDF',
            'Create Another CV',
            'Go to Dashboard',
          ],
        ),
      );
    } catch (e) {
      _addMessage(
        ChatMessage(
          text:
              "❌ Sorry, there was an error generating your CV. Please try again or create one manually.",
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      appBar: AppBar(
        title: const Text('AI CV Builder'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // Show help dialog
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          ProgressIndicatorWidget(
            currentStep: _currentStep,
            totalSteps: _steps.length,
          ),

          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isLoading) {
                  return const ChatMessage(
                    text: "AI is thinking...",
                    isUser: false,
                    timestamp: null,
                    isLoading: true,
                  );
                }
                return _messages[index];
              },
            ),
          ),

          // Quick response chips
          if (_currentStep < _steps.length &&
              _steps[_currentStep].suggestions != null)
            QuickResponseChips(
              suggestions: _steps[_currentStep].suggestions!,
              onTap: _handleQuickResponse,
            ),

          // Choice buttons
          if (_currentStep < _steps.length &&
              _steps[_currentStep].type == StepType.choice)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children:
                    _steps[_currentStep].options!.map((option) {
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ElevatedButton(
                          onPressed: () => _handleQuickResponse(option),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppTheme.darkText,
                            side: BorderSide(color: AppTheme.primaryTeal),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(option),
                        ),
                      );
                    }).toList(),
              ),
            ),

          // Input field
          if (_currentStep < _steps.length &&
              _steps[_currentStep].type == StepType.text)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type your answer...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppTheme.lightGray,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: _handleUserInput,
                      textInputAction: TextInputAction.send,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.primaryTeal,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed:
                          () => _handleUserInput(_messageController.text),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Helper methods to parse user input into structured CV data
  String _generateSummary() {
    final jobTitle = _cvData['jobTitle'] ?? 'Professional';
    final experienceLevel = _cvData['experienceLevel'] ?? 'Entry Level';
    final skills = _cvData['skills'] ?? '';

    return 'Experienced $jobTitle with $experienceLevel background. Skilled in $skills and committed to delivering high-quality results.';
  }

  List<Map<String, dynamic>> _parseExperience(String experienceText) {
    if (experienceText.trim().isEmpty) return [];

    return [
      {
        'title': _cvData['jobTitle'] ?? 'Professional',
        'company': 'Previous Company',
        'duration': '2022 - Present',
        'description': experienceText,
        'achievements': [experienceText],
      },
    ];
  }

  List<Map<String, dynamic>> _parseEducation(String educationText) {
    if (educationText.trim().isEmpty) return [];

    return [
      {
        'degree': educationText,
        'institution': 'Educational Institution',
        'year': '2020',
        'gpa': '',
      },
    ];
  }

  Map<String, dynamic> _parseSkills(String skillsText) {
    if (skillsText.trim().isEmpty) {
      return {
        'technical': [],
        'soft': [],
        'languages': ['English'],
      };
    }

    final skillsList =
        skillsText
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();

    return {
      'technical': skillsList.take(skillsList.length ~/ 2).toList(),
      'soft': skillsList.skip(skillsList.length ~/ 2).toList(),
      'languages': ['English'],
    };
  }
}

class CVBuilderStep {
  final String id;
  final String question;
  final StepType type;
  final String key;
  final List<String>? suggestions;
  final List<String>? options;

  CVBuilderStep({
    required this.id,
    required this.question,
    required this.type,
    required this.key,
    this.suggestions,
    this.options,
  });
}

enum StepType { text, choice, action }
