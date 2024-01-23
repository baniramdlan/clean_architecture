import 'package:clean_architecture/model/cloud_firestore/default/data_adaptor.dart';
import 'package:clean_architecture/model/cloud_firestore/default/hobby.dart';
import 'package:flutter/material.dart';
import 'package:devaloop_form_builder/form_builder.dart';

class HobbyAdd extends StatelessWidget {
  const HobbyAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Hobby'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(7.5),
        child: FormBulder(
          inputFields: const [
            InputText(
              name: 'name',
              label: 'Name',
            ),
            InputText(
              name: 'description',
              label: 'Description',
            ),
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
    );
  }
}
