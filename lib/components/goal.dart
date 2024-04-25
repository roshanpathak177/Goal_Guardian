import 'package:flutter/material.dart';

class Goal {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String type; // e.g., 'daily', 'weekly', 'monthly'
  final String accountabilityType; // 'partner' or 'group'
  final String? partnerId; // User ID of the accountability partner (if applicable)
  final String? groupId; // Group ID of the accountability group (if applicable)
  final List<DailyInput> dailyInputs;

  Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.accountabilityType,
    this.partnerId,
    this.groupId,
    required this.dailyInputs,
  });

  // Add necessary constructors, toMap, and fromMap methods
  Map<String, dynamic> toMap() {
  return {
    'id': id,
    'title': title,
    'description': description,
    'startDate': startDate.millisecondsSinceEpoch,
    'endDate': endDate.millisecondsSinceEpoch,
    'type': type,
    'accountabilityType': accountabilityType,
    'partnerId': partnerId,
    'groupId': groupId,
    'dailyInputs': dailyInputs.map((input) => input.toMap()).toList(),
  };
}
}

class DailyInput {
  final DateTime date;
  final String input;

  DailyInput({
    required this.date,
    required this.input,
  });

  // Add necessary constructors and toMap, fromMap methods
  Map<String, dynamic> toMap() {
  return {
    // Add the properties of DailyInput class here
  };
}
}

