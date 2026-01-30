import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/auth/domain/entities/app_user.dart';
import '../constants/app_constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User?> get userStream => _auth.authStateChanges();

  Future<AppUser?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection(AppConstants.usersCollection).doc(uid).get();
      if (doc.exists) {
        return AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
    return null;
  }

  Future<UserCredential?> signUp(String email, String password, String name) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      AppUser newUser = AppUser(
        uid: credential.user!.uid,
        email: email,
        name: name,
        role: 'user', // Default role
      );

      await _db.collection(AppConstants.usersCollection).doc(credential.user!.uid).set(newUser.toMap());
      return credential;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential?> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
