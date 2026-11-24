import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../screens/auth/methods/user_storage.dart';

import 'dart:typed_data';

import '../models/user.dart';

class AuthMethode {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> login({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      return 'Please fill all the fields';
    }

    await _auth.signInWithEmailAndPassword(email: email, password: password);

    return 'success';
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    Uint8List? file,
  }) async {
    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      return 'Please fill all the fields';
    }

    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final User user = userCredential.user!;

    String photoUrl = '';

    if (file != null) {
      photoUrl = await StorageMethods().uploadImageToStorage(
        false,
        'profile',
        file,
      );
    }

    Users users = Users(
      uid: user.uid,
      email: email,
      username: username,
      bio: '',
      photoUrl: photoUrl,
      followers: [],
      following: [],
      posts: [],
      saved: [],
      searchKey: username.toLowerCase(),
    );

    await _firestore.collection("users").doc(user.uid).set(users.toJson());

    return 'success';
  }
}
