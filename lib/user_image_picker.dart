import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker(this.pickImageFunction);

  final void Function(File pickedImage) pickImageFunction;
  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? pickImageFile;

  void pickImage() async {
    final pickedUserImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxHeight: 200,
        maxWidth: 200);
    if (pickedUserImage != null) {
      setState(() {
        pickImageFile = File(pickedUserImage.path);
      });
    }
    if (pickImageFile != null) {
      widget.pickImageFunction(pickImageFile!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload Image'), backgroundColor: Colors.red),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Color.fromARGB(102, 59, 167, 255),
            backgroundImage:
                pickImageFile != null ? FileImage(pickImageFile!) : null,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              onPressed: pickImage,
              child: Text(
                'Add Image',
                style: TextStyle(color: Colors.white),
              )),
        ],
      ),
    );
  }
}
