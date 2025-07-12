import 'package:flutter/foundation.dart';
import '../models/cv_model.dart';

/// ATS Optimization Service for keyword analysis and CV scoring
class ATSOptimizationService {
  /// Analyze CV for ATS compatibility and generate score
  static Future<ATSAnalysisResult> analyzeCV(
    CVModel cv, {
    String? jobDescription,
  }) async {
    try {
      final analysis = ATSAnalysisResult(
        overallScore: 0,
        sections: {},
        recommendations: [],
        keywords: ATSKeywordAnalysis(found: [], missing: [], suggestions: []),
        formatting: ATSFormattingAnalysis(
          score: 0,
          issues: [],
          recommendations: [],
        ),
      );

      // Analyze each section
      analysis.sections['personalInfo'] = _analyzePersonalInfo(
        cv.data['personalInfo'],
      );
      analysis.sections['experience'] = _analyzeExperience(
        cv.data['experience'],
      );
      analysis.sections['education'] = _analyzeEducation(cv.data['education']);
      analysis.sections['skills'] = _analyzeSkills(cv.data['skills']);

      // Analyze keywords if job description provided
      if (jobDescription != null && jobDescription.isNotEmpty) {
        analysis.keywords = _analyzeKeywords(cv, jobDescription);
      }

      // Analyze formatting
      analysis.formatting = _analyzeFormatting(cv);

      // Calculate overall score
      analysis.overallScore = _calculateOverallScore(analysis);

      // Generate recommendations
      analysis.recommendations = _generateRecommendations(analysis);

      return analysis;
    } catch (e) {
      debugPrint('ATS analysis error: $e');
      return ATSAnalysisResult.empty();
    }
  }

  /// Optimize CV content for better ATS score
  static Future<CVModel> optimizeCV(CVModel cv, String jobDescription) async {
    try {
      final analysis = await analyzeCV(cv, jobDescription: jobDescription);
      var optimizedData = Map<String, dynamic>.from(cv.data);

      // Apply optimizations based on analysis
      if (analysis.keywords.missing.isNotEmpty) {
        optimizedData = _optimizeKeywords(optimizedData, analysis.keywords);
      }

      // Optimize section structure
      optimizedData = _optimizeStructure(optimizedData, analysis);

      return cv.copyWith(data: optimizedData, lastEdited: DateTime.now());
    } catch (e) {
      debugPrint('CV optimization error: $e');
      return cv;
    }
  }

  /// Extract keywords from job description
  static List<String> extractJobKeywords(String jobDescription) {
    final keywords = <String>[];
    final text = jobDescription.toLowerCase();

    // Common technical skills
    final techSkills = [
      'javascript',
      'python',
      'java',
      'react',
      'angular',
      'vue',
      'node.js',
      'sql',
      'mongodb',
      'aws',
      'azure',
      'docker',
      'kubernetes',
      'git',
      'agile',
      'scrum',
      'ci/cd',
      'devops',
      'machine learning',
      'ai',
    ];

    // Common soft skills
    final softSkills = [
      'leadership',
      'communication',
      'teamwork',
      'problem solving',
      'project management',
      'analytical',
      'creative',
      'adaptable',
    ];

    // Extract technical keywords
    for (final skill in techSkills) {
      if (text.contains(skill)) {
        keywords.add(skill);
      }
    }

    // Extract soft skills
    for (final skill in softSkills) {
      if (text.contains(skill)) {
        keywords.add(skill);
      }
    }

    return keywords;
  }

  static ATSSectionScore _analyzePersonalInfo(dynamic personalInfo) {
    final info = personalInfo as Map<String, dynamic>? ?? {};
    int score = 0;
    final issues = <String>[];

    // Check required fields
    if (info['name']?.toString().isNotEmpty == true)
      score += 20;
    else
      issues.add('Missing full name');

    if (info['email']?.toString().isNotEmpty == true)
      score += 20;
    else
      issues.add('Missing email address');

    if (info['phone']?.toString().isNotEmpty == true)
      score += 15;
    else
      issues.add('Missing phone number');

    if (info['location']?.toString().isNotEmpty == true)
      score += 15;
    else
      issues.add('Missing location');

    // Check email format
    final email = info['email']?.toString() ?? '';
    if (email.isNotEmpty && !email.contains('@')) {
      score -= 10;
      issues.add('Invalid email format');
    }

    return ATSSectionScore(
      score: score.clamp(0, 100),
      maxScore: 100,
      issues: issues,
    );
  }

