import 'package:tribe/models/comments.dart';
import 'package:tribe/models/posts.dart';
import 'package:http/http.dart' as http;
import 'package:tribe/utils/constants.dart';

class RemoteService {
  Future<List<Post>> getAllPosts() async {
    var url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    var response = await http.get(url);
    return postFromJson(response.body);
  }

  Future<Post> getOnePost(String postId) async {
    var url = Uri.parse('https://jsonplaceholder.typicode.com/posts/$postId');
    var response = await http.get(url);
    return singlePostFromJson(response.body);
  }

  Future<List<Comments>> getComments(String postId) async {
    var url = Uri.parse('https://jsonplaceholder.typicode.com/comments?postId=$postId');
    var response = await http.get(url);
    return commentsFromJson(response.body);
  }
}
