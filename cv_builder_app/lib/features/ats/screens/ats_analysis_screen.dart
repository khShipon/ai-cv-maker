import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/cv_model.dart';
import '../../../core/services/ats_optimization_service.dart';
import '../widgets/ats_score_card.dart';
import '../widgets/section_analysis_card.dart';
import '../widgets/keyword_analysis_card.dart';
import '../widgets/recommendations_card.dart';

class ATSAnalysisScreen extends StatefulWidget {
  final CVModel cv;
  final String? jobDescription;

  const ATSAnalysisScreen({
    super.key,
    required this.cv,
    this.jobDescription,
  });

  @override
  State<ATSAnalysisScreen> createState() => _ATSAnalysisScreenState();
}

class _ATSAnalysisScreenState extends State<ATSAnalysisScreen> {
  ATSAnalysisResult? _analysisResult;
  bool _isLoading = true;
  bool _isOptimizing = false;
  final TextEditingController _jobDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.jobDescription != null) {
      _jobDescriptionController.text = widget.jobDescription!;
    }
    _performAnalysis();
  }

  @override
  void dispose() {
    _jobDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _performAnalysis() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ATSOptimizationService.analyzeCV(
        widget.cv,
        jobDescription: _jobDescriptionController.text.isNotEmpty 
            ? _jobDescriptionController.text 
            : null,
      );

      setState(() {
        _analysisResult = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Analysis failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _optimizeCV() async {
    if (_analysisResult == null || _jobDescriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide a job description for optimization'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isOptimizing = true;
    });

    try {
      final optimizedCV = await ATSOptimizationService.optimizeCV(
        widget.cv,
        _jobDescriptionController.text,
      );

      if (mounted) {
        Navigator.of(context).pop(optimizedCV);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Optimization failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isOptimizing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      appBar: AppBar(
        title: const Text('ATS Analysis'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_analysisResult != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _performAnalysis,
              tooltip: 'Re-analyze',
            ),
        ],
      ),
      body: _isLoading ? _buildLoadingState() : _buildAnalysisContent(),
      bottomNavigationBar: _analysisResult != null ? _buildBottomActions() : null,
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryTeal),
          ),
          SizedBox(height: 16),
          Text(
            'Analyzing your CV...',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.mediumGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisContent() {
    if (_analysisResult == null) {
      return const Center(
        child: Text('Analysis failed. Please try again.'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Job Description Input
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Job Description (Optional)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _jobDescriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Paste the job description here for better keyword analysis...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _performAnalysis,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryTeal,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Analyze with Job Description'),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Overall Score
          ATSScoreCard(
            score: _analysisResult!.overallScore,
            title: 'ATS Compatibility Score',
          ),
          
          const SizedBox(height: 16),
          
          // Section Analysis
          const Text(
            'Section Analysis',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkText,
            ),
          ),
          
          const SizedBox(height: 12),
          
          ..._analysisResult!.sections.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SectionAnalysisCard(
                sectionName: entry.key,
                sectionScore: entry.value,
              ),
            );
          }),
          
          const SizedBox(height: 16),
          
          // Keyword Analysis
          if (_jobDescriptionController.text.isNotEmpty)
            KeywordAnalysisCard(
              keywordAnalysis: _analysisResult!.keywords,
            ),
          
          const SizedBox(height: 16),
          
          // Recommendations
          RecommendationsCard(
            recommendations: _analysisResult!.recommendations,
          ),
          
          const SizedBox(height: 80), // Space for bottom actions
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
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
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.mediumGray),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Close',
                style: TextStyle(
                  color: AppTheme.mediumGray,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          Expanded(
            child: ElevatedButton(
              onPressed: _isOptimizing ? null : _optimizeCV,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryTeal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
              ),
              child: _isOptimizing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Optimize CV',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
