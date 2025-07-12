import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../models/cv_template.dart';
import '../widgets/template_card.dart';
import '../widgets/template_preview_dialog.dart';
import '../widgets/category_filter.dart';

class TemplatesScreen extends StatefulWidget {
  const TemplatesScreen({super.key});

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen> {
  String _selectedCategory = 'All';
  List<CVTemplate> _filteredTemplates = [];
  
  final List<String> _categories = [
    'All',
    'Modern',
    'Classic',
    'Creative',
    'Executive',
    'Technical',
    'Academic',
  ];

  final List<CVTemplate> _templates = [
    CVTemplate(
      id: 'modern_1',
      name: 'Modern Professional',
      category: 'Modern',
      description: 'Clean, modern design perfect for tech and creative roles',
      thumbnailPath: 'assets/templates/modern_1.png',
      isATSOptimized: true,
      isPremium: false,
      colors: [AppTheme.primaryTeal, AppTheme.primaryBlue],
      features: ['ATS Optimized', 'Clean Layout', 'Modern Typography'],
    ),
    CVTemplate(
      id: 'classic_1',
      name: 'Classic Executive',
      category: 'Classic',
      description: 'Traditional format ideal for corporate and executive positions',
      thumbnailPath: 'assets/templates/classic_1.png',
      isATSOptimized: true,
      isPremium: false,
      colors: [AppTheme.darkText, AppTheme.mediumGray],
      features: ['Professional', 'Traditional', 'Executive-friendly'],
    ),
    CVTemplate(
      id: 'creative_1',
      name: 'Creative Designer',
      category: 'Creative',
      description: 'Eye-catching design for creative professionals and designers',
      thumbnailPath: 'assets/templates/creative_1.png',
      isATSOptimized: false,
      isPremium: true,
      colors: [AppTheme.lightOrange, AppTheme.primaryTeal],
      features: ['Creative Layout', 'Visual Appeal', 'Portfolio-friendly'],
    ),
    CVTemplate(
      id: 'technical_1',
      name: 'Tech Engineer',
      category: 'Technical',
      description: 'Structured layout perfect for software engineers and developers',
      thumbnailPath: 'assets/templates/technical_1.png',
      isATSOptimized: true,
      isPremium: false,
      colors: [AppTheme.primaryBlue, AppTheme.darkText],
      features: ['Code-friendly', 'Skills-focused', 'Project showcase'],
    ),
    CVTemplate(
      id: 'academic_1',
      name: 'Academic Research',
      category: 'Academic',
      description: 'Comprehensive format for academic and research positions',
      thumbnailPath: 'assets/templates/academic_1.png',
      isATSOptimized: true,
      isPremium: true,
      colors: [AppTheme.darkText, AppTheme.mediumGray],
      features: ['Publication-ready', 'Research-focused', 'Detailed sections'],
    ),
    CVTemplate(
      id: 'modern_2',
      name: 'Minimalist Pro',
      category: 'Modern',
      description: 'Ultra-clean minimalist design for maximum impact',
      thumbnailPath: 'assets/templates/modern_2.png',
      isATSOptimized: true,
      isPremium: false,
      colors: [AppTheme.primaryTeal, Colors.white],
      features: ['Minimalist', 'High Impact', 'Scannable'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _filterTemplates();
  }

  void _filterTemplates() {
    setState(() {
      if (_selectedCategory == 'All') {
        _filteredTemplates = _templates;
      } else {
        _filteredTemplates = _templates
            .where((template) => template.category == _selectedCategory)
            .toList();
      }
    });
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _filterTemplates();
  }

  void _previewTemplate(CVTemplate template) {
    showDialog(
      context: context,
      builder: (context) => TemplatePreviewDialog(template: template),
    );
  }

  void _useTemplate(CVTemplate template) {
    // Navigate to CV builder with selected template
    Navigator.of(context).pop(template);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      appBar: AppBar(
        title: const Text('CV Templates'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Show filter options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category filter
          CategoryFilter(
            categories: _categories,
            selectedCategory: _selectedCategory,
            onCategoryChanged: _onCategoryChanged,
          ),
          
          // Templates grid
          Expanded(
            child: _filteredTemplates.isEmpty
                ? _buildEmptyState()
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _filteredTemplates.length,
                      itemBuilder: (context, index) {
                        final template = _filteredTemplates[index];
                        return TemplateCard(
                          template: template,
                          onPreview: () => _previewTemplate(template),
                          onUse: () => _useTemplate(template),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.lightGray.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.article_outlined,
              size: 40,
              color: AppTheme.mediumGray,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No templates found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkText,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try selecting a different category',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.mediumGray,
            ),
          ),
        ],
      ),
    );
  }
}
