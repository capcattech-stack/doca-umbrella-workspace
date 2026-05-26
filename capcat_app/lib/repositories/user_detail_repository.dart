import 'package:flutter_chat_mock_app/storage/user_detail_local_storage.dart';
import '../../models/user_detail.dart';
import '../../../services/user_detail_remote_service.dart';

class UserDetailRepository {
  final UserDetailLocalStorage local;
  final Duration ttl;
  UserDetailRepository({
    required this.local,
    this.ttl = const Duration(minutes: 10),
  });

  /// 1) Đọc local + quyết định có cần refresh
  Future<({UserDetail? localUser, bool shouldRefresh})>
  getLocalWithPolicy() async {
    final u = await local.read();
    final fetchedAt = await local.readFetchedAt();
    final isStale =
        fetchedAt == null || DateTime.now().difference(fetchedAt) > ttl;
    return (localUser: u, shouldRefresh: isStale);
  }

  /// 2) Gọi Remote qua service sẵn có, map về UserDetail, rồi cache
  Future<UserDetail> refreshRemote() async {
    final res = await UserDetailRemoteService.getMyProfile();
    if (res.isSuccess && res.data != null) {
      final user = res.data as UserDetail;
      await local.save(user);
      return user;
    }
    throw Exception(res.message ?? 'Không tải được hồ sơ');
  }

  Future<void> clear() => local.clear();
}
