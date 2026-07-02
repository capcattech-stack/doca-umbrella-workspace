import 'package:flutter/material.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/widgets/button/tap_effect.dart';

/// Text field that lets users add chips by pressing a trailing arrow.
class ChipsCreatorTextField extends StatefulWidget {
  const ChipsCreatorTextField({
    super.key,
    required this.hintText,
    this.initialChips = const [],
    this.onChanged,
  });

  final String hintText;
  final List<String> initialChips;
  final ValueChanged<List<String>>? onChanged;

  @override
  State<ChipsCreatorTextField> createState() => _ChipsCreatorTextFieldState();
}

class _ChipsCreatorTextFieldState extends State<ChipsCreatorTextField> {
  late final TextEditingController _controller;
  late List<String> _chips;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _chips = List<String>.from(widget.initialChips);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addChip() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _chips.add(text);
      _controller.clear();
    });
    widget.onChanged?.call(_chips);
  }

  void _removeChip(String text) {
    setState(() {
      _chips.remove(text);
    });
    widget.onChanged?.call(_chips);
  }

  Widget _buildChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SC.sw(16),
        vertical: SC.sh(8),
      ),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(203, 243, 229, 0.5),
        border: Border.all(
          color: AC.greenStrong2,
          width: SC.smin(2),
        ),
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(12, 26, 75, 0.04),
            blurRadius: SC.smin(5),
          ),
          BoxShadow(
            color: const Color.fromRGBO(50, 50, 71, 0.02),
            offset: const Offset(0, 4),
            blurRadius: SC.smin(20),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w500,
              fontSize: SC.sf(14),
              color: AC.greenStrong2,
            ),
          ),
          SizedBox(width: SC.sw(8)),
          TapEffect(
            effect: TapEffectType.opacity,
            onTap: () => _removeChip(text),
            child: Icon(
              Icons.close,
              size: SC.smin(16),
              color: AC.greenStrong2,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasChips = _chips.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: SizeConfig.sh(56),
          padding: EdgeInsets.symmetric(horizontal: SC.sw(16)),
          decoration: BoxDecoration(
            color: AC.greyBox1,
            border: Border.all(color: AC.greyBorder1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.hintText,
                    hintStyle: TextStyle(
                      fontSize: SC.sf(14),
                      color: AC.greyText1,
                    ),
                  ),
                  onSubmitted: (_) => _addChip(),
                ),
              ),
              TapEffect(
                onTap: _addChip,
                child: Container(
                  width: SC.sw(32),
                  height: SC.sw(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AC.greyBorder1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    size: SC.smin(18),
                    color: AC.blackText1,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (hasChips) ...[
          SizedBox(height: SC.sh(12)),
          Wrap(
            spacing: SC.sw(10),
            runSpacing: SC.sw(10),
            crossAxisAlignment: WrapCrossAlignment.center,
            children: _chips
                .map((e) => _buildChip(e))
                .toList(growable: false),
          ),
        ],
      ],
    );
  }
}
