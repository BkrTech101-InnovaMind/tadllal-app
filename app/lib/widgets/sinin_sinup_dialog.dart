import 'package:colorful_circular_progress_indicator/colorful_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:tedllal/config/global.dart';
import 'package:tedllal/model/api_molels/error_response.dart';
import 'package:tedllal/model/api_molels/login_response.dart';
import 'package:tedllal/model/api_molels/sinin_sinup_request.dart';
import 'package:tedllal/services/api/dio_api.dart';

class SinInSinUpDialog extends StatefulWidget {
  const SinInSinUpDialog(
      {Key? key,
      required this.onLogin,
      required this.sinInSinUpRequest,
      required this.type})
      : super(key: key);
  final Function(LoginResponse response) onLogin;
  final String type;

  final SinInSinUpRequest sinInSinUpRequest;

  @override
  State<SinInSinUpDialog> createState() => _SinInSinUpDialogState();
}

class _SinInSinUpDialogState extends State<SinInSinUpDialog> {
  final DioApi dioApi = DioApi();
  String statue = "يرجى الانتظار";
  late Future<LoginResponse> data;
  @override
  void initState() {
    _getData();
    super.initState();
  }

  Future _getData() async {
    setState(() {
      if (widget.type == SININ_TYPE) {
        data = dioApi.sinIn(sinInSinUpRequest: widget.sinInSinUpRequest);
        data.then((value) async {
          widget.onLogin(value);

          Navigator.of(context).pop();
        });
      } else {
        data = dioApi.sinUp(sinInSinUpRequest: widget.sinInSinUpRequest);
        data.then((value) async {
          widget.onLogin(value);

          Navigator.of(context).pop();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.type == SININ_TYPE ? "تسجيل الدخول" : "انشاء حساب";
    String progressDesc = widget.type == SININ_TYPE
        ? "جاري التحقق من البيانات وتسجيل الدخول"
        : "جاري التحقق من البيانات وإنشاء الحساب";
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.only(top: 5, right: 20, left: 20, bottom: 5),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(Consts.padding),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: FutureBuilder(
            future: data,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontFamily: "Cairo",
                            color: Color(0xFF1F4C6B),
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      const Divider(
                          height: 10,
                          color: Colors.black,
                          thickness: 1.5,
                          indent: 1,
                          endIndent: 1),
                      const SizedBox(height: 11.0),
                      Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: ColorfulCircularProgressIndicator(
                              colors: [
                                Color(0xfff48923),
                                Colors.lightGreenAccent,
                                Colors.red
                              ],
                              strokeWidth: 5,
                              indicatorHeight: 40,
                              indicatorWidth: 40,
                            ),
                          ),
                          const SizedBox(width: 30),
                          Expanded(
                            flex: 5,
                            child: Text(progressDesc,
                                style: const TextStyle(
                                    fontFamily: "Cairo",
                                    color: Color(0xFF234F68),
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12)),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && !snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(title,
                            style: const TextStyle(
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
                            const Expanded(
                                flex: 1,
                                child: Icon(
                                  Icons.done_outline_outlined,
                                  color: Color(0xFF8BC83F),
                                )),
                            const SizedBox(width: 20),
                            Expanded(
                              flex: 5,
                              child: Text(
                                "تم $title",
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
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  if (snapshot.error is ErrorResponse) {
                    ErrorResponse e = snapshot.error as ErrorResponse;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title,
                              style: const TextStyle(
                                  fontFamily: "Cairo",
                                  color: Color(0xFF234F68),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                          const Divider(
                            height: 10,
                            color: Colors.black,
                            thickness: 1.5,
                            indent: 1,
                            endIndent: 1,
                          ),
                          const SizedBox(height: 11.0),
                          Row(
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Icon(
                                  Icons.error_outline,
                                  color: Colors.redAccent,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(e.statusMessage,
                                        style: const TextStyle(
                                            fontFamily: "Cairo",
                                            color: Color(0xFF234F68),
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12)),
                                    Text(
                                      "رقم الخطأ: (${e.statusCode})",
                                      style: const TextStyle(
                                          fontFamily: "Cairo",
                                          color: Color(0xFF234F68),
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12),
                                    ),
                                  ],
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
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title,
                              style: const TextStyle(
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
                              const Expanded(
                                flex: 1,
                                child: Icon(
                                  Icons.error_outline,
                                  color: Colors.redAccent,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                flex: 5,
                                child: Text(
                                  "${snapshot.error}",
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
                                splashColor: const Color(0xFF8BC83F),
                                child: const Text(
                                  'إعادة المحاولة',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: const TextStyle(
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
                            const Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.error_outline,
                                color: Colors.redAccent,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              flex: 5,
                              child: Text(
                                "حدث خطاء في $title يرجى إعادة المحاولة",
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
                              splashColor: const Color(0xFF8BC83F),
                              child: const Text(
                                'إعادة المحاولة',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            "حدث خطاء اثناء $title إعادة المحاولة",
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
            }),
      ),
    );
  }
}
