import 'package:clean_architecture/model/cloud_firestore/default/data_adaptor.dart';
import 'package:clean_architecture/model/cloud_firestore/default/hobby.dart';
import 'package:clean_architecture/model/cloud_firestore/default/member.dart';
import 'package:clean_architecture/page/master_data/member/member_add.dart';
import 'package:clean_architecture/page/master_data/member/member_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devaloop_form_builder/form_builder.dart';
import 'package:devaloop_form_builder/input_field_text.dart';
import 'package:flutter/material.dart';

class MemberSearch extends StatefulWidget {
  const MemberSearch({super.key});

  @override
  State<MemberSearch> createState() => _MemberSearchState();
}

class _MemberSearchState extends State<MemberSearch> {
  late Future<SearchResult> _searchResult;

  void setSearchResultInitial() {
    _searchResult = Future(() async {
      var data = await DataAdaptor.member()
          .orderBy('lastUpdated', descending: true)
          .limit(10)
          .get();
      var mapDocs = {for (var v in data.docs) (v).reference: (v).data()};

      var totalData = await DataAdaptor.member().count().get();

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
                const Text('Member'),
                const Expanded(
                  child: Text(''),
                ),
                TextButton.icon(
                  onPressed: () async {
                    var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MemberAdd()),
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
                          name: 'email',
                          label: 'Email',
                          isOptional: true,
                          inputTextMode: InputTextMode.email,
                        ),
                      ],
                      onSubmit: (context, inputValues) async {
                        setState(() {
                          _searchResult = Future(() async {
                            var data = await DataAdaptor.member().get();
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
                            if (inputValues['email']!.getString() != null) {
                              var filtered = mapDocs.entries
                                  .where((element) => element.value.email
                                      .toLowerCase()
                                      .contains(inputValues['email']!
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
                                  'Show ${searchResult.result.length} of ${searchResult.totalData} Members'),
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
                                                'Email: ${docs[index].value.email}'),
                                          ),
                                        ),
                                        Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(7.5),
                                            child: Text(
                                                'Birth Date: ${docs[index].value.birthDate}'),
                                          ),
                                        ),
                                        Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(7.5),
                                            child: Text(
                                                'Gender: ${docs[index].value.gender.value}'),
                                          ),
                                        ),
                                        Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(7.5),
                                            child: Text(
                                                'Ethnic: ${docs[index].value.ethnic.value}'),
                                          ),
                                        ),
                                        Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(7.5),
                                            child: Text(
                                                'Parental Ethnic Groups: ${docs[index].value.parentalEthnicGroups.map((e) => e.value).toList().join(', ')}'),
                                          ),
                                        ),
                                        Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(7.5),
                                            child: Text(
                                                'Ethnic Mate: ${docs[index].value.ethnicMate?.value ?? ''}'),
                                          ),
                                        ),
                                        Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(7.5),
                                            child: Text(
                                                'Parental Ethnic Groups Mate: ${(docs[index].value.parentalEthnicGroupsMate ?? []).map((e) => e.value).toList().join(', ')}'),
                                          ),
                                        ),
                                        FutureBuilder(
                                          future:
                                              Future<DocumentSnapshot<Hobby>>(
                                            () async {
                                              return await docs[index]
                                                  .value
                                                  .mostFavoriteHobby
                                                  .get();
                                            },
                                          ),
                                          builder: (context, snapshot) {
                                            var label = const Text(
                                                'Most Favorite Hobby:');
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              return Card(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(7.5),
                                                  child: Wrap(
                                                    spacing: 7.5,
                                                    runSpacing: 7.5,
                                                    children: [
                                                      label,
                                                      Text(
                                                          'Name: ${snapshot.data!.data()!.name}'),
                                                      Text(
                                                          'Description: ${snapshot.data!.data()!.description}'),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Card(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(7.5),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      label,
                                                      const SizedBox(
                                                        width: 7.5,
                                                      ),
                                                      const SizedBox(
                                                        width: 24,
                                                        height: 24,
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                        Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(7.5),
                                            child: Text(
                                                'Other Hobbies: ${docs[index].value.otherHobbies.length} Selected'),
                                          ),
                                        ),
                                        FutureBuilder(
                                          future:
                                              Future<DocumentSnapshot<Hobby>?>(
                                            () async {
                                              if (docs[index]
                                                      .value
                                                      .mostFavoriteHobbyMate ==
                                                  null) {
                                                return null;
                                              }
                                              return await docs[index]
                                                  .value
                                                  .mostFavoriteHobbyMate!
                                                  .get();
                                            },
                                          ),
                                          builder: (context, snapshot) {
                                            var label = const Text(
                                                'Most Favorite Hobby Mate:');
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              return Card(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(7.5),
                                                  child: Wrap(
                                                    spacing: 7.5,
                                                    runSpacing: 7.5,
                                                    children: [
                                                      label,
                                                      if (snapshot.data != null)
                                                        Text(
                                                            'Name: ${snapshot.data!.data()!.name}'),
                                                      if (snapshot.data != null)
                                                        Text(
                                                            'Description: ${snapshot.data!.data()!.description}'),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Card(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(7.5),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      label,
                                                      const SizedBox(
                                                        width: 7.5,
                                                      ),
                                                      const SizedBox(
                                                        width: 24,
                                                        height: 24,
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                        Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(7.5),
                                            child: Text(
                                                'Other Hobbies Mate: ${docs[index].value.otherHobbiesMate?.length ?? 0} Selected'),
                                          ),
                                        ),
                                        Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(7.5),
                                            child: Text(
                                                'Rate: ${docs[index].value.rate ?? ''}'),
                                          ),
                                        ),
                                        Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(7.5),
                                            child: Text(
                                                'Rate Info: ${docs[index].value.rateInfo ?? ''}'),
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
                                          builder: (context) => MemberDetail(
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
  final Map<DocumentReference<Member>, Member> result;

  SearchResult({
    required this.totalData,
    required this.result,
  });
}
