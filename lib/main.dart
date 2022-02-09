import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:todo_app_hive/model/todo_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

String todoBoxName = 'todo';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
// before init runApp because error
  final document = await path_provider.getApplicationDocumentsDirectory();
  //one step create document package path
  Hive.init(document.path);
  // tow step create init hive take inside memory phone
  Hive.registerAdapter(ToDoModelAdapter());
  // thread after create class ###.g.dart add here registerAdapter
  await Hive.openBox<ToDoModel>(todoBoxName);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'To Do '),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Box<ToDoModel> todoBox;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todoBox = Hive.box<ToDoModel>(todoBoxName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
        actions: [],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 400,
              width: 400,
              child: ListView(
                children: [
                  ValueListenableBuilder(
                      valueListenable: todoBox.listenable(),
                      builder: (context, Box<ToDoModel> todos, _) {
                        List<int> keys = todos.keys.cast<int>().toList();

                        return ListView.separated(
                          scrollDirection: Axis.vertical,
                          itemBuilder: (_, index) {
                            final int key = keys[index];
                            final ToDoModel? todo = todos.get(key);
                            return ListTile(
                              title: Text(todo!.title),
                              subtitle: Text(todo.details),
                              leading: Text("$key"),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete_forever_outlined,
                                  color: Colors.pink,
                                ),
                                onPressed: () {
                                  todoBox.delete(key);
                                },
                              ),
                            );
                          },
                          separatorBuilder: (_, index) => Divider(),
                          itemCount: keys.length,
                          shrinkWrap: true,
                        );
                      },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => Dialog(
                    child: Container(
                      width: 200,
                      height: 400,
                      child: Column(
                        children: [
                          //title
                          TextField(
                            controller: titleController,
                            decoration: InputDecoration(hintText: "Title"),
                          ),
                          //details tack
                          TextField(
                            controller: detailsController,
                            decoration: InputDecoration(hintText: "Details"),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                //add here Tack
                                final String title = titleController.text;
                                final String details = detailsController.text;

                                ToDoModel todo =
                                    ToDoModel(title: title, details: details);
                                todoBox.add(todo);
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.done))
                        ],
                      ),
                    ),
                  ));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
