import 'package:clean_architecture/model/cloud_firestore/default/data_adaptor.dart';
import 'package:clean_architecture/model/cloud_firestore/default/hobby.dart';
import 'package:clean_architecture/page/master_data/hobby/hobby_add.dart';
import 'package:clean_architecture/page/master_data/hobby/hobby_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devaloop_form_builder/form_builder.dart';
import 'package:flutter/material.dart';

class HobbySearch extends StatefulWidget {
  const HobbySearch({super.key});

  @override
  State<HobbySearch> createState() => _HobbySearchState();
}

class _HobbySearchState extends State<HobbySearch> {
  late Future<SearchResult> _searchResult;

  void setSearchResultInitial() {
    _searchResult = Future(() async {
      var data = await DataAdaptor.hobby()
          .orderBy('lastUpdated', descending: true)
          .limit(10)
          .get();
      var mapDocs = {for (var v in data.docs) (v).reference: (v).data()};

      var totalData = await DataAdaptor.hobby().count().get();

      return SearchResult(totalData: totalData.count ?? 0, result: mapDocs);
    });
  }

  @override
  void initState() {
    super.initState();
    setSearchResultInitial();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: const LinearBorder(),
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.all(7.5),
        child: Column(
          children: [
            Row(
              children: [
                const Text('Hobby'),
                const Expanded(
                  child: Text(''),
                ),
                TextButton.icon(
                  onPressed: () async {
                    var result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HobbyAdd()),
                    );
                    if (!mounted) return;
                    if (result != null) {
                      setState(() {
                        setSearchResultInitial();
                      });
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back'),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FormBulder(
                      inputFields: const [
                        InputText(
                          name: 'name',
                          label: 'Name',
                          isOptional: true,
                        ),
                        InputText(
                          name: 'description',
                          label: 'Description',
                          isOptional: true,
                        ),
                      ],
                      onSubmit: (context, inputValues) async {
                        setState(() {
                          _searchResult = Future(() async {
                            var data = await DataAdaptor.hobby().get();
                            var mapDocs = {
                              for (var v in data.docs) (v).reference: (v).data()
                            };
                            if (inputValues['name']!.getString() != null) {
                              var filtered = mapDocs.entries
                                  .where((element) => element.value.name
                                      .toLowerCase()
                                      .contains(inputValues['name']!
                                          .getString()!
                                          .toLowerCase()))
                                  .toList();
                              mapDocs = {
                                for (var v in filtered) (v).key: (v).value
                              };
                            }
                            if (inputValues['description']!.getString() !=
                                null) {
                              var filtered = mapDocs.entries
                                  .where((element) => element.value.description
                                      .toLowerCase()
                                      .contains(inputValues['description']!
                                          .getString()!
                                          .toLowerCase()))
                                  .toList();
                              mapDocs = {
                                for (var v in filtered) (v).key: (v).value
                              };
                            }

                            var totalData =
                                await DataAdaptor.hobby().count().get();

                            return SearchResult(
                                totalData: totalData.count ?? 0,
                                result: mapDocs);
                          });
                        });
                      },
                      submitButtonSettings: const SubmitButtonSettings(
                        label: 'Search',
                        icon: Icon(Icons.search),
                      ),
                      additionalButtons: [
                        AdditionalButton(
                          label: 'Cancel',
                          icon: const Icon(Icons.cancel),
                          onTap: () {
                            setState(() {
                              setSearchResultInitial();
                            });
                          },
                        )
                      ],
                    ),
                    FutureBuilder(
                      future: _searchResult,
                      builder: (context, snapshot) {
                        if (snapshot.hasError ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 7.5),
                            child: LinearProgressIndicator(),
                          );
                        } else {
                          SearchResult searchResult = snapshot.data!;
                          var docs = searchResult.result.entries.toList();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  'Show ${searchResult.result.length} of ${searchResult.totalData} Hobbies'),
                              ListView.separated(
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Wrap(
                                      runSpacing: 7.5,
                                      spacing: 7.5,
                                      children: [
                                        Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(7.5),
                                            child: Text(
                                                'Name: ${docs[index].value.name}'),
                                          ),
                                        ),
                                        Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(7.5),
                                            child: Text(
                                                'Description: ${docs[index].value.description}'),
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Row(
                                      children: [
                                        const Expanded(
                                          child: Text(''),
                                        ),
                                        Text(
                                            'Last Update: ${docs[index].value.lastUpdated}'),
                                      ],
                                    ),
                                    onTap: () async {
                                      var result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HobbyDetail(
                                            mapDoc: docs[index],
                                          ),
                                        ),
                                      );

                                      if (!mounted) return;

                                      if (result != null) {
                                        setState(() {
                                          setSearchResultInitial();
                                        });
                                      }
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                                itemCount: searchResult.result.length,
                              )
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchResult {
  final int totalData;
  final Map<DocumentReference<Hobby>, Hobby> result;

  SearchResult({
    required this.totalData,
    required this.result,
  });
}
