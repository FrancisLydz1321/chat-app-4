import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

class StorageService {
  StorageService() {}

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String?> uploadUserPfp({
    required File file,
    required String uid,
  }) async {
    Reference fileRef = _firebaseStorage
        .ref('users/pfps')
        .child('$uid${p.extension(file.path)}'); // path package

    UploadTask task = fileRef.putFile(file);

    return task.then((p) {
      if(p.state == TaskState.success) {
        return fileRef.getDownloadURL();
      }
    });
  }
}
