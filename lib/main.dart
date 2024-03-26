import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'models.dart';
import 'api_service.dart';

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
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Show edit dialog
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

class EditPostDialog extends StatefulWidget {
  final Post post;
  final Function(String, String) onEdit;

  const EditPostDialog({Key? key, required this.post, required this.onEdit}) : super(key: key);

  @override
  _EditPostDialogState createState() => _EditPostDialogState();
}

class _EditPostDialogState extends State<EditPostDialog> {
  late TextEditingController _titleController;
  late TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post.title);
    _bodyController = TextEditingController(text: widget.post.body);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Post'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _bodyController,
            decoration: InputDecoration(labelText: 'Body'),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onEdit(_titleController.text, _bodyController.text);
          },
          child: Text('Save'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }
}

