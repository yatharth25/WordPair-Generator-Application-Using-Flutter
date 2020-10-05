import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:wordpair/welcome.dart';
import 'package:wordpair/worddef.dart';
import 'dart:convert';

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _randomWordPairs = <String>[];
  final _savedWordPairs = Set<String>();

  Widget _buildList() {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, item) {
          if (item.isOdd) return Divider();

          final index = item ~/ 2;

          if (index >= _randomWordPairs.length) {
            _randomWordPairs.addAll(nouns);
          }

          return _buildRow(_randomWordPairs[index]);
        });
  }

  Widget _buildRow(String pair) {
    final alreadySaved = _savedWordPairs.contains(pair);
    return ListTile(
      title: Text(pair, style: TextStyle(fontSize: 17.0)),
      trailing: IconButton(
          icon: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border,
              color: alreadySaved ? Colors.red : null),
          onPressed: () {
            setState(() {
              if (alreadySaved) {
                _savedWordPairs.remove(pair);
              } else {
                _savedWordPairs.add(pair);
              }
            });
          }),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Definition(word: pair)),
      ),
    );
  }

  void _SavedPage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      final Iterable<ListTile> tile = _savedWordPairs.map((String pair) {
        return ListTile(
            title: Text(pair, style: TextStyle(fontSize: 16.0)),
            trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    _savedWordPairs.remove(pair);
                    Navigator.of(context).pop();
                    _SavedPage();
                  });
                }),
            onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Definition(word: pair)),
                ));
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
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.favorite_border),
                  onPressed: () => _SavedPage()),
              centerTitle: true,
              title: Text("WordPair"),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.power_settings_new),
                    onPressed: () async {
                      var session = FlutterSession();
                      await session.set("email", '');
                      await session.set("idToken", '');
                      Navigator.popUntil(
                          context, ModalRoute.withName("HomePage"));
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => HomePage()));
                    })
              ]),
          body: _buildList(),
        ));
  }
}

Widget empty() {
  return Center(
      child: Text("You have not added anything to favorite",
          style: TextStyle(
            fontSize: 20,
          )));
}
