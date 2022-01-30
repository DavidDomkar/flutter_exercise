import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers.dart';
import '../../widgets/login_form/login_form.dart';
import '../form/form_screen.dart';
import 'detail_view_model.dart';
import 'widgets/delete_dialog.dart';

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

    final login = ref.watch(loginProvider(arguments.id));

    final loginTitle = login.asData?.value?.title ?? arguments.title;

    return Scaffold(
      appBar: AppBar(
        title: Text('$loginTitle details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/form',
                arguments: FormScreenArguments(
                  id: arguments.id,
                  title: loginTitle,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  return DeleteDialog(
                    loginTitle: loginTitle,
                    onDeletePressed: () async {
                      await viewModel.deleteLogin(arguments.id);
                      Navigator.pop(context);
                    },
                  );
                },
              );
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
                key: ValueKey(data),
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
