import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/database.dart';
import '../../providers.dart';
import '../detail/detail_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logins = ref.watch(loginsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Manager'),
      ),
      body: logins.when(
        data: (data) {
          return ListView.builder(
            itemBuilder: (context, index) => _buildItem(context, data[index]),
            itemCount: data.length,
          );
        },
        error: (_, __) {
          return const Center(
            child: Text(
              'An error occurred.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/form');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildItem(BuildContext context, Login login) {
    return ListTile(
      title: Text(login.title),
      subtitle: Text(login.username),
      onTap: () {
        Navigator.pushNamed(
          context,
          '/detail',
          arguments: DetailScreenArguments(
            id: login.id,
            title: login.title,
          ),
        );
      },
    );
  }
}
