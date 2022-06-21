// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/moor_database.dart';
import 'model/moor_database.dart';

class TodoHome extends StatefulWidget {
  TodoHome({Key? key}) : super(key: key);

  @override
  State<TodoHome> createState() => _TodoHomeState();
}

class _TodoHomeState extends State<TodoHome> {
  int _counter = 1;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Todo App",
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: _buildListView(context),
              ),
              _buildBottomAdd(context),
            ],
          ),
        ),
        onTap: () {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  Widget _buildListView(BuildContext context) {
    return StreamBuilder(
      stream: Provider.of<AppDatabase>(context, listen: false).watchAllTodos(),
      builder: (context, AsyncSnapshot<List<Todo>> snapshot) {
        if (!snapshot.hasData) {
          return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              "assets/emptyBox.png",
              scale: 2.5,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Rien de prévu",
              style: Theme.of(context).textTheme.headline5,
            )
          ]);
        }
        if (snapshot.data!.isEmpty) {
          return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              "assets/emptyBox.png",
              scale: 2.5,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Rien de prévu",
              style: Theme.of(context).textTheme.headline5,
            )
          ]);
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return _buildTodo(snapshot.data![index], index);
          },
        );
      },
    );
  }

  Widget _buildTodo(Todo todo, int index) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: Padding(
          child: Icon(
            Icons.delete,
            size: 30,
          ),
          padding: EdgeInsets.all(21),
        ),
      ),
      key: UniqueKey(),
      child: ListTile(
        contentPadding: EdgeInsets.fromLTRB(15, 10, 5, 0),
        style: ListTileStyle.list,
        title: Text(
          todo.title,
          style: TextStyle(
              fontSize: 18,
              decoration: todo.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none),
        ),
        leading: todo.isCompleted
            ? Icon(
                Icons.check_circle,
                color: Color.fromARGB(255, 255, 194, 102),
                size: 27,
              )
            : Icon(
                Icons.circle_outlined,
                size: 27,
              ),
        onTap: () => setState(
          () {
            Provider.of<AppDatabase>(context, listen: false)
                .updateTodo(todo.copyWith(isCompleted: !todo.isCompleted));
          },
        ),
      ),
      onDismissed: (direction) {
        setState(() {
          Provider.of<AppDatabase>(context, listen: false).deleteTodo(todo);
        });
      },
    );
  }

  Widget _buildBottomAdd(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    return Row(
      children: [
        Expanded(
          child: Container(
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(25, 10, 20, 10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none),
                fillColor: Colors.grey[300],
                filled: true,
                hintText: "Partir à la plage",
                hintStyle: TextStyle(color: Colors.grey[400]),
              ),
              onSubmitted: (value) {
                _addTodo(context, value);
                _controller.clear();
                FocusScope.of(context).unfocus();
              },
            ),
            margin: EdgeInsets.only(left: 20, right: 5, bottom: 10),
          ),
        ),
        IconButton(
            onPressed: () {
              _addTodo(context, _controller.value.text);
              _controller.clear();
              FocusScope.of(context).unfocus();
            },
            icon: Icon(
              Icons.add_circle_outline,
              size: 30,
            ))
      ],
    );
  }

  void _addTodo(BuildContext context, String newVal) {
    if (newVal.isNotEmpty) {
      final db = Provider.of<AppDatabase>(context, listen: false);
      final todo = Todo(id: _counter, title: newVal, isCompleted: false);
      db.insertTodo(todo);
      _counter++;
    }
  }
}

//TODO: Add DatePicker



    