import 'package:flutter/material.dart';
import 'package:tadllal/model/real_estate_type.dart';

class TypeFilter extends StatefulWidget {
  const TypeFilter(
      {super.key, required this.typeList, required this.onTypePressed});
  final List<RealEstateType> typeList;
  final Function(RealEstateType type) onTypePressed;

  @override
  State<TypeFilter> createState() => _RealEstateFilterState();
}

class _RealEstateFilterState extends State<TypeFilter> {
  int activeFilter = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          "إستكشف العقارات",
          style:
              TextStyle(color: Color(0xFF234F68), fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: MediaQuery.sizeOf(context).height / 15,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.typeList.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(right: 7, left: 7),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 2.5,
                      horizontal: 2.5,
                    ),
                    backgroundColor: activeFilter == index
                        ? const Color(0xFF234F68)
                        : const Color(0xFFF5F4F8),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14))),
                  ),
                  onPressed: () {
                    setState(() {
                      widget.onTypePressed(widget.typeList[index]);
                      activeFilter = index;
                    });
                  },
                  child: Text(
                    widget.typeList[index].attributes!.name!,
                    style: activeFilter == index
                        ? const TextStyle(color: Colors.white)
                        : const TextStyle(color: Colors.black),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
