import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserUpdateImagePicker extends StatefulWidget {
  UserUpdateImagePicker(this.imagePickFn, this.categoryImageRef);

  final String categoryImageRef;
  final void Function(File pickedImage) imagePickFn;

  @override
  _UserUpdateImagePickerState createState() => _UserUpdateImagePickerState();
}

class _UserUpdateImagePickerState extends State<UserUpdateImagePicker> {
  var _imageBool = false;
  File _pickedImage;
  final _imagePicker = ImagePicker();

  Future _pickImage() async {
    final pickedImageFile =
        await _imagePicker.getImage(source: ImageSource.gallery);

    _imageBool = true;
    setState(() {
      _pickedImage = File(pickedImageFile.path);
    });

//    final ref =
//    FirebaseStorage.instance.ref().child('images').child(DateTime.now().toString()+ ".jpg");
//    await ref.putFile(_pickedImage).onComplete.then((value) => {
//
//
//    });
//
//    final url = await ref.getDownloadURL();

    widget.imagePickFn(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FittedBox(
          child: _imageBool == false ?
              Container(
                  color: Theme.of(context).primaryColor,
                  width: 150,
                  height: 150,
                  child: ClipRRect(
                    borderRadius: new BorderRadius.circular(0.0),
                    child: Image(
                            fit: BoxFit.contain,
                            alignment: Alignment.topRight,
                            image: NetworkImage(widget.categoryImageRef))
                        ,
                  ),
                )
              : Container(
                  color: Theme.of(context).primaryColor,
                  width: 150,
                  height: 150,
                  child: ClipRRect(
                    borderRadius: new BorderRadius.circular(0.0),
                    child: _pickedImage != null
                        ? Image(
                            fit: BoxFit.contain,
                            alignment: Alignment.topRight,
                            image: FileImage(_pickedImage))
                        : Container(),
                  ),
                ),
        ),
        FlatButton.icon(
          textColor: Theme.of(context).primaryColor,
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text("Change Image"),
        ),
      ],
    );
  }
}
