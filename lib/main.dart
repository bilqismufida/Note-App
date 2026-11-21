import 'package:flutter/material.dart';
import 'package:note_app/models/note_database.dart';
import 'package:note_app/pages/notes_pages.dart';
import 'package:note_app/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {

  //initialize note isar database
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase.initialize();

  runApp(
    MultiProvider(
       providers: [
      //note provider
      ChangeNotifierProvider(create: (context) => NoteDatabase()),
      
      //theme provider
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ],
    child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const NotesPage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
