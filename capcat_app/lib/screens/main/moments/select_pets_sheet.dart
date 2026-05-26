import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/models/pet_detail.dart';
import 'package:flutter_chat_mock_app/providers/list_pet_detail_provider.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/widgets/image/circle_cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectPetsSheet extends ConsumerStatefulWidget {
  const SelectPetsSheet({super.key, this.initialSelected = const []});

  final List<PetDetail> initialSelected;

  @override
  ConsumerState<SelectPetsSheet> createState() => _SelectPetsSheetState();
}

class _SelectPetsSheetState extends ConsumerState<SelectPetsSheet> {
  late List<String> _selectedIds;

  @override
  void initState() {
    super.initState();
    _selectedIds = widget.initialSelected.map((e) => e.id).toList();
  }

  void _toggle(PetDetail pet, bool checked) {
    setState(() {
      if (checked) {
        if (!_selectedIds.contains(pet.id)) _selectedIds.add(pet.id);
      } else {
        _selectedIds.remove(pet.id);
      }
    });
  }

  void _confirm(List<PetDetail> pets) {
    final selected = pets.where((p) => _selectedIds.contains(p.id)).toList();
    Navigator.of(context).pop(selected);
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.8;
    final petsAsync = ref.watch(listPetDetailProvider);
    return SafeArea(
      child: Container(
        color: AppColors.white,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: SC.sh(8)),
              Container(
                width: SC.sw(44),
                height: SC.sh(4),
                decoration: BoxDecoration(
                  color: AppColors.greyBorder1,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              SizedBox(height: SC.sh(12)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: SC.sw(16)),
                child: Row(
                  children: [
                    Text(
                      'Chọn thú cưng',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w700,
                        fontSize: SC.sf(16),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: petsAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.greenStrong1,
                    ),
                  ),
                  error: (_, __) =>
                      const Center(child: Text('Không tải được thú cưng')),
                  data: (pets) {
                    if (pets.isEmpty) {
                      return const Center(child: Text('Chưa có thú cưng'));
                    }
                    return ListView.separated(
                      padding: EdgeInsets.fromLTRB(
                        SC.sw(16),
                        0,
                        SC.sw(16),
                        SC.sh(16),
                      ),
                      itemBuilder: (_, index) {
                        final pet = pets[index];
                        final checked = _selectedIds.contains(pet.id);
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: SC.sh(8),
                          ),
                          leading: pet.avatarUrl != null &&
                                  pet.avatarUrl!.isNotEmpty
                              ? CircleCachedNetworkImage(
                                  imageUrl: pet.avatarUrl!,
                                  size: SC.smin(56),
                                  subject: ImageSubject.pet,
                                )
                              : CircleAvatar(
                                  radius: SC.smin(56),
                                  backgroundColor: AppColors.greyBox1,
                                  child: const Icon(
                                    Icons.pets,
                                    color: AppColors.greenStrong1,
                                  ),
                                ),
                          title: Text(
                            pet.name,
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w600,
                              fontSize: SC.sf(14),
                            ),
                          ),
                              trailing: Transform.scale(
                                scale: SC.smin(24) / 18,
                                child: Checkbox(
                                  activeColor: AppColors.greenStrong1,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  side: BorderSide(
                                    color: AppColors.greyCheckbox,
                                    width: SC.smin(2),
                                  ),
                                  value: checked,
                                  onChanged: (v) => _toggle(pet, v ?? false),
                                ),
                              ),
                              onTap: () => _toggle(pet, !checked),
                            );
                          },
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemCount: pets.length,
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  SC.sw(16),
                  SC.sh(8),
                  SC.sw(16),
                  SC.sh(16),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greenStrong1,
                      padding: EdgeInsets.symmetric(vertical: SC.sh(14)),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () async {
                      final petsAsync = ref.read(listPetDetailProvider);
                      final pets = petsAsync.value ?? <PetDetail>[];
                      _confirm(pets);
                    },
                    child: Text(
                      'Xong',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w700,
                        fontSize: SC.sf(14),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
