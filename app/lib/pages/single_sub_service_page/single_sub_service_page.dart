import 'package:flutter/material.dart';
import 'package:tedllal/model/services.dart';
import 'package:tedllal/widgets/make_order_dialog.dart';
import 'package:tedllal/widgets/pages_back_button.dart';

class SingleSubServicesPage extends StatefulWidget {
  final Services subServiceDetails;
  const SingleSubServicesPage({required this.subServiceDetails, super.key});

  @override
  State<SingleSubServicesPage> createState() => _SingleSubServicesPageState();
}

class _SingleSubServicesPageState extends State<SingleSubServicesPage> {
  void _onPressed() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context2) => MakeOrderDialog(
          type: "Service", orderId: int.parse(widget.subServiceDetails.id!)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                "${widget.subServiceDetails.attributes!.image}",
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFF5F4F8))),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const PagesBackButton(),
                    MaterialButton(
                      height: 30.0,
                      minWidth: 50.0,
                      color: const Color(0xFFF5F4F8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      textColor: const Color(0xFF1F4C6B),
                      padding: const EdgeInsets.all(16),
                      onPressed: _onPressed,
                      splashColor: const Color(0xFFF5F4F8),
                      child: const Text(
                        'طلب الخدمة',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  constraints: const BoxConstraints.expand(),
                  child: Container(
                    margin: const EdgeInsets.only(top: 75),
                    color: Colors.black.withOpacity(0.3),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          buildServiceCard(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildServiceCard() {
    return Card(
      color: Colors.white.withOpacity(0.5),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(
              "${widget.subServiceDetails.attributes!.name}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 25,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Divider(
              thickness: 3,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              "${widget.subServiceDetails.attributes!.description}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
