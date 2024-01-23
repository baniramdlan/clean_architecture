import 'package:cloud_firestore/cloud_firestore.dart';
import 'hobby.dart';
import 'data_adaptor.dart';

class Member {
  final String name;
  final String email;
  final DateTime birthDate;
  final MemberGender gender;
  final DocumentReference<Hobby> hobby;
  final List<MemberGender> genders;
  final List<DocumentReference<Hobby>> hobbies;
  final int? rate;
  final String? rateInfo;

  Member({
    required this.name,
    required this.email,
    required this.birthDate,
    required this.gender,
    required this.hobby,
    required this.genders,
    required this.hobbies,
    this.rate,
    this.rateInfo,
  });

  factory Member.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Member(
      name: data?['name'],
      email: data?['email'],
      birthDate: (data?['birthDate'] as Timestamp).toDate(),
      gender: MemberGender.values
          .firstWhere((e) => e.toString() == data?['gender']),
      hobby: DataAdaptor.instance
          .doc((data?['hobby'])
              .toString()
              .replaceAll('DocumentReference<Map<String, dynamic>>(', '')
              .replaceAll(')', ''))
          .withConverter(
            fromFirestore: Hobby.fromFirestore,
            toFirestore: (Hobby m, options) => m.toFirestore(),
          ),
      genders: data?['genders'] is Iterable
          ? List.from(data?['genders'])
              .map((a) =>
                  MemberGender.values.firstWhere((e) => e.toString() == a))
              .toList()
          : [],
      hobbies: data?['hobbies'] is Iterable
          ? List.from(data?['hobbies']).map((e) {
              var id = e
                  .toString()
                  .replaceAll('DocumentReference<Map<String, dynamic>>(', '')
                  .replaceAll(')', '');
              return DataAdaptor.instance.doc(id).withConverter(
                    fromFirestore: Hobby.fromFirestore,
                    toFirestore: (Hobby m, options) => m.toFirestore(),
                  );
            }).toList()
          : [],
      rate: data?['rate'],
      rateInfo: data?['rateInfo'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'birthDate': birthDate,
      'gender': gender.toString(),
      'hobby': hobby,
      'genders': genders.map((e) => e.toString()).toList(),
      'hobbies': hobbies,
      if (rate != null) 'rate': rate,
      if (rateInfo != null) 'rateInfo': rateInfo,
    };
  }
}

enum MemberGender {
  male('Male'),
  female('Female');

  const MemberGender(this.value);
  final String value;
}
