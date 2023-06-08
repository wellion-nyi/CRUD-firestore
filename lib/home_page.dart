import 'package:crud_firestroe/controller/user_controller.dart';
import 'package:crud_firestroe/model/user_model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          TextField(
            controller: nameController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'Enter name'),
          ),
          const SizedBox(
            height: 4,
          ),
          TextField(
            controller: ageController,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(labelText: 'Enter age'),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty ||
                    ageController.text.isNotEmpty) {
                  final user = User(
                      name: nameController.text,
                      age: int.parse(
                        ageController.text,
                      ));
                  createUser(user);
                  Navigator.pop(context);
                } else {
                  const SnackBar(content: Text('Fill all field'));
                }
              },
              child: const Text("Create"))
        ]),
      ),
    );
  }
}
