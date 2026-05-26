// import 'package:flutter/material.dart';
// import 'package:flutter_chat_mock_app/providers/pet_form_providers.dart';
// import 'package:flutter_chat_mock_app/providers/pet_personalities_data_provider.dart';
// import 'package:flutter_chat_mock_app/widgets/text/section_header_text.dart';
// import 'package:flutter_chat_mock_app/widgets/input/select_text_field.dart';
// import 'package:flutter_chat_mock_app/utils/size_config.dart';
// import 'package:flutter_chat_mock_app/widgets/input/input_field.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class PetForm3rdSheet extends ConsumerWidget {
//   const PetForm3rdSheet({super.key, this.leftButton, this.rightButton});
//   final Widget? leftButton;
//   final Widget? rightButton;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final double hp = SC.sw(24);
//     final double smallVp = SC.sh(8);
//     final double mediumVp = SC.sh(16);
//     final double largeVp = SC.sh(24);
//     return Padding(
//       padding: EdgeInsets.fromLTRB(
//         hp,
//         largeVp,
//         hp,
//         SC.physicPaddingBottom + mediumVp,
//       ),
//       child: Column(
//         children: [
//           // Nội dung cuộn được
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   //--Image
//                   const _BossCuteImageWidget(),
//                   SizedBox(height: mediumVp),
//                   //--Introduction Banner
//                   const _PetAIBanner(),
//                   SizedBox(height: mediumVp),
//                   //--Personality
//                   const SectionHeaderText('Tính cách'),
//                   SizedBox(height: smallVp),
//                   const _SelectPersonalityWidget(),
//                   SizedBox(height: mediumVp),
//                   //--SelfTerm
//                   const SectionHeaderText('Gọi thú cưng là', isOptional: true),
//                   SizedBox(height: smallVp),
//                   const _InputSelfTermField(),
//                   SizedBox(height: mediumVp),
//                   //--OwnerTerm
//                   const SectionHeaderText(
//                     'Thú cưng gọi bạn là',
//                     isOptional: true,
//                   ),
//                   SizedBox(height: smallVp),
//                   const _InputOwnerTermField(),
//                   SizedBox(height: mediumVp),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [leftButton ?? SizedBox(), rightButton ?? SizedBox()],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _BossCuteImageWidget extends StatelessWidget {
//   const _BossCuteImageWidget();

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: const BorderRadius.only(
//         topLeft: Radius.circular(16),
//         topRight: Radius.circular(16),
//       ),
//       child: Image.asset(
//         'assets/images/boss-cute-oi.png',
//         fit: BoxFit.cover, // để ảnh phủ kín
//         width: double.infinity,
//       ),
//     );
//   }
// }

// class _PetAIBanner extends StatelessWidget {
//   const _PetAIBanner();

//   static const _content =
//       '"Pet AI của bạn cũng giống thú cưng ngoài đời — cần biết bạn là người thế nào, '
//       'gọi bạn ra sao và bạn muốn gọi nó thế nào. Như vậy mới tám chuyện hợp vibe, '
//       'cưng chiều nhau đúng kiểu ‘chủ - pet’ chứ!"';

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity, // theo Figma
//       height: 116, // theo Figma
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: AC.peachWarmBg,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: SizedBox(
//         width: double.infinity,
//         height: 100,
//         child: const Text(
//           _content,
//           style: TextStyle(
//             fontFamily: 'Quicksand',
//             fontStyle: FontStyle.normal,
//             fontWeight: FontWeight.w400,
//             fontSize: 14,
//             height: 20 / 14,
//             color: Colors.black,
//           ),
//           softWrap: true,
//         ),
//       ),
//     );
//   }
// }

// //--Pers
// class _SelectPersonalityWidget extends ConsumerStatefulWidget {
//   const _SelectPersonalityWidget();

//   @override
//   ConsumerState<_SelectPersonalityWidget> createState() =>
//       _SelectPersonalityWidgetState();
// }

// class _SelectPersonalityWidgetState
//     extends ConsumerState<_SelectPersonalityWidget> {
//   late final TextEditingController _personalityController;
//   @override
//   void initState() {
//     super.initState();
//     final initialPersonality = ref.read(
//       petFormDataProvider.select((s) => s.personality),
//     );
//     _personalityController = TextEditingController(
//       text: initialPersonality ?? '',
//     );
//   }

//   @override
//   void dispose() {
//     _personalityController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final allPersonalities = ref.watch(
//       petPersonalitiesProvider.select((s) => s.allPetPersonalities),
//     );
//     final quickPicks = ref.watch(
//       petPersonalitiesProvider.select((s) => s.recentPetPersonalities),
//     );
//     final petFormNotifier = ref.read(petFormDataProvider.notifier);

//     return SelectTextField(
//       fullOptions: allPersonalities,
//       quickOptions: quickPicks,
//       hintText: 'Tính cách',
//       sheetTitle: 'Chọn tính cách',
//       searchHint: 'Tìm tính cách',
//       allSectionText: 'Tất cả tính cách',
//       controller: _personalityController,
//       icon: null,
//       onChanged: (selected) {
//         if (selected != null) {
//           ref.read(petPersonalitiesProvider.notifier).addToRecent(selected);
//         }
//         petFormNotifier.setPersonality(selected);
//       },
//     );
//   }
// }

// //--Pet self term
// class _InputSelfTermField extends ConsumerStatefulWidget {
//   const _InputSelfTermField();

//   @override
//   ConsumerState<_InputSelfTermField> createState() =>
//       _InputSelfTermFieldState();
// }

// class _InputSelfTermFieldState extends ConsumerState<_InputSelfTermField> {
//   late final TextEditingController _selfTermController;
//   @override
//   void initState() {
//     super.initState();
//     final initialSelfTerm = ref.read(
//       petFormDataProvider.select((s) => s.petTerm),
//     );
//     _selfTermController = TextEditingController(text: initialSelfTerm ?? '');
//   }

//   @override
//   void dispose() {
//     _selfTermController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final petFormNotifier = ref.read(petFormDataProvider.notifier);

//     return InputField(
//       hintText: 'Nhập tên gọi',
//       controller: _selfTermController,
//       onChanged: petFormNotifier.setPetTerm,
//     );
//   }
// }

// //--Owner term
// class _InputOwnerTermField extends ConsumerStatefulWidget {
//   const _InputOwnerTermField();

//   @override
//   ConsumerState<_InputOwnerTermField> createState() =>
//       _InputOwnerTermFieldState();
// }

// class _InputOwnerTermFieldState extends ConsumerState<_InputOwnerTermField> {
//   late final TextEditingController _ownerTermController;
//   @override
//   void initState() {
//     super.initState();
//     final initialOwnerTerm = ref.read(
//       petFormDataProvider.select((s) => s.ownerTerm),
//     );
//     _ownerTermController = TextEditingController(text: initialOwnerTerm ?? '');
//   }

//   @override
//   void dispose() {
//     _ownerTermController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final petFormNotifier = ref.read(petFormDataProvider.notifier);

//     return InputField(
//       hintText: 'Nhập tên gọi',
//       controller: _ownerTermController,
//       onChanged: petFormNotifier.setOwnerTerm,
//     );
//   }
// }
