import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers.dart';
import '../../widgets/login_form/login_form.dart';
import '../detail/detail_screen.dart';

class FormScreenArguments {
  final int id;
  final String title;

  FormScreenArguments({required this.id, required this.title});
}

class FormScreen extends StatelessWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as FormScreenArguments?;

    return Scaffold(
      appBar: AppBar(
        title: arguments != null ? Text('Edit ${arguments.title} login') : const Text('Add new login'),
      ),
      body: arguments != null
          ? Consumer(
              builder: (context, ref, _) {
                final login = ref.watch(loginProvider(arguments.id));

                return login.when(
                  data: (data) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: LoginForm(
                          login: data,
                          onSaved: (_, __) {
                            Navigator.of(context).pop();
                          },
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
                );
              },
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: LoginForm(
                  onSaved: (id, title) {
                    Navigator.of(context).pushReplacementNamed(
                      '/detail',
                      arguments: DetailScreenArguments(
                        id: id,
                        title: title,
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
