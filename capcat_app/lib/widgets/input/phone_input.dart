import 'package:flutter/material.dart';
import 'package:capcat_doca/models/country.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/l10n/gen/app_localizations.dart';

class PhoneInput extends StatefulWidget {
  final void Function(String)? onChanged;
  final String? initialValue;

  const PhoneInput({super.key, this.onChanged, this.initialValue});

  @override
  State<PhoneInput> createState() => _PhoneInputState();
}

class _PhoneInputState extends State<PhoneInput> {
  final Country _selectedCountry = countryList.first;
  final TextEditingController _phoneController = TextEditingController();
  bool _isApplyingInitialValue = false;

  @override
  void initState() {
    super.initState();

    // Gán giá trị ban đầu nếu có
    _applyInitialValue(widget.initialValue);

    _phoneController.addListener(() {
      _emitFullPhoneNumber();
    });
  }

  @override
  void didUpdateWidget(covariant PhoneInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _applyInitialValue(widget.initialValue);
    }
  }

  void _applyInitialValue(String? initialValue) {
    if (initialValue == null) {
      return;
    }
    _isApplyingInitialValue = true;
    if (initialValue.isEmpty) {
      _phoneController.clear();
      _isApplyingInitialValue = false;
      return;
    }
    final dialCode = _selectedCountry.dialCode;
    if (initialValue.startsWith(dialCode)) {
      final rawPhone = initialValue.replaceFirst(dialCode, '').trim();
      _phoneController.text = rawPhone;
    } else {
      _phoneController.text = initialValue;
    }
    _isApplyingInitialValue = false;
  }

  // void _showCountryPicker() async {
  //   final selected = await showModalBottomSheet<Country>(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  //     ),
  //     backgroundColor: AppColors.background,
  //     builder: (_) {
  //       return ListView.separated(
  //         padding: const EdgeInsets.symmetric(vertical: 16),
  //         itemCount: countryList.length,
  //         separatorBuilder: (_, __) => const Divider(height: 1),
  //         itemBuilder: (context, index) {
  //           final country = countryList[index];
  //           return ListTile(
  //             leading: Image.asset(
  //               country.flagAsset,
  //               width: 24,
  //               height: 16,
  //               fit: BoxFit.cover,
  //             ),
  //             title: Text(
  //               country.dialCode,
  //               style: const TextStyle(fontWeight: FontWeight.w500),
  //             ),
  //             trailing: Text(country.name),
  //             onTap: () => Navigator.pop(context, country),
  //           );
  //         },
  //       );
  //     },
  //   );

  //   if (selected != null) {
  //     setState(() => _selectedCountry = selected);
  //     _emitFullPhoneNumber();
  //   }
  // }

  void _emitFullPhoneNumber() {
    if (_isApplyingInitialValue) return;
    final fullPhone =
        '${_selectedCountry.dialCode}${_phoneController.text.trim()}';
    widget.onChanged?.call(fullPhone);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final height = SizeConfig.sh(56);
    final dividerHeight = SizeConfig.sh(16);
    final flagWidth = SizeConfig.sw(24);
    final flagHeight = SizeConfig.sw(16);
    // final iconSize = SizeConfig.sw(16);

    return Container(
      width: SizeConfig.sw(327),
      height: height,
      padding: EdgeInsets.fromLTRB(SC.sw(20), 0, SC.sw(20), 0),
      decoration: BoxDecoration(
        color: AC.greyBox1,
        border: Border.all(color: AC.greyBorder1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // SizedBox(width: SizeConfig.sw(16)),
          InkWell(
            onTap: () {
              // _showCountryPicker();
            },
            child: SizedBox(
              height: SizeConfig.sw(24),
              // width: SizeConfig.sw(87),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    _selectedCountry.flagAsset,
                    width: flagWidth,
                    height: flagHeight,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: SizeConfig.sw(8)),
                  Text(
                    _selectedCountry.dialCode,
                    style: TextStyle(
                      fontSize: SizeConfig.sf(14),
                      fontWeight: FontWeight.w500,
                      color: AC.blackText1,
                    ),
                  ),
                  SizedBox(width: SizeConfig.sw(4)),
                  // Icon(
                  //   Icons.arrow_drop_down_outlined,
                  //   size: iconSize,
                  //   color: AC.greyText3,
                  // ),
                  SizedBox(width: SC.sw(8)),
                ],
              ),
            ),
          ),
          Container(width: 1, height: dividerHeight, color: AC.greyText2),
          SizedBox(width: SC.sw(8)),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(right: SizeConfig.sw(16)),
              child: TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: AC.greyBox1,
                  hintText: l10n.phoneInputHint,
                  hintStyle: TextStyle(
                    fontSize: SizeConfig.sf(14),
                    fontWeight: FontWeight.w400,
                    color: AC.greyText1,
                  ),
                ),
                style: TextStyle(
                  fontSize: SizeConfig.sf(14),
                  fontWeight: FontWeight.w500,
                  color: AC.blackText1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}
