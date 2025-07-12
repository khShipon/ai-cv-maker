import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

/// Custom exception for AI validation errors
class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);

  @override
  String toString() => 'ValidationException: $message';
}

/// AI Service for CV generation using DeepSeek R1 via OpenRouter
class AIService {
  static const String _baseUrl = 'https://openrouter.ai/api/v1';
  static const String _apiKey =
      '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';

  /// Rewrite rough CV input into polished, ATS-friendly content
  static Future<String> rewriteCVEntry({
    required String roughInput,
    required String jobTitle,
    String? context,
  }) async {
    try {
      final systemPrompt = '''
You are a professional CV writing assistant and ATS optimization expert. Your job is to rewrite the user's rough input into a polished, clear, formal, mistake-free CV bullet point or section. Follow these strict rules:

1️⃣ Start each entry with a strong action verb.
2️⃣ Use short, powerful sentences.
3️⃣ Quantify results with numbers if possible.
4️⃣ Write in third person. No 'I' or 'my'.
5️⃣ Optimize wording for the target job title: $jobTitle.
6️⃣ Check grammar and spelling.
7️⃣ VALIDATE INPUT: If the input is invalid, incomplete, or doesn't make sense, respond with "INVALID_INPUT: [explanation of what's wrong and what's needed]"
8️⃣ If valid, output only the final CV text, no extra commentary.

VALIDATION RULES:
- If input is too short (less than 3 words), ask for more details
- If input contains invalid information (fake companies, impossible achievements), ask for realistic information
- If input is completely unrelated to work/education, ask for relevant information
- If input is just random text or gibberish, ask for meaningful content

If the user's input is valid but vague, intelligently expand with realistic examples matching the role. Use common action verbs like: Managed, Led, Developed, Designed, Delivered, Streamlined, Achieved, Increased, Coordinated, Implemented, Analyzed.

EXAMPLES:
Input: "Worked in marketing, did ads."
Output: "Developed and managed digital marketing campaigns, optimizing ad performance and increasing brand engagement by 40%."

Input: "asdfgh random text"
Output: "INVALID_INPUT: Please provide meaningful information about your work experience, such as your job responsibilities, achievements, or projects."

Input: "I saved the world"
Output: "INVALID_INPUT: Please provide realistic and professional work experience. What was your actual job role and responsibilities?"

Always match the style: short, professional, quantifiable. Validate first, then generate polished CVs.
''';

      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
          'HTTP-Referer': 'https://ai-cv-builder.app',
          'X-Title': 'AI CV Builder',
        },
        body: jsonEncode({
          'model': 'deepseek/deepseek-r1-0528:free',
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': roughInput},
          ],
          'temperature': 0.7,
          'max_tokens': 200,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        final trimmedContent = content.trim();

        // Check if AI returned validation error
        if (trimmedContent.startsWith('INVALID_INPUT:')) {
          throw ValidationException(trimmedContent.substring(14).trim());
        }

        return trimmedContent;
      } else {
        throw Exception('Failed to rewrite CV entry: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('AI rewrite error: $e');
      return _getFallbackRewrite(roughInput);
    }
  }

  /// Generate CV content based on user input
  static Future<Map<String, dynamic>> generateCVContent({
    required String jobTitle,
    required String experience,
    required String skills,
    required String education,
    String? additionalInfo,
  }) async {
    try {
      final prompt = _buildCVPrompt(
        jobTitle: jobTitle,
        experience: experience,
        skills: skills,
        education: education,
        additionalInfo: additionalInfo,
      );

      final response = await _makeAPICall(prompt);
      return _parseCVResponse(response);
    } catch (e) {
      debugPrint('AI CV generation error: $e');
      rethrow;
    }
  }

  /// Optimize CV for ATS (Applicant Tracking System)
  static Future<Map<String, dynamic>> optimizeForATS({
    required Map<String, dynamic> cvData,
    required String targetJobDescription,
  }) async {
    try {
      final prompt = _buildATSOptimizationPrompt(cvData, targetJobDescription);
      final response = await _makeAPICall(prompt);
      return _parseCVResponse(response);
    } catch (e) {
      debugPrint('ATS optimization error: $e');
      rethrow;
    }
  }

  /// Generate cover letter
  static Future<String> generateCoverLetter({
    required String jobTitle,
    required String companyName,
    required Map<String, dynamic> cvData,
    String? jobDescription,
  }) async {
    try {
      final prompt = _buildCoverLetterPrompt(
        jobTitle: jobTitle,
        companyName: companyName,
        cvData: cvData,
        jobDescription: jobDescription,
      );

      final response = await _makeAPICall(prompt);
      return _parseCoverLetterResponse(response);
    } catch (e) {
      debugPrint('Cover letter generation error: $e');
      rethrow;
    }
  }

  /// Generate cover letter from user prompt
  static Future<String> generateCoverLetterFromPrompt({
    required String userPrompt,
    required Map<String, dynamic> cvData,
  }) async {
    try {
      final personalInfo =
          cvData['personalInfo'] as Map<String, dynamic>? ?? {};
      final experience = cvData['experience'] as List? ?? [];
      final skills = cvData['skills'] as Map<String, dynamic>? ?? {};

      final systemPrompt = '''
You are a professional cover letter writer. Create a compelling, personalized cover letter based on the user's request and their CV data.

RULES:
1. Write in first person
2. Keep it professional and engaging
3. Highlight relevant experience and skills
4. Match the tone to the job/company
5. Include specific achievements when possible
6. Keep it concise (3-4 paragraphs)
7. End with a strong call to action

CV DATA:
Name: ${personalInfo['name'] ?? 'N/A'}
Experience: ${experience.isNotEmpty ? experience.map((e) => '${e['title']} at ${e['company']}').join(', ') : 'N/A'}
Skills: ${skills['technical']?.join(', ') ?? 'N/A'}

USER REQUEST: $userPrompt

Generate a professional cover letter that addresses the user's specific request while showcasing their qualifications.
''';

      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
          'HTTP-Referer': 'https://ai-cv-builder.app',
          'X-Title': 'AI CV Builder',
        },
        body: jsonEncode({
          'model': 'deepseek/deepseek-r1-0528:free',
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': userPrompt},
          ],
          'temperature': 0.7,
          'max_tokens': 800,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        return content.trim();
      } else {
        throw Exception(
          'Failed to generate cover letter: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Cover letter generation error: $e');
      rethrow;
    }
  }

  /// Make API call to DeepSeek
  static Future<String> _makeAPICall(String prompt) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey',
      'HTTP-Referer': 'https://ai-cv-builder.app',
      'X-Title': 'AI CV Builder',
    };

