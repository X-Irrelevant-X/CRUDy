import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'models.dart';

class ApiService {
  final Dio dio;

  ApiService({required this.dio});

  Future<List<Post>> fetchPosts() async {
    try {
      final response = await dio.get('https://jsonplaceholder.typicode.com/posts');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      throw Exception('Failed to load posts');
    }
  }

  Future<void> deletePost(int postId) async {
    try {
      final response = await dio.delete('https://jsonplaceholder.typicode.com/posts/$postId');
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to delete post');
      }
    } catch (e) {
      throw Exception('Failed to delete post');
    }
  }

  Future<List<Comment>> fetchComments(int postId) async {
    try {
      final response = await dio.get('https://jsonplaceholder.typicode.com/posts/$postId/comments');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Comment.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load comments');
      }
    } catch (e) {
      throw Exception('Failed to load comments');
    }
  }

  Future<void> deleteComment(int commentId) async {
    try {
      final response = await dio.delete('https://jsonplaceholder.typicode.com/comments/$commentId');
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to delete comment');
      }
    } catch (e) {
      throw Exception('Failed to delete comment');
    }
  }
}
