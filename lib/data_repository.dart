import 'dart:convert';
import 'dart:io';
import 'package:webfeed/webfeed.dart';

import 'package:http/http.dart' as http;

class DataItem {}

class DataItemMessage implements DataItem {
  final String title;
  final String message;

  DataItemMessage(this.title, this.message);
}

class DataItemRssItem implements DataItem {
  final String title;
  final String message;
  final String link;
  DataItemRssItem(this.title, this.message, {this.link = ""});
}

// final String imageUrl;
// const DataItem(this.title, this.message, {this.imageUrl = ""});


class DataRepository {
  late Stream<List<DataItem>> stream;

  DataRepository() {
    stream = _fetcherLoop();
  }

  Stream<List<DataItem>> _fetcherLoop() async* {
    for (var i = 0; i < 10; i++) {
      yield await _loadRss();
      await Future.delayed(const Duration(seconds: 20));
    }
  }

  Future<List<DataItem>> _loadRss() async {
    // var uri = Uri.parse('http://www.ynet.co.il/Integration/StoryRss2.xml');
    var uri = Uri.parse('https://developer.apple.com/news/releases/rss/releases.rss');
    http.Response response = await http.get(uri);
    RssFeed feed = RssFeed.parse(utf8.decode(response.bodyBytes));
    List<DataItem> rows = feed.items?.map<DataItem>((item) {
      return DataItemRssItem(
          item.title ?? "TITLE", item.description ?? "Desc");
    }).toList() ?? <DataItemRssItem>[];
    return rows;
  }

  Future<List<DataItem>> _loadJson() async {
    var uri = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    http.Response response = await http.get(uri);
    dynamic items = jsonDecode(response.body);
    List<DataItem> rows = items.map<DataItem>((item) {
      return DataItemMessage(item["title"], item["body"]);
    }).toList();
    return rows;
  }
}