import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn);
  final void Function(File pickedImage) imagePickFn;
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;
  final _imagePicker = ImagePicker();

  Future _pickImage() async {
    final pickedImageFile = await _imagePicker.getImage(source: ImageSource.gallery);

    setState(() {
      _pickedImage = File(pickedImageFile.path);
    });
    widget.imagePickFn(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
      CircleAvatar(
      maxRadius: 90,
      backgroundColor: Colors.grey[400],
      backgroundImage:_pickedImage != null ? FileImage(_pickedImage):null,
    ),
        FlatButton.icon(
          textColor: Theme.of(context).accentColor,
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text("Add Image"),
        ),
      ],
    );
  }
}
