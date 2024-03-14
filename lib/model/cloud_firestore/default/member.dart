import 'package:clean_architecture/model/cloud_firestore/default/education.dart';
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
  final double? rate;
  final String? rateInfo;
  final DateTime? lastUpdated;

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
    this.lastUpdated,
  });

  Future<MapEntry<DocumentReference<Hobby>, Hobby>>
      getMostFavoriteHobby() async {
    var result = await mostFavoriteHobby.get();
    return MapEntry(mostFavoriteHobby, result.data()!);
  }

  Future<List<MapEntry<DocumentReference<Hobby>, Hobby>>>
      getOtherHobbies() async {
    List<MapEntry<DocumentReference<Hobby>, Hobby>> data = [];
    for (var element in otherHobbies) {
      var result = await element.get();
      data.add(MapEntry(element, result.data()!));
    }
    return data;
  }

  Future<MapEntry<DocumentReference<Hobby>, Hobby>?>?
      getMostFavoriteHobbyMate() async {
    if (mostFavoriteHobbyMate == null) return null;
    var result = await mostFavoriteHobbyMate!.get();
    return MapEntry(mostFavoriteHobby, result.data()!);
  }

  Future<List<MapEntry<DocumentReference<Hobby>, Hobby>>>?
      getOtherHobbiesMate() async {
    List<MapEntry<DocumentReference<Hobby>, Hobby>> data = [];
    if (otherHobbiesMate == null) return [];
    for (var element in otherHobbiesMate!) {
      var result = await element.get();
      data.add(MapEntry(element, result.data()!));
    }
    return data;
  }

  Future<Map<DocumentReference<Education>, Education>> getEducations(
      DocumentReference<Member> doc) async {
    var educationsData = await DataAdaptor.education(doc).get();
    var educations = {
      for (var v in educationsData.docs) (v).reference: (v).data()
    };
    return educations;
  }

  Future<Map<DocumentReference<Education>, Education>> setEducations(
      DocumentReference<Member> doc, List<Education> educations) async {
    await DataAdaptor.education(doc).get().then((value) async {
      for (var element in value.docs) {
        await element.reference.delete();
      }
    });

    Map<DocumentReference<Education>, Education> mapDocs = {};
    for (var element in educations) {
      var model = await DataAdaptor.education(doc).add(element);
      mapDocs[model] = element;
    }

    return mapDocs;
  }

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
      ethnicMate: data?['ethnicMate'] == null
          ? null
          : MemberEthnic.values
              .firstWhere((e) => e.toString() == data?['ethnicMate']),
      parentalEthnicGroupsMate: data?['parentalEthnicGroupsMate'] == null
          ? null
          : data?['parentalEthnicGroupsMate'] is Iterable
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
      lastUpdated: (data?['lastUpdated'] as Timestamp).toDate(),
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
      'lastUpdated': DateTime.now(),
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
