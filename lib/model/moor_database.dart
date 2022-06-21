import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
part 'moor_database.g.dart';

class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [Todos])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  @override
  int get schemaVersion => 1;

  Stream<List<Todo>> watchAllTodos() => select(todos).watch();
  Future<int> insertTodo(Todo todo) => into(todos).insert(todo);
  Future updateTodo(Todo todo) => update(todos).replace(todo);
  Future deleteTodo(Todo todo) => delete(todos).delete(todo);
}

LazyDatabase _openConnection() {
  return LazyDatabase(
    () async {
      final db = await getApplicationDocumentsDirectory();
      return NativeDatabase(File(join(db.path, "todos.sqlite")));
    },
  );
}
