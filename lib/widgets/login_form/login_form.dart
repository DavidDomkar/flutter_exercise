import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/database.dart';
import '../../screens/detail/detail_screen.dart';
import 'login_form_view_model.dart';
import 'widgets/password_form_field.dart';
import 'widgets/submit_button.dart';

final _viewModelProvider = ChangeNotifierProvider.autoDispose.family<LoginFormViewModel, Login?>((ref, login) => LoginFormViewModel(ref.read, login));

class LoginForm extends ConsumerWidget {
  final Login? login;
  final bool readOnly;

  const LoginForm({Key? key, this.login, this.readOnly = false}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(_viewModelProvider(login));

    return Form(
      key: viewModel.formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TextFormField(
              initialValue: login?.title,
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: viewModel.emptyFieldValidator,
              onChanged: (value) => viewModel.title = value,
              readOnly: readOnly,
              decoration: InputDecoration(
                labelText: 'Title',
                alignLabelWithHint: true,
                suffixIcon: readOnly
                    ? IconButton(
                        onPressed: () async {
                          await Clipboard.setData(ClipboardData(text: viewModel.title));
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Title copied to clipboard'),
                          ));
                        },
                        icon: const Icon(Icons.copy),
                      )
                    : null,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TextFormField(
              initialValue: login?.username,
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: viewModel.emptyFieldValidator,
              onChanged: (value) => viewModel.username = value,
              readOnly: readOnly,
              decoration: InputDecoration(
                labelText: 'Username / Email',
                alignLabelWithHint: true,
                suffixIcon: readOnly
                    ? IconButton(
                        onPressed: () async {
                          await Clipboard.setData(ClipboardData(text: viewModel.username));
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Username / Email copied to clipboard'),
                          ));
                        },
                        icon: const Icon(Icons.copy),
                      )
                    : null,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: PasswordFormField(
              initialValue: login?.password,
              textInputAction: TextInputAction.done,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: viewModel.emptyFieldValidator,
              onChanged: (value) => viewModel.password = value,
              onCopyPressed: () async {
                await Clipboard.setData(ClipboardData(text: viewModel.password));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Password copied to clipboard'),
                ));
              },
              readOnly: readOnly,
            ),
          ),
          if (!readOnly)
            Consumer(builder: (context, ref, _) {
              final viewModel = ref.watch(_viewModelProvider(login));

              return SubmitButton(
                loading: viewModel.loading,
                onPressed: () async {
                  final id = await viewModel.submit();

                  if (id != null) {
                    Navigator.of(context).pushReplacementNamed(
                      '/detail',
                      arguments: DetailScreenArguments(
                        id: id,
                        title: viewModel.title,
                      ),
                    );
                  }
                },
              );
            }),
        ],
      ),
    );
  }
}
