import 'package:flutter/material.dart';

import '../../database/database.dart';
import '../../widgets/login_form/login_form.dart';
import '../detail/detail_screen.dart';

class FormScreenArguments {
  final Login? login;

  FormScreenArguments({required this.login});
}

class FormScreen extends StatelessWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as FormScreenArguments?;

    return Scaffold(
      appBar: AppBar(
        title: arguments?.login != null ? Text('Edit ${arguments!.login!.title} login') : const Text('Add new login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: LoginForm(
            login: arguments?.login,
            onSaved: (id, title) {
              if (arguments != null) {
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pushReplacementNamed(
                  '/detail',
                  arguments: DetailScreenArguments(
                    id: id,
                    title: title,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
