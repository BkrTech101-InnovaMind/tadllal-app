import 'package:flutter/material.dart';

class SearchPageFilters extends StatefulWidget {
  const SearchPageFilters({super.key});

  @override
  State<SearchPageFilters> createState() => _SearchPageFiltersState();
}

class _SearchPageFiltersState extends State<SearchPageFilters> {
  String selectedSecondType = '';
  String selectedBaptism = '';
  String selectedFirstType = '';
  String selectedVision = '';

  List<String> secondTypes = ['for rent', 'for sale'];
  List<String> baptisms = ['itaque', 'dolorum'];
  List<String> firstTypes = ['dolore', 'ea'];
  List<String> visions = ['velit', 'nononone'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F4F8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextFormField(
              textAlign: TextAlign.center,
              readOnly: true,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('الحالة'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: secondTypes.map((type) {
                          return ListTile(
                            title: Text(type),
                            onTap: () {
                              setState(() {
                                selectedSecondType = type;
                              });
                              Navigator.pop(context);
                            },
                          );
                        }).toList(),
                      ),
                      actions: [
                        MaterialButton(
                          height: 30.0,
                          minWidth: 50.0,
                          color: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          textColor: Colors.white,
                          onPressed: () {
                            setState(() {
                              selectedSecondType = "";
                            });
                            Navigator.of(context).pop();
                          },
                          splashColor: Colors.redAccent,
                          child: const Text(
                            'تفريغ',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              decoration: const InputDecoration(
                hintText: 'الحالة',
                border: UnderlineInputBorder(borderSide: BorderSide.none),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
              ),
              controller: TextEditingController(text: selectedSecondType),
            ),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F4F8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextFormField(
              textAlign: TextAlign.center,
              readOnly: true,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('التعميد'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: baptisms.map((baptism) {
                          return ListTile(
                            title: Text(baptism),
                            onTap: () {
                              setState(() {
                                selectedBaptism = baptism;
                              });
                              Navigator.pop(context);
                            },
                          );
                        }).toList(),
                      ),
                      actions: [
                        MaterialButton(
                          height: 30.0,
                          minWidth: 50.0,
                          color: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          textColor: Colors.white,
                          onPressed: () {
                            setState(() {
                              selectedBaptism = "";
                            });
                            Navigator.of(context).pop();
                          },
                          splashColor: Colors.redAccent,
                          child: const Text(
                            'تفريغ',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              decoration: const InputDecoration(
                hintText: 'التعميد',
                border: UnderlineInputBorder(borderSide: BorderSide.none),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
              ),
              controller: TextEditingController(text: selectedBaptism),
            ),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F4F8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextFormField(
              textAlign: TextAlign.center,
              readOnly: true,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('النوع'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: firstTypes.map((type) {
                          return ListTile(
                            title: Text(type),
                            onTap: () {
                              setState(() {
                                selectedFirstType = type;
                              });
                              Navigator.pop(context);
                            },
                          );
                        }).toList(),
                      ),
                      actions: [
                        MaterialButton(
                          height: 30.0,
                          minWidth: 50.0,
                          color: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          textColor: Colors.white,
                          onPressed: () {
                            setState(() {
                              selectedFirstType = "";
                            });
                            Navigator.of(context).pop();
                          },
                          splashColor: Colors.redAccent,
                          child: const Text(
                            'تفريغ',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              decoration: const InputDecoration(
                hintText: 'النوع',
                border: UnderlineInputBorder(borderSide: BorderSide.none),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
              ),
              controller: TextEditingController(text: selectedFirstType),
            ),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F4F8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextFormField(
              textAlign: TextAlign.center,
              readOnly: true,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('البصيرة'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: visions.map((vision) {
                          return ListTile(
                            title: Text(vision),
                            onTap: () {
                              setState(() {
                                selectedVision = vision;
                              });
                              Navigator.pop(context);
                            },
                          );
                        }).toList(),
                      ),
                      actions: [
                        MaterialButton(
                          height: 30.0,
                          minWidth: 50.0,
                          color: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          textColor: Colors.white,
                          onPressed: () {
                            setState(() {
                              selectedVision = "";
                            });
                            Navigator.of(context).pop();
                          },
                          splashColor: Colors.redAccent,
                          child: const Text(
                            'تفريغ',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              decoration: const InputDecoration(
                hintText: 'البصيرة',
                // suffixIcon: Icon(Icons.arrow_drop_down),
                border: UnderlineInputBorder(borderSide: BorderSide.none),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
              ),
              controller: TextEditingController(text: selectedVision),
            ),
          ),
        ),
      ],
    );
  }
}
