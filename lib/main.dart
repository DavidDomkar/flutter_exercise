import 'package:flutter/material.dart';
import 'package:flutter_exercise/database/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'repositories/logins_repository.dart';
import 'screens/home/home_screen.dart';
import 'screens/form/form_screen.dart';
import 'screens/detail/detail_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final database = Database();
  const storage = FlutterSecureStorage();

  runApp(
    ProviderScope(
      overrides: [
        loginsRepositoryProvider.overrideWithValue(
          LoginsRepository(database: database, storage: storage),
        ),
      ],
      child: const PasswordManagerApp(),
    ),
  );
}

class PasswordManagerApp extends StatelessWidget {
  const PasswordManagerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/form': (context) => const FormScreen(),
        '/detail': (context) => const DetailScreen(),
      },
    );
  }
}
