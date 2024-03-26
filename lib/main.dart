import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'models.dart'; // Import your Post class
import 'api_service.dart'; // Import your generated ApiService

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late ApiService apiService;
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    apiService = ApiService(Dio());
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      final response = await apiService.fetchPosts();
      setState(() {
        posts = response;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> deletePost(int postId) async {
    try {
      await apiService.deletePost(postId);
      setState(() {
        posts.removeWhere((post) => post.id == postId);
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(140, 85, 166, 1),
          centerTitle: true,
          toolbarHeight: 55,
          title: const Text(
            'Posts',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
        body: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2.0),
                  ),
                  margin: const EdgeInsets.all(5.0),
                  child: ListTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(posts[index].title),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deletePost(posts[index].id);
                          },
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(posts[index].body),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

