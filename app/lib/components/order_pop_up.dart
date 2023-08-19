import 'package:flutter/material.dart';
import 'package:tadllal/config/config.dart';
import 'package:tadllal/model/api_molels/user.dart';
import 'package:tadllal/model/services.dart';

class OrderPopup extends StatefulWidget {
  final Services subServiceDetails;
  const OrderPopup({required this.subServiceDetails, super.key});

  @override
  State<OrderPopup> createState() => OrderPopupState();
}

class OrderPopupState extends State<OrderPopup> {
  final TextEditingController messageController = TextEditingController();
  bool showSuccessPopup = false;

  final User senderDetails = Config().user;

  void sendMessage() {
    final message = messageController.text;
    final order = widget.subServiceDetails;
    final sentMassage = {
      ...senderDetails.toJson(),
      "message": message,
      "order_details": {"order": order},
    };
    print(sentMassage);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
    );
  }
}