    final body = jsonEncode({
      'model': 'deepseek/deepseek-r1-0528:free',
      'messages': [
        {
          'role': 'system',
          'content':
              'You are a professional CV writer and career consultant. Generate well-structured, ATS-optimized CV content in JSON format.',
        },
        {'role': 'user', 'content': prompt},
      ],
      'max_tokens': 2000,
      'temperature': 0.7,
    });

    final response = await http.post(
      Uri.parse('$_baseUrl/chat/completions'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception(
        'API call failed: ${response.statusCode} - ${response.body}',
      );
    }
  }

  /// Build CV generation prompt
  static String _buildCVPrompt({
    required String jobTitle,
    required String experience,
    required String skills,
    required String education,
    String? additionalInfo,
  }) {
    return '''
Generate a professional CV in JSON format for the following details:

Job Title: $jobTitle
Experience: $experience
Skills: $skills
Education: $education
${additionalInfo != null ? 'Additional Info: $additionalInfo' : ''}

Return the response in this exact JSON structure:
{
  "personalInfo": {
    "name": "",
    "email": "",
    "phone": "",
    "location": "",
    "linkedin": "",
    "summary": ""
  },
  "experience": [
    {
      "title": "",
      "company": "",
      "duration": "",
      "description": "",
      "achievements": []
    }
  ],
  "education": [
    {
      "degree": "",
      "institution": "",
      "year": "",
      "gpa": ""
    }
  ],
  "skills": {
    "technical": [],
    "soft": [],
    "languages": []
  },
  "projects": [
    {
      "name": "",
      "description": "",
      "technologies": [],
      "link": ""
    }
  ],
  "certifications": [
    {
      "name": "",
      "issuer": "",
      "date": ""
    }
  ]
}

Make sure the content is professional, ATS-optimized, and tailored for the specified job title.
''';
  }

  /// Build ATS optimization prompt
  static String _buildATSOptimizationPrompt(
    Map<String, dynamic> cvData,
    String jobDescription,
  ) {
    return '''
Optimize the following CV data for ATS (Applicant Tracking System) based on this job description:

Job Description: $jobDescription

Current CV Data: ${jsonEncode(cvData)}

Please return the optimized CV in the same JSON structure, ensuring:
1. Keywords from job description are incorporated naturally
2. Skills are prioritized based on job requirements
3. Experience descriptions highlight relevant achievements
4. Technical terms match industry standards
5. Format is ATS-friendly

Return only the JSON structure without additional text.
''';
  }

  /// Build cover letter prompt
  static String _buildCoverLetterPrompt({
    required String jobTitle,
    required String companyName,
    required Map<String, dynamic> cvData,
    String? jobDescription,
  }) {
    return '''
Generate a professional cover letter for:

Position: $jobTitle
Company: $companyName
${jobDescription != null ? 'Job Description: $jobDescription' : ''}

Based on this CV data: ${jsonEncode(cvData)}

The cover letter should be:
- Professional and engaging
- Tailored to the specific role and company
- Highlight relevant experience and skills
- Show enthusiasm for the position
- Be concise (3-4 paragraphs)

Return only the cover letter text without additional formatting.
''';
  }

  /// Parse CV response from AI
  static Map<String, dynamic> _parseCVResponse(String response) {
    try {
      // Extract JSON from response if it contains additional text
      final jsonStart = response.indexOf('{');
      final jsonEnd = response.lastIndexOf('}') + 1;

      if (jsonStart != -1 && jsonEnd > jsonStart) {
        final jsonString = response.substring(jsonStart, jsonEnd);
        return jsonDecode(jsonString);
      }

      return jsonDecode(response);
    } catch (e) {
      debugPrint('Error parsing CV response: $e');
      // Return default structure if parsing fails
      return {
        'personalInfo': {
          'name': '',
          'email': '',
          'phone': '',
          'location': '',
          'linkedin': '',
          'summary': '',
        },
        'experience': [],
        'education': [],
        'skills': {'technical': [], 'soft': [], 'languages': []},
        'projects': [],
        'certifications': [],
      };
    }
  }

  /// Parse cover letter response
  static String _parseCoverLetterResponse(String response) {
    // Remove any markdown formatting or extra text
    return response.replaceAll('```', '').replaceAll('**', '').trim();
  }

  /// Fallback rewrite when AI service fails
  static String _getFallbackRewrite(String roughInput) {
    // Simple fallback that capitalizes and adds basic formatting
    final cleaned = roughInput.trim();
    if (cleaned.isEmpty) return 'Professional experience in relevant field';

    // Capitalize first letter and ensure it ends with a period
    final capitalized = cleaned[0].toUpperCase() + cleaned.substring(1);
    return capitalized.endsWith('.') ? capitalized : '$capitalized.';
  }
}
