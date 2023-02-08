import 'package:feed_reader/data_repository.dart';
import 'package:feed_reader/items_list.dart';
import 'package:flutter/material.dart';

void main() {
  final DataRepository repo = DataRepository();
  runApp(MyApp(repo));
}

class MyApp extends StatelessWidget {
  final DataRepository repo;
  const MyApp(this.repo, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page', repo: repo),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final DataRepository repo;
  const MyHomePage({super.key, required this.title, required this.repo});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState(repo);
}

class _MyHomePageState extends State<MyHomePage> {
  final DataRepository repo;
  _MyHomePageState(this.repo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: ItemsList(repo.stream),
      ),
    );
  }
}
