/// App Constants
/// Global constants used throughout the application
class AppConstants {
  AppConstants._();

  // App Information
  static const String appName = 'CV Builder';
  static const String appTagline = 'Build Your Perfect CV — AI or Custom, Your Choice';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'https://api.cvbuilder.com';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;
  
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String cvsCollection = 'cvs';
  static const String templatesCollection = 'templates';
  static const String coverLettersCollection = 'cover_letters';
  
  // Local Storage Keys
  static const String userPrefsKey = 'user_preferences';
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  static const String lastSyncKey = 'last_sync';
  
  // CV Builder Configuration
  static const int maxCVs = 10; // For free tier
  static const int maxCoverLetters = 5; // For free tier
  static const int maxSections = 15;
  static const int maxExperienceEntries = 20;
  static const int maxEducationEntries = 10;
  static const int maxSkills = 50;
  
  // AI Configuration
  static const int maxAIRequests = 50; // Per day for free tier
  static const int maxTokensPerRequest = 2000;
  static const Duration aiResponseTimeout = Duration(seconds: 45);
  
  // File Configuration
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx'];
  
  // ATS Score Thresholds
  static const int atsExcellentThreshold = 90;
  static const int atsGoodThreshold = 70;
  static const int atsFairThreshold = 50;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  static const Duration pageTransition = Duration(milliseconds: 250);
  
  // Debounce Durations
  static const Duration searchDebounce = Duration(milliseconds: 500);
  static const Duration autoSaveDebounce = Duration(seconds: 2);
  static const Duration typingDebounce = Duration(milliseconds: 300);
  
  // UI Configuration
  static const double maxContentWidth = 1200;
  static const double mobileBreakpoint = 768;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;
  
  // Chat Configuration
  static const int maxChatHistory = 100;
  static const int maxMessageLength = 1000;
  static const Duration typingIndicatorDelay = Duration(milliseconds: 1500);
  
  // Template Categories
  static const List<String> templateCategories = [
    'Minimalist',
    'Creative',
    'Corporate',
    'Modern',
    'Academic',
  ];
  
  // Industries
  static const List<String> industries = [
    'Technology',
    'Healthcare',
    'Finance',
    'Education',
    'Marketing',
    'Sales',
    'Engineering',
    'Design',
    'Consulting',
    'Legal',
    'Non-profit',
    'Government',
    'Retail',
    'Manufacturing',
    'Media',
    'Other',
  ];
  
  // Experience Levels
  static const List<String> experienceLevels = [
    'Entry Level',
    'Mid Level',
    'Senior Level',
    'Executive',
    'Student',
    'Career Change',
  ];
  
  // CV Sections
  static const List<String> defaultSections = [
    'Personal Information',
    'Professional Summary',
    'Work Experience',
    'Education',
    'Skills',
  ];
  
  static const List<String> optionalSections = [
    'Projects',
    'Certifications',
    'Languages',
    'Volunteer Experience',
    'Publications',
    'Awards',
    'References',
    'Hobbies',
  ];
  
  // Error Messages
  static const String networkError = 'Network connection error. Please check your internet connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String authError = 'Authentication error. Please sign in again.';
  static const String validationError = 'Please check your input and try again.';
  static const String fileUploadError = 'File upload failed. Please try again.';
  static const String aiServiceError = 'AI service is temporarily unavailable. Please try again.';
  
  // Success Messages
  static const String cvSavedSuccess = 'CV saved successfully!';
  static const String cvExportedSuccess = 'CV exported successfully!';
  static const String profileUpdatedSuccess = 'Profile updated successfully!';
  static const String passwordChangedSuccess = 'Password changed successfully!';
  
  // Validation Rules
  static const int minPasswordLength = 8;
  static const int maxNameLength = 50;
  static const int maxEmailLength = 100;
  static const int maxPhoneLength = 20;
  static const int maxSummaryLength = 500;
  static const int maxExperienceDescriptionLength = 1000;
  
  // Regular Expressions
  static const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phoneRegex = r'^\+?[\d\s\-\(\)]+$';
  static const String urlRegex = r'^https?:\/\/[^\s]+$';
  
  // Feature Flags
  static const bool enableAIFeatures = true;
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enableOfflineMode = true;
  static const bool enablePushNotifications = false;
}

/// App Spacing Constants
class AppSpacing {
  AppSpacing._();
  
  // Base spacing unit (8px)
  static const double base = 8.0;
  
  // Spacing scale
  static const double xs = base * 0.5;    // 4px
  static const double sm = base;          // 8px
  static const double md = base * 2;      // 16px
  static const double lg = base * 3;      // 24px
  static const double xl = base * 4;      // 32px
  static const double xxl = base * 6;     // 48px
  static const double xxxl = base * 8;    // 64px
  
  // Semantic spacing
  static const double cardPadding = md;
  static const double screenPadding = md;
  static const double sectionSpacing = lg;
  static const double elementSpacing = sm;
  static const double buttonSpacing = md;
  
  // Border radius
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusXxl = 24.0;
  
  // Icon sizes
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;
  static const double iconXxl = 64.0;
}

/// App Durations
class AppDurations {
  AppDurations._();
  
  static const Duration instant = Duration.zero;
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration slower = Duration(milliseconds: 750);
  static const Duration slowest = Duration(seconds: 1);
}
