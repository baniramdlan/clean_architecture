import 'package:cloud_firestore/cloud_firestore.dart';
import 'hobby.dart';
import 'data_adaptor.dart';

class Member {
  final String name;
  final String email;
  final DateTime birthDate;
  final MemberGender gender;
  final MemberEthnic ethnic;
  final List<MemberEthnic> parentalEthnicGroups;
  final MemberEthnic? ethnicMate;
  final List<MemberEthnic>? parentalEthnicGroupsMate;
  final DocumentReference<Hobby> mostFavoriteHobby;
  final List<DocumentReference<Hobby>> otherHobbies;
  final DocumentReference<Hobby>? mostFavoriteHobbyMate;
  final List<DocumentReference<Hobby>>? otherHobbiesMate;
  final int? rate;
  final String? rateInfo;

  Member({
    required this.name,
    required this.email,
    required this.birthDate,
    required this.gender,
    required this.ethnic,
    required this.parentalEthnicGroups,
    this.ethnicMate,
    this.parentalEthnicGroupsMate,
    required this.mostFavoriteHobby,
    required this.otherHobbies,
    this.mostFavoriteHobbyMate,
    this.otherHobbiesMate,
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
      ethnic: MemberEthnic.values
          .firstWhere((e) => e.toString() == data?['ethnic']),
      parentalEthnicGroups: data?['parentalEthnicGroups'] is Iterable
          ? List.from(data?['parentalEthnicGroups'])
              .map((a) =>
                  MemberEthnic.values.firstWhere((e) => e.toString() == a))
              .toList()
          : [],
      ethnicMate: data?['ethnic'] == null
          ? null
          : MemberEthnic.values
              .firstWhere((e) => e.toString() == data?['ethnic']),
      parentalEthnicGroupsMate: data?['parentalEthnicGroups'] == null
          ? null
          : data?['parentalEthnicGroups'] is Iterable
              ? List.from(data?['parentalEthnicGroups'])
                  .map((a) =>
                      MemberEthnic.values.firstWhere((e) => e.toString() == a))
                  .toList()
              : [],
      mostFavoriteHobby: DataAdaptor.instance
          .doc((data?['mostFavoriteHobby'])
              .toString()
              .replaceAll('DocumentReference<Map<String, dynamic>>(', '')
              .replaceAll(')', ''))
          .withConverter(
            fromFirestore: Hobby.fromFirestore,
            toFirestore: (Hobby m, options) => m.toFirestore(),
          ),
      otherHobbies: data?['otherHobbies'] is Iterable
          ? List.from(data?['otherHobbies']).map((e) {
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
      mostFavoriteHobbyMate: data?['mostFavoriteHobbyMate'] == null
          ? null
          : DataAdaptor.instance
              .doc((data?['mostFavoriteHobbyMate'])
                  .toString()
                  .replaceAll('DocumentReference<Map<String, dynamic>>(', '')
                  .replaceAll(')', ''))
              .withConverter(
                fromFirestore: Hobby.fromFirestore,
                toFirestore: (Hobby m, options) => m.toFirestore(),
              ),
      otherHobbiesMate: data?['otherHobbiesMate'] == null
          ? null
          : data?['otherHobbiesMate'] is Iterable
              ? List.from(data?['otherHobbiesMate']).map((e) {
                  var id = e
                      .toString()
                      .replaceAll(
                          'DocumentReference<Map<String, dynamic>>(', '')
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
      'ethnic': ethnic.toString(),
      'parentalEthnicGroups':
          parentalEthnicGroups.map((e) => e.toString()).toList(),
      if (ethnicMate != null) 'ethnicMate': ethnicMate.toString(),
      if (parentalEthnicGroupsMate != null)
        'parentalEthnicGroupsMate':
            parentalEthnicGroupsMate!.map((e) => e.toString()).toList(),
      'mostFavoriteHobby': mostFavoriteHobby,
      'otherHobbies': otherHobbies,
      if (mostFavoriteHobbyMate != null)
        'mostFavoriteHobbyMate': mostFavoriteHobbyMate,
      if (otherHobbiesMate != null) 'otherHobbiesMate': otherHobbiesMate,
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

enum MemberEthnic {
  black('Black'),
  hispanic('Hispanic'),
  white('White'),
  asian('Asian'),
  mixed('Mixed');

  const MemberEthnic(this.value);
  final String value;
}
