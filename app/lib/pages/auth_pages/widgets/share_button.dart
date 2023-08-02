import 'package:flutter/material.dart';
import 'package:share/share.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Share.share(
            "Enter the app URL from the store here to be shared when this button is clicked");
      },
      child: RichText(
        text: const TextSpan(
          text: "مشاركة التطبيق مع ",
          style: TextStyle(color: Colors.black, fontSize: 20),
          children: <TextSpan>[
            TextSpan(
              text: "صديق",
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
