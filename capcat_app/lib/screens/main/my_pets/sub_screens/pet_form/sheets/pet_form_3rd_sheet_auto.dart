import 'package:flutter/material.dart';
import 'package:capcat_doca/models/pet_persona_template_master_data.dart';
import 'package:capcat_doca/providers/pet_form_providers.dart';
import 'package:capcat_doca/providers/pet_hobbies_data_provider.dart';
import 'package:capcat_doca/providers/pet_hobby_repository_provider.dart';
import 'package:capcat_doca/providers/pet_persona_template_provider.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/media_query_utils.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/widgets/button/tap_effect.dart';
import 'package:capcat_doca/widgets/input/input_field.dart';
import 'package:capcat_doca/widgets/input/multiple_select_text_field.dart';
import 'package:capcat_doca/widgets/image/rectangle_cached_network_image.dart';
import 'package:capcat_doca/widgets/image/circle_cached_network_image.dart';
import 'package:capcat_doca/widgets/text/section_header_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:capcat_doca/l10n/gen/app_localizations.dart';

const int _kMaxHobbySelection = 3;

class PetForm3rdSheetAuto extends ConsumerWidget {
  const PetForm3rdSheetAuto({super.key, this.actionButton});
  final Widget? actionButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final double hp = SC.sw(24);
    final double vpS = SC.sh(8);
    final double vpM = SC.sh(16);

    return Padding(
      padding: EdgeInsets.only(bottom: MQ.bottomPadding(context)),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(hp, vpM, hp, 0),
        child: Column(
          children: [
            const _IntroductionSection(),
            SizedBox(height: vpM),
            //--Call pet
            SectionHeaderText(l10n.petFormCallPetLabel, isOptional: false),
            SizedBox(height: vpS),
            const _InputPetTermField(),
            SizedBox(height: vpM),
            //--Pet call you
            SectionHeaderText(l10n.petFormCallOwnerLabel, isOptional: false),
            SizedBox(height: vpS),
            const _InputOwnerTermField(),
            SizedBox(height: vpM),
            //--Hobby
            _HobbySection(vpS: vpS),
            SizedBox(height: vpM),
            //--Characteristic
            SectionHeaderText(
              l10n.petFormPersonaRepresentative,
              isOptional: false,
            ),
            SizedBox(height: vpS),
            const _PetPersonalityCardGrid(),
            SizedBox(height: vpM),
            actionButton ?? SizedBox(),
            SizedBox(height: vpM),
          ],
        ),
      ),
      // SizedBox(height: vpM),
    );
  }
}

