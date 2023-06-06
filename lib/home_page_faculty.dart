import 'dart:typed_data';

import 'package:docvault/main.dart';
import 'package:flutter/material.dart';
import 'package:docvault/models/student.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/faculty.dart';

// ignore: must_be_immutable
class HomePageFaculty extends StatefulWidget {
  Faculty faculty;

  HomePageFaculty(this.faculty);

  @override
  State<HomePageFaculty> createState() => _HomePageFacultyState();
}

class _HomePageFacultyState extends State<HomePageFaculty> {
  viewUploadedFiles() async {
    var storageRef = FirebaseStorage.instance.ref().child('Users');
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
                          'Name  :' " " "${widget.faculty.name}",
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
                          'Usn  :' " " "${widget.faculty.usn}",
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
                          'DOB  :' " " "${widget.faculty.dob}",
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
                          'Experience  :' " " "${widget.faculty.sem}",
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
                    child: const Text('View uploaded documents '),
                  ),
                ),
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
        label: const Text('Logout !'),
        icon: const Icon(Icons.logout),
        backgroundColor: Colors.red,
      ),
    );
  }
}
