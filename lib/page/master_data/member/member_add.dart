import 'package:clean_architecture/model/cloud_firestore/default/data_adaptor.dart';
import 'package:clean_architecture/model/cloud_firestore/default/hobby.dart';
import 'package:clean_architecture/model/cloud_firestore/default/member.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devaloop_form_builder/input_field_date_time.dart';
import 'package:devaloop_form_builder/input_field_number.dart';
import 'package:devaloop_form_builder/input_field_option.dart';
import 'package:devaloop_form_builder/input_field_text.dart';
import 'package:flutter/material.dart';
import 'package:devaloop_form_builder/form_builder.dart';

class MemberAdd extends StatelessWidget {
  const MemberAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Mamber'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
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
                    var totalOption = await DataAdaptor.hobby().count().get();

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
                    var totalOption = await DataAdaptor.hobby().count().get();

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
                    var totalOption = await DataAdaptor.hobby().count().get();

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
                    var totalOption = await DataAdaptor.hobby().count().get();

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
            onSubmit: (context, inputValues) async {
              await DataAdaptor.member().add(Member(
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
                    .map((e) => e.hiddenValue.first as DocumentReference<Hobby>)
                    .toList(),
                mostFavoriteHobbyMate: inputValues['mostFavoriteHobbyMate']
                    ?.getListOptionValues()
                    .firstOrNull
                    ?.hiddenValue
                    .firstOrNull,
                otherHobbiesMate: inputValues['otherHobbiesMate']
                    ?.getListOptionValues()
                    .map((e) => e.hiddenValue.first as DocumentReference<Hobby>)
                    .toList(),
                rate: inputValues['rate']?.getNumber(),
                rateInfo: inputValues['rateInfo']?.getString(),
              ));

              if (!context.mounted) return;

              Navigator.of(context).pop(true);
            },
            submitButtonSettings: const SubmitButtonSettings(
              label: 'Add',
              icon: Icon(Icons.add),
            ),
            additionalButtons: [
              AdditionalButton(
                label: 'Cancel',
                icon: const Icon(Icons.cancel),
                onTap: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
