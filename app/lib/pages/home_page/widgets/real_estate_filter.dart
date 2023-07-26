import 'package:flutter/material.dart';

class RealEstateFilter extends StatefulWidget {
  const RealEstateFilter({super.key});

  @override
  State<RealEstateFilter> createState() => _RealEstateFilterState();
}

class _RealEstateFilterState extends State<RealEstateFilter> {
  int activeFilter = 0;
  @override
  Widget build(BuildContext context) {
    final List locations = [
      "الكل",
      "منزل",
      "شقة",
      "عمارة",
      "أرض",
    ];
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "إستكشف العقارات",
              style: TextStyle(
                  color: Color(0xFF234F68), fontWeight: FontWeight.w900),
            ),
          ],
        ),
        SizedBox(
          height: 60,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: locations.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 15),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 17.5,
                        horizontal: 24,
                      ),
                      backgroundColor: activeFilter == index
                          ? const Color(0xFF234F68)
                          : const Color(0xFFF5F4F8),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                    ),
                    onPressed: () {
                      setState(() {
                        activeFilter = index;
                      });
                    },
                    child: Text(
                      locations[index],
                      style: activeFilter == index
                          ? const TextStyle(color: Colors.white)
                          : const TextStyle(color: Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
