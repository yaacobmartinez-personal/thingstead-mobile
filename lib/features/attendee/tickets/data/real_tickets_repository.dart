import '../../../../core/config/app_config.dart';
import '../../../../core/config/feature_availability.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_error.dart';
import '../domain/ticket.dart';
import '../domain/tickets_repository.dart';

class RealTicketsRepository implements TicketsRepository {
  RealTicketsRepository(this._api);

  final ApiClient _api;

  static const _base = '/mobile/tickets';

  void _require() {
    if (!isAvailable(Feature.attendeeMode, ApiMode.real)) throw ApiError.notAvailable();
  }

  @override
  Future<List<Ticket>> list() async {
    _require();
    final json = await _api.get(_base);
    return [
      for (final t in (json['tickets'] as List? ?? const []))
        Ticket.fromJson(t as Map<String, dynamic>),
    ];
  }

  @override
  Future<Ticket> get(String id) async {
    _require();
    final json = await _api.get('$_base/${Uri.encodeComponent(id)}');
    return Ticket.fromJson(json['ticket'] as Map<String, dynamic>);
  }

  @override
  Future<Ticket> import(String manageToken) async {
    _require();
    final json = await _api.post('$_base/import', body: {'token': manageToken.trim()});
    return Ticket.fromJson(json['ticket'] as Map<String, dynamic>);
  }

  @override
  Future<CancelOutcome> cancel(String id) async {
    _require();
    final json = await _api.post('$_base/${Uri.encodeComponent(id)}/cancel');
    return switch (json['outcome']) {
      'cancelled' => CancelOutcome.cancelled,
      'already' => CancelOutcome.already,
      'started' => CancelOutcome.started,
      _ => throw ApiError.fromResponse(502, {'error': 'Unexpected reply from the server.'}),
    };
  }
}
