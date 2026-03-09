import 'package:flutter_test/flutter_test.dart';
import 'package:cicwtch/features/dashboard/data/dashboard_repository.dart';
import 'package:cicwtch/shared/data/api_client.dart';
import 'package:cicwtch/shared/data/api_exception.dart';

/// A minimal fake [ApiClient] that records the requested path and returns
/// a configurable response or throws a configurable exception.
class _FakeApiClient extends ApiClient {
  _FakeApiClient({this.response, this.exception})
      : super(baseUrl: 'https://test.example.com', bearerToken: 'test-token');

  String? lastPath;
  final dynamic response;
  final Exception? exception;

  @override
  Future<dynamic> get(String path) async {
    lastPath = path;
    if (exception != null) throw exception!;
    return response;
  }
}

void main() {
  group('DashboardRepository', () {
    test('requests the correct /api/v1/dashboard endpoint', () async {
      final api = _FakeApiClient(
        response: <String, dynamic>{
          'clients': {'total': 0},
          'dogs': {'total': 0},
          'walks': {'total': 0, 'today': 0, 'upcoming': 0},
          'walkers': {'total': 0},
          'invoices': {'total': 0, 'outstanding': 0},
        },
      );

      final repo = DashboardRepository(api);
      await repo.getDashboard();

      expect(api.lastPath, '/api/v1/dashboard');
    });

    test('returns parsed DashboardData on success', () async {
      final api = _FakeApiClient(
        response: <String, dynamic>{
          'clients': {'total': 3},
          'dogs': {'total': 8},
          'walks': {'total': 20, 'today': 2, 'upcoming': 5},
          'walkers': {'total': 1},
          'invoices': {'total': 10, 'outstanding': 4},
        },
      );

      final repo = DashboardRepository(api);
      final data = await repo.getDashboard();

      expect(data.clientsTotal, 3);
      expect(data.dogsTotal, 8);
      expect(data.walksTotal, 20);
      expect(data.walksToday, 2);
      expect(data.walksUpcoming, 5);
      expect(data.walkersTotal, 1);
      expect(data.invoicesTotal, 10);
      expect(data.invoicesOutstanding, 4);
    });

    test('propagates ApiException on non-200 response', () async {
      final api = _FakeApiClient(
        exception: const ApiException(statusCode: 404, message: 'Not found'),
      );

      final repo = DashboardRepository(api);

      expect(
        () => repo.getDashboard(),
        throwsA(isA<ApiException>()),
      );
    });

    test('propagates ApiException on 500 response', () async {
      final api = _FakeApiClient(
        exception:
            const ApiException(statusCode: 500, message: 'Internal error'),
      );

      final repo = DashboardRepository(api);

      expect(
        () => repo.getDashboard(),
        throwsA(
          isA<ApiException>().having(
            (e) => e.statusCode,
            'statusCode',
            500,
          ),
        ),
      );
    });

    test('propagates network errors to caller', () async {
      final api = _FakeApiClient(
        exception: Exception('Network error'),
      );

      final repo = DashboardRepository(api);

      expect(
        () => repo.getDashboard(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
