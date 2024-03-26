import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'models.dart'; // Import your generated Post class

part 'api_service.g.dart';

@RestApi(baseUrl: "https://jsonplaceholder.typicode.com")
abstract class ApiService {
  factory ApiService(Dio dio) = _ApiService;

  @GET("/posts")
  Future<List<Post>> fetchPosts();

  @DELETE("/posts/{id}")
  Future<void> deletePost(@Path("id") int postId);
}
