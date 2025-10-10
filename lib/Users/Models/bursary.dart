import 'dart:convert';

class Bursary {
  final String id; 
  final String name;
  final String provider;
  final String category;          
  final String type;              
  final String targetGroup;       
  final String level;             
  final String region;            
  final String fundingType;       
  final String amountRange;       
  final List<String> eligibility; 
  final String applicationMode;   
  final String applicationPeriod; 
  final String? applicationLink;  
  final bool isOpen;              
  final String? deadline;         
  final String contactEmail;      
  final String website;           

  Bursary({
    required this.id,
    required this.name,
    required this.provider,
    required this.category,
    required this.type,
    required this.targetGroup,
    required this.level,
    required this.region,
    required this.fundingType,
    required this.amountRange,
    required this.eligibility,
    required this.applicationMode,
    required this.applicationPeriod,
    this.applicationLink,
    required this.isOpen,
    this.deadline,
    required this.contactEmail,
    required this.website,
  });

  /// Convert JSON → Bursary object
  factory Bursary.fromJson(Map<String, dynamic> json,String id) {
    return Bursary(
      id: id,
      name: json['name'] ?? '',
      provider: json['provider'] ?? '',
      category: json['category'] ?? '',
      type: json['type'] ?? '',
      targetGroup: json['targetGroup'] ?? json['target_group'] ?? '',
      level: json['level'] ?? '',
      region: json['region'] ?? '',
      fundingType: json['fundingType'] ?? json['funding_type'] ?? '',
      amountRange: json['amountRange'] ?? json['amount_range'] ?? '',
      eligibility: (json['eligibility'] is String)
          ? (json['eligibility'] as String)
          .split(',')
          .map((e) => e.trim())
          .toList()
          : List<String>.from(json['eligibility'] ?? []),
      applicationMode: json['applicationMode'] ?? json['application_mode'] ?? '',
      applicationPeriod:
          json['applicationPeriod'] ?? json['application_period'] ?? '',
      applicationLink:
          json['applicationLink'] ?? json['application_link'] ?? '',
      isOpen: json['isOpen'] ?? json['is_open'] ?? false,
      deadline: json['deadline'],
      contactEmail: json['contactEmail'] ?? json['contact_email'] ?? '',
      website: json['website'] ?? '',
    );
  }

  ///  Convert Bursary object → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'provider': provider,
      'category': category,
      'type': type,
      'targetGroup': targetGroup,
      'level': level,
      'region': region,
      'fundingType': fundingType,
      'amountRange': amountRange,
      'eligibility': eligibility,
      'applicationMode': applicationMode,
      'applicationPeriod': applicationPeriod,
      'applicationLink': applicationLink,
      'isOpen': isOpen,
      'deadline': deadline,
      'contactEmail': contactEmail,
      'website': website,
    };
  }

  /// Decode a list of bursaries from JSON string
  static List<Bursary> fromJsonList(String jsonString) {
    final data = json.decode(jsonString) as List;
    return data.asMap().entries.map((entry){
     final e = entry.value;
     final id = e['id'] ?? entry.key.toString();
     return Bursary.fromJson(Map<String, dynamic>.from(e), id);
    }).toList();
  }

  ///  Encode list → JSON string
  static String toJsonList(List<Bursary> bursaries) {
    return json.encode(bursaries.map((b) => b.toJson()).toList());
  }
}
