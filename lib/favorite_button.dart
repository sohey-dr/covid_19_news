import 'package:flutter/material.dart';
import 'package:covid_news/model/news_entry.dart';

typedef void FavoritePressedCallback(
    NewsEntry newsEntry, bool isAlreadySaved, Set<NewsEntry> savedEntries);

class FavoriteButton extends StatelessWidget {
  final NewsEntry newsEntry;
  final Set<NewsEntry> savedEntries;
  final FavoritePressedCallback handleFavoritePressed;
  final bool isAlreadySaved;
  FavoriteButton(
      {@required this.newsEntry,
        @required this.savedEntries,
        @required this.handleFavoritePressed})
      : isAlreadySaved = savedEntries.contains(newsEntry);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(0.0),
        child: IconButton(
            icon: Icon(
              isAlreadySaved ? Icons.favorite : Icons.favorite_border,
              color: isAlreadySaved ? Colors.red : null,
            ),
            onPressed: () {
              handleFavoritePressed(newsEntry, isAlreadySaved, savedEntries);
            }));
  }
}