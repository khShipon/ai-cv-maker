import 'package:flutter/material.dart';

/// CV Template Model
class CVTemplate {
  final String id;
  final String name;
  final String category;
  final String description;
  final String thumbnailPath;
  final bool isATSOptimized;
  final bool isPremium;
  final List<Color> colors;
  final List<String> features;
  final Map<String, dynamic>? layout;

  CVTemplate({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.thumbnailPath,
    required this.isATSOptimized,
    required this.isPremium,
    required this.colors,
    required this.features,
    this.layout,
  });

  /// Convert template to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'thumbnailPath': thumbnailPath,
      'isATSOptimized': isATSOptimized,
      'isPremium': isPremium,
      'colors': colors.map((color) => color.value).toList(),
      'features': features,
      'layout': layout,
    };
  }

  /// Create template from JSON
  factory CVTemplate.fromJson(Map<String, dynamic> json) {
    return CVTemplate(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      thumbnailPath: json['thumbnailPath'] as String,
      isATSOptimized: json['isATSOptimized'] as bool,
      isPremium: json['isPremium'] as bool,
      colors: (json['colors'] as List<dynamic>)
          .map((colorValue) => Color(colorValue as int))
          .toList(),
      features: List<String>.from(json['features'] as List),
      layout: json['layout'] as Map<String, dynamic>?,
    );
  }

  /// Create a copy with updated fields
  CVTemplate copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    String? thumbnailPath,
    bool? isATSOptimized,
    bool? isPremium,
    List<Color>? colors,
    List<String>? features,
    Map<String, dynamic>? layout,
  }) {
    return CVTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      isATSOptimized: isATSOptimized ?? this.isATSOptimized,
      isPremium: isPremium ?? this.isPremium,
      colors: colors ?? this.colors,
      features: features ?? this.features,
      layout: layout ?? this.layout,
    );
  }

  @override
  String toString() {
    return 'CVTemplate(id: $id, name: $name, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CVTemplate && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Template categories
enum TemplateCategory {
  modern('Modern'),
  classic('Classic'),
  creative('Creative'),
  executive('Executive'),
  technical('Technical'),
  academic('Academic');

  const TemplateCategory(this.displayName);
  final String displayName;
}

/// Template layout configuration
class TemplateLayout {
  final String type; // 'single-column', 'two-column', 'sidebar'
  final Map<String, dynamic> sections;
  final Map<String, dynamic> styling;

  TemplateLayout({
    required this.type,
    required this.sections,
    required this.styling,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'sections': sections,
      'styling': styling,
    };
  }

  factory TemplateLayout.fromJson(Map<String, dynamic> json) {
    return TemplateLayout(
      type: json['type'] as String,
      sections: json['sections'] as Map<String, dynamic>,
      styling: json['styling'] as Map<String, dynamic>,
    );
  }
}
