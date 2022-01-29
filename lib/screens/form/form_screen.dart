import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/password_form_field.dart';

import 'form_view_model.dart';
import 'widgets/submit_button.dart';

final _viewModelProvider = ChangeNotifierProvider.autoDispose((ref) => FormViewModel(ref.read));

class FormScreen extends ConsumerWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(_viewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: viewModel.formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: viewModel.emptyFieldValidator,
                    onChanged: (value) => viewModel.title = value,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      alignLabelWithHint: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: viewModel.emptyFieldValidator,
                    onChanged: (value) => viewModel.username = value,
                    decoration: const InputDecoration(
                      labelText: 'Username / Email',
                      alignLabelWithHint: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: PasswordFormField(
                    textInputAction: TextInputAction.done,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: viewModel.emptyFieldValidator,
                    onChanged: (value) => viewModel.password = value,
                  ),
                ),
                Consumer(builder: (context, ref, _) {
                  final viewModel = ref.watch(_viewModelProvider);

                  return SubmitButton(
                    loading: viewModel.loading,
                    onPressed: () async {
                      await viewModel.submit();
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
