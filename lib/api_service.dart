import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'models.dart'; 

part 'api_service.g.dart';

@RestApi(baseUrl: "https://jsonplaceholder.typicode.com")
abstract class ApiService {
  factory ApiService(Dio dio) = _ApiService;

  @GET("/posts")
  Future<List<Post>> fetchPosts();

  @PUT("/posts/{id}")
  Future<void> editPost(@Path("id") int postId, @Body() Map<String, dynamic> postData);

  @DELETE("/posts/{id}")
  Future<void> deletePost(@Path("id") int postId);
}