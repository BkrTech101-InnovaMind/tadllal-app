import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tadllal/methods/api_provider.dart';
import 'package:tadllal/model/real_estate.dart';
import 'package:tadllal/pages/real_estate_details_page/real_estate_details_page.dart';
import 'package:tadllal/services/api/dio_api.dart';
import 'package:tadllal/widgets/error_dialog.dart';

class RealEstateCard extends StatefulWidget {
  const RealEstateCard({Key? key}) : super(key: key);

  @override
  State<RealEstateCard> createState() => _RealEstateCardState();
}

class _RealEstateCardState extends State<RealEstateCard> {
  final DioApi dioApi = DioApi();

  void toggleFavorite({required int index, AppProvider? appProvider}) {
    RealEstate realEstate = appProvider!.filteredRealEstateList[index];

    if (realEstate.attributes!.isFavorite == true) {
      setState(() {
        appProvider.filteredRealEstateList[index].attributes!.isFavorite =
            false;
      });
      dioApi.delete("/favorites/remove/${realEstate.id}").catchError((e) {
        onToggleFavoriteError(
            index: index,
            appProvider: appProvider,
            value: true,
            desc: "فشلت عملية الحذف من المفضلة");
        return e;
      });
    } else {
      setState(() {
        appProvider.filteredRealEstateList[index].attributes!.isFavorite = true;
      });
      dioApi.post("/favorites/add", myData: {"id": realEstate.id}).catchError(
          (e) {
        onToggleFavoriteError(
            index: index, appProvider: appProvider, value: false);
        return e;
      });
    }
  }

  void onToggleFavoriteError(
      {required int index,
      AppProvider? appProvider,
      required bool value,
      String? desc}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context2) => ErrorDialog(
        desc: desc ?? "فشلت عملية الاضافة الى المفضلة",
      ),
    );

    setState(() {
      appProvider!.filteredRealEstateList[index].attributes!.isFavorite = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, appProvider, child) {
      return DynamicHeightGridView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        itemCount: appProvider.filteredRealEstateList.length,
        builder: (context, index) {
          bool favoriteColor =
              appProvider.filteredRealEstateList[index].attributes!.isFavorite!;
          String secondType =
              appProvider.filteredRealEstateList[index].attributes!.secondType!;
          String secondTypeText;
          Color backgroundColor;

          // secondType == "for sale"
          //     ?
          //     : ;

          secondType == "for rent"
              ? {
                  backgroundColor = const Color(0xFFA82727),
                  secondTypeText = "للإيجار"
                }
              : {
                  backgroundColor = const Color(0xFFFA712D),
                  secondTypeText = "للبيع"
                };

          return TextButton(
            style: TextButton.styleFrom(padding: const EdgeInsets.all(5)),
            onPressed: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => RealEstateDetailsPage(
                    realEstate: appProvider.filteredRealEstateList[index],
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color(0xFFF5F4F8),
              ),
              child: Column(
                children: [
                  CachedNetworkImage(
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            height: 180,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Stack(
                                      children: [
                                        Positioned(
                                          child: GestureDetector(
                                            onTap: () {
                                              toggleFavorite(
                                                  index: index,
                                                  appProvider: appProvider);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                color: favoriteColor
                                                    ? const Color(0xFF8BC83F)
                                                    : Colors.white,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(100),
                                                ),
                                              ),
                                              child: SvgPicture.asset(
                                                "assets/icons/favorites-icon.svg",
                                                width: 20,
                                                colorFilter: ColorFilter.mode(
                                                  favoriteColor
                                                      ? Colors.white
                                                      : const Color(0xFFFD5F4A),
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 8),
                                      decoration: BoxDecoration(
                                          color: backgroundColor,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(12))),
                                      child: Text(
                                        secondTypeText,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF234F68)
                                        .withOpacity(0.7),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                  ),
                                  child: Text(
                                    '\$ ${appProvider.filteredRealEstateList[index].attributes!.price!}',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      imageUrl: appProvider
                          .filteredRealEstateList[index].attributes!.photo!,
                      placeholder: (context, url) => Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/shape.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              height: 180,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Stack(
                                        children: [
                                          Positioned(
                                            child: GestureDetector(
                                              onTap: () {
                                                toggleFavorite(
                                                    index: index,
                                                    appProvider: appProvider);
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                decoration: BoxDecoration(
                                                  color: favoriteColor
                                                      ? const Color(0xFF8BC83F)
                                                      : Colors.white,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(100),
                                                  ),
                                                ),
                                                child: SvgPicture.asset(
                                                  "assets/icons/favorites-icon.svg",
                                                  width: 20,
                                                  colorFilter: ColorFilter.mode(
                                                    favoriteColor
                                                        ? Colors.white
                                                        : const Color(
                                                            0xFFFD5F4A),
                                                    BlendMode.srcIn,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 8),
                                        decoration: BoxDecoration(
                                            color: backgroundColor,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12))),
                                        child: Text(
                                          secondType,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF234F68)
                                          .withOpacity(0.7),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                    ),
                                    child: Text(
                                      '\$ ${appProvider.filteredRealEstateList[index].attributes!.price!}',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                  const SizedBox(height: 13),
                  Container(
                    padding: const EdgeInsets.all(5.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${appProvider.filteredRealEstateList[index].attributes!.name}",
                          style: const TextStyle(
                            color: Color(0xFF234F68),
                            fontWeight: FontWeight.bold,
                            height: 1,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Color(0xFF234F68),
                                ),
                                SizedBox(
                                  width: 50,
                                  child: Text(
                                    "${appProvider.filteredRealEstateList[index].attributes!.location!.name}",
                                    style: const TextStyle(
                                      color: Color(0xFF234F68),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "${appProvider.filteredRealEstateList[index].attributes!.ratings!.averageRating}",
                                  style: const TextStyle(
                                    color: Color(0xFF234F68),
                                  ),
                                ),
                                const Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 16,
                                )
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
