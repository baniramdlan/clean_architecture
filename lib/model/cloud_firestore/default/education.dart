import 'package:cloud_firestore/cloud_firestore.dart';

class Education {
  final String educationName;

  Education({
    required this.educationName,
  });

  factory Education.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Education(
      educationName: data?['educationName'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'educationName' : educationName,
    };
  }
}


