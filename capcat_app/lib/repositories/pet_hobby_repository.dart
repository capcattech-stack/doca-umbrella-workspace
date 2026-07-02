// repositories/pet_hobby_repository.dart
import 'package:capcat_doca/models/pet_hobby_master_data.dart';
import 'package:capcat_doca/services/pet_hobby_remote_service.dart';
import 'package:capcat_doca/storage/pet_hobby_local_storage.dart';

class PetHobbyRepository {
  final PetHobbyLocalStorage local;

  PetHobbyRepository({required this.local});

  /// Lấy danh sách từ local, nếu chưa có thì gọi remote và cache
  Future<List<PetHobbyMasterData>> getAll() async {
    final localData = await local.read();
    if (localData != null && localData.isNotEmpty) {
      return localData;
    }
    return await refreshRemote();
  }

  /// Gọi remote & lưu cache
  Future<List<PetHobbyMasterData>> refreshRemote() async {
    final list = await PetHobbyRemoteService.getAll();
    await local.save(list);
    return list;
  }

  Future<void> clear() async => local.clear();
}
