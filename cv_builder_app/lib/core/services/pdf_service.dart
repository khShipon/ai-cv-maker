import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/foundation.dart';
import '../models/cv_model.dart';

/// PDF Service for generating and downloading CV PDFs
class PDFService {
  /// Generate PDF from CV data
  static Future<Uint8List> generateCVPDF(CVModel cv) async {
    final pdf = pw.Document();
    
    // Extract CV data
    final personalInfo = cv.data['personalInfo'] as Map<String, dynamic>? ?? {};
    final experience = cv.data['experience'] as List<dynamic>? ?? [];
    final education = cv.data['education'] as List<dynamic>? ?? [];
    final skills = cv.data['skills'] as Map<String, dynamic>? ?? {};
    final projects = cv.data['projects'] as List<dynamic>? ?? [];
    final certifications = cv.data['certifications'] as List<dynamic>? ?? [];

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Header with personal info
            _buildHeader(personalInfo),
            pw.SizedBox(height: 20),
            
            // Summary
            if (personalInfo['summary'] != null && personalInfo['summary'].toString().isNotEmpty)
              _buildSection('Professional Summary', [
                pw.Text(
                  personalInfo['summary'].toString(),
                  style: const pw.TextStyle(fontSize: 11),
                  textAlign: pw.TextAlign.justify,
                ),
              ]),
            
            // Experience
            if (experience.isNotEmpty)
              _buildSection('Work Experience', 
                experience.map((exp) => _buildExperienceItem(exp)).toList(),
              ),
            
            // Education
            if (education.isNotEmpty)
              _buildSection('Education',
                education.map((edu) => _buildEducationItem(edu)).toList(),
              ),
            
            // Skills
            if (skills.isNotEmpty)
              _buildSkillsSection(skills),
            
            // Projects
            if (projects.isNotEmpty)
              _buildSection('Projects',
                projects.map((project) => _buildProjectItem(project)).toList(),
              ),
            
            // Certifications
            if (certifications.isNotEmpty)
              _buildSection('Certifications',
                certifications.map((cert) => _buildCertificationItem(cert)).toList(),
              ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  /// Build header section with personal information
  static pw.Widget _buildHeader(Map<String, dynamic> personalInfo) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Name
        pw.Text(
          personalInfo['name']?.toString() ?? 'Your Name',
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 8),
        
        // Contact information
        pw.Row(
          children: [
            if (personalInfo['email'] != null)
              pw.Expanded(
                child: pw.Text(
                  personalInfo['email'].toString(),
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ),
            if (personalInfo['phone'] != null)
              pw.Expanded(
                child: pw.Text(
                  personalInfo['phone'].toString(),
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ),
          ],
        ),
        
        if (personalInfo['location'] != null || personalInfo['linkedin'] != null)
          pw.SizedBox(height: 4),
        
        pw.Row(
          children: [
            if (personalInfo['location'] != null)
              pw.Expanded(
                child: pw.Text(
                  personalInfo['location'].toString(),
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ),
            if (personalInfo['linkedin'] != null)
              pw.Expanded(
                child: pw.Text(
                  personalInfo['linkedin'].toString(),
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ),
          ],
        ),
        
        pw.SizedBox(height: 8),
        pw.Divider(color: PdfColors.blue900, thickness: 2),
      ],
    );
  }

  /// Build section with title and content
  static pw.Widget _buildSection(String title, List<pw.Widget> content) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 16),
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 8),
        ...content,
      ],
    );
  }

  /// Build experience item
  static pw.Widget _buildExperienceItem(dynamic exp) {
    final experience = exp as Map<String, dynamic>;
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Expanded(
              child: pw.Text(
                experience['title']?.toString() ?? '',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Text(
              experience['duration']?.toString() ?? '',
              style: const pw.TextStyle(fontSize: 10),
            ),
          ],
        ),
        pw.Text(
          experience['company']?.toString() ?? '',
          style: pw.TextStyle(
            fontSize: 11,
            fontStyle: pw.FontStyle.italic,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          experience['description']?.toString() ?? '',
          style: const pw.TextStyle(fontSize: 10),
        ),
        
        // Achievements
        if (experience['achievements'] != null && experience['achievements'] is List)
          ...((experience['achievements'] as List).map((achievement) => 
            pw.Padding(
              padding: const pw.EdgeInsets.only(left: 12, top: 2),
              child: pw.Text(
                '• ${achievement.toString()}',
                style: const pw.TextStyle(fontSize: 10),
              ),
            ),
          )),
        
        pw.SizedBox(height: 12),
      ],
    );
  }

  /// Build education item
  static pw.Widget _buildEducationItem(dynamic edu) {
    final education = edu as Map<String, dynamic>;
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Expanded(
              child: pw.Text(
                education['degree']?.toString() ?? '',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Text(
              education['year']?.toString() ?? '',
              style: const pw.TextStyle(fontSize: 10),
            ),
          ],
        ),
        pw.Text(
          education['institution']?.toString() ?? '',
          style: const pw.TextStyle(fontSize: 11),
        ),
        if (education['gpa'] != null)
          pw.Text(
            'GPA: ${education['gpa']}',
            style: const pw.TextStyle(fontSize: 10),
          ),
        pw.SizedBox(height: 8),
      ],
    );
  }

  /// Build skills section
  static pw.Widget _buildSkillsSection(Map<String, dynamic> skills) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 16),
        pw.Text(
          'Skills',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 8),
        
        if (skills['technical'] != null && (skills['technical'] as List).isNotEmpty)
          _buildSkillCategory('Technical Skills', skills['technical'] as List),
        
        if (skills['soft'] != null && (skills['soft'] as List).isNotEmpty)
          _buildSkillCategory('Soft Skills', skills['soft'] as List),
        
        if (skills['languages'] != null && (skills['languages'] as List).isNotEmpty)
          _buildSkillCategory('Languages', skills['languages'] as List),
      ],
    );
  }

  /// Build skill category
  static pw.Widget _buildSkillCategory(String category, List<dynamic> skillList) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          '$category:',
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Text(
          skillList.join(', '),
          style: const pw.TextStyle(fontSize: 10),
        ),
        pw.SizedBox(height: 6),
      ],
    );
  }

  /// Build project item
  static pw.Widget _buildProjectItem(dynamic proj) {
    final project = proj as Map<String, dynamic>;
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          project['name']?.toString() ?? '',
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Text(
          project['description']?.toString() ?? '',
          style: const pw.TextStyle(fontSize: 10),
        ),
        if (project['technologies'] != null && (project['technologies'] as List).isNotEmpty)
          pw.Text(
            'Technologies: ${(project['technologies'] as List).join(', ')}',
            style: const pw.TextStyle(fontSize: 9),
          ),
        if (project['link'] != null)
          pw.Text(
            'Link: ${project['link']}',
            style: const pw.TextStyle(fontSize: 9),
          ),
        pw.SizedBox(height: 8),
      ],
    );
  }

  /// Build certification item
  static pw.Widget _buildCertificationItem(dynamic cert) {
    final certification = cert as Map<String, dynamic>;
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Expanded(
              child: pw.Text(
                certification['name']?.toString() ?? '',
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Text(
              certification['date']?.toString() ?? '',
              style: const pw.TextStyle(fontSize: 10),
            ),
          ],
        ),
        pw.Text(
          certification['issuer']?.toString() ?? '',
          style: const pw.TextStyle(fontSize: 10),
        ),
        pw.SizedBox(height: 6),
      ],
    );
  }

  /// Save and share PDF
  static Future<void> saveAndSharePDF(CVModel cv) async {
    try {
      final pdfBytes = await generateCVPDF(cv);
      
      if (kIsWeb) {
        // For web, trigger download
        // This would need web-specific implementation
        debugPrint('PDF download for web not implemented yet');
      } else {
        // For mobile, save to device and share
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/${cv.title}_CV.pdf');
        await file.writeAsBytes(pdfBytes);
        
        await Share.shareXFiles(
          [XFile(file.path)],
          text: 'My CV - ${cv.title}',
        );
      }
    } catch (e) {
      debugPrint('Error generating PDF: $e');
      rethrow;
    }
  }
}
