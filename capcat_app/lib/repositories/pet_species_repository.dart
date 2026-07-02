import 'package:capcat_doca/models/pet_species_master_data.dart';
import 'package:capcat_doca/services/pet_species_remote_service.dart';
import 'package:capcat_doca/storage/pet_species_local_storage.dart';

class PetSpeciesRepository {
  final PetSpeciesLocalStorage local;

  PetSpeciesRepository({required this.local});

  Future<List<PetSpeciesMasterData>> getAll() async {
    final localData = await local.read();
    if (localData != null && localData.isNotEmpty) {
      return localData;
    }
    return await refreshRemote();
  }

  Future<List<PetSpeciesMasterData>> refreshRemote() async {
    final list = await PetSpeciesRemoteService.getAll();
    await local.save(list);
    return list;
  }

  Future<void> clear() => local.clear();
}
