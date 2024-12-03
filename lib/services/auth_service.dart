import 'package:ap2/models/usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel?> createAccount(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel(email: userCredential.user?.email ?? '');
    } on FirebaseAuthException catch (e) {
      print("Erro ao criar conta: ${e.message}");
      return null;
    }
  }

  Future<UserModel?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel(email: userCredential.user?.email ?? '');
    } on FirebaseAuthException catch (e) {
      print("Erro ao fazer login: ${e.message}");
      return null;
    }
  }

  Stream<UserModel?> get user {
    return _auth.authStateChanges().map((User? user) {
      return user != null ? UserModel(email: user.email ?? '') : null;
    });
  }
}