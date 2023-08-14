import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:tadllal/pages/real_estate_details_page/real_estate_details_page.dart';

final realEstatesApiExample = [
  {
    'images': [
      'assets/images/shape.png',
      'assets/images/shape2.png',
      'assets/images/shape3.png',
      'assets/images/shape4.png',
    ],
    "availability": "متاح",
    "state": "للإيجار",
    "location": "حدة,حي العفيفة",
    "price": "220",
    "type": "أرض",
    "title": "شقة مفروشة للإيجار",
    "description":
        "شقة مفروشة للايجار في ارقى احياء صنعاء مجهزة باحدث وسائل الراحة الممكنه التي قد تحلم بها في حياتك ",
    "rating": "4.8",
    "isFavorite": false
  },
  {
    'images': [
      'assets/images/shape.png',
      'assets/images/shape2.png',
      'assets/images/shape3.png',
      'assets/images/shape4.png',
    ],
    "availability": "غير متاح",
    "state": "للبيع",
    "type": "شقة",
    "location": "بيت بوس, حي الشباب",
    "price": "500,000",
    "title": "فيلا بتصميم حديث",
    "description":
        "شقة مفروشة للايجار في ارقى احياء صنعاء مجهزة باحدث وسائل الراحة الممكنه التي قد تحلم بها في حياتك ",
    "rating": "4.8",
    "isFavorite": false
  },
];

class RealEstate {
  final List<String> images;
  final String availability;
  final String state;
  final String location;
  final String price;
  final String type;
  final String title;
  final String description;
  final String rating;
  final bool isFavorite;

  RealEstate({
    required this.images,
    required this.availability,
    required this.state,
    required this.location,
    required this.price,
    required this.type,
    required this.title,
    required this.description,
    required this.rating,
    required this.isFavorite,
  });
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchValue = '';
  final List<String> _suggestions = [];

  List<Map<String, dynamic>> filteredResults() {
    return realEstatesApiExample.where((Map<String, dynamic> realEstate) {
      return (realEstate['title'].toLowerCase().contains(
                searchValue.toLowerCase(),
              )) ||
          (realEstate['location'].toLowerCase().contains(
                searchValue.toLowerCase(),
              )) ||
          (realEstate['price'].toString().toLowerCase().contains(
                searchValue.toLowerCase(),
              ));
    }).toList();
  }

  void onSearch(value) {
    setState(() {
      searchValue = value;
      _suggestions.clear();
      if (searchValue.isNotEmpty) {
        for (Map<String, dynamic> realEstate in realEstatesApiExample) {
          if ((realEstate['title'].toLowerCase().contains(
                    searchValue.toLowerCase(),
                  )) ||
              (realEstate['location'].toLowerCase().contains(
                    searchValue.toLowerCase(),
                  )) ||
              (realEstate['price'].toString().toLowerCase().contains(
                    searchValue.toLowerCase(),
                  ))) {
            _suggestions.add(realEstate['title']);
          }
        }
      }
    });
  }

  void onSuggestionTap(String suggestion) {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      searchValue = suggestion;
      if (!_suggestions.contains(suggestion)) {
        _suggestions.add(suggestion);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EasySearchBar(
        backgroundColor: const Color(0xFF194706),
        title: const Text(
          'ألبحث',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        onSearch: onSearch,
        iconTheme: const IconThemeData(color: Colors.white),
        suggestions: _suggestions,
        onSuggestionTap: onSuggestionTap,
      ),
      body: searchValue.isNotEmpty
          ? GestureDetector(
              onPanDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: filteredResults().length,
                itemBuilder: (context, index) {
                  final realEstate = filteredResults()[index];
                  return ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return RealEstateDetailsPage(realEstate: realEstate);
                      }));
                    },
                    leading: Image.asset(realEstate['images'][0]),
                    title: Text(realEstate['title']),
                    subtitle: Text('${realEstate['price']} \$'),
                  );
                },
              ),
            )
          : GestureDetector(
              onPanDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
              child: const Center(
                child: Text(
                  'هنا حيث تستطيع البحث عن العقار الذي يناسب احتياجك',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF234F68),
                    fontSize: 25,
                  ),
                ),
              ),
            ),
    );
  }
}
