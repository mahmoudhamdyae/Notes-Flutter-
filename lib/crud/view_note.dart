import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes/crud/edit_note.dart';

class ViewNote extends StatefulWidget {
  final QueryDocumentSnapshot? note;
  final String? noteId;
  const ViewNote({Key? key, required this.note, required this.noteId}) : super(key: key);

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Notes'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
          EditNote(noteId: widget.noteId, note: widget.note)
          ));
        },
        child: const Icon(Icons.edit),
      ),
      body: Column(
        children: [
          Image.network(
            "${widget.note!['imageUrl']}",
            width: double.infinity,
            height: 300,
            fit: BoxFit.fill,
          ),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                "${widget.note!['title']}",
                style: Theme.of(context).textTheme.headlineSmall,
              )),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                "${widget.note!['note']}",
                style: Theme.of(context).textTheme.bodyMedium,
              )),
        ],
      ),
    );
  }
}