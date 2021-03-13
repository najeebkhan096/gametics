import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class Upload_image extends StatefulWidget {
  @override
  _Upload_imageState createState() => _Upload_imageState();
}

class _Upload_imageState extends State<Upload_image> {
  @override


  File _image;
  File _image2;
  final picker = ImagePicker();

  Future getGalleryImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getCameraImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image2 = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }




  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    return FlatButton(
      minWidth:  mediaquery.size.height * 0.7,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(80),
        side: BorderSide(color: Colors.teal, width: 1.3),
      ),
      child: FittedBox(
        fit: BoxFit.fill,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 22, top: 6, right: 10, bottom: 6),
          child: Row(
            children: [
              Icon(
                Icons.upload_rounded,
                color: Colors.teal,
                size: 35,
              ),
              SizedBox(
                width:22,
              ),
              Text(
                "Upload Your Certificates",
                style: TextStyle(
                    color: Colors.teal,
                    fontSize: 21,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      onPressed: () {
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                actionsPadding: EdgeInsets.only(right: 80),
                actions: [
                  Column(children: [
                    FlatButton(
                        onPressed: (){
                          getCameraImage();
                          Navigator.of(context).pop();

                        },
                        child: Text("Camera",style: TextStyle(fontSize: 17,color: Colors.black),)),
                    FlatButton(
                      onPressed: (){
                        getGalleryImage();
                        Navigator.of(context).pop();

                      },
                      child: Text("Gallery",style: TextStyle(fontSize: 17,color: Colors.black),),
                    ),],)


                ],
              );
            });
      },
    );
  }
}
