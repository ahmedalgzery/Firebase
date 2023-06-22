import 'dart:io';

import 'package:firebase/utils/utils.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? _image;
  final picker = ImagePicker();
  bool loading = false;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('post');
  Future getImagFromGallery() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image picked');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: InkWell(
                  onTap: () {
                    getImagFromGallery();
                  },
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.black,
                        )),
                    child: _image != null
                        ? Image.file(_image!.absolute)
                        : Icon(Icons.image),
                  ),
                ),
              ),
              SizedBox(
                height: 39,
              ),
              RoundButton(
                  title: 'Upload',
                  loading: loading,
                  onTap: () async {
                    setState(() {
                      loading = true;
                    });
                    firebase_storage.Reference ref = firebase_storage
                        .FirebaseStorage.instance
                        .ref('/images${DateTime.now().microsecondsSinceEpoch}');
                    firebase_storage.UploadTask uploadTask =
                        ref.putFile(_image!.absolute);
                    await Future.value(uploadTask).then((value)async {
                      var newUrl =await ref.getDownloadURL();
                      databaseRef.child('1').set({
                        'id': '456',
                        'title': newUrl.toString(),
                      }).then((value) {
                        setState(() {
                          loading = false;
                        });
                        Utils().tostMessage(message: 'Image Uploaded');
                      }).onError((error, stackTrace) {
                        setState(() {
                          loading = false;
                        });
                        Utils().tostMessage(message: error.toString());
                      });
                    }).onError((error, stackTrace) {
                      setState(() {
                        loading = false;
                      });
                      Utils().tostMessage(message: error.toString());
                    });
                  }),
            ]),
      ),
    );
  }
}
