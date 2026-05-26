import 'package:flutter_chat_mock_app/models/pet_breed_master_data.dart';
import 'package:flutter_chat_mock_app/services/pet_breed_remote_service.dart';
import 'package:flutter_chat_mock_app/storage/pet_breed_local_storage.dart';

class PetBreedRepository {
  final PetBreedLocalStorage local;

  PetBreedRepository({required this.local});

  /// Lấy từ local nếu có, nếu không thì tải từ remote và cache.
  Future<List<PetBreedMasterData>> getAll() async {
    final localData = await local.read();
    if (localData != null && localData.isNotEmpty) {
      return localData;
    }
    return await refreshRemote();
  }

  /// Force tải remote + ghi cache
  Future<List<PetBreedMasterData>> refreshRemote() async {
    final list = await PetBreedRemoteService.getAll();
    await local.save(list);
    return list;
  }

  Future<void> clear() => local.clear();
}
