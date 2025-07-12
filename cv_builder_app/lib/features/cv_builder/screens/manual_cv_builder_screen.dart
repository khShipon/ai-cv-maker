import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/cv_model.dart';
import '../../../core/services/local_storage_service.dart';
import '../widgets/ai_rewrite_widget.dart';
import 'cover_letter_screen.dart';
import 'package:uuid/uuid.dart';

class ManualCVBuilderScreen extends StatefulWidget {
  final CVModel? existingCV;

  const ManualCVBuilderScreen({super.key, this.existingCV});

  @override
  State<ManualCVBuilderScreen> createState() => _ManualCVBuilderScreenState();
}

class _ManualCVBuilderScreenState extends State<ManualCVBuilderScreen> {
  late CVModel _currentCV;
  int _selectedSectionIndex = 0;
  bool _isPreviewMode = false;
  bool _isSaving = false;

  final List<CVSection> _sections = [
    CVSection(
      id: 'personal_info',
      title: 'Personal Information',
      icon: Icons.person,
      isRequired: true,
    ),
    CVSection(
      id: 'summary',
      title: 'Professional Summary',
      icon: Icons.description,
      isRequired: false,
    ),
    CVSection(
      id: 'experience',
      title: 'Work Experience',
      icon: Icons.work,
      isRequired: true,
    ),
    CVSection(
      id: 'education',
      title: 'Education',
      icon: Icons.school,
      isRequired: true,
    ),
    CVSection(
      id: 'skills',
      title: 'Skills',
      icon: Icons.star,
      isRequired: true,
    ),
    CVSection(
      id: 'projects',
      title: 'Projects',
      icon: Icons.code,
      isRequired: false,
    ),
    CVSection(
      id: 'certifications',
      title: 'Certifications',
      icon: Icons.verified,
      isRequired: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeCV();
  }

  void _initializeCV() {
    if (widget.existingCV != null) {
      _currentCV = widget.existingCV!;
    } else {
      const uuid = Uuid();
      _currentCV = CVModel(
        id: uuid.v4(),
        title: 'New CV',
        status: 'draft',
        lastEdited: DateTime.now(),
        created: DateTime.now(),
        data: {
          'personalInfo': {},
          'summary': '',
          'experience': [],
          'education': [],
          'skills': {'technical': [], 'soft': [], 'languages': []},
          'projects': [],
          'certifications': [],
        },
      );
    }
  }

  void _updateCVData(String section, dynamic data) {
    setState(() {
      _currentCV = _currentCV.copyWith(
        data: {..._currentCV.data, section: data},
        lastEdited: DateTime.now(),
      );
    });
  }

  Future<void> _saveCV() async {
    setState(() {
      _isSaving = true;
    });

    try {
      await LocalStorageService.saveCV(_currentCV);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('CV saved successfully!'),
            backgroundColor: AppTheme.primaryTeal,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving CV: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  void _togglePreviewMode() {
    setState(() {
      _isPreviewMode = !_isPreviewMode;
    });
  }

  void _addSection(String sectionType) {
    // Add new section logic
    setState(() {
      // Implementation depends on section type
    });
  }

  void _reorderSections(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final section = _sections.removeAt(oldIndex);
      _sections.insert(newIndex, section);
    });
  }

  Future<void> _selectPhoto() async {
    // For now, we'll use a placeholder URL
    // In a real app, you would use image_picker package
    final personalInfo =
        _currentCV.data['personalInfo'] as Map<String, dynamic>? ?? {};

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Photo'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Photo upload functionality will be implemented with image_picker package.',
                ),
                const SizedBox(height: 16),
                const Text('For now, you can use a placeholder photo:'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _updateCVData('personalInfo', {
                      ...personalInfo,
                      'photo':
                          'https://via.placeholder.com/150x150/2196F3/FFFFFF?text=Photo',
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Use Placeholder Photo'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      appBar: AppBar(
        title: Text(_currentCV.title),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.description),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CoverLetterScreen(cvData: _currentCV),
                ),
              );
            },
            tooltip: 'Generate Cover Letter',
          ),
          IconButton(
            icon: Icon(_isPreviewMode ? Icons.edit : Icons.preview),
            onPressed: _togglePreviewMode,
            tooltip: _isPreviewMode ? 'Edit Mode' : 'Preview Mode',
          ),
          IconButton(
            icon:
                _isSaving
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : const Icon(Icons.save),
            onPressed: _isSaving ? null : _saveCV,
            tooltip: 'Save CV',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'export_pdf':
                  // Export to PDF
                  break;
                case 'duplicate':
                  // Duplicate CV
                  break;
                case 'delete':
                  // Delete CV
                  break;
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'export_pdf',
                    child: Row(
                      children: [
                        Icon(Icons.picture_as_pdf),
                        SizedBox(width: 8),
                        Text('Export PDF'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'duplicate',
                    child: Row(
                      children: [
                        Icon(Icons.copy),
                        SizedBox(width: 8),
                        Text('Duplicate'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: _isPreviewMode ? _buildPreviewMode() : _buildEditMode(),
    );
  }

  Widget _buildEditMode() {
    return Row(
      children: [
        // Left sidebar - Section list
        Container(
          width: 280,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(2, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              // Section toolbar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppTheme.lightGray)),
                ),
                child: Row(
                  children: [
                    const Text(
                      'CV Sections',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.darkText,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _addSection('custom'),
                      tooltip: 'Add Section',
                    ),
                  ],
                ),
              ),

              // Section list
              Expanded(
                child: ReorderableListView.builder(
                  onReorder: _reorderSections,
                  itemCount: _sections.length,
                  itemBuilder: (context, index) {
                    final section = _sections[index];
                    final isSelected = index == _selectedSectionIndex;

                    return Container(
                      key: ValueKey(section.id),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      child: ListTile(
                        leading: Icon(
                          section.icon,
                          color:
                              isSelected
                                  ? AppTheme.primaryTeal
                                  : AppTheme.mediumGray,
                        ),
                        title: Text(
                          section.title,
                          style: TextStyle(
                            fontWeight:
                                isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                            color:
                                isSelected
                                    ? AppTheme.primaryTeal
                                    : AppTheme.darkText,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (section.isRequired)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Required',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            const Icon(Icons.drag_handle),
                          ],
                        ),
                        selected: isSelected,
                        selectedTileColor: AppTheme.primaryTeal.withValues(
                          alpha: 0.1,
                        ),
                        onTap: () {
                          setState(() {
                            _selectedSectionIndex = index;
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // Main content area - Section editor
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _sections[_selectedSectionIndex].icon,
                      color: AppTheme.primaryTeal,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _sections[_selectedSectionIndex].title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: _buildSectionEditor(_sections[_selectedSectionIndex]),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionEditor(CVSection section) {
    switch (section.id) {
      case 'personal_info':
        return _buildPersonalInfoEditor();
      case 'summary':
        return _buildSummaryEditor();
      case 'experience':
        return _buildExperienceEditor();
      case 'education':
        return _buildEducationEditor();
      case 'skills':
        return _buildSkillsEditor();
      case 'projects':
        return _buildProjectsEditor();
      case 'certifications':
        return _buildCertificationsEditor();
      default:
        return const Center(child: Text('Section editor not implemented yet'));
    }
  }

  Widget _buildPersonalInfoEditor() {
    final personalInfo =
        _currentCV.data['personalInfo'] as Map<String, dynamic>? ?? {};

    return SingleChildScrollView(
      child: Column(
        children: [
          // Photo upload section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.lightGray.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.lightGray),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppTheme.primaryTeal.withValues(alpha: 0.1),
                  backgroundImage:
                      personalInfo['photo'] != null
                          ? NetworkImage(personalInfo['photo'])
                          : null,
                  child:
                      personalInfo['photo'] == null
                          ? Icon(
                            Icons.person,
                            size: 50,
                            color: AppTheme.primaryTeal,
                          )
                          : null,
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _selectPhoto,
                  icon: const Icon(Icons.camera_alt),
                  label: Text(
                    personalInfo['photo'] == null
                        ? 'Add Photo'
                        : 'Change Photo',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryTeal,
                    foregroundColor: Colors.white,
                  ),
                ),
                if (personalInfo['photo'] != null)
                  TextButton(
                    onPressed: () {
                      _updateCVData('personalInfo', {
                        ...personalInfo,
                        'photo': null,
                      });
                    },
                    child: const Text('Remove Photo'),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          TextField(
            controller: TextEditingController(
              text: personalInfo['name']?.toString() ?? '',
            ),
            decoration: const InputDecoration(
              labelText: 'Full Name',
              hintText: 'Enter your full name',
            ),
            onChanged: (value) {
              _updateCVData('personalInfo', {...personalInfo, 'name': value});
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: TextEditingController(
              text: personalInfo['email']?.toString() ?? '',
            ),
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'your.email@example.com',
            ),
            onChanged: (value) {
              _updateCVData('personalInfo', {...personalInfo, 'email': value});
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: TextEditingController(
              text: personalInfo['phone']?.toString() ?? '',
            ),
            decoration: const InputDecoration(
              labelText: 'Phone',
              hintText: '+1 (555) 123-4567',
            ),
            onChanged: (value) {
              _updateCVData('personalInfo', {...personalInfo, 'phone': value});
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: TextEditingController(
              text: personalInfo['location']?.toString() ?? '',
            ),
            decoration: const InputDecoration(
              labelText: 'Location',
              hintText: 'City, State/Country',
            ),
            onChanged: (value) {
              _updateCVData('personalInfo', {
                ...personalInfo,
                'location': value,
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryEditor() {
    final summary = _currentCV.data['summary'] as String? ?? '';
    final jobTitle =
        _currentCV.data['personalInfo']?['jobTitle'] ?? 'Professional';

    return AIRewriteWidget(
      initialText: summary,
      jobTitle: jobTitle,
      sectionType: 'summary',
      onRewritten: (value) {
        _updateCVData('summary', value);
      },
    );
  }

  Widget _buildExperienceEditor() {
    return const Center(child: Text('Experience editor - Coming soon'));
  }

  Widget _buildEducationEditor() {
    return const Center(child: Text('Education editor - Coming soon'));
  }

  Widget _buildSkillsEditor() {
    return const Center(child: Text('Skills editor - Coming soon'));
  }

  Widget _buildProjectsEditor() {
    return const Center(child: Text('Projects editor - Coming soon'));
  }

  Widget _buildCertificationsEditor() {
    return const Center(child: Text('Certifications editor - Coming soon'));
  }

  Widget _buildPreviewMode() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text(
            'CV Preview',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkText,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(child: Text('CV Preview - Coming soon')),
            ),
          ),
        ],
      ),
    );
  }
}

class CVSection {
  final String id;
  final String title;
  final IconData icon;
  final bool isRequired;

  CVSection({
    required this.id,
    required this.title,
    required this.icon,
    required this.isRequired,
  });
}
