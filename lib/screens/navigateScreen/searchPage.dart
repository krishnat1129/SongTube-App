import 'package:flutter/material.dart';
import 'package:songtube/ui/searchResult/videoTile.dart';

class SearchPage extends StatelessWidget {
  final List results;
  SearchPage({
    @required this.results,
  });
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        var video = results[index];
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: video == results.first ? 10 : 5,
                bottom: video == results.last ? 10 : 5,
                left: 12,
              ),
              child: VideoTile(
                video: results[index],
                onSelect: () {}
              ),
            ),
          ],
        );
      }
    );
  }
}