import 'package:flutter/material.dart';
import 'package:tedllal/config/global.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({Key? key, required this.onLogOutPressed})
      : super(key: key);
  final VoidCallback onLogOutPressed;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consist.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.only(top: 5, right: 20, left: 20, bottom: 5),
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
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("تسجيل الخروج",
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
              const FittedBox(
                fit: BoxFit.contain,
                child: Text("هل تريد فعلا تسجيل الخروج؟",
                    style: TextStyle(
                        fontFamily: "Cairo",
                        color: Color(0xFF1F4C6B),
                        fontWeight: FontWeight.normal,
                        fontSize: 12)),
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
                      'لا',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 30),
                  MaterialButton(
                    height: 30.0,
                    minWidth: 50.0,
                    color: const Color(0xFF8BC83F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    textColor: Colors.white,
                    onPressed: () => onLogOutPressed(),
                    splashColor: const Color(0xFF8BC83F),
                    child: const Text(
                      'نعم',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
