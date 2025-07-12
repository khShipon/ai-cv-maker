import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../models/cv_model.dart';

/// Local Storage Service for managing CV data locally
class LocalStorageService {
  static const String _cvsKey = 'cvs';
  static const String _coverLettersKey = 'cover_letters';
  static const String _templatesKey = 'templates';
  static const String _userPreferencesKey = 'user_preferences';

  /// Get all CVs from local storage
  static Future<List<CVModel>> getCVs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cvsJson = prefs.getString(_cvsKey);
      
      if (cvsJson == null) return [];
      
      final List<dynamic> cvsList = jsonDecode(cvsJson);
      return cvsList.map((json) => CVModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error loading CVs: $e');
      return [];
    }
  }

  /// Save CV to local storage
  static Future<bool> saveCV(CVModel cv) async {
    try {
      final cvs = await getCVs();
      
      // Check if CV already exists and update it
      final existingIndex = cvs.indexWhere((existingCV) => existingCV.id == cv.id);
      if (existingIndex != -1) {
        cvs[existingIndex] = cv;
      } else {
        cvs.add(cv);
      }
      
      final prefs = await SharedPreferences.getInstance();
      final cvsJson = jsonEncode(cvs.map((cv) => cv.toJson()).toList());
      
      return await prefs.setString(_cvsKey, cvsJson);
    } catch (e) {
      debugPrint('Error saving CV: $e');
      return false;
    }
  }

  /// Delete CV from local storage
  static Future<bool> deleteCV(String cvId) async {
    try {
      final cvs = await getCVs();
      cvs.removeWhere((cv) => cv.id == cvId);
      
      final prefs = await SharedPreferences.getInstance();
      final cvsJson = jsonEncode(cvs.map((cv) => cv.toJson()).toList());
      
      return await prefs.setString(_cvsKey, cvsJson);
    } catch (e) {
      debugPrint('Error deleting CV: $e');
      return false;
    }
  }

  /// Get CV by ID
  static Future<CVModel?> getCVById(String cvId) async {
    try {
      final cvs = await getCVs();
      return cvs.firstWhere((cv) => cv.id == cvId);
    } catch (e) {
      debugPrint('CV not found: $e');
      return null;
    }
  }

  /// Get all cover letters from local storage
  static Future<List<CVModel>> getCoverLetters() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final coverLettersJson = prefs.getString(_coverLettersKey);
      
      if (coverLettersJson == null) return [];
      
      final List<dynamic> coverLettersList = jsonDecode(coverLettersJson);
      return coverLettersList.map((json) => CVModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error loading cover letters: $e');
      return [];
    }
  }

  /// Save cover letter to local storage
  static Future<bool> saveCoverLetter(CVModel coverLetter) async {
    try {
      final coverLetters = await getCoverLetters();
      
      // Check if cover letter already exists and update it
      final existingIndex = coverLetters.indexWhere((existing) => existing.id == coverLetter.id);
      if (existingIndex != -1) {
        coverLetters[existingIndex] = coverLetter;
      } else {
        coverLetters.add(coverLetter);
      }
      
      final prefs = await SharedPreferences.getInstance();
      final coverLettersJson = jsonEncode(coverLetters.map((cl) => cl.toJson()).toList());
      
      return await prefs.setString(_coverLettersKey, coverLettersJson);
    } catch (e) {
      debugPrint('Error saving cover letter: $e');
      return false;
    }
  }

  /// Delete cover letter from local storage
  static Future<bool> deleteCoverLetter(String coverLetterId) async {
    try {
      final coverLetters = await getCoverLetters();
      coverLetters.removeWhere((cl) => cl.id == coverLetterId);
      
      final prefs = await SharedPreferences.getInstance();
      final coverLettersJson = jsonEncode(coverLetters.map((cl) => cl.toJson()).toList());
      
      return await prefs.setString(_coverLettersKey, coverLettersJson);
    } catch (e) {
      debugPrint('Error deleting cover letter: $e');
      return false;
    }
  }

  /// Save user preferences
  static Future<bool> saveUserPreferences(Map<String, dynamic> preferences) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final preferencesJson = jsonEncode(preferences);
      
      return await prefs.setString(_userPreferencesKey, preferencesJson);
    } catch (e) {
      debugPrint('Error saving user preferences: $e');
      return false;
    }
  }

  /// Get user preferences
  static Future<Map<String, dynamic>> getUserPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final preferencesJson = prefs.getString(_userPreferencesKey);
      
      if (preferencesJson == null) return {};
      
      return jsonDecode(preferencesJson) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error loading user preferences: $e');
      return {};
    }
  }

  /// Clear all local data
  static Future<bool> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cvsKey);
      await prefs.remove(_coverLettersKey);
      await prefs.remove(_templatesKey);
      await prefs.remove(_userPreferencesKey);
      
      return true;
    } catch (e) {
      debugPrint('Error clearing data: $e');
      return false;
    }
  }

  /// Export all data as JSON
  static Future<Map<String, dynamic>> exportAllData() async {
    try {
      final cvs = await getCVs();
      final coverLetters = await getCoverLetters();
      final preferences = await getUserPreferences();
      
      return {
        'cvs': cvs.map((cv) => cv.toJson()).toList(),
        'coverLetters': coverLetters.map((cl) => cl.toJson()).toList(),
        'preferences': preferences,
        'exportDate': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint('Error exporting data: $e');
      return {};
    }
  }

  /// Import data from JSON
  static Future<bool> importData(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Import CVs
      if (data['cvs'] != null) {
        final cvsJson = jsonEncode(data['cvs']);
        await prefs.setString(_cvsKey, cvsJson);
      }
      
      // Import cover letters
      if (data['coverLetters'] != null) {
        final coverLettersJson = jsonEncode(data['coverLetters']);
        await prefs.setString(_coverLettersKey, coverLettersJson);
      }
      
      // Import preferences
      if (data['preferences'] != null) {
        final preferencesJson = jsonEncode(data['preferences']);
        await prefs.setString(_userPreferencesKey, preferencesJson);
      }
      
      return true;
    } catch (e) {
      debugPrint('Error importing data: $e');
      return false;
    }
  }

  /// Get storage usage statistics
  static Future<Map<String, int>> getStorageStats() async {
    try {
      final cvs = await getCVs();
      final coverLetters = await getCoverLetters();
      
      return {
        'totalCVs': cvs.length,
        'totalCoverLetters': coverLetters.length,
        'draftCVs': cvs.where((cv) => cv.status == 'draft').length,
        'readyCVs': cvs.where((cv) => cv.status == 'ready').length,
        'exportedCVs': cvs.where((cv) => cv.status == 'exported').length,
      };
    } catch (e) {
      debugPrint('Error getting storage stats: $e');
      return {};
    }
  }
}
