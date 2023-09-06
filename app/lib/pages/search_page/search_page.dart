import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tedllal/config/global.dart';
import 'package:tedllal/methods/api_provider.dart';
import 'package:tedllal/model/real_estate.dart';
import 'package:tedllal/pages/real_estate_details_page/real_estate_details_page.dart';
import 'package:tedllal/pages/search_page/widgets/search_page_filters.dart';
import 'package:tedllal/services/api/dio_api.dart';
import 'package:tedllal/widgets/loading_ui/loader1.dart';

enum FilterSearchType{
  secondType,
  baptism,
  firstType,
  vision
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  bool isEmpty = true;

  void whenSearchIsEmpty() {
    setState(() {
      searchController.clear();
      isEmpty = true;
    });
  }

  String searchValue = '';
  final List<String> _suggestions = [];
  List<RealEstate> realEstatesApiExample = [];
  List<RealEstate> filteredResultsList = [];
  final DioApi dioApi = DioApi();
  Future<List<RealEstate>> realEstateDataList = Future(() => []);

  void filteredResults({ String data="",FilterSearchType? filterSearchType,}) {

    List<RealEstate> real=realEstatesApiExample.where((realEstate) {
      return (realEstate.attributes!.name!.toLowerCase().contains(searchValue.toLowerCase() ))
          ||
          (realEstate.attributes!.location!.name!.toLowerCase().contains(searchValue.toLowerCase()))
          ||
          (realEstate.attributes!.price.toString().toLowerCase().contains(searchValue.toLowerCase()));
    }).toList();


    if(filterSearchType!=null  &&data.isNotEmpty){
      switch (filterSearchType){
        case FilterSearchType.secondType:{
          real= real.where((element) => element.attributes!.secondType==data).toList();
          break;
        }
        case FilterSearchType.baptism:{
          real= real.where((element) => element.attributes!.baptism==data).toList();
          break;
        }
        case FilterSearchType.firstType:{
          real= real.where((element) => element.attributes!.firstType!.name==data).toList();
          break;
        }
        case FilterSearchType.vision:{
          real= real.where((element) => element.attributes!.vision==data).toList();
          break;
        }


      }
    }

    setState(() {
      filteredResultsList=real;
    });

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
    if (searchController.text.isEmpty) {
      setState(() {
        isEmpty = true;
      });
    } else {
      setState(() {
        isEmpty = false;
      });
    }
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
        body: SafeArea(
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F4F8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                onChanged: (value) {
                  onSearch(value);
                  filteredResults();
                },
                onSubmitted: onSuggestionTap,
                onTapOutside: (event) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                controller: searchController,
                decoration: InputDecoration(
                  suffixIcon: !isEmpty
                      ? IconButton(
                          onPressed: () => whenSearchIsEmpty(),
                          icon: const Icon(Icons.highlight_remove_rounded),
                        )
                      : null,
                  prefixIcon: const Icon(Icons.search_sharp),
                  prefixIconColor: Colors.black,
                  suffixIconColor: Colors.black,
                  border:
                      const UnderlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                      const UnderlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(vertical: 20),
                  hintText: "ابحث عن عقار",
                ),
              ),
            ),
            Expanded(
              child: searchValue.isNotEmpty
                  ? Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xFFDFDFDF),
                                offset: Offset(0, 5),
                                blurRadius: 10,
                              )
                            ],
                          ),
                          child:  Column(
                            children: [
                              const Text(
                                "فلترة النتائج",
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Color(0xFF234F68),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              SearchPageFilters(
                                onSelectedSecondType:
                                    (String selectedSecondType) {

                                  filteredResults(filterSearchType: FilterSearchType.secondType,data: selectedSecondType);
                                    },
                                onSelectedBaptism: (String selectedBaptism) {
                                  filteredResults(filterSearchType: FilterSearchType.baptism,data: selectedBaptism);
                                },
                                onSelectedFirstType:
                                    (String selectedFirstType) {

                                      filteredResults(filterSearchType: FilterSearchType.firstType,data: selectedFirstType);
                                    },
                                onSelectedVision: (String selectedVision) {
                                  filteredResults(filterSearchType: FilterSearchType.vision,data: selectedVision);
                                },
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Text(
                                  "نتائج البحث",
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Color(0xFF234F68),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        filteredResultsList.isNotEmpty
                            ? Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: filteredResultsList.length,
                                  itemBuilder: (context, index) {
                                    final realEstate = filteredResultsList[index];
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      color: const Color(0xFFF5F4F8),
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                              return RealEstateDetailsPage(
                                                  realEstate: realEstate);
                                            }),
                                          );
                                        },
                                        leading: CircleAvatar(
                                          radius: 30,
                                          backgroundImage: NetworkImage(
                                              realEstate.attributes!.photo!),
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
                                              Text(realEstate.attributes!
                                                  .ratings!.averageRating!),
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
                              )
                            : Container(
                                margin: const EdgeInsets.only(top: 30),
                                child: const Center(
                                  child: Text(noData),
                                ),
                              )
                      ],
                    )
                  : RefreshIndicator(
                      onRefresh: _refresh,
                      child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            const Center(
                              child: Text(
                                "الاعلى تقييماً",
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Color(0xFF234F68),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: FutureBuilder<List<RealEstate>>(
                                  future: realEstateDataList,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<RealEstate>>
                                          snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.hasData &&
                                          snapshot.hasError == false) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 20),
                                          child: ListView.separated(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: snapshot.data!.length,
                                              separatorBuilder: (context,
                                                      index) =>
                                                  const Divider(thickness: 2),
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 15),
                                                  child: ListTile(
                                                    onTap: () {
                                                      Navigator.push<void>(
                                                        context,
                                                        MaterialPageRoute<void>(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              RealEstateDetailsPage(
                                                            realEstate: snapshot
                                                                .data![index],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    title: Text(
                                                      snapshot.data![index]
                                                          .attributes!.name!,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    subtitle: Text(
                                                      snapshot
                                                          .data![index]
                                                          .attributes!
                                                          .description!,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    leading: CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(
                                                        snapshot.data![index]
                                                            .attributes!.photo!,
                                                      ),
                                                    ),
                                                    trailing: Container(
                                                      constraints:
                                                          BoxConstraints.tight(
                                                              const Size.square(
                                                                  60)),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Colors.grey[300],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      width: 60,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            snapshot
                                                                .data![index]
                                                                .attributes!
                                                                .ratings!
                                                                .averageRating!,
                                                          ),
                                                          const Icon(
                                                            Icons.star,
                                                            color: Color(
                                                                0xFFE0A410),
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
                                          child: Text(errorWhileGetData),
                                        ));
                                      } else {
                                        return const Center(
                                            child: Padding(
                                          padding: EdgeInsets.only(top: 16),
                                          child: Text(noData),
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
                                              child:
                                                  Text(loadingDataFromServer),
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
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 16),
                                              child:
                                                  Text(loadingDataFromServer),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    ));
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

  Future<void> _refresh() async {
    _syncData();
  }
}
