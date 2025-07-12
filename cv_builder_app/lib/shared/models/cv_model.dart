import 'package:json_annotation/json_annotation.dart';

part 'cv_model.g.dart';

/// CV Data Model
/// Represents a complete CV with all sections and metadata
@JsonSerializable()
class CVModel {
  final String id;
  final String userId;
  final String title;
  final String? templateId;
  final PersonalInfo personalInfo;
  final String? professionalSummary;
  final List<WorkExperience> workExperience;
  final List<Education> education;
  final List<Skill> skills;
  final List<Project>? projects;
  final List<Certification>? certifications;
  final List<Language>? languages;
  final List<VolunteerExperience>? volunteerExperience;
  final List<Publication>? publications;
  final List<Award>? awards;
  final List<String>? references;
  final CVMetadata metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CVModel({
    required this.id,
    required this.userId,
    required this.title,
    this.templateId,
    required this.personalInfo,
    this.professionalSummary,
    required this.workExperience,
    required this.education,
    required this.skills,
    this.projects,
    this.certifications,
    this.languages,
    this.volunteerExperience,
    this.publications,
    this.awards,
    this.references,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CVModel.fromJson(Map<String, dynamic> json) => _$CVModelFromJson(json);
  Map<String, dynamic> toJson() => _$CVModelToJson(this);

  CVModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? templateId,
    PersonalInfo? personalInfo,
    String? professionalSummary,
    List<WorkExperience>? workExperience,
    List<Education>? education,
    List<Skill>? skills,
    List<Project>? projects,
    List<Certification>? certifications,
    List<Language>? languages,
    List<VolunteerExperience>? volunteerExperience,
    List<Publication>? publications,
    List<Award>? awards,
    List<String>? references,
    CVMetadata? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CVModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      templateId: templateId ?? this.templateId,
      personalInfo: personalInfo ?? this.personalInfo,
      professionalSummary: professionalSummary ?? this.professionalSummary,
      workExperience: workExperience ?? this.workExperience,
      education: education ?? this.education,
      skills: skills ?? this.skills,
      projects: projects ?? this.projects,
      certifications: certifications ?? this.certifications,
      languages: languages ?? this.languages,
      volunteerExperience: volunteerExperience ?? this.volunteerExperience,
      publications: publications ?? this.publications,
      awards: awards ?? this.awards,
      references: references ?? this.references,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Personal Information Section
@JsonSerializable()
class PersonalInfo {
  final String firstName;
  final String lastName;
  final String? email;
  final String? phone;
  final String? address;
  final String? city;
  final String? country;
  final String? postalCode;
  final String? linkedIn;
  final String? website;
  final String? profileImageUrl;

  const PersonalInfo({
    required this.firstName,
    required this.lastName,
    this.email,
    this.phone,
    this.address,
    this.city,
    this.country,
    this.postalCode,
    this.linkedIn,
    this.website,
    this.profileImageUrl,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) => _$PersonalInfoFromJson(json);
  Map<String, dynamic> toJson() => _$PersonalInfoToJson(this);

  String get fullName => '$firstName $lastName';
}

/// Work Experience Entry
@JsonSerializable()
class WorkExperience {
  final String id;
  final String jobTitle;
  final String company;
  final String? location;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCurrentJob;
  final String? description;
  final List<String>? achievements;
  final List<String>? technologies;

  const WorkExperience({
    required this.id,
    required this.jobTitle,
    required this.company,
    this.location,
    required this.startDate,
    this.endDate,
    required this.isCurrentJob,
    this.description,
    this.achievements,
    this.technologies,
  });

  factory WorkExperience.fromJson(Map<String, dynamic> json) => _$WorkExperienceFromJson(json);
  Map<String, dynamic> toJson() => _$WorkExperienceToJson(this);
}

/// Education Entry
@JsonSerializable()
class Education {
  final String id;
  final String degree;
  final String institution;
  final String? location;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCurrentStudy;
  final String? gpa;
  final String? description;
  final List<String>? coursework;

  const Education({
    required this.id,
    required this.degree,
    required this.institution,
    this.location,
    required this.startDate,
    this.endDate,
    required this.isCurrentStudy,
    this.gpa,
    this.description,
    this.coursework,
  });

  factory Education.fromJson(Map<String, dynamic> json) => _$EducationFromJson(json);
  Map<String, dynamic> toJson() => _$EducationToJson(this);
}

/// Skill Entry
@JsonSerializable()
class Skill {
  final String id;
  final String name;
  final SkillLevel level;
  final SkillCategory category;

  const Skill({
    required this.id,
    required this.name,
    required this.level,
    required this.category,
  });

  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);
  Map<String, dynamic> toJson() => _$SkillToJson(this);
}

/// Project Entry
@JsonSerializable()
class Project {
  final String id;
  final String name;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? url;
  final List<String>? technologies;

  const Project({
    required this.id,
    required this.name,
    this.description,
    this.startDate,
    this.endDate,
    this.url,
    this.technologies,
  });

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}

/// Certification Entry
@JsonSerializable()
class Certification {
  final String id;
  final String name;
  final String issuer;
  final DateTime? issueDate;
  final DateTime? expiryDate;
  final String? credentialId;
  final String? url;

  const Certification({
    required this.id,
    required this.name,
    required this.issuer,
    this.issueDate,
    this.expiryDate,
    this.credentialId,
    this.url,
  });

  factory Certification.fromJson(Map<String, dynamic> json) => _$CertificationFromJson(json);
  Map<String, dynamic> toJson() => _$CertificationToJson(this);
}

/// Language Entry
@JsonSerializable()
class Language {
  final String id;
  final String name;
  final LanguageProficiency proficiency;

  const Language({
    required this.id,
    required this.name,
    required this.proficiency,
  });

  factory Language.fromJson(Map<String, dynamic> json) => _$LanguageFromJson(json);
  Map<String, dynamic> toJson() => _$LanguageToJson(this);
}

/// Volunteer Experience Entry
@JsonSerializable()
class VolunteerExperience {
  final String id;
  final String role;
  final String organization;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCurrentRole;
  final String? description;

  const VolunteerExperience({
    required this.id,
    required this.role,
    required this.organization,
    required this.startDate,
    this.endDate,
    required this.isCurrentRole,
    this.description,
  });

  factory VolunteerExperience.fromJson(Map<String, dynamic> json) => _$VolunteerExperienceFromJson(json);
  Map<String, dynamic> toJson() => _$VolunteerExperienceToJson(this);
}

/// Publication Entry
@JsonSerializable()
class Publication {
  final String id;
  final String title;
  final String? publisher;
  final DateTime? publishDate;
  final String? url;
  final String? description;

  const Publication({
    required this.id,
    required this.title,
    this.publisher,
    this.publishDate,
    this.url,
    this.description,
  });

  factory Publication.fromJson(Map<String, dynamic> json) => _$PublicationFromJson(json);
  Map<String, dynamic> toJson() => _$PublicationToJson(this);
}

/// Award Entry
@JsonSerializable()
class Award {
  final String id;
  final String title;
  final String? issuer;
  final DateTime? date;
  final String? description;

  const Award({
    required this.id,
    required this.title,
    this.issuer,
    this.date,
    this.description,
  });

  factory Award.fromJson(Map<String, dynamic> json) => _$AwardFromJson(json);
  Map<String, dynamic> toJson() => _$AwardToJson(this);
}

/// CV Metadata
@JsonSerializable()
class CVMetadata {
  final CVStatus status;
  final int atsScore;
  final String? targetRole;
  final String? targetIndustry;
  final List<String>? keywords;
  final bool isPublic;
  final int viewCount;
  final int downloadCount;

  const CVMetadata({
    required this.status,
    required this.atsScore,
    this.targetRole,
    this.targetIndustry,
    this.keywords,
    required this.isPublic,
    required this.viewCount,
    required this.downloadCount,
  });

  factory CVMetadata.fromJson(Map<String, dynamic> json) => _$CVMetadataFromJson(json);
  Map<String, dynamic> toJson() => _$CVMetadataToJson(this);
}

/// Enums
enum CVStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('complete')
  complete,
  @JsonValue('exported')
  exported,
}

enum SkillLevel {
  @JsonValue('beginner')
  beginner,
  @JsonValue('intermediate')
  intermediate,
  @JsonValue('advanced')
  advanced,
  @JsonValue('expert')
  expert,
}

enum SkillCategory {
  @JsonValue('technical')
  technical,
  @JsonValue('soft')
  soft,
  @JsonValue('language')
  language,
  @JsonValue('other')
  other,
}

enum LanguageProficiency {
  @JsonValue('basic')
  basic,
  @JsonValue('conversational')
  conversational,
  @JsonValue('fluent')
  fluent,
  @JsonValue('native')
  native,
}
