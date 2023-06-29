import 'package:docvault/main.dart';

import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:url_launcher/url_launcher.dart';

import 'models/faculty.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: must_be_immutable
class HomePageFaculty extends StatefulWidget {
  Faculty faculty;

  HomePageFaculty(this.faculty);

  @override
  State<HomePageFaculty> createState() => _HomePageFacultyState();
}

class _HomePageFacultyState extends State<HomePageFaculty> {
  //

  //

  //
  dynamic createUserNode(usn, String textValue, String fileName) async {
    try {
      final userDocRef =
          FirebaseFirestore.instance.collection('Users').doc('$usn');

      final subcollectionRef = userDocRef.collection('alpha');
      var myStr = "File Name ->  $fileName ---$textValue";
      await subcollectionRef.add({'text': myStr});

      Fluttertoast.showToast(
        msg: 'User document created successfully!',
        textColor: Colors.black,
        backgroundColor: Colors.white,
      );
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Failed to create user document. Error: $error',
        textColor: Colors.black,
        backgroundColor: Colors.white,
      );
    }
  }

  viewUploadedFilesForAccepted(usn) async {
    var storageRef = FirebaseStorage.instance.ref().child('Accepted/$usn');
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

  viewUploadedFilesForRejected(usn) async {
    var storageRef = FirebaseStorage.instance.ref().child('Rejected/$usn');
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

  dynamic dialogueShower(names, usn) async {
    var storageRef = FirebaseStorage.instance.ref().child('Users/$usn');
    var result = await storageRef.listAll();
    List<String> downloadUrls = [];
    List<String> fileNames = [];
    for (var fileRef in result.items) {
      var downloadUrl = await fileRef.getDownloadURL();
      var fileName = fileRef.name;
      downloadUrls.add(downloadUrl);
      fileNames.add(fileName);
    }

    void showTextDialog(int index, int usn) async {
      String textValue = ''; // Variable to store the entered text

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Enter the reason for rejection !'),
            content: TextFormField(
              onChanged: (value) {
                textValue =
                    value; // Update the textValue variable as the user types
              },
              decoration: InputDecoration(
                hintText: 'Enter your text !',
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  // Do something with the entered text
                  print('Entered text: $textValue');
                  await createUserNode(usn, textValue, fileNames[index]);
                  // send this to the data base
                  await FirebaseStorage.instance
                      .ref('Users/$usn/${fileNames[index]}')
                      .delete();

                  var acceptedRef = FirebaseStorage.instance
                      .ref('Rejected/$usn/${fileNames[index]}');
                  var fileUrl = downloadUrls[index];

                  await acceptedRef.putString(fileUrl);
                  if (fileUrl == true) {
                    Fluttertoast.showToast(
                      msg: "Something went wrong ",
                      textColor: Colors.black,
                      backgroundColor: Colors.white,
                      // webBgColor: Colors.white,
                    );
                  } else {
                    Fluttertoast.showToast(
                        msg: "File rejected",
                        textColor: Colors.red,
                        backgroundColor: Colors.white);
                  }

                  print(
                      'Item accepted and moved to the Accepted collection in Firebase Storage.');
                  Navigator.pop(context); // Close the dialog
                },
                child: Text('Submit'),
              ),
            ],
          );
        },
      );
    }
//recent funciton above

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Uploaded Files'),
          content: Column(
            children: [
              Container(
                height: 300,
                width: 800,
                child: ListView.builder(
                  itemCount: downloadUrls.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Text("${index + 1}) " + fileNames[index]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              showTextDialog(index, usn);
                              // //  createUserNode(usn);
                              // await FirebaseStorage.instance
                              //     .ref('Users/$usn/${fileNames[index]}')
                              //     .delete();

                              // var acceptedRef = FirebaseStorage.instance
                              //     .ref('Rejected/$usn/${fileNames[index]}');
                              // var fileUrl = downloadUrls[index];

                              // await acceptedRef.putString(fileUrl);
                              // if (fileUrl == true) {
                              //   Fluttertoast.showToast(
                              //     msg: "Something went wrong ",
                              //     textColor: Colors.black,
                              //     backgroundColor: Colors.white,
                              //     // webBgColor: Colors.white,
                              //   );
                              // } else {
                              //   Fluttertoast.showToast(
                              //       msg: "File rejected",
                              //       textColor: Colors.red,
                              //       backgroundColor: Colors.white);
                              // }

                              // print(
                              //     'Item accepted and moved to the Accepted collection in Firebase Storage.');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text('Reject  '),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await FirebaseStorage.instance
                                  .ref('Users/$usn/${fileNames[index]}')
                                  .delete();

                              var acceptedRef = FirebaseStorage.instance
                                  .ref('Accepted/$usn/${fileNames[index]}');
                              var fileUrl = downloadUrls[index];

                              await acceptedRef.putString(fileUrl);
                              if (fileUrl == true) {
                                Fluttertoast.showToast(
                                  msg: "Something went wrong ",
                                  textColor: Colors.black,
                                  backgroundColor: Colors.white,
                                  // webBgColor: Colors.white,
                                );
                              } else {
                                Fluttertoast.showToast(
                                    msg: "File accepted",
                                    textColor: Colors.black,
                                    backgroundColor: Colors.white);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text('Accept  '),
                          ),
                        ],
                      ),
                      onTap: () {
                        launchUrl(Uri.parse(downloadUrls[index]));
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) =>
                        //         PdfViewer(downloadUrl: downloadUrls[index]),
                        //   ),
                        // );
                      },
                    );
                  },
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 60,
                    width: 220,
                    margin: EdgeInsets.all(15),
                    child: ElevatedButton(
                      onPressed: () async {
                        // await viewUploadedFiles();
                        await viewUploadedFilesForAccepted(usn);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                        ),
                        textStyle: const TextStyle(fontSize: 20.0),
                      ),
                      child: const Text('Accepted documents'),
                    ),
                  ),
                  Container(
                    height: 60,
                    width: 220,
                    margin: EdgeInsets.all(15),
                    child: ElevatedButton(
                      onPressed: () async {
                        // await viewUploadedFiles();
                        await viewUploadedFilesForRejected(usn);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                        ),
                        textStyle: const TextStyle(fontSize: 20.0),
                      ),
                      child: const Text('Rejected documents'),
                    ),
                  ),
                ],
              )
              // do it here
            ],
          ),
        );
      },
    );
  }

  viewUploadedFiles() async {
    List<String> names = ['Test', 'Shreyas', 'Shre', 'Varun', 'Deepak'];
    List<int> usn = [1, 2, 3, 4, 5];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('All listed users are :'),
          content: Container(
            height: 450,
            width: 400,
            child: ListView.builder(
              itemCount: names.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(names[index]),
                  onTap: () async {
                    //
                    await dialogueShower(names[index], usn[index]);
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
                          'Designation  :' " " "${widget.faculty.sem}",
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
        label: const Text('Logout '),
        icon: const Icon(Icons.logout),
        backgroundColor: Colors.red,
      ),
    );
  }
}
