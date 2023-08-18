import 'package:flutter/material.dart';

class LocationFilter extends StatefulWidget {
  const LocationFilter({super.key});

  @override
  State<LocationFilter> createState() => _LocationFilterState();
}

class _LocationFilterState extends State<LocationFilter> {
  int activeFilter = 0;
  @override
  Widget build(BuildContext context) {
    final List locations = [
      "أرتل",
      "حدة",
      "السبعين",
      "الأصبحي",
      "المطار",
    ];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "أفضل المواقع",
            style: TextStyle(
                color: Color(0xFF234F68), fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 60,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
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
      ),
    );
  }
}
