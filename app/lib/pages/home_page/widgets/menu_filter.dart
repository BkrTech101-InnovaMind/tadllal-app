import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tedllal/model/filter_option.dart';

class MenuFilter extends StatefulWidget {
  const MenuFilter({super.key, required this.onFiltersChecked});
  final Function(List<FilterOption> selectedOptions) onFiltersChecked;

  @override
  State<MenuFilter> createState() => _MenuFilterState();
}

class _MenuFilterState extends State<MenuFilter> {
  List<FilterOption> options = [
    FilterOption(label: 'للبيع', isChecked: false),
    FilterOption(label: 'للإيجار', isChecked: false),
    FilterOption(label: 'التقييم', isChecked: false),
  ];

  List<FilterOption> selectedOptions = [];

  final GlobalKey _popupKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
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

                      widget.onFiltersChecked(selectedOptions);
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
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFDFDFDF), width: 2),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(Icons.arrow_drop_down_rounded),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  child: Text(
                    selectedOptions.isNotEmpty
                        ? selectedOptions
                            .map((option) => option.label)
                            .join('، ')
                        : 'فلترة المعروضات',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              SvgPicture.asset('assets/icons/filter-icon.svg'),
            ],
          ),
        ),
      ),
    );
  }
}
