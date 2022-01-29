import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'form_view_model.dart';

final _viewModelProvider = ChangeNotifierProvider.autoDispose((ref) => FormViewModel(ref.read));

class FormScreen extends ConsumerWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(_viewModelProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Text('Form'),
        ),
      ),
    );
  }
}
