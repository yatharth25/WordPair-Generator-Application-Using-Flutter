import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/rendering.dart';

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _randomWordPairs = <WordPair>[];
  final _savedWordPairs = Set<WordPair>();

  Widget _buildList() {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, item) {
          if (item.isOdd) return Divider();

          final index = item ~/ 2;

          if (index >= _randomWordPairs.length) {
            _randomWordPairs.addAll(generateWordPairs().take(10));
          }

          return _buildRow(_randomWordPairs[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _savedWordPairs.contains(pair);
    return ListTile(
      title: Text(pair.asPascalCase, style: TextStyle(fontSize: 17.0)),
      trailing: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _savedWordPairs.remove(pair);
          } else {
            _savedWordPairs.add(pair);
          }
        });
      },
    );
  }

  void _SavedPage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      final Iterable<ListTile> tile = _savedWordPairs.map((WordPair pair) {
        return ListTile(
          title: Text(pair.asPascalCase, style: TextStyle(fontSize: 16.0)),
          trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  _savedWordPairs.remove(pair);
                  Navigator.of(context).pop();
                  _SavedPage();
                });
              }),
        );
      });

      final List<Widget> divided =
          ListTile.divideTiles(context: context, tiles: tile).toList();

      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Saved WordPairs'),
          ),
          body: _savedWordPairs.length == 0
              ? empty()
              : ListView(
                  children: divided,
                  physics: BouncingScrollPhysics(),
                ));
    }));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text("WordPair"),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.list), onPressed: _SavedPage)
          ]),
      body: _buildList(),
    );
  }
}

Widget empty() {
  return Center(
      child: Text("You have not added anything to favorite",
          style: TextStyle(
            fontSize: 20,
          )));
}
