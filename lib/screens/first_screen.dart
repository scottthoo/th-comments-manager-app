import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tribe/models/posts.dart';
import 'package:tribe/screens/second_screen.dart';
import 'package:tribe/services/service.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  late Future<List<Post>> posts;

  @override
  void initState() {
    super.initState();
    posts = RemoteService().getAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments Manager'),
      ),
      body: FutureBuilder<List<Post>>(
          future: posts,
          builder: (context, snap) {
            if (!snap.hasData) return Center(child: CircularProgressIndicator());
            return ListView.builder(
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SecondScreen(selectedPostId: snap.data![index].id.toString())),
                    );
                  },
                  child: Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: ListTile(
                      minVerticalPadding: 10,
                      leading: Text(snap.data![index].id.toString()),
                      title: Text(snap.data![index].title),
                      subtitle: Text(snap.data![index].body),
                    ),
                  ),
                );
              },
              itemCount: snap.data!.length,
              shrinkWrap: true,
              padding: EdgeInsets.all(5),
              scrollDirection: Axis.vertical,
            );
          }),
    );
  }
}
