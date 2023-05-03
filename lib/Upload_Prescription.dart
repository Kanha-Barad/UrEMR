
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpLoadPrescrIPtioN extends StatefulWidget {
  const UpLoadPrescrIPtioN({Key? key}) : super(key: key);

  @override
  _UpLoadPrescrIPtioNState createState() => _UpLoadPrescrIPtioNState();
}

class _UpLoadPrescrIPtioNState extends State<UpLoadPrescrIPtioN> {

  final ImagePicker _picker = ImagePicker();
  File? file;
  List<File?> files = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Picjer"),
        actions: [
          IconButton(onPressed: ()async{

            XFile? photo = await _picker.pickImage(source: ImageSource.camera);

            if(photo==null){

            }else{
              setState(() {
                file = File(photo.path);
                files.add(File(photo.path));
              });
            }

          }, icon: Icon(Icons.camera)),
          IconButton(onPressed: ()async{

            XFile? photo = await _picker.pickImage(source: ImageSource.gallery);

            if(photo==null){

            }else{
              setState(() {
                file = File(photo.path);
               files.add(File(photo.path));
              });
            }

          }, icon: Icon(Icons.image))
        ],
      ),
      body: 
      
      ListView.builder(
          itemCount: files.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index){
        return Container(
          child:files[index]==null?Text("No Image Selected") : Image.file(files[index]!),
        );
      }),
    );
  }
}
