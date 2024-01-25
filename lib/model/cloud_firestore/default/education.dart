import 'package:cloud_firestore/cloud_firestore.dart';

class Education {
  final String institutionName;
  final EducationDegree educationDegree;
  final DateTime? lastUpdated;

  Education({
    required this.institutionName,
    required this.educationDegree,
    this.lastUpdated,
  });

  factory Education.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Education(
      institutionName: data?['institutionName'],
      educationDegree: EducationDegree.values
          .firstWhere((e) => e.toString() == data?['educationDegree']),
      lastUpdated: (data?['lastUpdated'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'institutionName': institutionName,
      'educationDegree': educationDegree.toString(),
      'lastUpdated': DateTime.now(),
    };
  }
}

enum EducationDegree {
  sd('SD'),
  smp('SMP'),
  sma('SMA'),
  s1('S1'),
  s2('S2'),
  s3('S3');

  const EducationDegree(this.value);
  final String value;
}
