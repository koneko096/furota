import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'member.dart';
import 'strings.dart'; 

class GHFlutter extends StatefulWidget {
  @override
  createState() => GHFlutterState();
}

class GHFlutterState extends State<GHFlutter> {
  var _members = <Member>[];

  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Widget _buildRow(int order) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListTile(
        title: Text("${_members[order].login}", style: _biggerFont),
        leading: CircleAvatar(
          backgroundColor: Colors.green,
          backgroundImage: NetworkImage(_members[order].avatarUrl)
        ),
      )
    );
  }

  _loadData() async {
    http.Response response = await http.get(Strings.dataURL);
    setState(() {
      final membersJson = json.decode(response.body);
      for (var memberJson in membersJson) {
        final member = Member(memberJson["login"], memberJson["avatar_url"]);
        _members.add(member);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.appTitle),
      ),
      body: ListView.builder(
        itemCount: _members.length * 2 - 1,
        itemBuilder: (BuildContext ctx, int position) {
          if (position.isOdd) return Divider();
          return _buildRow(position ~/ 2);
        },
      ),
    );
  }
}