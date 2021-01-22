import 'dart:async';
import 'dart:convert';
import 'package:covid_news/model/news_entry.dart';
import 'package:http/http.dart' as http;


class HackerNewsService {

  // Store the last feed in memory to instantly load when requested.
  String _cacheFeedKey;
  List<NewsEntry> _cacheFeedResult;

  Future<List<NewsEntry>> getNewsEntries(int page) async {
    final url = 'https://crawlers-hey.herokuapp.com/api/v1/newsses.json';
    if (_cacheFeedKey == url) {
      return _cacheFeedResult;
    }
    final response = await http.get(url);
    final decoded = json.decode(response.body) as List;
    _cacheFeedKey = url;
    final jsonMapList = decoded.cast<Map>();
    _cacheFeedResult = jsonMapList.map((e) => NewsEntry.fromMap(e)).toList();
    return _cacheFeedResult;
  }
}