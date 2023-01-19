import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ride_seattle/classes/agency.dart';
import 'keys.dart' as OBAKey;
import 'package:xml/xml.dart' as xml;

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  void getData() async {
    String uri =
        'http://api.pugetsound.onebusaway.org/api/where/agencies-with-coverage.xml?key=${OBAKey.Key.oneBusAway}';
    Response res = await get(Uri.parse(uri));
    final document = xml.XmlDocument.parse(res.body);
    for (var agency in document.findAllElements('agency')) {
      final id = agency.findElements('id');
      final name = agency.findElements('name');
      final url = agency.findElements('url');
      final timezone = agency.findElements('timezone');
      final lang = agency.findElements('lang');
      var phone;
      var fareUrl;
      try {
        phone = agency.findElements('phone').first.text;
      } catch (e) {
        if (e is StateError) phone = null;
      }
      try {
        fareUrl = agency.findElements('fareUrl').first.text;
      } catch (e) {
        if (e is StateError) fareUrl = null;
      }
      final privateService = agency.findElements('privateService');
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
      ),
    );
  }
}
