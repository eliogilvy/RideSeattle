import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ride_seattle/classes/agency.dart';
import 'package:xml/xml.dart';
import '../OneBusAway/routes.dart';

class StateInfo with ChangeNotifier {
  final Map<String, Agency> _agencies = {};

  Map<String, Agency> get agencies => _agencies;

  Future<void> getAgencies() async {
    Response res = await get(Uri.parse(Routes.getAgencies()));
    final document = XmlDocument.parse(res.body);
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
      _agencies[id.first.text] = Agency(
        id: id.first.text,
        name: name.first.text,
        url: url.first.text,
        timezone: timezone.first.text,
        lang: lang.first.text,
        phone: phone,
        fareUrl: fareUrl,
        privateService: bool.fromEnvironment(privateService.first.text),
      );
    }
  }
}
