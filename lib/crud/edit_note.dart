import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/component/toast.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../component/alert.dart';
import '../data/services/firebase_service.dart';

class EditNote extends StatefulWidget {
  final QueryDocumentSnapshot? note;
  final String? noteId;
  const EditNote({Key? key, required this.noteId, required this.note}) : super(key: key);

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {

  FirebaseService firebaseService = FirebaseService();
  late Reference ref;
  File? file;

  String? title, note, imageUrl;

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  updateNote(context) async {
    var formData = formState.currentState;

    if (file == null) {
      if (formData!.validate()) {
        showLoading(context);
        formData.save();
        await firebaseService.updateNote(widget.noteId!, title, note, imageUrl).then((value) {
          Navigator.of(context).pushReplacementNamed("/");
        }).catchError((e) {
          showToast(e.toString());
        });
      }
    } else {
      if (formData!.validate()) {
        showLoading(context);
        formData.save();
        await ref.putFile(file!);
        imageUrl = await ref.getDownloadURL();
        await firebaseService.updateNote(widget.noteId!, title, note, imageUrl).then((value) {
          Navigator.of(context).pushReplacementNamed("/");
        }).catchError((e) {
          showToast(e.toString());
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.save),
        onPressed: () {
          updateNote(context);
        }
      ),
      body: Column(
        children: [
          Form(
              key: formState,
              child: Column(children: [
                TextFormField(
                  initialValue: widget.note!['title'],
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Title can't be empty";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    title = val;
                  },
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Title Note",
                      prefixIcon: Icon(Icons.note)),
                ),
                TextFormField(
                  initialValue: widget.note!['note'],
                  onSaved: (val) {
                    note = val;
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
                  child: const Text("Edit Image For Note"),
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
                  "Edit Image",
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
                      ref = FirebaseStorage.instance
                          .ref("images")
                          .child(imageName);
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
                      ref = FirebaseStorage.instance
                          .ref("images")
                          .child(imageName);
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