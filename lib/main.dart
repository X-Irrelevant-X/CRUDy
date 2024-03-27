import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'models.dart';
import 'api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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

  Future<void> editPost(int postId, String newTitle, String newBody) async {
    try {
      await apiService.editPost(postId, {
        'title': newTitle,
        'body': newBody,
      });
      final updatedPostIndex = posts.indexWhere((post) => post.id == postId);
      if (updatedPostIndex != -1) {
        setState(() {
          posts[updatedPostIndex].title = newTitle;
          posts[updatedPostIndex].body = newBody;
        });
      }
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
            'CRUDy',
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
                GestureDetector(
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return EditPostDialog(
                                        post: posts[index],
                                        onEdit: (newTitle, newBody) {
                                          editPost(posts[index].id, newTitle, newBody);
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    },
                                  );
                                },
                                child: const Text('Edit'),
                              ),
                              TextButton(
                                onPressed: () {
                                  deletePost(posts[index].id);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2.0),
                    ),
                    margin: const EdgeInsets.all(5.0),
                    child: ListTile(
                      title: Text(posts[index].title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(posts[index].body),
                        ],
                      ),
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

class EditPostDialog extends StatefulWidget {
  final Post post;
  final Function(String, String) onEdit;

  const EditPostDialog({super.key, required this.post, required this.onEdit});

  @override
  _EditPostDialogState createState() => _EditPostDialogState();
}

class _EditPostDialogState extends State<EditPostDialog> {
  late TextEditingController editTitle;
  late TextEditingController editBody;

  @override
  void initState() {
    super.initState();
    editTitle = TextEditingController(text: widget.post.title);
    editBody = TextEditingController(text: widget.post.body);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Post'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: editTitle,
            decoration: const InputDecoration(
              labelText: 'Title:', 
              labelStyle: TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: editBody,
            decoration: const InputDecoration(
              labelText: 'Body:', 
              labelStyle: TextStyle(fontSize: 20),
            ),
            maxLines: null,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onEdit(editTitle.text, editBody.text);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    editTitle.dispose();
    editBody.dispose();
    super.dispose();
  }
}

