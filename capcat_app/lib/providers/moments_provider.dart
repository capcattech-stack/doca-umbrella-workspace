import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_mock_app/models/moment.dart';
import 'package:flutter_chat_mock_app/services/moment_remote_service.dart';

final momentsProvider =
    AsyncNotifierProvider<MomentsNotifier, List<Moment>>(() => MomentsNotifier());

class MomentsNotifier extends AsyncNotifier<List<Moment>> {
  static const Duration _ttl = Duration(minutes: 10);
  DateTime? _lastFetched;

  @override
  Future<List<Moment>> build() async {
    return _loadWithCache();
  }

  bool _isExpired() {
    if (_lastFetched == null) return true;
    return DateTime.now().difference(_lastFetched!) > _ttl;
  }

  Future<List<Moment>> _fetchRemote() async {
    final resp = await MomentRemoteService.fetchMoments();
    if (resp.isSuccess && resp.data != null) {
      _lastFetched = DateTime.now();
      return resp.data!;
    }
    return <Moment>[];
  }

  Future<List<Moment>> _loadWithCache() async {
    final cached = state.value;
    if (cached != null && !_isExpired()) {
      return cached;
    }
    return _fetchRemote();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchRemote);
  }

  Future<void> refreshSilently() async {
    final prev = state.value ?? <Moment>[];
    final next = await AsyncValue.guard(_fetchRemote);
    next.when(
      data: (data) => state = AsyncData(data),
      error: (_, __) => state = AsyncData(prev),
      loading: () {},
    );
  }

  Future<void> deleteMoment(String id) async {
    final current = state.value ?? <Moment>[];
    final updated = current.where((m) => m.id != id).toList();
    state = AsyncData(updated);
  }

  Future<void> upsertMoment(Moment moment) async {
    final current = [...(state.value ?? <Moment>[])];
    final idx = current.indexWhere((m) => m.id == moment.id);
    if (idx == -1) {
      current.insert(0, moment);
    } else {
      current[idx] = moment;
    }
    state = AsyncData(current);
  }
}
