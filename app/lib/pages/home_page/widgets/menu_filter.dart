import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuFilter extends StatefulWidget {
  const MenuFilter({super.key});

  @override
  State<MenuFilter> createState() => _MenuFilterState();
}

class _MenuFilterState extends State<MenuFilter> {
  List<FilterOption> options = [
    FilterOption(label: 'للبيع', isChecked: false),
    FilterOption(label: 'للإيجار', isChecked: false),
    FilterOption(label: 'متاح', isChecked: false),
    FilterOption(label: 'التقييم', isChecked: false),
  ];

  List<FilterOption> selectedOptions = [];

  final GlobalKey _popupKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: GestureDetector(
        onTap: () {
          final RenderBox popupBox =
              _popupKey.currentContext!.findRenderObject() as RenderBox;
          showMenu<int>(
            context: context,
            position: RelativeRect.fromLTRB(
              popupBox.localToGlobal(Offset.zero).dx,
              popupBox.localToGlobal(Offset.zero).dy + popupBox.size.height,
              popupBox.localToGlobal(Offset.zero).dx + popupBox.size.width,
              popupBox.localToGlobal(Offset.zero).dy +
                  popupBox.size.height +
                  options.length * 56.0, // Adjust based on the number of items
            ),
            items: options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              return PopupMenuItem<int>(
                value: index,
                child: CheckboxListTile(
                  title: Text(option.label),
                  value: option.isChecked,
                  onChanged: (value) {
                    setState(() {
                      option.isChecked = value!;
                      if (value) {
                        selectedOptions.add(option);
                      } else {
                        selectedOptions.remove(option);
                      }
                    });
                    Navigator.pop(context);
                    _popupKey.currentContext!
                        .findRenderObject()!
                        .markNeedsLayout();
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              );
            }).toList(),
          );
        },
        child: Container(
          key: _popupKey,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFDFDFDF)),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              SvgPicture.asset('assets/icons/filter-icon.svg'),
              const SizedBox(width: 10),
              Text(
                selectedOptions.isNotEmpty
                    ? selectedOptions.map((option) => option.label).join(', ')
                    : 'فلترة المعروضات',
              ),
              const SizedBox(width: 5),
              const Icon(Icons.arrow_drop_down_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class FilterOption {
  final String label;
  bool isChecked;

  FilterOption({required this.label, required this.isChecked});
}
