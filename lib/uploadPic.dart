// ignore_for_file: body_might_complete_normally_nullable, use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<String?> uploadData(BuildContext context) async {
  File? imageFile;
  XFile? pickedFile =
      await ImagePicker().pickImage(source: ImageSource.gallery);
  imageFile = File(pickedFile!.path);
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(
                  height: 30,
                ),
                Text('Uploading image..'),
              ],
            ),
          ),
        );
      });
  try {
    Reference reference = FirebaseStorage.instance.ref("todopic");

    final TaskSnapshot snapshot = await reference.putFile(imageFile);

    final downloadUrl = await snapshot.ref.getDownloadURL();

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image Added Successfully')));

    return downloadUrl;
  } catch (e) {
    log("hereU${e.toString()}");
  }
}
