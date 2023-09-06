import 'package:flutter/material.dart';
import 'package:tedllal/model/api_models/location.dart';

class LocationFilter extends StatefulWidget {
  const LocationFilter(
      {super.key, required this.locationList, required this.onLocationPressed});
  final List<Location> locationList;
  final Function(Location filter) onLocationPressed;

  @override
  State<LocationFilter> createState() => _LocationFilterState();
}

class _LocationFilterState extends State<LocationFilter> {
  int activeFilter = 0;

  @override
  Widget build(BuildContext context) {
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
            height: MediaQuery.sizeOf(context).height / 15,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.locationList.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 15),
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
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                    ),
                    onPressed: () {
                      widget.onLocationPressed(widget.locationList[index]);
                      setState(() {
                        activeFilter = index;
                      });
                    },
                    child: Text(
                      widget.locationList[index].attributes!.name!,
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
      ),
    );
  }
}
