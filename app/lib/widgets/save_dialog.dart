import 'package:colorful_circular_progress_indicator/colorful_circular_progress_indicator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tadllal/config/global.dart';
import 'package:tadllal/services/api/dio_api.dart';

class SaveDialog extends StatefulWidget {
  final Function(List<Response<dynamic>> response) onUrlChanged;

  final List<Map<String, dynamic>> formValue;

  const SaveDialog(
      {super.key, required this.onUrlChanged, required this.formValue});

  @override
  State<SaveDialog> createState() => _SaveDialogState();
}

class _SaveDialogState extends State<SaveDialog> {
  String statue = "يرجى الانتظار";
  Future<List<Response>> data = Future(() => []);
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
        child: FutureBuilder<List<Response>>(
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
                            color: Color(0xFF1F4C6B),
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
                        const ColorfulCircularProgressIndicator(
                          colors: [
                            Color(0xfff48923),
                            Colors.yellowAccent,
                            Colors.red
                          ],
                          strokeWidth: 5,
                          indicatorHeight: 40,
                          indicatorWidth: 40,
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Text(
                          statue,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
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
                            color: Color(0xFF8BC83F),
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
                          const SizedBox(
                            width: 30,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(snapshot.error.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontFamily: "Cairo",
                                    color: Color(0xFF234F68),
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
                          Icons.error_outline,
                          color: Colors.redAccent,
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
                                  color: Color(0xFF234F68),
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
              }
            }),
      ),
    );
  }

  Future<List<Response>> _getData() async {
    List<Response> tempData = [];

    for (int i = 0; i < widget.formValue.length; i++) {
      Response r = await dioApi.post(widget.formValue[i]["path"],
          myData: widget.formValue[i]["myData"]);
      tempData.insert(i, r);
    }
    return tempData;
  }
}
