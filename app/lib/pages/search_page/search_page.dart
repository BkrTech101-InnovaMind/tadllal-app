import 'dart:convert';

import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tadllal/config/global.dart';
import 'package:tadllal/methods/api_provider.dart';
import 'package:tadllal/model/real_estate.dart';
import 'package:tadllal/pages/real_estate_details_page/real_estate_details_page.dart';
import 'package:tadllal/services/api/dio_api.dart';
import 'package:tadllal/widgets/LodingUi/Loder1.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchValue = '';
  final List<String> _suggestions = [];
  List<RealEstate> realEstatesApiExample = [];
  final DioApi dioApi = DioApi();
  Future<List<RealEstate>> realEstateDataList = Future(() => []);
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
    _syncData();
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
              child: RefreshIndicator(
                onRefresh: refresh,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: [

                    FutureBuilder<List<RealEstate>>(
                        future: realEstateDataList,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<RealEstate>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData &&
                                snapshot.hasError == false) {
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 20),
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.length,
                                    separatorBuilder: (context, index) => const Divider(thickness: 2),
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: const EdgeInsets.only(top: 15),
                                        child: ListTile(
                                          onTap: () {},
                                          title: Text(
                                            snapshot.data![index].attributes!.name!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          subtitle: Text(
                                              snapshot.data![index].attributes!.description!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          leading: CircleAvatar(
                                            backgroundImage:
                                            NetworkImage( snapshot.data![index].attributes!.photo!,),
                                          ),
                                          trailing: Container(
                                            constraints: BoxConstraints.tight(const Size.square(60)),
                                            decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius: BorderRadius.circular(10)),
                                            width: 60,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text( snapshot.data![index].attributes!.ratings!.averageRating!,),
                                                const Icon(
                                                  Icons.star,
                                                  color: Color(0xFFE0A410),
                                                  size: 20,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              );
                            } else if (snapshot.hasError) {
                              return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 16),
                                    child: Text(ERROR_WHILE_GET_DATA),
                                  ));
                            } else {
                              return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 16),
                                    child: Text(NO_DATA),
                                  ));
                            }
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: ColorLoader1(),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 16),
                                    child: Text(LOADING_DATA_FROM_SERVER),
                                  )
                                ],
                              ),
                            );
                          } else {
                            return const Center(
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: CircularProgressIndicator(),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 16),
                                    child: Text(LOADING_DATA_FROM_SERVER),
                                  )
                                ],
                              ),
                            );
                          }
                        }),
                  ],
                ),
              )
            ),
    );
  }

  Future<List<RealEstate>> _getRealEstateData() async {
    var rowData = await dioApi.get("/realEstate/filters/by-highest-rated");
    // var rowData = await dioApi.get("/realEstate/realty");
    // log("rowData ${rowData}");
    String jsonString = json.encode(rowData.data["data"]);
    // log("jsonString ${jsonString}");
    List<Map<String, dynamic>> data = (jsonDecode(jsonString) as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();

    // log("data ${data}");
    List<RealEstate> realEstate =
    (data).map((itemWord) => RealEstate.fromJson(itemWord)).toList();
    return realEstate;
  }
  _syncData() {

    setState(() {
      realEstateDataList = _getRealEstateData();

    });
  }
  Future<void> refresh() async {
    _syncData();
  }
}
