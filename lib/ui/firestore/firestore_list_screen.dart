import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/ui/auth/login_screen.dart';
import 'package:firebase/ui/firestore/add_firestore_data.dart';
import 'package:firebase/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirestoreScreen extends StatefulWidget {
  const FirestoreScreen({super.key});

  @override
  State<FirestoreScreen> createState() => _FirestoreScreenState();
}

class _FirestoreScreenState extends State<FirestoreScreen> {
  final auth = FirebaseAuth.instance;
  final searchFilterController = TextEditingController();
  final editeController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('users').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('users');
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Firestore'),
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
              builder: (context) => const AddFirestoreDataScreen(),
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
          StreamBuilder<QuerySnapshot>(
              stream: fireStore,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Text(
                    'Some Eroor',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          ref
                              .doc(snapshot.data!.docs[index]['id'].toString())
                              .update({'title': 'A New Update'}).then((value) {
                            Utils().tostMessage(message: 'Updated');
                          }).onError((error, stackTrace) {
                            Utils().tostMessage(message: error.toString());
                          });
                        },
                        title: Text(
                            snapshot.data!.docs[index]['title'].toString()),
                        subtitle: Text(
                          snapshot.data!.docs[index]['id'].toString(),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            ref
                                .doc(
                                    snapshot.data!.docs[index]['id'].toString())
                                .delete();
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      );
                    },
                  ),
                );
              }),
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
                },
                child: const Text('Update'),
              ),
            ],
          );
        });
  }
}
