// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_firestroe/controller/user_controller.dart';
import 'package:crud_firestroe/model/user_model.dart';
import 'package:flutter/material.dart';

class EditePage extends StatefulWidget {
  final String? name;
  final int? age;
  final String? id;
  const EditePage(
      {super.key, required this.name, required this.age, required this.id});

  @override
  State<EditePage> createState() => _EditePageState();
}

class _EditePageState extends State<EditePage> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  bool showProgressIndicator = false;

  @override
  void initState() {
    nameController.text = widget.name!;
    ageController.text = widget.age.toString();
    super.initState();
  }

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
        title: const Text('Edit Task'),
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
          MaterialButton(
            onPressed: () async {
              setState(() {});
              if (nameController.text.isEmpty || ageController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Fill in all fields")));
              } else {
                final docUser = FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.id!.isNotEmpty ? widget.id : null);
                String docID = '';
                if (widget.id!.isNotEmpty) {
                  docID = widget.id!;
                } else {
                  docID = docUser.id;
                }
                final jsonData = {
                  'name': nameController.text,
                  'age': int.parse(ageController.text),
                  'id': docID,
                };
                showProgressIndicator = true;
                if (widget.id!.isEmpty) {
                  await docUser.set(jsonData).then((value) {
                    nameController.text = '';
                    ageController.text = '';
                    showProgressIndicator = false;
                    setState(() {});
                  });
                } else {
                  await docUser.update(jsonData).then((value) {
                    nameController.text = '';
                    ageController.text = '';
                    showProgressIndicator = false;
                    setState(() {});
                  });
                }
              }
              Navigator.pop(context);
            },
            minWidth: double.infinity,
            height: 50,
            color: Colors.red.shade400,
            child: showProgressIndicator
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Text(
                    'Update',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w300),
                  ),
          )
        ]),
      ),
    );
  }
}