class _IntroductionSection extends StatelessWidget {
  const _IntroductionSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SC.smin(8)),
      decoration: BoxDecoration(
        color: AC.yellowChatInputGroup,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        l10n.petFormPersonaIntro,
        style: TextStyle(
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.w400,
          fontSize: SC.sf(14),
          height: 20 / 14,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _InputPetTermField extends ConsumerStatefulWidget {
  const _InputPetTermField({super.key});

  @override
  ConsumerState<_InputPetTermField> createState() => _InputPetTermFieldState();
}

class _InputPetTermFieldState extends ConsumerState<_InputPetTermField> {
  late final TextEditingController _petTermController;

  String get value => _petTermController.text;

  @override
  void initState() {
    super.initState();
    final initialPetTerm = ref.read(
      petFormDataProvider.select((s) => s.petTerm),
    );
    _petTermController = TextEditingController(text: initialPetTerm ?? '');
  }

  @override
  void dispose() {
    _petTermController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final petFormNotifier = ref.read(petFormDataProvider.notifier);

    return InputField(
      hintText: l10n.petFormCallPetHint,
      controller: _petTermController,
      onChanged: petFormNotifier.setPetTerm,
    );
  }
}

class _InputOwnerTermField extends ConsumerStatefulWidget {
  const _InputOwnerTermField({super.key});

  @override
  ConsumerState<_InputOwnerTermField> createState() =>
      _InputOwnerTermFieldState();
}

class _InputOwnerTermFieldState extends ConsumerState<_InputOwnerTermField> {
  late final TextEditingController _ownerTermController;
  String get value => _ownerTermController.text;

  @override
  void initState() {
    super.initState();
    final initialOwnerTerm = ref.read(
      petFormDataProvider.select((s) => s.ownerTerm),
    );
    _ownerTermController = TextEditingController(text: initialOwnerTerm ?? '');
  }

  @override
  void dispose() {
    _ownerTermController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final petFormNotifier = ref.read(petFormDataProvider.notifier);

    return InputField(
      hintText: l10n.petFormCallOwnerHint,
      controller: _ownerTermController,
      onChanged: petFormNotifier.setOwnerTerm,
    );
  }
}

class _HobbySection extends ConsumerWidget {
  const _HobbySection({required this.vpS, this.selectKey});

  final double vpS;
  final GlobalKey<_SelectHobbyWidgetState>? selectKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selectedHobbies =
        ref.watch(petFormDataProvider.select((s) => s.hobby)) ?? <String>[];
    final count = selectedHobbies.length;
    final headerText = l10n.petFormHobbyHeader(count, _kMaxHobbySelection);

    return Column(
      children: [
        SectionHeaderText(headerText, isOptional: false),
        SizedBox(height: vpS),
        _SelectHobbyWidget(key: selectKey, maxSelection: _kMaxHobbySelection),
      ],
    );
  }
}

class _SelectHobbyWidget extends ConsumerStatefulWidget {
  const _SelectHobbyWidget({super.key, required this.maxSelection});

  final int maxSelection;

  @override
  ConsumerState<_SelectHobbyWidget> createState() => _SelectHobbyWidgetState();
}

class _SelectHobbyWidgetState extends ConsumerState<_SelectHobbyWidget> {
  bool _normalizedInitial = false;
  late List<String> _selectedHobbies;

  List<String> get selectedHobbies => List.unmodifiable(_selectedHobbies);

  @override
  void initState() {
    super.initState();
    _selectedHobbies = List<String>.from(
      ref.read(petFormDataProvider).hobby ?? [],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_normalizedInitial) return;

    final current =
        ref.read(petFormDataProvider.select((s) => s.hobby)) ?? <String>[];
    if (current.length > widget.maxSelection) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final limited = current.take(widget.maxSelection).toList();
        ref.read(petFormDataProvider.notifier).setHobby(limited);
      });
    }
    _normalizedInitial = true;
  }

  @override
  Widget build(BuildContext context) {
    // Lấy danh sách hobby từ provider mới (AsyncValue<List<PetHobby>>)
    final hobbiesAsync = ref.watch(petHobbyProvider);

    // Vẫn dùng provider cũ để lấy quick picks (recent)
    final quickPicks = ref.watch(
      petHobbiesProvider.select((s) => s.recentPetHobbies),
    );

    // Giá trị đã chọn (đang lưu trong form)
    final selectedHobbies =
        ref.watch(petFormDataProvider.select((s) => s.hobby)) ?? [];
    if (!_normalizedInitial && selectedHobbies.length <= widget.maxSelection) {
      _selectedHobbies = List<String>.from(selectedHobbies);
    }

    final petFormNotifier = ref.read(petFormDataProvider.notifier);

    return hobbiesAsync.when(
      loading: () => Container(
        width: double.infinity,
        height: SizeConfig.sh(56),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: SC.sw(20)),
        decoration: BoxDecoration(
          color: AC.greyBox1,
          border: Border.all(color: AC.greyBorder1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            SizedBox(
              width: SC.smin(16),
              height: SC.smin(16),
              child: CircularProgressIndicator(
                color: AC.greenStrong1,
                strokeWidth: SC.sw(2),
              ),
            ),
            SizedBox(width: SC.sw(8)),
            Text(AppLocalizations.of(context)!.petFormHobbyLoading),
          ],
        ),
      ),
      error: (e, _) =>
          Text(AppLocalizations.of(context)!.petFormHobbyError('$e')),
      data: (hobbies) {
        // Map sang list tên để đưa vào MultipleSelectTextField
        final allHobbyNames = hobbies.map((h) => h.name).toList();

        return MultipleSelectTextField(
          icon: Image.asset(
            'assets/icons/list-select-widget.png',
            width: SC.smin(20),
          ),
          maxSelection: widget.maxSelection,
          fullOptions: allHobbyNames,
          quickOptions: quickPicks,
          hintText: AppLocalizations.of(context)!.petFormHobbyHint,
          sheetTitle: AppLocalizations.of(context)!.petFormHobbySheetTitle,
          allSectionText: AppLocalizations.of(context)!.petFormHobbyAll,
          initialSelected: selectedHobbies,
          onChanged: (selectedList) {
            final limited = selectedList.length <= widget.maxSelection
                ? selectedList
                : selectedList.take(widget.maxSelection).toList();
            setState(() {
              _selectedHobbies = List<String>.from(limited);
            });
            // Lưu recent cho từng lựa chọn
            if (limited.isNotEmpty) {
              final recentNotifier = ref.read(petHobbiesProvider.notifier);
              for (final hobbyName in limited) {
                recentNotifier.addToRecent(hobbyName);
              }
            }
            // Lưu vào form
            petFormNotifier.setHobby(limited);
          },
        );
      },
    );
  }
}

