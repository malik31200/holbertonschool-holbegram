import 'package:flutter/material.dart';

import '../../utils/posts.dart';

class Feed extends StatelessWidget {
  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 25),
            Text(
              'Holbegram',
              style: TextStyle(fontFamily: 'Billabong', fontSize: 30),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.add_box)),

              IconButton(onPressed: () {}, icon: Icon(Icons.message)),
            ],
          ),
        ],
      ),
      body: Posts(),
    );
  }
}
