import 'package:cloud_firestore/cloud_firestore.dart';

class Hobby {
  final String name;
  final String description;

  Hobby({
    required this.name,
    required this.description,
  });

  factory Hobby.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Hobby(
      name: data?['name'],
      description: data?['description'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name' : name,
      'description' : description,
    };
  }
}


