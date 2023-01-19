import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:ride_seattle/OneBusAway/routes.dart';
import 'package:ride_seattle/classes/Agency.dart';
import 'package:xml/xml.dart' as xml;

class MockClient extends Mock implements http.Client {}

void main() {
  group('Agency', () {
    test('constructor sets properties correctly', () {
      var agency = Agency(
        id: '1',
        name: 'Test Agency',
        url: 'http://example.com',
        timezone: 'UTC',
        lang: 'en',
        phone: '555-555-5555',
        fareUrl: 'http://example.com/fares',
        privateService: false,
      );

      expect(agency.id, '1');
      expect(agency.name, 'Test Agency');
      expect(agency.url, 'http://example.com');
      expect(agency.timezone, 'UTC');
      expect(agency.lang, 'en');
      expect(agency.phone, '555-555-5555');
      expect(agency.fareUrl, 'http://example.com/fares');
      expect(agency.privateService, isFalse);
    });
  });
}
