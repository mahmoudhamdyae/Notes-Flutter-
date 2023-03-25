import 'dart:io';
import 'dart:math';
import 'package:notes/component/toast.dart';
import 'package:notes/data/services/firebase_service.dart';
import 'package:notes/data/services/firebase_storage_service.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../component/alert.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({Key? key}) : super(key: key);

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {

  FirebaseService firebaseService = FirebaseService();
  FirebaseStorageService firebaseStorageService = FirebaseStorageService();

  File? file;

  String? title, description, imageUrl;

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  addNote(context) async {
    var formData = formState.currentState;
    if (formData!.validate()) {
      showLoading(context);
      formData.save();
      await firebaseStorageService.putFile(file!);
      imageUrl = await firebaseStorageService.getDownloadUrl();
      await firebaseService.addNote(title, description, imageUrl).then((value) {
        Navigator.of(context).pushNamed("/");
      }).catchError((e) {
        showToast(e.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.save),
          onPressed: () {
            if (file == null) {
              showToast("Please choose Image");
            } else {
              addNote(context);
            }
          }
      ),
      body: Column(
        children: [
          Form(
              key: formState,
              child: Column(children: [
                TextFormField(
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Title can't be empty";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    title = val;
                  },
                  maxLength: 30,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Title Note",
                      prefixIcon: Icon(Icons.note)),
                ),
                TextFormField(
                  onSaved: (val) {
                    description = val;
                  },
                  minLines: 1,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Note",
                      prefixIcon: Icon(Icons.note)),
                ),
                ElevatedButton(
                  onPressed: () {
                    showBottomSheet(context);
                  },
                  child: const Text("Add Image For Note"),
                ),
              ]))
        ],
      ),
    );
  }

  showBottomSheet(context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(20),
            height: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Please Choose Image",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () async {
                    var picked = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (picked != null) {
                      file = File(picked.path);
                      var rand = Random().nextInt(100000);
                      var imageName = "$rand${basename(picked.path)}";
                      firebaseStorageService.setRef(imageName);
                      if (mounted) Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.photo_outlined,
                            size: 30,
                          ),
                          SizedBox(width: 20),
                          Text(
                            "From Gallery",
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      )),
                ),
                InkWell(
                  onTap: () async {
                    var picked = await ImagePicker()
                        .pickImage(source: ImageSource.camera);
                    if (picked != null) {
                      file = File(picked.path);
                      var rand = Random().nextInt(100000);
                      var imageName = "$rand${basename(picked.path)}";
                      firebaseStorageService.setRef(imageName);
                      if (mounted) Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.camera,
                            size: 30,
                          ),
                          SizedBox(width: 20),
                          Text(
                            "From Camera",
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      )),
                ),
              ],
            ),
          );
        });
  }
}