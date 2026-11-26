import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../auth/methods/user_storage.dart';

class PostStorage {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String caption,
    String uid,
    String username,
    String profImage,
    Uint8List image,
  ) async {
    try {
      String postUrl = await StorageMethods().uploadImageToStorage(
        true,
        'posts',
        image,
      );

      String postId = _firestore.collection('posts').doc().id;

      await _firestore.collection('posts').doc(postId).set({
        'caption': caption,
        'uid': uid,
        'username': username,
        'likes': [],
        'postId': postId,
        'datePublished': DateTime.now(),
        'postUrl': postUrl,
        'profImage': profImage,
      });

      return 'Ok';
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> deletePost(String postId, String publicId) async {
    await _firestore.collection('posts').doc(postId).delete();
  }
}
