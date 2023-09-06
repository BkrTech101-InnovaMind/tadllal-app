// import 'package:flutter/material.dart';

// class PriceFilter extends StatefulWidget {
//   const PriceFilter({super.key});

//   @override
//   State<PriceFilter> createState() => _PriceFilterState();
// }

// class _PriceFilterState extends State<PriceFilter> {
//   RangeValues _currentRangeValues = const RangeValues(10, 100000);
//   TextEditingController minController = TextEditingController();
//   TextEditingController maxController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         RangeSlider(
//           values: _currentRangeValues,
//           min: 0,
//           max: 100000,
//           divisions: 100,
//           labels: RangeLabels(
//             _currentRangeValues.start.round().toString(),
//             _currentRangeValues.end.round().toString(),
//           ),
//           onChanged: (RangeValues values) {
//             setState(() {
//               _currentRangeValues = values;
//               minController.text = values.start.round().toString();
//               maxController.text = values.end.round().toString();
//             });
//           },
//         ),
//         TextFormField(
//           controller: minController,
//           keyboardType: TextInputType.number,
//           onChanged: (value) {
//             setState(() {
//               _currentRangeValues =
//                   RangeValues(double.parse(value), _currentRangeValues.end);
//             });
//           },
//         ),
//         TextFormField(
//           controller: maxController,
//           keyboardType: TextInputType.number,
//           onChanged: (value) {
//             setState(() {
//               _currentRangeValues =
//                   RangeValues(_currentRangeValues.start, double.parse(value));
//             });
//           },
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';

class PriceFilter extends StatefulWidget {
  final Function(double from, double to) onPricePressed;

  const PriceFilter({required this.onPricePressed, super.key});

  @override
  State<PriceFilter> createState() => _PriceFilterState();
}

class _PriceFilterState extends State<PriceFilter> {
  int activeFilter = 5;

  void _selectFilter(int index) {
    setState(() {
      activeFilter = index;
    });
    printSelectedFilter(index);
  }

  void printSelectedFilter(int index) {
    switch (index) {
      case 0:
        widget.onPricePressed(0, 100);
        break;
      case 1:
        widget.onPricePressed(100, 1000);
        break;
      case 2:
        widget.onPricePressed(1000, 10000);
        break;
      case 3:
        widget.onPricePressed(10000, 100000);
        break;
      case 4:
        widget.onPricePressed(100000, 100000);
        break;
      case 5:
        widget.onPricePressed(0, 0);
      default:
    }
  }

  Widget _buildFilterButton(int index, String label) {
    final isActive = activeFilter == index;
    return Container(
      margin: const EdgeInsets.only(right: 15),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: 2.5,
            horizontal: 2.5,
          ),
          backgroundColor:
              isActive ? const Color(0xFF234F68) : const Color(0xFFF5F4F8),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
        ),
        onPressed: () {
          _selectFilter(index);
        },
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            "حسب السعر",
            style: TextStyle(
                color: Color(0xFF234F68), fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: MediaQuery.sizeOf(context).height / 15,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                _buildFilterButton(5, "الكل"),
                _buildFilterButton(0, "0 - 100"),
                _buildFilterButton(1, "100 - 1,000"),
                _buildFilterButton(2, "1,000 - 10,000"),
                _buildFilterButton(3, "10,000 - 100,000"),
                _buildFilterButton(4, "100,000+"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