class _PetPersonalityCardGrid extends ConsumerStatefulWidget {
  const _PetPersonalityCardGrid({super.key});

  @override
  ConsumerState<_PetPersonalityCardGrid> createState() =>
      _PetPersonalityCardGridState();
}

class _PetPersonalityCardGridState
    extends ConsumerState<_PetPersonalityCardGrid> {
  int? _selectedPersonaId;

  int? get selectedPersonaId => _selectedPersonaId;

  @override
  void initState() {
    super.initState();
    _selectedPersonaId = ref.read(petFormDataProvider).personaTemplateId;
  }

  @override
  Widget build(BuildContext context) {
    final personasAsync = ref.watch(petPersonaTemplateProvider);
    final l10n = AppLocalizations.of(context)!;
    _selectedPersonaId = ref.watch(
      petFormDataProvider.select((s) => s.personaTemplateId),
    );

    return personasAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AC.greenStrong1),
      ),
      error: (e, _) => Text(l10n.petFormPersonaLoadError('$e')),
      data: (personas) {
        if (personas.isEmpty) {
          return Text(l10n.petFormPersonaEmpty);
        }
        return _CardGrid(
          items: personas,
          selectedPersonaId: _selectedPersonaId,
          onTap: (persona, isSelected) {
            final nextId = isSelected ? null : persona.id;
            setState(() {
              _selectedPersonaId = nextId;
            });
            ref.read(petFormDataProvider.notifier).setPersonality(nextId);
          },
        );
      },
    );
  }
}

class _CardGrid extends StatelessWidget {
  final List<PetPersonaTemplateMasterData> items;
  final void Function(PetPersonaTemplateMasterData persona, bool isSelected)
  onTap;
  final int? selectedPersonaId;

  const _CardGrid({
    required this.items,
    required this.onTap,
    this.selectedPersonaId,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: SC.smin(8),
        mainAxisSpacing: SC.smin(8),
        childAspectRatio: 159.5 / 227.5,
      ),
      itemBuilder: (context, index) {
        final persona = items[index];
        final isSelected = persona.id == selectedPersonaId;

        return TapEffect(
          onTap: () => onTap(persona, isSelected),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AC.greyTab1,
                  borderRadius: BorderRadius.circular(24),
                  border: isSelected
                      ? Border.all(color: AC.greenStrong2, width: SC.smin(2))
                      : null,
                ),
                // padding: EdgeInsets.fromLTRB(SC.sw(8), SC.sh(8), SC.sw(8), 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RectangleCachedNetworkImage(
                      imageUrl: persona.iconUrl,
                      height: SC.smin(143.5),
                      width: double.infinity,
                      radius: 16,
                      fit: BoxFit.cover,
                      subject: ImageSubject.others,
                    ),

                    SizedBox(height: SC.sh(10)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          persona.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w700,
                            fontSize: SC.sf(12),
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: SC.sh(4)),
                        Text(
                          persona.description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w500,
                            fontSize: SC.sf(12),
                            color: AC.neutralPetFormSubtext,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Positioned(
                  top: SC.smin(9),
                  right: SC.smin(9),
                  child: Container(
                    width: SC.smin(32),
                    height: SC.smin(32),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AC.greenStrong1,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: SC.smin(20),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
