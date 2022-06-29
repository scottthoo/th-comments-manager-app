import 'package:flutter/material.dart';
import 'package:tribe/models/comments.dart';
import 'package:tribe/models/posts.dart';
import 'package:tribe/services/service.dart';

class SecondScreen extends StatefulWidget {
  final String selectedPostId;
  const SecondScreen({Key? key, required this.selectedPostId}) : super(key: key);

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  late var futureCall;
  late Future<Post> getSelectedPostFuture;
  late Future<List<Comments>> getCommentFuture;
  List<Comments> comments = [];

  final controller = TextEditingController();

  @override
  initState() {
    super.initState();
    getSelectedPostFuture = RemoteService().getOnePost(widget.selectedPostId);
    getCommentFuture = RemoteService().getComments(widget.selectedPostId);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      comments = await RemoteService().getComments(widget.selectedPostId);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comment'),
      ),
      body: FutureBuilder<Post>(
          future: getSelectedPostFuture,
          builder: (context, snap) {
            if (!snap.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(38.0),
                  child: Card(
                    elevation: 5,
                    child: Center(
                      child: ListTile(
                        title: Text(snap.data!.title),
                        subtitle: Text(snap.data!.body),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Content, email, name...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                    ),
                    onChanged: searchComments,
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                  itemBuilder: (BuildContext, index) {
                    return Card(
                      child: ListTile(
                        title: Text(comments[index].name),
                        subtitle: Text(comments[index].body),
                        trailing: Text(
                          comments[index].email,
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    );
                  },
                  itemCount: comments.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(5),
                  scrollDirection: Axis.vertical,
                ))
              ],
            );
          }),
    );
  }

  void searchComments(String query) async {
    print('Query : ${query}');
    final suggestions = comments.where((comment) {
      final email = comment.email.toLowerCase();
      final name = comment.name.toLowerCase();
      final body = comment.body.toLowerCase();
      final input = query.toLowerCase();
      return email.contains(input) || body.contains(input) || name.contains(input);
    }).toList();
    print('suggestions.length : ${suggestions.length}');
    print('query.length : ${query.length}');
    if (query.length == 0) {
      comments = await RemoteService().getComments(widget.selectedPostId);
      setState(() {});
    } else {
      setState(() => comments = suggestions);
    }
  }
}
