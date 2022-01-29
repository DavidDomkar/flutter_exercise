import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/database.dart';
import '../../repositories/logins_repository.dart';

final _viewModelProvider = StreamProvider<List<Login>>((ref) {
  final loginsRepository = ref.watch(loginsRepositoryProvider);

  return loginsRepository.watchLogins();
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(_viewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Manager'),
      ),
      body: viewModel.when(
        data: (data) {
          return ListView.builder(
            itemBuilder: (context, index) => _buildItem(context, data[index]),
            itemCount: data.length,
          );
        },
        error: (_, __) {
          return const Center(
            child: Text('An error occurred.', style: TextStyle(color: Colors.red)),
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
        Navigator.pushNamed(context, '/detail', arguments: login);
      },
    );
  }
}
