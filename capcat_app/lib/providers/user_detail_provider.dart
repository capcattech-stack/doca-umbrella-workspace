// lib/features/user/providers/user_detail_provider.dart
import 'package:capcat_doca/repositories/user_detail_repository.dart';
import 'package:capcat_doca/storage/user_detail_local_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user_detail.dart';

final _userLocalStorageProvider = Provider((_) => UserDetailLocalStorage());
final _userRepositoryProvider = Provider(
  (ref) => UserDetailRepository(
    local: ref.read(_userLocalStorageProvider),
    ttl: const Duration(minutes: 10),
  ),
);

final userDetailProvider =
    AsyncNotifierProvider<UserDetailController, UserDetail?>(
      () => UserDetailController(),
    );

class UserDetailController extends AsyncNotifier<UserDetail?> {
  @override
  Future<UserDetail?> build() async {
    final repo = ref.read(_userRepositoryProvider);

    // 1) Emit local ngay (nếu có)
    final policy = await repo.getLocalWithPolicy();
    state = AsyncData(policy.localUser);

    // 2) Refresh nền nếu chưa có dữ liệu hoặc đã stale
    if (policy.localUser == null || policy.shouldRefresh) {
      _refreshSilently();
    }
    return policy.localUser;
  }

  Future<void> _refreshSilently() async {
    final repo = ref.read(_userRepositoryProvider);
    final prev = state.value;
    final result = await AsyncValue.guard(repo.refreshRemote);
    result.when(
      data: (user) => state = AsyncData(user),
      error: (_, __) => state = AsyncData(prev), // giữ dữ liệu cũ nếu fail
      loading: () {},
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final repo = ref.read(_userRepositoryProvider);
    state = await AsyncValue.guard(repo.refreshRemote);
  }

  void setFromServer(UserDetail user) {
    //--Updates on RAM, UI changes accordingly
    state = AsyncData(user);

    //--Write cache
    ref.read(_userRepositoryProvider).local.save(user);
  }

  Future<void> clear() async {
    final repo = ref.read(_userRepositoryProvider);
    await repo.clear();
    state = const AsyncData(null);
  }
}
