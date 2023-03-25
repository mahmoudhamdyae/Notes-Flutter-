import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../component/alert.dart';
import '../data/firebase_service.dart';

class EditNotes extends StatefulWidget {
  final QueryDocumentSnapshot? notes;
  final String? noteId;
  const EditNotes({Key? key, this.noteId, this.notes}) : super(key: key);

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {

  FirebaseService firebaseService = FirebaseService();
  late Reference ref;
  late File? file;

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
      body: Column(
        children: [
          Form(
              key: formState,
              child: Column(children: [
                TextFormField(
                  initialValue: widget.notes!['title'],
                  validator: (val) {
                    if (val != null) {
                      if (val.length > 30) {
                        return "Title can't to be larger than 30 letter";
                      }
                      if (val.length < 2) {
                        return "Title can't to be less than 2 letter";
                      }
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
                  initialValue: widget.notes!['note'],
                  validator: (val) {
                    if (val != null) {
                      if (val.length > 255) {
                        return "Notes can't to be larger than 255 letter";
                      }
                      if (val.length < 10) {
                        return "Notes can't to be less than 10 letter";
                      }
                    }
                    return null;
                  },
                  onSaved: (val) {
                    note = val;
                  },
                  minLines: 1,
                  maxLines: 3,
                  maxLength: 200,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                  child: ElevatedButton(
                    onPressed: () async {
                      await updateNote(context);
                    },
                    child: Text(
                      "Edit Note",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                )
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