  static ATSSectionScore _analyzeExperience(dynamic experience) {
    final exp = experience as List<dynamic>? ?? [];
    int score = 0;
    final issues = <String>[];

    if (exp.isEmpty) {
      issues.add('No work experience listed');
      return ATSSectionScore(score: 0, maxScore: 100, issues: issues);
    }

    // Analyze each experience entry
    for (final entry in exp) {
      final expEntry = entry as Map<String, dynamic>? ?? {};

      if (expEntry['title']?.toString().isNotEmpty == true)
        score += 15;
      else
        issues.add('Missing job title in experience');

      if (expEntry['company']?.toString().isNotEmpty == true)
        score += 15;
      else
        issues.add('Missing company name in experience');

      if (expEntry['duration']?.toString().isNotEmpty == true)
        score += 10;
      else
        issues.add('Missing duration in experience');

      if (expEntry['description']?.toString().isNotEmpty == true)
        score += 20;
      else
        issues.add('Missing job description');

      // Check for achievements
      final achievements = expEntry['achievements'] as List<dynamic>? ?? [];
      if (achievements.isNotEmpty)
        score += 20;
      else
        issues.add('No achievements listed for experience');
    }

    return ATSSectionScore(
      score: (score / exp.length).clamp(0, 100).round(),
      maxScore: 100,
      issues: issues,
    );
  }

  static ATSSectionScore _analyzeEducation(dynamic education) {
    final edu = education as List<dynamic>? ?? [];
    int score = 0;
    final issues = <String>[];

    if (edu.isEmpty) {
      issues.add('No education listed');
      return ATSSectionScore(score: 0, maxScore: 100, issues: issues);
    }

    for (final entry in edu) {
      final eduEntry = entry as Map<String, dynamic>? ?? {};

      if (eduEntry['degree']?.toString().isNotEmpty == true) score += 30;
      if (eduEntry['institution']?.toString().isNotEmpty == true) score += 30;
      if (eduEntry['year']?.toString().isNotEmpty == true) score += 20;
    }

    return ATSSectionScore(
      score: (score / edu.length).clamp(0, 100).round(),
      maxScore: 100,
      issues: issues,
    );
  }

  static ATSSectionScore _analyzeSkills(dynamic skills) {
    final skillsData = skills as Map<String, dynamic>? ?? {};
    int score = 0;
    final issues = <String>[];

    final technical = skillsData['technical'] as List<dynamic>? ?? [];
    final soft = skillsData['soft'] as List<dynamic>? ?? [];

    if (technical.isEmpty) {
      issues.add('No technical skills listed');
    } else {
      score += (technical.length * 10).clamp(0, 50);
    }

    if (soft.isEmpty) {
      issues.add('No soft skills listed');
    } else {
      score += (soft.length * 5).clamp(0, 30);
    }

    return ATSSectionScore(
      score: score.clamp(0, 100),
      maxScore: 100,
      issues: issues,
    );
  }

  static ATSKeywordAnalysis _analyzeKeywords(
    CVModel cv,
    String jobDescription,
  ) {
    final jobKeywords = extractJobKeywords(jobDescription);
    final cvText = _extractCVText(cv).toLowerCase();

    final found = <String>[];
    final missing = <String>[];

    for (final keyword in jobKeywords) {
      if (cvText.contains(keyword.toLowerCase())) {
        found.add(keyword);
      } else {
        missing.add(keyword);
      }
    }

    return ATSKeywordAnalysis(
      found: found,
      missing: missing,
      suggestions: missing.take(5).toList(),
    );
  }

  static ATSFormattingAnalysis _analyzeFormatting(CVModel cv) {
    int score = 100;
    final issues = <String>[];
    final recommendations = <String>[];

    // Check for common formatting issues
    final cvText = _extractCVText(cv);

    if (cvText.length < 200) {
      score -= 20;
      issues.add('CV content is too short');
      recommendations.add('Add more detailed descriptions');
    }

    if (cvText.length > 2000) {
      score -= 10;
      issues.add('CV content might be too long');
      recommendations.add('Consider condensing content');
    }

    return ATSFormattingAnalysis(
      score: score.clamp(0, 100),
      issues: issues,
      recommendations: recommendations,
    );
  }

