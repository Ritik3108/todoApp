import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/dialog.dart';
import 'package:todoapp/taskDetails.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<bool> strikes = [];
  List<DateTime> date = [];
  DateTime? dateTime;
  final myController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _saveTask(String desc, String url) {
    final taskName = myController.text;
    FirebaseFirestore.instance.collection('task').add({
      "name": taskName,
      "url": url,
      "desc": desc,
      "date": DateTime.now(),
      "strike": false
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Todo'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Text("TODO APP"),
            const Divider(
              height: 4,
              color: Colors.black,
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('task')
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return const CircularProgressIndicator();
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.isEmpty) {
                      return Container(
                        height: 200,
                        width: 300,
                        color: Colors.red,
                        child: const Center(
                          child: Text(
                            'NO TASK TO DO!',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      );
                    } else {
                      final messages = snapshot.data!.docs;
                      date = [];
                      strikes = [];
                      if (messages.isNotEmpty) {
                        for (var message in messages) {
                          strikes.add(message['strike']);
                          date.add(message['date'].toDate());
                        }
                      }
                    }

                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        itemBuilder: (_, int index) {
                          return Dismissible(
                            key: UniqueKey(),
                            onDismissed: (dir) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: const Text("Are you sure?"),
                                  actions: [
                                    // ignore: deprecated_member_use
                                    TextButton(
                                      child: const Text("No Thanks"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        setState(() {});
                                      },
                                    ),
                                    // ignore: deprecated_member_use
                                    TextButton(
                                      child: const Text("Yes"),
                                      onPressed: () async {
                                        FirebaseFirestore.instance
                                            .collection("task")
                                            .doc(snapshot.data!.docs[index].id)
                                            .delete();
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                ),
                              );
                            },
                            child: ListTile(
                              dense: true,
                              minLeadingWidth: 5,
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => TaskDetails(
                                          docs: snapshot.data!.docs[index],
                                        )));
                              },
                              title: Row(
                                children: [
                                  Expanded(
                                    child: CheckboxListTile(
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      title: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data!.docs[index]
                                                  ['name'],
                                              style: TextStyle(
                                                  decoration: strikes[index]
                                                      ? TextDecoration
                                                          .lineThrough
                                                      : null,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              maxLines: 1,
                                            ),
                                            Text(
                                              snapshot.data!.docs[index]
                                                  ['desc'],
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      value: strikes[index],
                                      onChanged: (val) {
                                        setState(() {
                                          strikes[index] = val!;
                                          FirebaseFirestore.instance
                                              .collection("task")
                                              .doc(
                                                  snapshot.data!.docs[index].id)
                                              .update({
                                            "strike":
                                                strikes[index] ? true : false
                                          });
                                        });
                                      },
                                    ),
                                  ),
                                  Text(DateFormat('dd MMM yyyy')
                                      .format(date[index])),
                                ],
                              ),
                              trailing: ElevatedButton(
                                child: const Text(
                                  'DELETE',
                                ),
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection("task")
                                      .doc(snapshot.data!.docs[index].id)
                                      .delete();
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return const SizedBox();
                }),
            const Divider(
              height: 1,
              color: Colors.black,
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: _formKey,
                    child: SizedBox(
                      width: 150,
                      child: TextFormField(
                        controller: myController,
                        decoration: InputDecoration(
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            hintText: 'Enter the Task'),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Enter Something';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 200,
                    height: 58,
                    child: ElevatedButton(
                      child: const Text(
                        '+ADD',
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await showDialogs(context: context).then((value) {
                            _saveTask(value['desc'], value['url']);
                          });
                          myController.clear();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
