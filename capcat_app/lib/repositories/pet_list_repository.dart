import 'package:flutter_chat_mock_app/models/pet_detail.dart';
import 'package:flutter_chat_mock_app/services/pet_list_remote_service.dart';
import 'package:flutter_chat_mock_app/storage/pet_list_local_storage.dart';

class PetListRepository {
  final PetListLocalStorage local;
  final Duration ttl;

  PetListRepository({
    required this.local,
    this.ttl = const Duration(minutes: 10),
  });

  Future<({List<PetDetail> localPets, bool shouldRefresh})>
  getLocalWithPolicy() async {
    final pets = await local.read();
    final fetchedAt = await local.readFetchedAt();
    final isStale =
        fetchedAt == null || DateTime.now().difference(fetchedAt) > ttl;
    return (localPets: pets, shouldRefresh: isStale);
  }

  Future<List<PetDetail>> refreshRemote() async {
    final response = await PetListRemoteService.getMyPets();
    if (response.isSuccess && response.data != null) {
      final pets = response.data!;
      await local.save(pets);
      return pets;
    }
    throw Exception(response.message ?? 'Không tải được danh sách thú cưng');
  }

  Future<void> cache(List<PetDetail> pets) => local.save(pets);

  Future<void> clear() => local.clear();
}
