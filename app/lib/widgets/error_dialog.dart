import 'package:flutter/material.dart';
import 'package:tadllal/config/global.dart';




class ErrorDialog extends StatefulWidget {



  final String desc;


  ErrorDialog({
 required this.desc});

  @override
  State<ErrorDialog> createState() => _ErroeDialogState();
}

class _ErroeDialogState extends State<ErrorDialog> {



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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("فشل",
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
            SizedBox(height: 11.0),
            Row(

              children: [
                Icon(Icons.error_outline,color: Color(0xfff48923),),
                SizedBox(width: 30,),
                Text(widget.desc,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Cairo",
                        color: Color(0xfff48923),
                        fontWeight: FontWeight.normal,
                        fontSize: 12)),
              ],),

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
                  child: Text('إغلاق',style: TextStyle(fontSize: 12),),
                  onPressed: ()  {
                    Navigator.of(context).pop();
                  },
                  splashColor: Colors.redAccent,
                ),

              ],)
          ],
        ),
      ),
    );
  }




}