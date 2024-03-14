import 'package:clean_architecture/model/cloud_firestore/default/data_adaptor.dart';
import 'package:clean_architecture/model/cloud_firestore/default/education.dart';
import 'package:clean_architecture/model/cloud_firestore/default/hobby.dart';
import 'package:clean_architecture/model/cloud_firestore/default/member.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devaloop_form_builder/input_field_date_time.dart';
import 'package:devaloop_form_builder/input_field_number.dart';
import 'package:devaloop_form_builder/input_field_option.dart';
import 'package:devaloop_form_builder/input_field_text.dart';
import 'package:flutter/material.dart';
import 'package:devaloop_form_builder/form_builder.dart';

class MemberDetail extends StatelessWidget {
  final MapEntry<DocumentReference<Member>, Member> mapDoc;

  const MemberDetail({
    super.key,
    required this.mapDoc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Member'),
        elevation: 0,
      ),
      body: FutureBuilder(future: Future<List<dynamic>>(() async {
        var mostFavoriteHobby = await mapDoc.value.getMostFavoriteHobby();
        var otherHobbies = await mapDoc.value.getOtherHobbies();
        var mostFavoriteHobbyMate =
            await mapDoc.value.getMostFavoriteHobbyMate();
        var otherHobbiesMate = await mapDoc.value.getOtherHobbiesMate();
        var educations = await mapDoc.value.getEducations(mapDoc.key);
        return [
          mostFavoriteHobby,
          otherHobbies,
          mostFavoriteHobbyMate,
          otherHobbiesMate,
          educations,
        ];
      }), builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(7.5),
              child: FormBulder(
                inputFields: [
                  const InputText(
                    name: 'name',
                    label: 'Name',
                  ),
                  const InputText(
                    name: 'email',
                    label: 'Email',
                    inputTextMode: InputTextMode.email,
                  ),
                  const InputDateTime(
                    name: 'birthDate',
                    label: 'Birth Date',
                    inputDateTimeMode: InputDateTimeMode.date,
                  ),
                  InputOption(
                    name: 'gender',
                    label: 'Gender',
                    optionData: Future(
                      () {
                        var displayedListOfOptions = MemberGender.values
                            .map((e) =>
                                OptionItem(hiddenValue: [e], value: [e.value]))
                            .toList();
                        return OptionData(
                            displayedListOfOptions: displayedListOfOptions,
                            totalOption: MemberGender.values.length);
                      },
                    ),
                    optionTotalData: Future(() => MemberGender.values.length),
                  ),
                  InputOption(
                    name: 'ethnic',
                    label: 'Ethnic',
                    optionData: Future(
                      () {
                        var displayedListOfOptions = MemberEthnic.values
                            .map((e) =>
                                OptionItem(hiddenValue: [e], value: [e.value]))
                            .toList();
                        return OptionData(
                            displayedListOfOptions: displayedListOfOptions,
                            totalOption: MemberEthnic.values.length);
                      },
                    ),
                    optionTotalData: Future(() => MemberEthnic.values.length),
                  ),
                  InputOption(
                    name: 'parentalEthnicGroups',
                    label: 'Parental Ethnic Groups',
                    isMultiSelection: true,
                    optionData: Future(
                      () {
                        var displayedListOfOptions = MemberEthnic.values
                            .map((e) =>
                                OptionItem(hiddenValue: [e], value: [e.value]))
                            .toList();
                        return OptionData(
                            displayedListOfOptions: displayedListOfOptions,
                            totalOption: MemberEthnic.values.length);
                      },
                    ),
                    optionTotalData: Future(() => MemberEthnic.values.length),
                  ),
                  InputOption(
                    name: 'ethnicMate',
                    label: 'Ethnic Mate',
                    isOptional: true,
                    optionData: Future(
                      () {
                        var displayedListOfOptions = MemberEthnic.values
                            .map((e) =>
                                OptionItem(hiddenValue: [e], value: [e.value]))
                            .toList();
                        return OptionData(
                            displayedListOfOptions: displayedListOfOptions,
                            totalOption: MemberEthnic.values.length);
                      },
                    ),
                    optionTotalData: Future(() => MemberEthnic.values.length),
                  ),
                  InputOption(
                    name: 'parentalEthnicGroupsMate',
                    label: 'Parental Ethnic Groups Mate',
                    isMultiSelection: true,
                    isOptional: true,
                    optionData: Future(
                      () {
                        var displayedListOfOptions = MemberEthnic.values
                            .map((e) =>
                                OptionItem(hiddenValue: [e], value: [e.value]))
                            .toList();
                        return OptionData(
                            displayedListOfOptions: displayedListOfOptions,
                            totalOption: MemberEthnic.values.length);
                      },
                    ),
                    optionTotalData: Future(() => MemberEthnic.values.length),
                  ),
                  InputOption(
                    name: 'mostFavoriteHobby',
                    label: 'Most Favorite Hobby',
                    optionData: Future(
                      () async {
                        var data = await DataAdaptor.hobby()
                            .orderBy('lastUpdated', descending: true)
                            .limit(10)
                            .get();
                        var totalOption =
                            await DataAdaptor.hobby().count().get();

                        var displayedListOfOptions = data.docs
                            .map(
                              (e) => OptionItem(
                                hiddenValue: [e.reference],
                                value: [
                                  e.data().name,
                                  e.data().description,
                                ],
                              ),
                            )
                            .toList();

                        return OptionData(
                            displayedListOfOptions: displayedListOfOptions,
                            totalOption: totalOption.count ?? 0);
                      },
                    ),
                    optionTotalData: Future(() async =>
                        (await DataAdaptor.hobby().count().get()).count ?? 0),
                  ),
                  InputOption(
                    name: 'otherHobbies',
                    label: 'other Hobbies',
                    isMultiSelection: true,
                    optionData: Future(
                      () async {
                        var data = await DataAdaptor.hobby()
                            .orderBy('lastUpdated', descending: true)
                            .limit(10)
                            .get();
                        var totalOption =
                            await DataAdaptor.hobby().count().get();

                        var displayedListOfOptions = data.docs
                            .map(
                              (e) => OptionItem(
                                hiddenValue: [e.reference],
                                value: [
                                  e.data().name,
                                  e.data().description,
                                ],
                              ),
                            )
                            .toList();

                        return OptionData(
                            displayedListOfOptions: displayedListOfOptions,
                            totalOption: totalOption.count ?? 0);
                      },
                    ),
                    optionTotalData: Future(() async =>
                        (await DataAdaptor.hobby().count().get()).count ?? 0),
                  ),
                  InputOption(
                    name: 'mostFavoriteHobbyMate',
                    label: 'Most Favorite Hobby Mate',
                    isOptional: true,
                    optionData: Future(
                      () async {
                        var data = await DataAdaptor.hobby()
                            .orderBy('lastUpdated', descending: true)
                            .limit(10)
                            .get();
                        var totalOption =
                            await DataAdaptor.hobby().count().get();

                        var displayedListOfOptions = data.docs
                            .map(
                              (e) => OptionItem(
                                hiddenValue: [e.reference],
                                value: [
                                  e.data().name,
                                  e.data().description,
                                ],
                              ),
                            )
                            .toList();

                        return OptionData(
                            displayedListOfOptions: displayedListOfOptions,
                            totalOption: totalOption.count ?? 0);
                      },
                    ),
                    optionTotalData: Future(() async =>
                        (await DataAdaptor.hobby().count().get()).count ?? 0),
                  ),
                  InputOption(
                    name: 'otherHobbiesMate',
                    label: 'other HobbiesMate',
                    isMultiSelection: true,
                    isOptional: true,
                    optionData: Future(
                      () async {
                        var data = await DataAdaptor.hobby()
                            .orderBy('lastUpdated', descending: true)
                            .limit(10)
                            .get();
                        var totalOption =
                            await DataAdaptor.hobby().count().get();

                        var displayedListOfOptions = data.docs
                            .map(
                              (e) => OptionItem(
                                hiddenValue: [e.reference],
                                value: [
                                  e.data().name,
                                  e.data().description,
                                ],
                              ),
                            )
                            .toList();

                        return OptionData(
                            displayedListOfOptions: displayedListOfOptions,
                            totalOption: totalOption.count ?? 0);
                      },
                    ),
                    optionTotalData: Future(() async =>
                        (await DataAdaptor.hobby().count().get()).count ?? 0),
                  ),
                  InputForm(
                    name: 'educations',
                    label: 'Educations',
                    inputFields: [
                      const InputText(
                        name: 'institutionName',
                        label: 'Institution Name',
                      ),
                      InputOption(
                        name: 'educationDegree',
                        label: 'Education Degree',
                        optionData: Future(
                          () {
                            var displayedListOfOptions = EducationDegree.values
                                .map((e) => OptionItem(
                                    hiddenValue: [e], value: [e.value]))
                                .toList();
                            return OptionData(
                                displayedListOfOptions: displayedListOfOptions,
                                totalOption: EducationDegree.values.length);
                          },
                        ),
                        optionTotalData:
                            Future(() => EducationDegree.values.length),
                      ),
                    ],
                  ),
                  InputForm(
                    name: 'educationsMate',
                    label: 'Educations Mate',
                    isOptional: true,
                    inputFields: [
                      const InputText(
                        name: 'institutionName',
                        label: 'Institution Name',
                      ),
                      InputOption(
                        name: 'educationDegree',
                        label: 'Education Degree',
                        optionData: Future(
                          () {
                            var displayedListOfOptions = EducationDegree.values
                                .map((e) => OptionItem(
                                    hiddenValue: [e], value: [e.value]))
                                .toList();
                            return OptionData(
                                displayedListOfOptions: displayedListOfOptions,
                                totalOption: EducationDegree.values.length);
                          },
                        ),
                        optionTotalData:
                            Future(() => EducationDegree.values.length),
                      ),
                    ],
                  ),
                  const InputNumber(
                    name: 'rate',
                    label: 'Rate',
                    inputNumberMode: InputNumberMode.integer,
                    isOptional: true,
                  ),
                  const InputText(
                    name: 'rateInfo',
                    label: 'Rate Info',
                    isMultilines: true,
                    isOptional: true,
                  ),
                ],
                onInitial: (context, inputValues) async {
                  inputValues['name']!.setString(mapDoc.value.name);
                  inputValues['rate']!.setNumber(mapDoc.value.rate);
                  inputValues['rateInfo']!.setString(mapDoc.value.rateInfo);
                  inputValues['birthDate']!.setDateTime(mapDoc.value.birthDate);
                  inputValues['email']!.setString(mapDoc.value.email);
                  inputValues['gender']!.setListOptionValues([
                    OptionItem(
                        hiddenValue: [mapDoc.value.gender],
                        value: [mapDoc.value.gender.value])
                  ]);
                  inputValues['ethnic']!.setListOptionValues([
                    OptionItem(
                        hiddenValue: [mapDoc.value.ethnic],
                        value: [mapDoc.value.ethnic.value])
                  ]);
                  inputValues['parentalEthnicGroups']!.setListOptionValues(
                      mapDoc.value.parentalEthnicGroups
                          .map((e) =>
                              OptionItem(hiddenValue: [e], value: [e.value]))
                          .toList());
                  inputValues['ethnicMate']!
                      .setListOptionValues(mapDoc.value.ethnicMate == null
                          ? []
                          : [
                              OptionItem(
                                  hiddenValue: [mapDoc.value.ethnicMate],
                                  value: [mapDoc.value.ethnicMate!.value])
                            ]);
                  inputValues['parentalEthnicGroupsMate']!.setListOptionValues(
                      mapDoc.value.parentalEthnicGroupsMate == null
                          ? []
                          : mapDoc.value.parentalEthnicGroupsMate!
                              .map((e) => OptionItem(
                                  hiddenValue: [e], value: [e.value]))
                              .toList());

                  var mostFavoriteHobby = snapshot.data![0]
                      as MapEntry<DocumentReference<Hobby>, Hobby>;
                  inputValues['mostFavoriteHobby']!.setListOptionValues([
                    OptionItem(hiddenValue: [
                      mostFavoriteHobby.key
                    ], value: [
                      mostFavoriteHobby.value.name,
                      mostFavoriteHobby.value.description,
                    ])
                  ]);

                  var otherHobbies = snapshot.data![1]
                      as List<MapEntry<DocumentReference<Hobby>, Hobby>>;
                  inputValues['otherHobbies']!.setListOptionValues(otherHobbies
                      .map((e) => OptionItem(hiddenValue: [
                            e.key
                          ], value: [
                            e.value.name,
                            e.value.description,
                          ]))
                      .toList());

                  //TODO Need nullable check
                  /*var mostFavoriteHobbyMate = snapshot.data![2]
                      as MapEntry<DocumentReference<Hobby>, Hobby>;
                  inputValues['mostFavoriteHobbyMate']!.setListOptionValues([
                    OptionItem(hiddenValue: [
                      mostFavoriteHobbyMate.key
                    ], value: [
                      mostFavoriteHobbyMate.value.name,
                      mostFavoriteHobbyMate.value.description,
                    ])
                  ]);

                  var otherHobbiesMate = snapshot.data![3]
                      as List<MapEntry<DocumentReference<Hobby>, Hobby>>;
                  inputValues['otherHobbiesMate']!
                      .setListOptionValues(otherHobbiesMate
                          .map((e) => OptionItem(hiddenValue: [
                                e.key
                              ], value: [
                                e.value.name,
                                e.value.description,
                              ]))
                          .toList());*/

                  var educations = snapshot.data![4]
                      as Map<DocumentReference<Education>, Education>;
                  inputValues['educations']!
                      .setFormValues(educations.entries.map((e) {
                    Map<String, dynamic> data = <String, dynamic>{
                      'institutionName': e.value.institutionName,
                      'educationDegree': [
                        OptionItem(
                          hiddenValue: [e.value.educationDegree],
                          value: [
                            e.value.educationDegree.value,
                          ],
                        )
                      ],
                    };
                    return data;
                  }).toList());

                  //TODO Add another field intial
                },
                onSubmit: (context, inputValues) async {
                  await mapDoc.key.set(Member(
                    name: inputValues['name']!.getString()!,
                    email: inputValues['email']!.getString()!,
                    birthDate: inputValues['birthDate']!.getDateTime()!,
                    gender: inputValues['gender']!
                        .getListOptionValues()
                        .first
                        .hiddenValue
                        .first,
                    ethnic: inputValues['ethnic']!
                        .getListOptionValues()
                        .first
                        .hiddenValue
                        .first,
                    parentalEthnicGroups: inputValues['parentalEthnicGroups']!
                        .getListOptionValues()
                        .map((e) => e.hiddenValue.first as MemberEthnic)
                        .toList(),
                    ethnicMate: inputValues['ethnicMate']
                        ?.getListOptionValues()
                        .firstOrNull
                        ?.hiddenValue
                        .firstOrNull,
                    parentalEthnicGroupsMate:
                        inputValues['parentalEthnicGroupsMate']
                            ?.getListOptionValues()
                            .map((e) => e.hiddenValue.first as MemberEthnic)
                            .toList(),
                    mostFavoriteHobby: inputValues['mostFavoriteHobby']!
                        .getListOptionValues()
                        .first
                        .hiddenValue
                        .first,
                    otherHobbies: inputValues['otherHobbies']!
                        .getListOptionValues()
                        .map((e) =>
                            e.hiddenValue.first as DocumentReference<Hobby>)
                        .toList(),
                    mostFavoriteHobbyMate: inputValues['mostFavoriteHobbyMate']
                        ?.getListOptionValues()
                        .firstOrNull
                        ?.hiddenValue
                        .firstOrNull,
                    otherHobbiesMate: inputValues['otherHobbiesMate']
                        ?.getListOptionValues()
                        .map((e) =>
                            e.hiddenValue.first as DocumentReference<Hobby>)
                        .toList(),
                    rate: inputValues['rate']?.getNumber(),
                    rateInfo: inputValues['rateInfo']?.getString(),
                  ));

                  inputValues['educations']
                      ?.getFormValues()
                      .forEach((element) async {
                    await DataAdaptor.education(mapDoc.key).add(Education(
                      institutionName: element['institutionName'],
                      educationDegree:
                          (element['educationDegree'] as List<OptionItem>)
                              .first
                              .hiddenValue
                              .first,
                    ));
                  });

                  if (!context.mounted) return;

                  Navigator.of(context).pop(true);
                },
                submitButtonSettings: const SubmitButtonSettings(
                  label: 'Update',
                  icon: Icon(Icons.save),
                ),
                additionalButtons: [
                  AdditionalButton(
                    label: 'Cancel',
                    icon: const Icon(Icons.cancel),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  AdditionalButton(
                    label: 'Remove',
                    icon: const Icon(Icons.remove),
                    onTap: () async {
                      var result = await showDialog<String>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Warning'),
                            content: const SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text('Are you sure you want to remove?'),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('No'),
                                onPressed: () {
                                  Navigator.of(context).pop('No');
                                },
                              ),
                              TextButton(
                                child: const Text('Yes'),
                                onPressed: () {
                                  Navigator.of(context).pop('Yes');
                                },
                              ),
                            ],
                          );
                        },
                      );

                      if (!context.mounted) return;

                      if (result != null) {
                        if (result == 'Yes') {
                          await mapDoc.key.delete();

                          if (!context.mounted) return;

                          Navigator.of(context).pop(true);
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }
}
