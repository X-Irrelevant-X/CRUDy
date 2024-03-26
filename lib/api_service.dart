import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import 'models.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: 'https://jsonplaceholder.typicode.com')
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET('/posts')
  Future<List<Post>> getPosts();

  @PUT('/posts/{postId}')
  Future<void> editPost(@Path('postId') int postId, @Body() Map<String, dynamic> data);
  
  @DELETE('/posts/{postId}')
  Future<void> deletePost(@Path('postId') int postId);


  @GET('/posts/{postId}/comments')
  Future<List<Comment>> getComments(@Path('postId') int postId);

  @PUT('/posts/{postId}//comments/{commentId}')
  Future<void> editComment(@Path('commentId') int commentId, @Body() Map<String, dynamic> data);
  
  @DELETE('/posts/{postId}/comments/{commentId}')
  Future<void> deleteComment(@Path('commentId') int commentId);
}
