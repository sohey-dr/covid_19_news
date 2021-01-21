import 'package:flutter/foundation.dart';

class NewsEntry {
  final int id;
  final String title;
  final String url;
  final String domain;
  factory NewsEntry.fromMap(Map jsonMap) {
    return NewsEntry._(
        id: jsonMap['id'],
        title: jsonMap['title'],
        url: jsonMap['url'],
        domain: jsonMap['domain']);
  }
  NewsEntry._(
      {@required this.id,
        @required this.title,
        @required this.url,
        @required this.domain});
}