import 'dart:convert';

/// CV Model for storing CV data
class CVModel {
  final String id;
  final String title;
  final String status; // 'draft', 'ready', 'exported'
  final DateTime lastEdited;
  final DateTime created;
  final Map<String, dynamic> data;
  final String? templateId;
  final String? thumbnailPath;

  CVModel({
    required this.id,
    required this.title,
    required this.status,
    required this.lastEdited,
    required this.created,
    required this.data,
    this.templateId,
    this.thumbnailPath,
  });

  /// Create a copy of this CV with updated fields
  CVModel copyWith({
    String? id,
    String? title,
    String? status,
    DateTime? lastEdited,
    DateTime? created,
    Map<String, dynamic>? data,
    String? templateId,
    String? thumbnailPath,
  }) {
    return CVModel(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
      lastEdited: lastEdited ?? this.lastEdited,
      created: created ?? this.created,
      data: data ?? this.data,
      templateId: templateId ?? this.templateId,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
    );
  }

  /// Convert CV to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'status': status,
      'lastEdited': lastEdited.toIso8601String(),
      'created': created.toIso8601String(),
      'data': data,
      'templateId': templateId,
      'thumbnailPath': thumbnailPath,
    };
  }

  /// Create CV from JSON
  factory CVModel.fromJson(Map<String, dynamic> json) {
    return CVModel(
      id: json['id'] as String,
      title: json['title'] as String,
      status: json['status'] as String,
      lastEdited: DateTime.parse(json['lastEdited'] as String),
      created: DateTime.parse(json['created'] as String),
      data: json['data'] as Map<String, dynamic>,
      templateId: json['templateId'] as String?,
      thumbnailPath: json['thumbnailPath'] as String?,
    );
  }

  /// Convert CV to JSON string
  String toJsonString() => jsonEncode(toJson());

  /// Create CV from JSON string
  factory CVModel.fromJsonString(String jsonString) {
    return CVModel.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }

  @override
  String toString() {
    return 'CVModel(id: $id, title: $title, status: $status, lastEdited: $lastEdited)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CVModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Personal Information model
class PersonalInfo {
  final String name;
  final String email;
  final String phone;
  final String location;
  final String? linkedin;
  final String? website;
  final String? summary;

  PersonalInfo({
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    this.linkedin,
    this.website,
    this.summary,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'location': location,
      'linkedin': linkedin,
      'website': website,
      'summary': summary,
    };
  }

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      location: json['location'] as String,
      linkedin: json['linkedin'] as String?,
      website: json['website'] as String?,
      summary: json['summary'] as String?,
    );
  }
}

/// Work Experience model
class WorkExperience {
  final String title;
  final String company;
  final String duration;
  final String description;
  final List<String> achievements;

  WorkExperience({
    required this.title,
    required this.company,
    required this.duration,
    required this.description,
    required this.achievements,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'company': company,
      'duration': duration,
      'description': description,
      'achievements': achievements,
    };
  }

  factory WorkExperience.fromJson(Map<String, dynamic> json) {
    return WorkExperience(
      title: json['title'] as String,
      company: json['company'] as String,
      duration: json['duration'] as String,
      description: json['description'] as String,
      achievements: List<String>.from(json['achievements'] as List),
    );
  }
}

/// Education model
class Education {
  final String degree;
  final String institution;
  final String year;
  final String? gpa;

  Education({
    required this.degree,
    required this.institution,
    required this.year,
    this.gpa,
  });

  Map<String, dynamic> toJson() {
    return {
      'degree': degree,
      'institution': institution,
      'year': year,
      'gpa': gpa,
    };
  }

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      degree: json['degree'] as String,
      institution: json['institution'] as String,
      year: json['year'] as String,
      gpa: json['gpa'] as String?,
    );
  }
}

/// Skills model
class Skills {
  final List<String> technical;
  final List<String> soft;
  final List<String> languages;

  Skills({
    required this.technical,
    required this.soft,
    required this.languages,
  });

  Map<String, dynamic> toJson() {
    return {
      'technical': technical,
      'soft': soft,
      'languages': languages,
    };
  }

  factory Skills.fromJson(Map<String, dynamic> json) {
    return Skills(
      technical: List<String>.from(json['technical'] as List),
      soft: List<String>.from(json['soft'] as List),
      languages: List<String>.from(json['languages'] as List),
    );
  }
}

/// Project model
class Project {
  final String name;
  final String description;
  final List<String> technologies;
  final String? link;

  Project({
    required this.name,
    required this.description,
    required this.technologies,
    this.link,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'technologies': technologies,
      'link': link,
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      name: json['name'] as String,
      description: json['description'] as String,
      technologies: List<String>.from(json['technologies'] as List),
      link: json['link'] as String?,
    );
  }
}

/// Certification model
class Certification {
  final String name;
  final String issuer;
  final String date;

  Certification({
    required this.name,
    required this.issuer,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'issuer': issuer,
      'date': date,
    };
  }

  factory Certification.fromJson(Map<String, dynamic> json) {
    return Certification(
      name: json['name'] as String,
      issuer: json['issuer'] as String,
      date: json['date'] as String,
    );
  }
}
