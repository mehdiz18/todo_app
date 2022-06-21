// ignore_for_file: prefer_const_constructors, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/moor_database.dart';

import 'todo_home.dart';

void main(List<String> args) {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<AppDatabase>(
      create: (context) => AppDatabase(),
      dispose: (context, db) => db.close(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Colors.black,
            fontFamily: GoogleFonts.montserrat().toString(),
            appBarTheme: AppBarTheme(
                backgroundColor: Colors.white, foregroundColor: Colors.black),
            textTheme: TextTheme(
              headline5: TextStyle(fontWeight: FontWeight.w700),
              headline6: TextStyle(
                color: Colors.grey[700],
                fontSize: 25,
              ),
            )),
        home: TodoHome(),
      ),
    );
  }
}
