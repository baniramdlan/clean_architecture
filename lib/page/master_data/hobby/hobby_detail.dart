import 'package:clean_architecture/model/cloud_firestore/default/hobby.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devaloop_form_builder/form_builder.dart';
import 'package:flutter/material.dart';

class HobbyDetail extends StatelessWidget {
  final MapEntry<DocumentReference<Hobby>, Hobby> mapDoc;

  const HobbyDetail({
    super.key,
    required this.mapDoc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hobby'),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
            onInitial: (context, inputValues) {
              inputValues['name']!.setString(mapDoc.value.name);
              inputValues['description']!.setString(mapDoc.value.description);
            },
            onSubmit: (context, inputValues) async {
              await mapDoc.key.set(Hobby(
                name: inputValues['name']!.getString()!,
                description: inputValues['description']!.getString()!,
              ));

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
      ),
    );
  }
}
