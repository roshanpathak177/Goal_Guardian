import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  final String id;
  final String name;
  final String photoUrl;
  final String description;
  final List<String> memberIds;
  int get memberCount => memberIds.length;

  Group({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.description,
    required this.memberIds,
  });

  factory Group.fromMap(Map<String, dynamic> data, String documentId) {
    return Group(
      id: documentId,
      name: data['name'],
      photoUrl: data['photoUrl'],
      description: data['description'],
      memberIds: List<String>.from(data['memberIds']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'photoUrl': photoUrl,
      'description': description,
      'memberIds': memberIds,
    };
  }
}