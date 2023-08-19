
import 'package:flutter/material.dart';
import 'package:tadllal/config/global.dart';


class LogoutDialog extends StatelessWidget {
  LogoutDialog({Key? key, required this.onLogOutPressed}) : super(key: key);
  final VoidCallback onLogOutPressed;

  @override
  Widget build(BuildContext context) {
    return Dialog(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(

        padding: EdgeInsets.only(top: 5,right: 20,left: 20,bottom: 5),
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color:Color(0xff103c5b) ,

          borderRadius: BorderRadius.circular(Consts.padding),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("تسجيل الخروج",

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
              SizedBox(height: 11.0),
              FittedBox(
                fit: BoxFit.contain,
                child: Text("هل تريد فعلا تسجيل الخروج؟",

                  style: TextStyle(
                      fontFamily: "Cairo",
                      color: Color(0xfff48923),
                      fontWeight: FontWeight.normal,
                      fontSize: 12)),),
              SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialButton(
                    height: 30.0,
                    minWidth: 50.0,
                    color: Color(0xFFBD6611),
                    shape:RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ) ,
                    textColor: Colors.white,
                    child: Text('لا',style: TextStyle(fontSize: 12),),
                    onPressed: ()  {
                      Navigator.of(context).pop();
                    },
                    splashColor: Colors.redAccent,
                  ),

                  SizedBox(width: 30,),
                  MaterialButton(
                    height: 30.0,
                    minWidth: 50.0,
                    color: Color(0xFFBD6611),
                    shape:RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ) ,
                    textColor: Colors.white,
                    child: Text('نعم',style: TextStyle(fontSize: 12),),
                    onPressed: () =>onLogOutPressed(),
                    splashColor: Colors.redAccent,
                  ),
                ],),


            ],
          ),
        ),
      ),
    );
  }
}
