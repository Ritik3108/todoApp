// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskDetails extends StatelessWidget {
  QueryDocumentSnapshot<Map<String, dynamic>> docs;
  TaskDetails({required this.docs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Task Detail'),
        ),
        body: SafeArea(
            child: Container(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: ListView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(docs['url']),
                      ),
                      title: Text(
                        docs['name'],
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            docs['desc'],
                            style: const TextStyle(
                                color: Color(0xff0395eb),
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            DateFormat('dd MMM yyyy')
                                .format(docs['date'].toDate()),
                            style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ))));
  }
}
