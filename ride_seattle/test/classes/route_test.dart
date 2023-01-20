import 'package:flutter_test/flutter_test.dart';
import 'package:ride_seattle/classes/route.dart';

void main() {
  group(
    'Route',
    () {
      test(
        'Constructor sets properties correctly',
        () {
          var route = Route(
            id: "1_102715",
            shortName: "162",
            description: "Lake Meridean P&R - Downtown Seattle",
            type: '3',
            url: "http://metro.kingcounty.gov/schedules/162/n0.html",
            agencyId: "1",
          );

          expect(route.id, "1_102715");
          expect(route.shortName, "162");
          expect(route.description, "Lake Meridean P&R - Downtown Seattle");
          expect(route.type, '3');
          expect(
              route.url, "http://metro.kingcounty.gov/schedules/162/n0.html");
          expect(route.agencyId, "1");
        },
      );
    },
  );
}
