import 'dart:async';
import 'favorite_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:covid_news/model/hacker_news_service.dart';
import 'package:covid_news/model/news_entry.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

void main() => runApp(CovidNews());


class CovidNews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'コロナニュース',
      theme: ThemeData(primaryColor: Colors.amber),
      home: NewsEntriesPage(),
    );
  }
}

class NewsEntriesPage extends StatefulWidget {
  NewsEntriesPage({Key key}) : super(key: key);

  @override
  createState() => NewsEntriesState();
}

class NewsEntriesState extends State<NewsEntriesPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();
  final List<NewsEntry> _newsEntries = [];
  final Set<NewsEntry> _savedEntries = Set<NewsEntry>();
  final TextStyle _biggerFontStyle = TextStyle(fontSize: 18.0);
  final HackerNewsService hackerNewsService = HackerNewsService();

  int _nextPage = 1;
  bool _isLastPage = false;

  void _viewNewsEntry(NewsEntry entry) {
    url_launcher.launch(entry.url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('コロナニュース'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _navigateToSavedPage)
        ],
      ),
      body: _buildBody(),
    );
  }

  @override
  void initState() {
    super.initState();
    _getNewsEntries();
  }

  Widget _buildBody() {
    if (_newsEntries.isEmpty) {
      return Center(
        child: Container(
          margin: EdgeInsets.only(top: 8.0),
          width: 32.0,
          height: 32.0,
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return _buildNewsEntriesListView();
    }
  }

  Future<Null> _getNewsEntries() async {
    final newsEntries = await hackerNewsService.getNewsEntries(1);
    setState(() {
      _newsEntries.addAll(newsEntries);
    });
  }

  Widget _buildNewsEntriesListView() {
    return ListView.builder(itemBuilder: (BuildContext context, int index) {
      if (index.isOdd) return Divider();

      final i = index ~/ 2;
      if (i < _newsEntries.length) {
        return _buildNewsEntryRow(_newsEntries[i]);
      } else {
        return null;
      }
    });
  }

  Widget _buildNewsEntryRow(NewsEntry newsEntry) {
    return ListTile(
      onTap: () {
        _viewNewsEntry(newsEntry);
      },
      title: Text(
        newsEntry.title,
        style: _biggerFontStyle,
      ),
      subtitle:
      Text(newsEntry.domain),
      trailing: FavoriteButton(
          newsEntry: newsEntry,
          savedEntries: _savedEntries,
          handleFavoritePressed: _handleFavoritePressed),
    );
  }

  _handleFavoritePressed(
      NewsEntry newsEntry, bool isAlreadySaved, Set<NewsEntry> savedEntries) {
    setState(
          () {
        if (isAlreadySaved) {
          savedEntries.remove(newsEntry);
        } else {
          savedEntries.add(newsEntry);
        }
      },
    );
  }

  void _navigateToSavedPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          final tiles = _savedEntries.map(
                (entry) {
              return ListTile(
                title: Text(
                  entry.title,
                  style: _biggerFontStyle,
                ),
              );
            },
          );
          final divided = ListTile
              .divideTiles(
            context: context,
            tiles: tiles,
          )
              .toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('お気に入り'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
}