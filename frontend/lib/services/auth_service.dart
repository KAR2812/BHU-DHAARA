import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<User?> signIn(String email, String password) async {
    var cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return cred.user;
  }

  Future<User?> register(String email, String password, String name) async {
    var cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    User? user = cred.user;
    if (user != null) {
      await _db.collection('users').doc(user.uid).set({'name': name, 'email': email});
    }
    return user;
  }

  Future<void> signOut() async => _auth.signOut();
}
