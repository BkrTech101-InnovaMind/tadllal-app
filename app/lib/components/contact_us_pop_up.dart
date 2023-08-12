import 'package:flutter/material.dart';

class OrderPopup extends StatefulWidget {
  const OrderPopup({super.key});

  @override
  State<OrderPopup> createState() => OrderPopupState();
}

class OrderPopupState extends State<OrderPopup> {
  final TextEditingController messageController = TextEditingController();
  bool showSuccessPopup = false;

  final Map<String, dynamic> senderDetails = {
    "user_details": {
      "id": "4",
      "name": "أبوبكر صديق",
      "avatar": "https://i.pravatar.cc/300",
      "email": "zz78zz@zzz6z.tttt665604",
      "phone": "779 207 445",
      "role": "user",
    }
  };

  void sendMessage() {
    final message = messageController.text;
    final sentMassage = {
      "user_details": {
        ...senderDetails,
        "message": message,
        "order": {
          "order_id": "23",
          "order_title": "test order title",
        }
      },
    };
    print(sentMassage);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: Text(
          showSuccessPopup ? '✅ تم ارسال طلبك بنجاح' : 'هل تريد هذا الطلب ؟',
        ),
        content: SingleChildScrollView(
          child: showSuccessPopup
              ? const Text('سيتم الرد عليك في اقرب وقت.')
              : Column(
                  children: [
                    const Text(
                      'تم اخذ تفاصيل طلبك اَليا، هل هناك تفاصيل اخرى تود إضافتها ؟.',
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: messageController,
                      decoration: const InputDecoration(
                        labelText: 'رسالتك',
                      ),
                    ),
                    // You can add more fields here if needed
                  ],
                ),
        ),
        actions: [
          if (!showSuccessPopup)
            TextButton(
              onPressed: () {
                sendMessage();
                setState(() {
                  showSuccessPopup = true;
                });
              },
              child: const Text('طلب'),
            ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(!showSuccessPopup ? 'إلغاء' : "حسناً"),
          ),
        ],
      ),
    );
  }
}