  static String _extractCVText(CVModel cv) {
    final buffer = StringBuffer();

    // Extract text from all sections
    final personalInfo = cv.data['personalInfo'] as Map<String, dynamic>? ?? {};
    buffer.write('${personalInfo['name'] ?? ''} ');
    buffer.write('${personalInfo['summary'] ?? ''} ');

    final experience = cv.data['experience'] as List<dynamic>? ?? [];
    for (final exp in experience) {
      final expData = exp as Map<String, dynamic>? ?? {};
      buffer.write('${expData['title'] ?? ''} ');
      buffer.write('${expData['description'] ?? ''} ');
    }

    final skills = cv.data['skills'] as Map<String, dynamic>? ?? {};
    final technical = skills['technical'] as List<dynamic>? ?? [];
    final soft = skills['soft'] as List<dynamic>? ?? [];
    buffer.write('${technical.join(' ')} ');
    buffer.write('${soft.join(' ')} ');

    return buffer.toString();
  }

  static int _calculateOverallScore(ATSAnalysisResult analysis) {
    final sectionScores = analysis.sections.values.map((s) => s.score).toList();
    if (sectionScores.isEmpty) return 0;

    final avgSectionScore =
        sectionScores.reduce((a, b) => a + b) / sectionScores.length;
    final keywordScore = analysis.keywords.found.length * 5;
    final formattingScore = analysis.formatting.score;

    return ((avgSectionScore * 0.5) +
            (keywordScore * 0.3) +
            (formattingScore * 0.2))
        .round()
        .clamp(0, 100);
  }

  static List<String> _generateRecommendations(ATSAnalysisResult analysis) {
    final recommendations = <String>[];

    // Section-specific recommendations
    analysis.sections.forEach((section, score) {
      if (score.score < 70) {
        recommendations.addAll(score.issues.map((issue) => '$section: $issue'));
      }
    });

    // Keyword recommendations
    if (analysis.keywords.missing.isNotEmpty) {
      recommendations.add(
        'Add missing keywords: ${analysis.keywords.missing.take(3).join(', ')}',
      );
    }

    // Formatting recommendations
    recommendations.addAll(analysis.formatting.recommendations);

    return recommendations.take(5).toList();
  }

  static Map<String, dynamic> _optimizeKeywords(
    Map<String, dynamic> data,
    ATSKeywordAnalysis keywords,
  ) {
    // This would implement keyword optimization logic
    return data;
  }

  static Map<String, dynamic> _optimizeStructure(
    Map<String, dynamic> data,
    ATSAnalysisResult analysis,
  ) {
    // This would implement structure optimization logic
    return data;
  }
}

/// ATS Analysis Result
class ATSAnalysisResult {
  int overallScore;
  Map<String, ATSSectionScore> sections;
  List<String> recommendations;
  ATSKeywordAnalysis keywords;
  ATSFormattingAnalysis formatting;

  ATSAnalysisResult({
    required this.overallScore,
    required this.sections,
    required this.recommendations,
    required this.keywords,
    required this.formatting,
  });

  factory ATSAnalysisResult.empty() {
    return ATSAnalysisResult(
      overallScore: 0,
      sections: {},
      recommendations: [],
      keywords: ATSKeywordAnalysis(found: [], missing: [], suggestions: []),
      formatting: ATSFormattingAnalysis(
        score: 0,
        issues: [],
        recommendations: [],
      ),
    );
  }
}

/// Section Score
class ATSSectionScore {
  final int score;
  final int maxScore;
  final List<String> issues;

  ATSSectionScore({
    required this.score,
    required this.maxScore,
    required this.issues,
  });
}

/// Keyword Analysis
class ATSKeywordAnalysis {
  final List<String> found;
  final List<String> missing;
  final List<String> suggestions;

  ATSKeywordAnalysis({
    required this.found,
    required this.missing,
    required this.suggestions,
  });
}

/// Formatting Analysis
class ATSFormattingAnalysis {
  final int score;
  final List<String> issues;
  final List<String> recommendations;

  ATSFormattingAnalysis({
    required this.score,
    required this.issues,
    required this.recommendations,
  });
}
