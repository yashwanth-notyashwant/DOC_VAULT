import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import './login_as.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseOptions options = FirebaseOptions(
    appId: '1:131190517366:android:8b7b9343d7878df5d5f957',
    apiKey: 'AIzaSyA-txHHKbk-R1YwDBLTKKmQ2WaqfQQhVhE',
    projectId: 'doc-vault-59492', messagingSenderId: '131190517366',
    // Add other necessary configuration options
    storageBucket: 'doc-vault-59492.appspot.com',
  );
  await Firebase.initializeApp(
    // name: 'docvault',
    options: options,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var a = MediaQuery.of(context).size;
    var b = (a.width / 4) - 200;
    var c = (a.height / 4) - 50;
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width * 0.5,
              child: Image.asset(
                'assets/images/easydocs.png',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: c, horizontal: b),
              child: Column(
                children: [
                  Container(
                    child: const Text(
                      "Login as -",
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(20)),
                  Container(
                    height: 100,
                    width: 350,
                    margin: const EdgeInsets.all(5),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FacultyLogin(
                              isFaculty: false,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25.0),
                            topRight: Radius.circular(25.0),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        textStyle: const TextStyle(fontSize: 20.0),
                      ),
                      child: const Text('Student'),
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 350,
                    margin: const EdgeInsets.all(5),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FacultyLogin(
                                    isFaculty: true,
                                  )),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25.0),
                            bottomRight: Radius.circular(25.0),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        textStyle: const TextStyle(fontSize: 20.0),
                      ),
                      child: const Text('Faculty'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
