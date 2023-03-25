import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes/data/account_service.dart';
import 'package:notes/data/firebase_service.dart';

import '../crud/edit_note.dart';
import '../crud/view_note.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  FirebaseService firebaseService = FirebaseService();
  AccountService accountService = AccountService();

  @override
  void initState() {
    if (accountService.currentUser == null) {
      Navigator.of(context).pushReplacementNamed('/log_in');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () async {
                accountService.signOut().then((value) {
                  Navigator.of(context).pushReplacementNamed("/log_in");
                });
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed("/add_note");
          }),
      body: FutureBuilder(
          future: firebaseService.getNotes(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, i) {
                    return Dismissible(

                      // todo del note
                        onDismissed: (direction) async {
                          // await notesRef
                          //     .doc(snapshot.data?.docs[i].id)
                          //     .delete();
                          // await FirebaseStorage.instance
                          //     .refFromURL(snapshot.data?.docs[i]['imageUrl'])
                          //     .delete();
                        },
                        key: UniqueKey(),
                        child: NoteItem(
                          note: snapshot.data?.docs[i],
                          noteId: snapshot.data?.docs[i].id,
                        ));
                  });
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}

class NoteItem extends StatelessWidget {
  final QueryDocumentSnapshot? note;
  final String? noteId;
  const NoteItem({super.key, required this.note, required this.noteId});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ViewNote(note: note);
        }));
      },
      child: Card(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Image.network(
                "${note!['imageUrl']}",
                fit: BoxFit.fill,
                height: 80,
              ),
            ),
            Expanded(
              flex: 3,
              child: ListTile(
                title: Text("${note!['title']}"),
                subtitle: Text(
                  "${note!['note']}",
                  style: const TextStyle(fontSize: 14),
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return EditNotes(noteId: noteId, notes: note);
                    }));
                  },
                  icon: const Icon(Icons.edit),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

