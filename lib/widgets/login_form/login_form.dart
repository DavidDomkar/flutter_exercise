import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/database.dart';

import 'widgets/password_form_field.dart';
import 'widgets/submit_button.dart';

import 'login_form_view_model.dart';

final _viewModelProvider = ChangeNotifierProvider.autoDispose.family<LoginFormViewModel, Login?>((ref, login) => LoginFormViewModel(ref.read, login));

class LoginForm extends ConsumerWidget {
  final Login? login;
  final bool readOnly;
  final void Function(int id, String title)? onSaved;

  const LoginForm({Key? key, this.login, this.readOnly = false, this.onSaved}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(_viewModelProvider(login));

    return Form(
      key: readOnly ? null : viewModel.formKey,
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
                        onPressed: () => copyToClipboard(context, viewModel.title, 'Title'),
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
                        onPressed: () => copyToClipboard(context, viewModel.username, 'Username / Email'),
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
              onCopyPressed: () => copyToClipboard(context, viewModel.password, 'Password'),
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

                  if (id != null && onSaved != null) {
                    onSaved!(id, viewModel.title);
                  }
                },
                child: login != null ? const Text('Save') : const Text('Add login'),
              );
            }),
        ],
      ),
    );
  }

  Future<void> copyToClipboard(BuildContext context, String data, String label) async {
    await Clipboard.setData(ClipboardData(text: data));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$label copied to clipboard'),
    ));
  }
}
