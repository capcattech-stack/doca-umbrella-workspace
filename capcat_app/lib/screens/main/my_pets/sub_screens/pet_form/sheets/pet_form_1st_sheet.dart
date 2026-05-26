import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/enums/image_upload_purpose.dart';
import 'package:flutter_chat_mock_app/models/pet_detail.dart';
import 'package:flutter_chat_mock_app/providers/pet_form_providers.dart';
import 'package:flutter_chat_mock_app/services/image_picker_service.dart';
import 'package:flutter_chat_mock_app/services/image_service.dart';
import 'package:flutter_chat_mock_app/utils/media_query_utils.dart';
import 'package:flutter_chat_mock_app/utils/toast_overlay.dart';
import 'package:flutter_chat_mock_app/widgets/text/section_header_text.dart';
import 'package:flutter_chat_mock_app/screens/main/my_pets/sub_screens/pet_form/sheets/widgets/tag_selection.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/widgets/button/tap_effect.dart';
import 'package:flutter_chat_mock_app/widgets/input/input_field.dart';
import 'package:flutter_chat_mock_app/widgets/shared/avatar_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_mock_app/l10n/gen/app_localizations.dart';

class PetForm1stSheet extends ConsumerWidget {
  const PetForm1stSheet({super.key, this.actionButton});
  final Widget? actionButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final double hp = SC.sw(24);
    final double smallVp = SC.sh(8);
    final double mediumVp = SC.sh(16);
    final double largeVp = SC.sh(24);
    return Padding(
      padding: EdgeInsets.fromLTRB(hp, 0, hp, MQ.bottomPadding(context)),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: largeVp),
                  //--Avatar
                  SizedBox(height: smallVp),
                  const _SelectAvatarWidget(),
                  SizedBox(height: mediumVp),
                  //--Name
                  SectionHeaderText(l10n.petFormNameLabel),
                  SizedBox(height: smallVp),
                  const _InputNameField(),
                  SizedBox(height: mediumVp),
                  //--Gender
                  SectionHeaderText(l10n.petFormGenderLabel, isOptional: true),
                  SizedBox(height: smallVp),
                  const _SelectGenderWidget(),
                  SizedBox(height: largeVp),
                  //--Is Neutered
                  const _IsNeuteredCheckboxWidget(),
                  //--
                ],
              ),
            ),
          ),
          SizedBox(height: mediumVp),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [leftButton ?? SizedBox(), actionButton ?? SizedBox()],
          // ),
          actionButton ?? SizedBox(),
          SizedBox(height: mediumVp),
        ],
      ),
    );
  }
}

class _SelectAvatarWidget extends ConsumerWidget {
  const _SelectAvatarWidget();

  Future<void> _onEditTap(BuildContext context, WidgetRef ref) async {
    final picked = await ImagePickerService.pickImages(
      context,
      allowMultiple: false,
      allowCamera: true,
      allowGallery: true,
    );
    final path = picked?.paths.firstOrNull;
    if (path == null) return;

    final result = await ImageService.uploadImageFromPath(
      imagePath: path,
      purpose: ImageUploadPurpose.petAvatar,
    );

    if (!result.isSuccess) {
      if (context.mounted) {
        TO.show(context, AppLocalizations.of(context)!.petFormUploadError);
      }
      return;
    }

    final avatarUrl = result.fileUrl!;
    ref.read(petFormDataProvider.notifier).setAvatarUrl(avatarUrl);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarUrl = ref.watch(petFormDataProvider.select((s) => s.avatarUrl));

    return AvatarWidget(
      imageUrl: avatarUrl,
      isPet: true,
      size: SC.sh(100),
      editIconPath: 'assets/icons/take-avatar.png',
      onEditTap: () => _onEditTap(context, ref),
    );
  }
}

class _InputNameField extends ConsumerStatefulWidget {
  const _InputNameField();

  @override
  ConsumerState<_InputNameField> createState() => _InputNameFieldState();
}

class _InputNameFieldState extends ConsumerState<_InputNameField> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final initialName = ref.read(petFormDataProvider.select((s) => s.name));
    _nameController = TextEditingController(text: initialName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final petFormNotifier = ref.read(petFormDataProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return InputField(
      hintText: l10n.petFormNameHint,
      controller: _nameController,
      onChanged: petFormNotifier.setName,
    );
  }
}

class _SelectGenderWidget extends ConsumerWidget {
  const _SelectGenderWidget();

  static List<TagItem<PetGender>> _genderItems(BuildContext context) => [
    TagItem(
      value: PetGender.female,
      label: AppLocalizations.of(context)!.petFormGenderFemale,
      selectedBg: AC.pinkSelectedBg,
      selectedBorder: AC.pinkGenderAccent,
      selectedText: AC.pinkGenderAccent,
    ),
    TagItem(
      value: PetGender.male,
      label: AppLocalizations.of(context)!.petFormGenderMale,
      selectedBg: AC.blueSelectedBg,
      selectedBorder: AC.blueGenderAccent,
      selectedText: AC.blueGenderAccent,
    ),
    // TagItem(
    //   value: PetGender.other,
    //   label: 'Khác',
    //   selectedBg: AC.greenSelectedBg,
    //   selectedBorder: AC.greenSelectedAccent,
    //   selectedText: AC.greenSelectedAccent,
    // ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gender = ref.watch(petFormDataProvider.select((s) => s.gender));
    final notifier = ref.read(petFormDataProvider.notifier);

    return SizedBox(
      width: double.infinity,
      child: TagSelector<PetGender>(
        value: gender,
        onChanged: notifier.setGender,
        items: _genderItems(context),
        itemsPerRow: 2,
      ),
    );
  }
}

class _IsNeuteredCheckboxWidget extends ConsumerWidget {
  const _IsNeuteredCheckboxWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNeutered = ref.watch(
      petFormDataProvider.select((s) => s.isNeutered),
    );
    final notifier = ref.read(petFormDataProvider.notifier);

    return Align(
      alignment: Alignment.centerLeft,
      child: TapEffect(
        effect: TapEffectType.none,
        onTap: () {
          notifier.setIsNeutered(!isNeutered);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.scale(
              scale: SC.smin(24) / 18,
              child: Checkbox(
                value: isNeutered,
                onChanged: (_) => notifier.setIsNeutered(!isNeutered),
                activeColor: AC.greenStrong1,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                side: BorderSide(color: AC.greyCheckbox, width: SC.smin(2)),
              ),
            ),
            SizedBox(width: SC.sw(4)),
            Text(
              AppLocalizations.of(context)!.petFormNeutered,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                fontSize: SC.sf(14),
                letterSpacing: 0.2,
                color: AC.blackText4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class _ContinueButton extends StatelessWidget {
//   const _ContinueButton({required this.onTap});

//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.bottomRight,
//       child: ActionButton(
//         text: 'Tiếp tục',
//         isSmall: true,
//         trailingIcon: Image.asset('assets/icons/arrow-right-pet-form.png'),
//         onTap: () {
//           onTap();
//         },
//       ),
//     );
//   }
// }
