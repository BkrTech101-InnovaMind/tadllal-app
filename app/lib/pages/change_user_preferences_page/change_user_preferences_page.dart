import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';

final List preferences = [
  {
    "id": "1",
    "image": "assets/images/shape.png",
    "type": "فيلا",
    "isCHecked": false,
  },
  {
    "id": "2",
    "image": "assets/images/shape.png",
    "type": "فيلا",
    "isCHecked": false,
  },
  {
    "id": "3",
    "image": "assets/images/shape.png",
    "type": "فيلا",
    "isCHecked": false,
  },
  {
    "id": "4",
    "image": "assets/images/shape.png",
    "type": "فيلا",
    "isCHecked": false,
  },
  {
    "id": "5",
    "image": "assets/images/shape.png",
    "type": "فيلا",
    "isCHecked": false,
  },
  {
    "id": "6",
    "image": "assets/images/shape.png",
    "type": "فيلا",
    "isCHecked": false,
  },
  {
    "id": "7",
    "image": "assets/images/shape.png",
    "type": "فيلا",
    "isCHecked": false,
  },
  {
    "id": "8",
    "image": "assets/images/shape.png",
    "type": "فيلا",
    "isCHecked": false,
  },
  {
    "id": "9",
    "image": "assets/images/shape.png",
    "type": "فيلا",
    "isCHecked": false,
  },
  {
    "id": "10",
    "image": "assets/images/shape.png",
    "type": "فيلا",
    "isCHecked": false,
  },
];

class ChangeUserPreferencesPage extends StatefulWidget {
  const ChangeUserPreferencesPage({super.key});

  @override
  State<ChangeUserPreferencesPage> createState() =>
      _ChangeUserPreferencesPageState();
}

class _ChangeUserPreferencesPageState extends State<ChangeUserPreferencesPage> {
  final realEstate = preferences;

  void toggleCheck(int index) {
    setState(() {
      realEstate[index]['isCHecked'] = !realEstate[index]['isCHecked'];
    });
  }

  void handleSubmit() {
    List<String> selectedPreferences = [];
    for (var i = 0; i < realEstate.length; i++) {
      if (realEstate[i]?['isCHecked']) {
        selectedPreferences.add(realEstate[i]?['id']);
      }
    }

    print(selectedPreferences);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("تم تغيير المفضلة"),
      ),
    );

    Navigator.pop(context);

    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تغيير المفضلة'),
        backgroundColor: const Color(0xFF194706),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildTypesGrid(),
            buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  // Types Grid Builder widget
  Widget buildTypesGrid() {
    return Expanded(
      child: DynamicHeightGridView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 2,
        itemCount: realEstate.length,
        builder: (context, index) {
          bool isChecked = realEstate[index]['isCHecked'];
          return Card(
            color: isChecked ? const Color(0xFF1F4C6B) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextButton(
              onPressed: () => toggleCheck(index),
              style: TextButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Image.asset(realEstate[index]['image']),
                      Positioned(
                        top: 10,
                        left: 15,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: isChecked ? null : Colors.white,
                            gradient: isChecked
                                ? LinearGradient(
                                    colors: [
                                      const Color(0xFF1F4C6B).withAlpha(200),
                                      const Color(0xFF8BC83F)
                                    ],
                                  )
                                : null,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Icon(
                              Icons.check,
                              color: isChecked ? Colors.white : Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${realEstate[index]['type']}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: isChecked ? Colors.white : const Color(0xFF252B5C),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Profile Editor Submit Button widget
  Widget buildSubmitButton() {
    return Container(
      margin: const EdgeInsets.only(top: 15, bottom: 10),
      color: Colors.transparent,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: const Color(0xFF1F4C6B),
          fixedSize: const Size(278, 63),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          side: const BorderSide(color: Color(0xFF8BC83F), width: 3),
        ),
        onPressed: () {
          showDialog(context: context, builder: (_) => buildDialog());
        },
        child: const Text(
          "تعديل",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  buildDialog() {
    return AlertDialog(
      content: const Text(
        "هل متأكد من تغيير المفضلة ؟",
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("لا"),
        ),
        TextButton(
          onPressed: () {
            handleSubmit();
          },
          child: const Text("تأكيد"),
        ),
      ],
    );
  }
}
