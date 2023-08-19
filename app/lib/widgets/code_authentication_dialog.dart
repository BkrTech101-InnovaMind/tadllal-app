import 'package:colorful_circular_progress_indicator/colorful_circular_progress_indicator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tadllal/config/global.dart';
import 'package:tadllal/services/api/dio_api.dart';

class CodeAuthenticationDialog extends StatefulWidget {
  final Function(Response response) onUrlChanged;

  final Map<String, dynamic> formValue;

  const CodeAuthenticationDialog(
      {super.key, required this.onUrlChanged, required this.formValue});

  @override
  State<CodeAuthenticationDialog> createState() =>
      _CodeAuthenticationDialogState();
}

class _CodeAuthenticationDialogState extends State<CodeAuthenticationDialog> {
  String statue = "يرجى الانتظار";
  late Future<Response> data;
  DioApi dioApi = DioApi();
  @override
  void initState() {
    setState(() {
      data = _getData();
      data.then((value) {
        widget.onUrlChanged(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          color: const Color(0xff103c5b),
          borderRadius: BorderRadius.circular(Consts.padding),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: FutureBuilder<Response>(
            future: data,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("جاري حفظ البيانات",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Cairo",
                            color: Color(0xfff48923),
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                    const Divider(
                        height: 10,
                        color: Colors.white,
                        thickness: 1.5,
                        indent: 1,
                        endIndent: 1),
                    const SizedBox(height: 11.0),
                    Row(
                      children: [
                        const ColorfulCircularProgressIndicator(
                          colors: [Color(0xfff48923), Colors.white, Colors.red],
                          strokeWidth: 5,
                          indicatorHeight: 40,
                          indicatorWidth: 40,
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Text(statue,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontFamily: "Cairo",
                                color: Color(0xfff48923),
                                fontWeight: FontWeight.normal,
                                fontSize: 12)),
                      ],
                    ),
                  ],
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && !snapshot.hasError) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("تم الحفظ بنجاح",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "Cairo",
                              color: Color(0xfff48923),
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
                            Icons.done_outline_outlined,
                            color: Color(0xfff48923),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Text("تم الحفظ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "Cairo",
                                  color: Color(0xfff48923),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MaterialButton(
                            height: 30.0,
                            minWidth: 50.0,
                            color: const Color(0xFFBD6611),
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
                              color: Color(0xfff48923),
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                      const Divider(
                          height: 10,
                          color: Colors.white,
                          thickness: 1.5,
                          indent: 1,
                          endIndent: 1),
                      const SizedBox(height: 11.0),
                      Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Color(0xfff48923),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(snapshot.error.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontFamily: "Cairo",
                                    color: Color(0xfff48923),
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12)),
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
                            color: const Color(0xFFBD6611),
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
                            color: const Color(0xFFBD6611),
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
                              color: Color(0xfff48923),
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
                          Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.error_outline,
                              color: Color(0xfff48923),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            flex: 9,
                            child: Text(
                                "حدث خطاء اثناء الحفظ يرجى إعادة المحاولة",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: "Cairo",
                                    color: Color(0xfff48923),
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12)),
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
                            color: const Color(0xFFBD6611),
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
                            color: const Color(0xFFBD6611),
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
                            color: Color(0xfff48923),
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
                          color: Color(0xfff48923),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                              "حدث خطاء اثناء الحفظ يرجى إعادة المحاولة",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "Cairo",
                                  color: Color(0xfff48923),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12)),
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
                          color: const Color(0xFFBD6611),
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
                          color: const Color(0xFFBD6611),
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
              }
            }),
      ),
    );
  }

  Future<Response> _getData() async {
    return await dioApi.postCodeAuthentication(widget.formValue["path"],
        myData: widget.formValue["myData"]);
  }
}
