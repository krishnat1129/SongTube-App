// Flutter
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songtube/provider/managerProvider.dart';
import 'package:songtube/screens/navigateScreen/searchPage.dart';
import 'package:songtube/screens/navigateScreen/shimmer/shimmerSearchPage.dart';

// UI
import 'package:songtube/ui/appBar.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

List<SearchVideo> searchResults = new List<SearchVideo>();

class Navigate extends StatefulWidget {
  final String searchQuery;
  Navigate({
    this.searchQuery,
  });
  @override
  _NavigateState createState() => _NavigateState();
}

class _NavigateState extends State<Navigate> {

  // YT Explode Instance
  YoutubeExplode yt;

  // No Internet
  bool errorSearching;

  @override
  void initState() {
    super.initState();
    errorSearching = false;
    yt = new YoutubeExplode();
    if (searchResults.isEmpty || widget.searchQuery != null) {
      search(widget.searchQuery);
    }
  }

  void search([String searchQuery]) async {
    setState(() => searchResults.clear());
    SearchQuery search = await yt.search
      .queryFromPage(
        searchQuery == null
          ? String.fromCharCodes(Iterable.generate(
              1, (_) => 'qwertyuiopasdfghjlcvbnm'
              .codeUnitAt(Random().nextInt('qwertyuiopasdfgjlcvbnm'.length))
            ))
          : searchQuery
      ).timeout(
        Duration(seconds: 20),
        onTimeout: () {
          setState(() => errorSearching = true);
          return;
        }
      );
    search.content.whereType<SearchVideo>().forEach((element) {
      searchResults.add(element);
    });
    if (mounted) {
      setState((){});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          searchBar(context),
          Expanded(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: errorSearching
                ? Center(
                    child: IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () => search(widget.searchQuery),
                    ),
                  )
                : searchResults.isNotEmpty
                    ? SearchPage(
                        results: searchResults,
                      )
                    : ShimmerSearchPage()
            ),
          )
        ]
      )
    );
  }

  Widget searchBar(BuildContext context) {
    ManagerProvider manager = Provider.of<ManagerProvider>(context);
    return SearchBar(
      controller: manager.urlController,
      onSearch: (String searchQuery) async {
        FocusScope.of(context).unfocus();
        search(manager.urlController.text);
      }
    );
  }
}