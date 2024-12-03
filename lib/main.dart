import 'package:ap2/models/usermodel.dart';
import 'package:ap2/screens/create_account.dart';
import 'package:ap2/screens/login.dart';
import 'package:ap2/services/auth_service.dart';
import 'package:ap2/services/character_service.dart';
import 'package:ap2/widgets/character_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:ap2/widgets//my_home_page.dart'; // Import do MyHomePage


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Estacionamento',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<UserModel?>(
        stream: _authService.user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const CreateAccount();
          }

          return const LoginScreen();
        },
      ),
      routes: {
        '/cadastro': (context) => const CreateAccount(),
        '/login': (context) =>  LoginScreen(),
        '/home': (context) =>  CharacterList(),
      },
    );
  }
}