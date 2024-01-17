import 'package:cloud_firestore/cloud_firestore.dart';

import 'hobby.dart';
import 'member.dart';
import 'education.dart';


class DataAdaptor {
  static final instance = FirebaseFirestore.instance;

  static CollectionReference<Hobby> hobby() {
    return instance.collection('Hobby').withConverter(
          fromFirestore: Hobby.fromFirestore,
          toFirestore: (Hobby m, options) => m.toFirestore(),
        );
  }

  static CollectionReference<Member> member() {
    return instance.collection('Member').withConverter(
          fromFirestore: Member.fromFirestore,
          toFirestore: (Member m, options) => m.toFirestore(),
        );
  }

  static CollectionReference<Education> education(
      QueryDocumentSnapshot<Member> doc) {
    return member().doc(doc.id).collection('Education').withConverter(
          fromFirestore: Education.fromFirestore,
          toFirestore: (Education m, options) => m.toFirestore(),
        );
  }
}
