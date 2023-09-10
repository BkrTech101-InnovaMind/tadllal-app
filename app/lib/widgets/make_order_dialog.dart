import 'package:colorful_circular_progress_indicator/colorful_circular_progress_indicator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tedllal/config/global.dart';
import 'package:tedllal/services/api/dio_api.dart';

class MakeOrderDialog extends StatefulWidget {
  final int orderId;

  ///make order type [type]
  ///
  /// If the type is RealEstate the api path will be /orders/new/[orderId]
  /// else if the type is Service the api path will be orders/service/new/[orderId]
  ///
  final String type;
  const MakeOrderDialog({super.key, required this.type, required this.orderId});

  @override
  State<MakeOrderDialog> createState() => _MakeOrderDialogState();
}

class _MakeOrderDialogState extends State<MakeOrderDialog> {
  TextEditingController messageController = TextEditingController();
  Future<Response> data =
      Future(() => Response(requestOptions: RequestOptions()));

  DioApi dioApi = DioApi();
  Map<String, dynamic> formValue = {};
  bool makeOrder = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consist.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding:
              const EdgeInsets.only(top: 5, right: 20, left: 20, bottom: 5),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(Consist.padding),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: makeOrder
              ? FutureBuilder<Response>(
                  future: data,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "حفظ البيانات",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Cairo",
                              color: Color(0xFF234F68),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Divider(
                              height: 10,
                              color: Colors.black,
                              thickness: 1.5,
                              indent: 1,
                              endIndent: 1),
                          SizedBox(height: 11.0),
                          Row(
                            children: [
                              ColorfulCircularProgressIndicator(
                                colors: [
                                  Color(0xfff48923),
                                  Colors.lightGreenAccent,
                                  Colors.red
                                ],
                                strokeWidth: 5,
                                indicatorHeight: 40,
                                indicatorWidth: 40,
                              ),
                              SizedBox(width: 30),
                              Text(
                                "جاري حفظ البيانات يرجى الانتظار",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Cairo",
                                  color: Color(0xFF234F68),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      if (snapshot.hasData && !snapshot.hasError) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("تم الحفظ بنجاح",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: "Cairo",
                                    color: Color(0xFF234F68),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                            const Divider(
                                height: 10,
                                color: Colors.black,
                                thickness: 1.5,
                                indent: 1,
                                endIndent: 1),
                            const SizedBox(height: 11.0),
                            const Row(
                              children: [
                                Icon(
                                  Icons.done_outline_outlined,
                                  color: Colors.lightGreenAccent,
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  "تم الحفظ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Cairo",
                                    color: Color(0xFF234F68),
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                MaterialButton(
                                  height: 30.0,
                                  minWidth: 50.0,
                                  color: Colors.redAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  textColor: Colors.white,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  splashColor: Colors.redAccent,
                                  child: const Text(
                                    'إغلاق',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            )
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("فشل",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: "Cairo",
                                    color: Color(0xFF234F68),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                            const Divider(
                                height: 10,
                                color: Colors.black,
                                thickness: 1.5,
                                indent: 1,
                                endIndent: 1),
                            const SizedBox(height: 11.0),
                            Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.redAccent,
                                ),
                                const SizedBox(width: 30),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text(
                                    snapshot.error.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontFamily: "Cairo",
                                      color: Color(0xFF234F68),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                MaterialButton(
                                  height: 30.0,
                                  minWidth: 50.0,
                                  color: Colors.redAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  textColor: Colors.white,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  splashColor: Colors.redAccent,
                                  child: const Text(
                                    'إغلاق',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                MaterialButton(
                                  height: 30.0,
                                  minWidth: 50.0,
                                  color: const Color(0xFF8BC83F),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  textColor: Colors.white,
                                  onPressed: () {
                                    _getData();
                                  },
                                  splashColor: Colors.redAccent,
                                  child: const Text(
                                    'إعادة المحاولة',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("فشل",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: "Cairo",
                                    color: Color(0xFF234F68),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                            const Divider(
                                height: 10,
                                color: Colors.black,
                                thickness: 1.5,
                                indent: 1,
                                endIndent: 1),
                            const SizedBox(height: 11.0),
                            const Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Icon(
                                    Icons.error_outline,
                                    color: Colors.redAccent,
                                  ),
                                ),
                                SizedBox(width: 30),
                                Expanded(
                                  flex: 9,
                                  child: Text(
                                    "حدث خطاء اثناء الحفظ يرجى إعادة المحاولة",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: "Cairo",
                                      color: Color(0xFF234F68),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                MaterialButton(
                                  height: 30.0,
                                  minWidth: 50.0,
                                  color: Colors.redAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  textColor: Colors.white,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  splashColor: Colors.redAccent,
                                  child: const Text(
                                    'إغلاق',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                MaterialButton(
                                  height: 30.0,
                                  minWidth: 50.0,
                                  color: const Color(0xFF8BC83F),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  textColor: Colors.white,
                                  onPressed: () {
                                    _getData();
                                  },
                                  splashColor: const Color(0xFF8BC83F),
                                  child: const Text(
                                    'إعادة المحاولة',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    } else {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("فشل",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "Cairo",
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                          const Divider(
                              height: 10,
                              color: Colors.white,
                              thickness: 1.5,
                              indent: 1,
                              endIndent: 1),
                          const SizedBox(height: 11.0),
                          const Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.redAccent,
                              ),
                              SizedBox(width: 30),
                              FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  "حدث خطاء اثناء الحفظ يرجى إعادة المحاولة",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Cairo",
                                    color: Color(0xFF234F68),
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              MaterialButton(
                                height: 30.0,
                                minWidth: 50.0,
                                color: Colors.redAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                textColor: Colors.white,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                splashColor: Colors.redAccent,
                                child: const Text(
                                  'إغلاق',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              MaterialButton(
                                height: 30.0,
                                minWidth: 50.0,
                                color: const Color(0xFF8BC83F),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                textColor: Colors.white,
                                onPressed: () {
                                  _getData();
                                },
                                splashColor: const Color(0xFF8BC83F),
                                child: const Text(
                                  'إعادة المحاولة',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  })
              : SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("هل تريد هذا الطلب؟",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "Cairo",
                              color: Color(0xFF234F68),
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                      const Divider(
                          height: 10,
                          color: Colors.white,
                          thickness: 1.5,
                          indent: 1,
                          endIndent: 1),
                      const SizedBox(height: 11.0),
                      const Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Color(0xFF8BC83F),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Text(
                              "سيتم اخذ تفاصيل طلبك اَليا، هل هناك تفاصيل اخرى تود إضافتها ؟.",
                              textAlign: TextAlign.center,
                              softWrap: false,
                              style: TextStyle(
                                fontFamily: "Cairo",
                                color: Color(0xFF234F68),
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      FormBuilderTextField(
                        textAlign: TextAlign.start,
                        controller: messageController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        style: lightDetailsTextFieldTheme,
                        decoration: InputDecoration(
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 5),
                          fillColor: const Color(0xFFF5F4F8),
                          //<-- SEE HERE
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1, color: Color(0xFFF5F4F8)),
                            //<-- SEE HERE
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          focusedBorder: const OutlineInputBorder(
                              gapPadding: 1,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Color(0xFF234F68))),

                          labelText: 'تفاصيل اضافية',
                          labelStyle: lightDetailsLabelTextFieldTheme,
                        ),
                        name: '',
                      ),
                      const SizedBox(height: 15.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MaterialButton(
                            height: 30.0,
                            minWidth: 50.0,
                            color: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            splashColor: Colors.redAccent,
                            child: const Text(
                              'الغاء',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          MaterialButton(
                            height: 30.0,
                            minWidth: 50.0,
                            color: const Color(0xFF8BC83F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            textColor: Colors.white,
                            onPressed: () {
                              setState(() {
                                makeOrder = true;
                                String message = messageController.text.trim();
                                formValue = {
                                  "message": message.isEmpty == true
                                      ? "اريد هذا الطلب"
                                      : message
                                };
                              });

                              _getData();
                            },
                            splashColor: const Color(0xFF8BC83F),
                            child: const Text(
                              'تاكيد',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> _getData() async {
    setState(() {
      if (widget.type == "RealEstate") {
        data = dioApi.post("/orders/new/${widget.orderId}", myData: formValue);
      } else if (widget.type == "Service") {
        data = dioApi.post("/orders/service/new/${widget.orderId}",
            myData: formValue);
      }
    });
  }
}
