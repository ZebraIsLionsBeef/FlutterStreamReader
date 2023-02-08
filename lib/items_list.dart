import 'package:feed_reader/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ItemsList extends StatefulWidget {
  final Stream<List<DataItem>> _stream;

  const ItemsList(this._stream, {super.key});

  @override
  ListState createState() => ListState(_stream);
}

class ListState extends State<StatefulWidget> {
  List<Widget> rows = <Widget>[];
  final Stream<List<DataItem>> _stream;

  ListState(this._stream);

  @override
  void initState() {
    print("Listening");
    updateByData();
    super.initState();
  }

  Future<void> updateByData() async {
    await for (final List<DataItem> data in _stream) {
      setState(() {
        rows = data.map((e) {
          return _Factory.createUi(e);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.ltr, child: ListView.builder(
        itemCount: rows.length,
        itemBuilder: (context, position) {
          return rows[position];
        }));
  }
}

class _Factory {
  static Widget createUi(DataItem item) {
    if (item is DataItemRssItem) {
      return _createRssItem(item);
    } else if (item is DataItemMessage) {
      return _createMessage(item);
    } else {
      return const Text("N/A");
    }
  }

  static Widget _createRssItem(DataItemRssItem rssItem) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(rssItem.title,
              style: const TextStyle(color: Colors.black, fontSize: 20)),
          TextButton(
            child: Html(data: rssItem.message),
            onPressed: () {},
          )
        ],
      );

  static Widget _createMessage(DataItemMessage messageItem) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(messageItem.title,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold)),
          Text(messageItem.message)
        ],
      );
}
