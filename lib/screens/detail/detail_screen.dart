import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/login_form/login_form.dart';
import '../../database/database.dart';
import '../../repositories/logins_repository.dart';

final _viewModelProvider = StreamProvider.family<Login, int>((ref, id) {
  final loginsRepository = ref.watch(loginsRepositoryProvider);

  return loginsRepository.watchLogin(id);
});

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

    final viewModel = ref.watch(_viewModelProvider(arguments.id));

    return Scaffold(
      appBar: AppBar(
        title: Text('${arguments.title} details'),
      ),
      body: viewModel.when(
        data: (data) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: LoginForm(
              login: data,
              readOnly: true,
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
