import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TodoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TodoState();
  }
}

class TodoState extends State<TodoScreen> {
  CollectionReference _store = Firestore.instance.collection('todo');
  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> appBarActions = [
      IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, "/newScreen");
        },
      ),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          setState(() {
            _store.where('done', isEqualTo: 1).getDocuments().then((doc) {
              for (DocumentSnapshot item in doc.documents) {
                item.reference.delete();
              }
            });
          });
        },
      )
    ];
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Todo"),
          actions: <Widget>[appBarActions[tabIndex]],
        ),
        body: TabBarView(
          children: <Widget>[
            StreamBuilder(
              stream: _store.where("done", isEqualTo: 0).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData && snapshot.data.documents.length > 0) {
                  return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot item =
                          snapshot.data.documents.elementAt(index);
                      return CheckboxListTile(
                        title: Text("${item.data['title']}"),
                        value: item.data['done'] == 1,
                        onChanged: (bool value) {
                          setState(() {
                            item.reference.updateData({"done": 1});
                          });
                        },
                      );
                    },
                  );
                } else {
                  return Center(child: Text("No data found.."));
                }
              },
            ),
            StreamBuilder(
              stream: _store.where("done", isEqualTo: 1).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData && snapshot.data.documents.length > 0) {
                  return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot item =
                          snapshot.data.documents.elementAt(index);
                      return CheckboxListTile(
                        title: Text("${item.data['title']}"),
                        value: item.data['done'] == 1,
                        onChanged: (bool value) {
                          setState(() {
                            item.data['done'] = 1;
                            item.reference.updateData({"done": 0});
                          });
                        },
                      );
                    },
                  );
                } else {
                  return Center(child: Text("No data found.."));
                }
              },
            ),
          ],
        ),
        bottomNavigationBar: TabBar(
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.blue,
          indicatorColor: Colors.blue,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.list),
              text: "Task",
            ),
            Tab(
              icon: Icon(Icons.done_all),
              text: "Completed",
            ),
          ],
          onTap: (index) {
            setState(() {
              tabIndex = index;
            });
          },
        ),
      ),
    );
  }
}
