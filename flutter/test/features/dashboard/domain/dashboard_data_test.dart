import 'package:flutter_test/flutter_test.dart';
import 'package:cicwtch/features/dashboard/domain/dashboard_data.dart';

void main() {
  group('DashboardData.fromJson', () {
    test('parses a full API response', () {
      final json = <String, dynamic>{
        'clients': {'total': 12},
        'dogs': {'total': 25},
        'walks': {'total': 150, 'today': 3, 'upcoming': 18},
        'walkers': {'total': 5},
        'invoices': {'total': 40, 'outstanding': 7},
      };

      final data = DashboardData.fromJson(json);

      expect(data.clientsTotal, 12);
      expect(data.dogsTotal, 25);
      expect(data.walksTotal, 150);
      expect(data.walksToday, 3);
      expect(data.walksUpcoming, 18);
      expect(data.walkersTotal, 5);
      expect(data.invoicesTotal, 40);
      expect(data.invoicesOutstanding, 7);
    });

    test('parses zero counts', () {
      final json = <String, dynamic>{
        'clients': {'total': 0},
        'dogs': {'total': 0},
        'walks': {'total': 0, 'today': 0, 'upcoming': 0},
        'walkers': {'total': 0},
        'invoices': {'total': 0, 'outstanding': 0},
      };

      final data = DashboardData.fromJson(json);

      expect(data.clientsTotal, 0);
      expect(data.dogsTotal, 0);
      expect(data.walksTotal, 0);
      expect(data.walksToday, 0);
      expect(data.walksUpcoming, 0);
      expect(data.walkersTotal, 0);
      expect(data.invoicesTotal, 0);
      expect(data.invoicesOutstanding, 0);
    });

    test('handles large counts', () {
      final json = <String, dynamic>{
        'clients': {'total': 99999},
        'dogs': {'total': 50000},
        'walks': {'total': 1000000, 'today': 500, 'upcoming': 25000},
        'walkers': {'total': 1000},
        'invoices': {'total': 200000, 'outstanding': 15000},
      };

      final data = DashboardData.fromJson(json);

      expect(data.clientsTotal, 99999);
      expect(data.dogsTotal, 50000);
      expect(data.walksTotal, 1000000);
      expect(data.walksToday, 500);
      expect(data.walksUpcoming, 25000);
      expect(data.walkersTotal, 1000);
      expect(data.invoicesTotal, 200000);
      expect(data.invoicesOutstanding, 15000);
    });
  });
}
