import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:note_app/models/note.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatabase extends ChangeNotifier {
  static late Isar isar;  
  
  // inisialisasi
  static Future<void> initialize() async{
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [NoteSchema],
      directory: dir.path,
    );
  }

  //list of notes
  final List<Note> currentNotes = [];

  // create
  Future<void> addNote(String textFromUser) async{
    
    //create new note obj
    final newNote = Note()..text = textFromUser;

    //save to db
    await isar.writeTxn(() => isar.notes.put(newNote));

    //reread db
    fetchNotes(); // Refresh the list of notes after adding a new note
  }


  // read
  Future<void> fetchNotes() async{
    List<Note> fetchedNotes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchedNotes);
    notifyListeners();
  }

  // update
  Future<void> updateNote(int id, String newText) async{
    final existingNote = await isar.notes.get(id);
    if (existingNote != null) {
      existingNote.text = newText;
      await isar.writeTxn(() => isar.notes.put(existingNote));
      await fetchNotes(); // Refresh the list of notes after updating
    }
  }

  // delete
  Future<void> deleteNote(int id) async{
    await isar.writeTxn(() => isar.notes.delete(id));
    await fetchNotes(); // Refresh the list of notes after deleting
  }
}