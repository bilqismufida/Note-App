import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/components/drawer.dart';
import 'package:note_app/components/note_tile.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/models/note_database.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {

  // text controller for the text field
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // on app startup, fetch the notes from the database
    readNotes();
  }

  // create a note
  void createNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('Create Note'),
        content: TextField(
          controller: textController,
        ),
        actions: [
          // creeate button
          MaterialButton(
            onPressed: (){
              // add to db
              context.read<NoteDatabase>().addNote(textController.text);

              // clear controller
              textController.clear();

              // pop dialog box
              Navigator.pop(context);
            },
            child: const Text('Create'),
          )
        ]
      ),
    );
  }

  //read
  void readNotes() {
    context.read<NoteDatabase>().fetchNotes();
  }

  //update
  void updateNote(Note note){
    //pre-fill the current note text
    textController.text = note.text;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('Update Note'),
        content: TextField( controller: textController),
        actions: [
          // update button
          MaterialButton(
            onPressed: (){
              // update in db
              context
                .read<NoteDatabase>()
                .updateNote(note.id, textController.text);

              // clear controller
              textController.clear();

              // pop dialog box
              Navigator.pop(context);
            },
            child: const Text('Update'),
          )
        ]
      ),
    );
  }

  //delete
  void deleteNote(int id){
    context.read<NoteDatabase>().deleteNote(id);
  }

  @override
  Widget build(BuildContext context) {

    //note db
    final noteDatabase = context.watch<NoteDatabase>();

    // current notes
    List<Note> currentNotes = noteDatabase.currentNotes;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),

      backgroundColor: Theme.of(context).colorScheme.background,

      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),

      drawer: const MyDrawer(),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          //HEADING
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              'Notes',
              style: GoogleFonts.dmSerifText(
                fontSize: 48,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ), 

          // list of notes
          Expanded(
            child: ListView.builder(
              itemCount: currentNotes.length,
              itemBuilder: (context, index){
                //get individual note
                final note = currentNotes[index];
            
                //list tile ui
                return NoteTile(
                  text: note.text,
                  onEditPressed: () => updateNote(note),
                  onDeletePressed: () => deleteNote(note.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
