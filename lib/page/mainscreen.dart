import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile/services/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreServices firestoreService = FirestoreServices();

  final TextEditingController textController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  void openNoteBox({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (docID == null) {
                firestoreService.addNote(textController.text);
              } else {
                firestoreService.updateNote(docID, textController.text);
              }

              textController.clear();

              Navigator.pop(context);
            },
            child: const Text('Add'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Color.fromARGB(255, 200, 61, 255),
      //   title: const Text(
      //     'build 0.0.2',
      //     style: TextStyle(fontSize: 14, color: Colors.white),
      //   ),
      //   actions: [
      //     Text(
      //       'id: ${user.uid}',
      //       style: TextStyle(color: Colors.white),
      //     ),
      //     IconButton(
      //       onPressed: signUserOut,
      //       icon: const Icon(Icons.logout_sharp),
      //       color: Colors.white,
      //     ),
      //   ],
      // ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;

            return ListView.builder(
                itemCount: notesList.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = notesList[index];
                  String docID = document.id;

                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  String name = data['name'];
                  String phone = data['phone'];
                  String services = data['services'];
                  // print('----------------------$services-----------------------');

                  return ListTile(
                      title: Text(name,
                      style: const TextStyle(
                                            decoration: TextDecoration.none,
                                            fontSize: 20,
                                            color: Color(0xff1b1850),
                                            fontFamily: 'UrbanistRoman-SemiBold',
                                            fontWeight: FontWeight.normal),
                                        maxLines: 9999,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0,0,450,0),
                            child: Text(phone,
                            style: const TextStyle(
                                      decoration: TextDecoration.none,
                                            fontSize: 20,
                                            color: Color(0xff1b1850),
                                            fontFamily: 'UrbanistRoman-SemiBold',
                                            fontWeight: FontWeight.normal),
                                        maxLines: 9999,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0,0,0,0),
                            child: Text(services,
                            style: const TextStyle(
                                            decoration: TextDecoration.none,
                                            fontSize: 20,
                                            color: Color(0xff1b1850),
                                            fontFamily: 'UrbanistRoman-SemiBold',
                                            fontWeight: FontWeight.normal),
                                        maxLines: 9999,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0,0,0,0),
                            child: IconButton(
                                onPressed: () => openNoteBox(docID: docID),
                                icon: const Icon(Icons.edit)),
                          ),
                          IconButton(
                              onPressed: () =>
                                  firestoreService.deleteNote(docID),
                              icon: const Icon(Icons.delete)),
                        ],  
                      )
                      );

                });
          } else {
            return const Text('No notes');
          }
        },
      ),
      // bottomNavigationBar: GNav(
      //   backgroundColor: Colors.white,
      //   tabBorderRadius: 15,
      //   tabActiveBorder:
      //       Border.all(color: const Color.fromARGB(255, 200, 61, 255)),
      //   activeColor: const Color.fromARGB(255, 200, 61, 255),
      //   padding: const EdgeInsets.all(16),
      //   gap: 6,
      //   tabs: const [
      //     GButton(
      //       icon: Icons.bar_chart,
      //       text: 'Статистика',
      //     ),
      //     GButton(icon: Icons.lock_clock, text: 'Учёт'),
      //     GButton(
      //       icon: Icons.settings,
      //       text: 'Параметры',
      //     )
      //   ],
      // ),
    );
  }
}
