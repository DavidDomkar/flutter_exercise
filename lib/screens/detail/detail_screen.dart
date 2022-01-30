import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/login_form/login_form.dart';
import '../../database/database.dart';
import '../../repositories/logins_repository.dart';
import 'detail_view_model.dart';

final _loginProvider = StreamProvider.autoDispose.family<Login?, int>((ref, id) {
  final loginsRepository = ref.watch(loginsRepositoryProvider);

  return loginsRepository.watchLogin(id).distinct((previous, current) => previous != null && current == null);
});

final _viewModelProvider = Provider.autoDispose((ref) => DetailViewModel(ref.read));

class DetailScreenArguments {
  final int id;
  final String title;

  DetailScreenArguments({required this.id, required this.title});
}

class DetailScreen extends ConsumerWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arguments = ModalRoute.of(context)!.settings.arguments as DetailScreenArguments;

    final viewModel = ref.read(_viewModelProvider);

    final login = ref.watch(_loginProvider(arguments.id));

    return Scaffold(
      appBar: AppBar(
        title: Text('${arguments.title} details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {},
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await viewModel.deleteLogin(arguments.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: login.when(
        data: (data) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: LoginForm(
                login: data,
                readOnly: true,
              ),
            ),
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
    );
  }
}
