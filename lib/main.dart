import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_firestroe/edit_delete/edit_page.dart';
import 'package:crud_firestroe/home_page.dart';
import 'package:crud_firestroe/model/user_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final CollectionReference _product =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
      ),
      body: StreamBuilder(
        stream: _product.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final users = snapshot.data!;

            return ListView.builder(
              itemCount: users.docs.length,
              itemBuilder: (context, index) {
                final docSnapshot = users.docs[index];
                return ListTile(
                  title: Text(
                    docSnapshot['name'],
                  ),
                  subtitle: Text(docSnapshot['age'].toString()),
                  trailing: Wrap(spacing: 12, children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (contect) => EditePage(
                                      name: docSnapshot['name'],
                                      age: int.parse(
                                          docSnapshot['age'].toString()),
                                      id: docSnapshot['id'],
                                    )));
                      },
                      child: const Icon(
                        Icons.edit,
                        color: Colors.green,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final docData = await FirebaseFirestore.instance
                            .collection("users")
                            .doc(docSnapshot['id'])
                            .delete();
                      },
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    )
                  ]),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Widget buildUser(User user) => ListTile(
//       leading: CircleAvatar(
//         child: Text('${user.age}'),
//       ),
//       title: Text(user.name.toString()),
//     );
