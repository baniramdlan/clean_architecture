import 'package:clean_architecture/page/master_data/hobby/hobby_search.dart';
import 'package:flutter/material.dart';

class MasterDataMenu extends StatelessWidget {
  const MasterDataMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text('Member'),
          trailing: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.navigate_next),
          ),
        ),
        ListTile(
          title: const Text('Hobby'),
          trailing: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HobbySearch()),
              );
            },
            icon: const Icon(Icons.navigate_next),
          ),
        ),
      ],
    );
  }
}
