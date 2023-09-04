import 'package:flutter/material.dart';
import 'package:tadllal/config/global.dart';

class ErrorDialog extends StatefulWidget {
  final String desc;

  const ErrorDialog({super.key, required this.desc});

  @override
  State<ErrorDialog> createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog> {
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
          color: const Color(0xFFF5F4F8),
          borderRadius: BorderRadius.circular(Consts.padding),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
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
                Text(widget.desc,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontFamily: "Cairo",
                        color: Color(0xFF234F68),
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
        ),
      ),
    );
  }
}
