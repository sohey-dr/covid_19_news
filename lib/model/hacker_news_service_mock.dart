import 'dart:async';

import 'package:covid_news/mock_data/news1.dart';
import 'package:covid_news/mock_data/news2.dart';
import 'package:covid_news/model/news_entry.dart';

class HackerNewsServiceMock {
  Future<List<NewsEntry>> getNewsEntries(int page) async {
    if (page == 1) {
      return mockNews1.map((e) => NewsEntry.fromMap(e)).toList();
    } else if (page == 2) {
      return mockNews2.map((e) => NewsEntry.fromMap(e)).toList();
    } else {
      return [];
    }
  }
}