import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewState();
  }
}

class NewState extends State<NewScreen> {
  final _formkey = GlobalKey<FormState>();
  CollectionReference _store = Firestore.instance.collection('todo');
  TextEditingController title = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Subject"),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Form(
          key: _formkey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: title,
                decoration: InputDecoration(
                  labelText: "Subject",
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please fill subject";
                  }
                },
              ),
              RaisedButton(
                child: Text("Save"),
                onPressed: () {
                  if (_formkey.currentState.validate()) {
                    _store.add({"title": title.text, "done": 0});
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
