import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Favorite extends StatelessWidget {
  const Favorite({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(fontFamily: 'Billabong', fontSize: 32),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .snapshots(),
        builder: (context, userSnapshot) {
          if (!userSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<dynamic> saved = userSnapshot.data!.data()?['saved'] ?? [];

          return StreamBuilder(
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
            builder: (context, postsSnapshot) {
              if (!postsSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final savedPosts = postsSnapshot.data!.docs
                  .where((doc) => saved.contains(doc.data()['postId']))
                  .toList();

              if (savedPosts.isEmpty) {
                return const Center(child: Text('No favorites yet'));
              }

              return ListView.builder(
                itemCount: savedPosts.length,
                itemBuilder: (context, index) {
                  final data = savedPosts[index].data();

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Image.network(
                      data['postUrl'],
                      width: double.infinity,
                      height: 400,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
