import 'package:docvault/home_page_faculty.dart';
import 'package:docvault/home_page_for_student.dart';
// import 'package:docvault/models/faculty.dart';
import 'package:docvault/models/student.dart';
import 'package:flutter/material.dart';

import 'models/faculty.dart';

class FacultyLogin extends StatefulWidget {
  final bool isFaculty;

  const FacultyLogin({
    Key? key,
    required this.isFaculty,
  }) : super(key: key);

  @override
  State<FacultyLogin> createState() => _FacultyLoginState();
}

class _FacultyLoginState extends State<FacultyLogin> {
  @override
  Widget build(BuildContext context) {
//

    List<Student> students = [
      Student('Test', '1', 'sem', 'dob', '12345'),
      Student('Shreyas', '2', 'sem', 'dob', '12345'),
      Student('Shre', '3', 'sem', 'dob', '12345'),
      Student('Varun', '4', 'sem', 'dob', '12345'),
      Student('Deepak', '5', 'sem', 'dob', '12345'),
    ];
    List<Faculty> faculty = [
      Faculty('Faculty', '10', 'Asst. Professor', 'dob', '12345'),
      Faculty('Shreyas A T', '20', 'sem', 'dob', '12345'),
      Faculty('Test', '30', 'sem', 'dob', '12345'),
      Faculty('Test2', '40', 'sem', 'dob', '12345'),
      Faculty('Test3', '50', 'sem', 'dob', '12345'),
    ];

//

    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    GlobalKey<FormState> formKey1 = GlobalKey<FormState>();

    TextEditingController usernameController1 = TextEditingController();
    TextEditingController usernameController2 = TextEditingController();

    @override
    void dispose() {
      usernameController1.dispose();
      usernameController2.dispose();
      super.dispose();
    }

    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Colors.amber,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width / 2.5,
              child: Image.asset(
                'assets/images/loginpageimage.png',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width * 0.6,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.28,
                  ),
                  widget.isFaculty == true
                      ? Container(
                          child: const Text(
                            "Faculty Login - ",
                            style: TextStyle(fontSize: 40),
                          ),
                        )
                      : Container(
                          child: const Text(
                            "Student Login - ",
                            style: TextStyle(fontSize: 40),
                          ),
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    width: 320,
                    margin: const EdgeInsets.all(10),
                    child: Form(
                      key: formKey,
                      child: TextFormField(
                        controller: usernameController1,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: const TextStyle(color: Colors.blue),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a Username .';
                          }
                          // Add additional validation rules as needed
                          return null; // Return null if the value is valid
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 320,
                    margin: const EdgeInsets.all(10),
                    child: Form(
                      key: formKey1,
                      child: TextFormField(
                        controller: usernameController2,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.blue),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a password.';
                          }
                          // Add additional validation rules as needed
                          return null; // Return null if the value is valid
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    height: 50,
                    width: 320,
                    margin: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () {
                        //student logic
                        if (formKey.currentState!.validate() != true &&
                            formKey1.currentState!.validate() != true) {
                          return;
                        }
                        bool isStudentNamePresent = students
                            .where((student) =>
                                student.usn ==
                                usernameController1.text.trim().toString())
                            .isNotEmpty;
                        bool isStudentPasswordPresent = students
                            .where((student) =>
                                student.password ==
                                usernameController2.text.trim().toString())
                            .isNotEmpty;
                        late Student student1;
                        if (isStudentPasswordPresent &&
                            isStudentNamePresent &&
                            !widget.isFaculty == true) {
                          student1 = students.firstWhere(
                            (student) =>
                                student.usn ==
                                usernameController1.text.trim().toString(),
                            orElse: () => Student('', '', '', '', ''),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePageStudent(
                                student: student1,
                              ),
                            ),
                          );
                        } else {
                          print('nothing');
                        }

                        bool isFacultyNamePresent = faculty
                            .where((student) =>
                                student.usn ==
                                usernameController1.text.trim().toString())
                            .isNotEmpty;
                        bool isFacultyPasswordPresent = faculty
                            .where((student) =>
                                student.password ==
                                usernameController2.text.trim().toString())
                            .isNotEmpty;
                        late Faculty faculty1;

                        if (isFacultyNamePresent &&
                            isFacultyPasswordPresent &&
                            widget.isFaculty == true) {
                          faculty1 = faculty.firstWhere(
                            (student) =>
                                student.usn ==
                                usernameController1.text.trim().toString(),
                            orElse: () => Faculty('', '', '', '', ''),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePageFaculty(faculty1),
                            ),
                          );
                        } else {
                          print('notstudent');
                        }

                        if (isFacultyPasswordPresent &&
                            isStudentPasswordPresent == false) {
                          return;
                        }
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
                      child: const Text('Login  '),
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
