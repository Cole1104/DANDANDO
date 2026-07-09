import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signInAnonymously() async {
    return await _auth.signInAnonymously();
  }

  User? get currentUser => _auth.currentUser;
}
