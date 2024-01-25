import 'package:cloud_firestore/cloud_firestore.dart';

class Education {
  final String educationName;
  final DateTime? lastUpdated;

  Education({
    required this.educationName,
    this.lastUpdated,
  });

  factory Education.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Education(
      educationName: data?['educationName'],
      lastUpdated: (data?['lastUpdated'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'educationName': educationName,
      'lastUpdated': DateTime.now(),
    };
  }
}
