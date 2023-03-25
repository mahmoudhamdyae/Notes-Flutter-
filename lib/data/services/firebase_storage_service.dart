import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {

  late Reference notesRef;

  setRef(String imageName) {
    notesRef = FirebaseStorage.instance.ref("images").child(imageName);
  }

  Future putFile(File? file) async {
    await notesRef.putFile(file!);
  }

  Future<String> getDownloadUrl() async {
    return await notesRef.getDownloadURL();
  }
}