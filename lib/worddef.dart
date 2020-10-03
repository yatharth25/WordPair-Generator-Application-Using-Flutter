import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';

class Definition extends StatefulWidget {
  final word;

  Definition({@required this.word});

  @override
  _DefinitionState createState() => _DefinitionState();
}

class _DefinitionState extends State<Definition> {
  dynamic snapshot = "waiting";
  _getMeaning(word) async {
    if (word == null || word.length == 0) {
      return;
    }

    String _url = "https://owlbot.info/api/v4/dictionary/";
    String _token = "75df0f5e598bc5908a1dec5c2afb999564761ee6";
    Response response = await get(_url + word.toString().trim(),
        headers: {"Authorization": "Token " + _token});

    setState(() {
      snapshot = json.decode(response.body);
    });
  }

  @override
  void initState() {
    super.initState();
    _getMeaning(widget.word.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.word.toString().toUpperCase()),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.all(8.0),
        child: snapshot == "waiting"
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot["definitions"].length,
                itemBuilder: (BuildContext context, int index) {
                  return ListBody(
                    children: <Widget>[
                      Container(
                        color: Colors.grey[300],
                        child: ListTile(
                          leading: snapshot["definitions"][index]
                                      ["image_url"] ==
                                  null
                              ? null
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      snapshot["definitions"][index]
                                          ["image_url"]),
                                ),
                          title: Text(widget.word.toString() +
                              "(" +
                              snapshot["definitions"][index]["type"] +
                              ")"),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(12.0),
                          child:
                              Text(snapshot["definitions"][index]["definition"],
                                  style: TextStyle(
                                    fontSize: 16,
                                  )))
                    ],
                  );
                },
              ),
      ),
    );
  }
}
