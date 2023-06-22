import 'package:firebase/ui/auth/login_screen.dart';
import 'package:firebase/ui/posts/add_post.dart';
import 'package:firebase/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final ref = FirebaseDatabase.instance.ref('post');
  final auth = FirebaseAuth.instance;
  final searchFilterController = TextEditingController();
  final editeController = TextEditingController();
  @override
  void initState() {
    super.initState();
    ref.onValue.listen((event) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Post'),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              }).onError((error, stackTrace) {
                Utils().tostMessage(message: error.toString());
              });
            },
            icon: const Icon(Icons.logout_outlined),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPostScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextFormField(
              controller: searchFilterController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Search',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
              query: ref,
              defaultChild: const Text('Loading'),
              itemBuilder: (context, snapshot, animation, index) {
                final title = snapshot.child('title').value.toString();
                if (searchFilterController.text.isEmpty) {
                  return ListTile(
                    title: Text(
                      snapshot.child('title').value.toString(),
                    ),
                    subtitle: Text(
                      snapshot.child('id').value.toString(),
                    ),
                    trailing: PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              showMyDialog(
                                title: title,
                                id: snapshot.child('id').value.toString(),
                              );
                            },
                            leading: const Icon(Icons.edit),
                            title: const Text('Edite'),
                          ),
                        ),
                        PopupMenuItem(
                          value: 1,
                          child: ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              ref
                                  .child(snapshot.child('id').value.toString())
                                  .remove();
                            },
                            leading: const Icon(Icons.delete),
                            title: const Text('Delete'),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (title.toLowerCase().contains(
                    searchFilterController.text.toLowerCase().toLowerCase())) {
                  return ListTile(
                    title: Text(
                      snapshot.child('title').value.toString(),
                    ),
                    subtitle: Text(
                      snapshot.child('id').value.toString(),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> showMyDialog({required String title, required String id}) async {
    editeController.text = title;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Update'),
            content: TextFormField(
              controller: editeController,
              decoration: const InputDecoration(hintText: 'Edit'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ref.child(id).update({
                    'title': editeController.text.toLowerCase(),
                    'id': id
                  }).then((value) {
                    Utils().tostMessage(message: 'Post Updated');
                  }).onError((error, stackTrace) {
                    Utils().tostMessage(
                      message: error.toString(),
                    );
                  });
                },
                child: const Text('Update'),
              ),
            ],
          );
        });
  }
}


          // Expanded(
          //   child: StreamBuilder(
          //       stream: ref.onValue,
          //       builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          //         if (!snapshot.hasData) {
          //           return const Center(child: CircularProgressIndicator());
          //         } else {
          //           Map<dynamic, dynamic> map =
          //               snapshot.data!.snapshot.value as dynamic;
          //           List<dynamic> list = [];
          //           list.clear();
          //           list = map.values.toList();
          //           return ListView.builder(
          //               itemCount: snapshot.data!.snapshot.children.length,
          //               itemBuilder: (context, index) {
          //                 return ListTile(
          //                   title: Text(list[index]['title']),
          //                   subtitle: Text(list[index]['id']),
          //                 );
          //               });
          //         }
          //       }),
          // ),
       