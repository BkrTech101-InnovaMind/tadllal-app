import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tadllal/methods/api_provider.dart';
import 'package:tadllal/model/real_estate.dart';
import 'package:tadllal/pages/real_estate_details_page/real_estate_details_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchValue = '';
  final List<String> _suggestions = [];
  List<RealEstate> realEstatesApiExample = [];

  List<RealEstate> filteredResults() {
    return realEstatesApiExample.where((realEstate) {
      return (realEstate.attributes!.name!.toLowerCase().contains(
                searchValue.toLowerCase(),
              )) ||
          (realEstate.attributes!.location!.name!.toLowerCase().contains(
                searchValue.toLowerCase(),
              )) ||
          (realEstate.attributes!.price.toString().toLowerCase().contains(
                searchValue.toLowerCase(),
              ));
    }).toList();
  }

  void onSearch(value) {
    setState(() {
      searchValue = value;
      _suggestions.clear();
      if (searchValue.isNotEmpty) {
        for (RealEstate realEstate in realEstatesApiExample) {
          if ((realEstate.attributes!.name!.toLowerCase().contains(
                    searchValue.toLowerCase(),
                  )) ||
              (realEstate.attributes!.location!.name!.toLowerCase().contains(
                    searchValue.toLowerCase(),
                  )) ||
              (realEstate.attributes!.price.toString().toLowerCase().contains(
                    searchValue.toLowerCase(),
                  ))) {
            _suggestions.add(realEstate.attributes!.name!);
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
  void initState() {
    setState(() {
      realEstatesApiExample =
          Provider.of<AppProvider>(context, listen: false).realEstateList;
    });

    super.initState();
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
              child: Container(
                margin: const EdgeInsets.only(top: 40),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: filteredResults().length,
                  itemBuilder: (context, index) {
                    final realEstate = filteredResults()[index];
                    return Container(
                      margin:
                          const EdgeInsets.only(bottom: 20, left: 10, right: 7),
                      color: const Color(0xFFF5F4F8),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return RealEstateDetailsPage(
                                  realEstate: realEstate);
                            }),
                          );
                        },
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              NetworkImage(realEstate.attributes!.photo!),
                        ),
                        title: Text(
                          realEstate.attributes!.name!,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Text(
                          '${realEstate.attributes!.price!} \$',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        trailing: SizedBox(
                          width: 60,
                          child: Row(
                            children: [
                              Text(realEstate
                                  .attributes!.ratings!.averageRating!),
                              const SizedBox(
                                width: 10,
                              ),
                              const Icon(
                                Icons.star,
                                color: Color(0xFFE0A410),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
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
