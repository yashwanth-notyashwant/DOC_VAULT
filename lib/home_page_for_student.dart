import 'dart:typed_data';

import 'package:docvault/main.dart';
import 'package:flutter/material.dart';
import 'package:docvault/models/student.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: must_be_immutable
class HomePageStudent extends StatefulWidget {
  Student student;

  HomePageStudent({
    super.key,
    required this.student,
  });

  @override
  State<HomePageStudent> createState() => _HomePageStudentState();
}

class _HomePageStudentState extends State<HomePageStudent> {
  Uint8List? fileBytes;

  String url = "";
  var name;

  getfile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'png', 'jpeg'],
    );

    if (result != null) {
      Uint8List bytes = result.files.single.bytes!;
      setState(() {
        name = result.files.single.name;
      });
      uploadFile(bytes);
    }
  }

  uploadFile(Uint8List bytes) async {
    try {
      var imagefile = FirebaseStorage.instance
          .ref()
          .child("Users/${widget.student.usn}")
          .child("/$name");
      UploadTask task = imagefile.putData(bytes);
      TaskSnapshot snapshot = await task;
      url = await snapshot.ref.getDownloadURL();

      print(url);
      // ignore: unnecessary_null_comparison
      if (url != null && bytes != null) {
        Fluttertoast.showToast(
          msg: "Done Uploaded",
          textColor: Colors.black,
          backgroundColor: Colors.white,
          // webBgColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
            msg: "Something went wrong",
            textColor: Colors.red,
            backgroundColor: Colors.white);
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          textColor: Colors.black,
          backgroundColor: Colors.white);
    }
  }

  viewUploadedFiles() async {
    var storageRef =
        FirebaseStorage.instance.ref().child('Users/${widget.student.usn}');
    var result = await storageRef.listAll();
    List<String> downloadUrls = [];
    List<String> fileNames = [];
    for (var fileRef in result.items) {
      var downloadUrl = await fileRef.getDownloadURL();
      var fileName = fileRef.name;
      downloadUrls.add(downloadUrl);
      fileNames.add(fileName);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Uploaded Files'),
          content: Container(
            height: 450,
            width: 800,
            child: ListView.builder(
              itemCount: downloadUrls.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(fileNames[index]),
                  onTap: () {
                    launchUrl(Uri.parse(downloadUrls[index]));
                    // Handle the download action here
                    // You can use the downloadUrls[index] to download the file
                    // Example: launch(url) to open the file in a browser or download manager
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  // Fetch messages from Firestore
  Future<List<Map<String, dynamic>>> fetchMessages(String usn) async {
    List<Map<String, dynamic>> messages = [];

    try {
      final userDocRef =
          FirebaseFirestore.instance.collection('Users').doc(usn);
      final subcollectionRef = userDocRef.collection('alpha');
      final querySnapshot = await subcollectionRef.get();

      querySnapshot.docs.forEach((doc) {
        messages.add(doc.data());
      });
    } catch (error) {
      print('yashwanth error Failed to fetch messages. Error: $error');
    }

    return messages;
  }

  // Display dialog with ListView.builder
  dynamic showMessagesDialog(BuildContext context, String usn) async {
    List<Map<String, dynamic>> messages = await fetchMessages(usn);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Uploaded Files'),
          content: Container(
            height: 450,
            width: 800,
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index]['text']),
                  onTap: () {
                    // Handle the onTap action here
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

// here is what is I added on thursday up above

  viewUploadedFilesForAccepted() async {
    var storageRef =
        FirebaseStorage.instance.ref().child('Accepted/${widget.student.usn}');
    var result = await storageRef.listAll();
    List<String> downloadUrls = [];
    List<String> fileNames = [];
    for (var fileRef in result.items) {
      var downloadUrl = await fileRef.getDownloadURL();
      var fileName = fileRef.name;
      downloadUrls.add(downloadUrl);
      fileNames.add(fileName);
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Accepted Files'),
          content: Container(
            height: 450,
            width: 800,
            child: ListView.builder(
              itemCount: downloadUrls.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(fileNames[index]),
                  onTap: () {
                    launchUrl(Uri.parse(downloadUrls[index]));
                    // Handle the download action here
                    // You can use the downloadUrls[index] to download the file
                    // Example: launch(url) to open the file in a browser or download manager
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  viewUploadedFilesForRejected() async {
    var storageRef =
        FirebaseStorage.instance.ref().child('Rejected/${widget.student.usn}');
    var result = await storageRef.listAll();
    List<String> downloadUrls = [];
    List<String> fileNames = [];
    for (var fileRef in result.items) {
      var downloadUrl = await fileRef.getDownloadURL();
      var fileName = fileRef.name;
      downloadUrls.add(downloadUrl);
      fileNames.add(fileName);
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rejected  Files'),
          content: Container(
            height: 450,
            width: 800,
            child: ListView.builder(
              itemCount: downloadUrls.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(fileNames[index]),
                  onTap: () {
                    launchUrl(Uri.parse(downloadUrls[index]));
                    // Handle the download action here
                    // You can use the downloadUrls[index] to download the file
                    // Example: launch(url) to open the file in a browser or download manager
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.5,
                color: Colors.blue,
                child: Image.asset(
                  'assets/images/profilepic.png',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.5,
                color: Colors.blue,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 60,
                      width: 350,
                      margin: EdgeInsets.all(5),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                        ),
                        child: Text(
                          'Name  :' " " "${widget.student.name}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 60,
                      width: 350,
                      margin: EdgeInsets.all(5),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                        ),
                        child: Text(
                          'Usn  :' " " "${widget.student.usn}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 60,
                      width: 350,
                      margin: EdgeInsets.all(5),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                        ),
                        child: Text(
                          'DOB  :' " " "${widget.student.dob}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 60,
                      width: 350,
                      margin: EdgeInsets.all(5),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                        ),
                        child: Text(
                          'Sem  :' " " "${widget.student.sem}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 60,
                  width: 400,
                  margin: EdgeInsets.all(15),
                  child: ElevatedButton(
                    onPressed: () {
                      getfile();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      textStyle: const TextStyle(fontSize: 20.0),
                    ),
                    child: const Text('Upload Documents '),
                  ),
                ),
                Container(
                  height: 60,
                  width: 400,
                  margin: EdgeInsets.all(15),
                  child: ElevatedButton(
                    onPressed: () async {
                      await viewUploadedFiles();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      textStyle: const TextStyle(fontSize: 20.0),
                    ),
                    child: const Text('View Pending documents '),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 60,
                      width: 120,
                      margin: EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () async {
                          // await viewUploadedFiles();
                          await viewUploadedFilesForAccepted();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                          ),
                          textStyle: const TextStyle(fontSize: 20.0),
                        ),
                        child: const Text('Accepted'),
                      ),
                    ),
                    Container(
                      height: 60,
                      width: 120,
                      margin: EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () async {
                          // await viewUploadedFiles();
                          await viewUploadedFilesForRejected();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                          ),
                          textStyle: const TextStyle(fontSize: 20.0),
                        ),
                        child: const Text('Rejected'),
                      ),
                    ),
                    Container(
                      height: 60,
                      width: 120,
                      margin: EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () async {
                          // await viewUploadedFiles();
                          // await viewUploadedFilesForRejected();
                          await showMessagesDialog(context, widget.student.usn);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                          ),
                          textStyle: const TextStyle(fontSize: 15.0),
                        ),
                        child: const Text('Notificatoins'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MyHomePage(
                      title: "proj",
                    )),
          );
        },
        label: const Text('Logout '),
        icon: const Icon(Icons.logout),
        backgroundColor: Colors.red,
      ),
    );
  }
}
