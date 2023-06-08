import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_firestroe/model/user_model.dart';

Future createUser(User user) async {
  final docUser = FirebaseFirestore.instance.collection('users').doc();
  user.id = docUser.id;

  final json = user.toJson();
  await docUser.set(json);
}

Stream<List<User>> readUsers(User user) => FirebaseFirestore.instance
    .collection('users')
    .snapshots()
    .map((event) => event.docs.map((e) => User.fromJson(e.data())).toList());

// Future<User?> readUser() async {
//   final docUser = FirebaseFirestore.instance.collection('users').doc('my-id');
//   final snapshot = await docUser.get();

//   if (snapshot.exists) {
//     return User.fromJson(snapshot.data()!);
//   }
// 

