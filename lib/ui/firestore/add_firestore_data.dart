import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/utils/utils.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:flutter/material.dart';

class AddFirestoreDataScreen extends StatefulWidget {
  const AddFirestoreDataScreen({Key? key}) : super(key: key);

  @override
  State<AddFirestoreDataScreen> createState() => _AddFirestoreDataScreenState();
}

class _AddFirestoreDataScreenState extends State<AddFirestoreDataScreen> {
  bool loading = false;
  final postController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add firestore data'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: postController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'What is on your mind?',
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            RoundButton(
              title: 'Add',
              loading: loading,
              onTap: () {
                setState(() {
                  loading = true;
                });
                String id = DateTime.now().microsecondsSinceEpoch.toString();
                fireStore.doc(id).set({
                  'title': postController.text.toString(),
                  'id': id,
                }).then((value) {
                  Utils().tostMessage(message: 'Post added');
                  setState(() {
                    loading = false;
                  });
                }).onError((error, stackTrace) {
                  setState(() {
                    loading = false;
                  });
                  Utils().tostMessage(message: error.toString());
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
