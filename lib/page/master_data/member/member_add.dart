import 'package:clean_architecture/model/cloud_firestore/default/data_adaptor.dart';
import 'package:clean_architecture/model/cloud_firestore/default/hobby.dart';
import 'package:clean_architecture/model/cloud_firestore/default/member.dart';
import 'package:devaloop_form_builder/input_field_date_time.dart';
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
              //TODO Add Another Column
            ],
            onSubmit: (context, inputValues) async {
              await DataAdaptor.hobby().add(Hobby(
                name: inputValues['name']!.getString()!,
                description: inputValues['description']!.getString()!,
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
