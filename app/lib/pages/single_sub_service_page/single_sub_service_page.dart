import 'package:flutter/material.dart';
import 'package:tadllal/model/services.dart';
import 'package:tadllal/widgets/LodingUi/make_order_dialog.dart';

class SingleSubServicesPage extends StatefulWidget {
  final Services subServiceDetails;
  const SingleSubServicesPage({required this.subServiceDetails, super.key});

  @override
  State<SingleSubServicesPage> createState() => _SingleSubServicesPageState();
}

class _SingleSubServicesPageState extends State<SingleSubServicesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تفاصيل الخدمة"),
        centerTitle: true,
        backgroundColor: const Color(0xFF194706),
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              "${widget.subServiceDetails.attributes!.image}",
            ),
            fit: BoxFit.fill,
          ),
        ),
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
          buildOrderButton(),
        ],
      ),
    );
  }

  Widget buildOrderButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF194706).withOpacity(0.8),
          fixedSize: const Size(150, 63),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context2) => MakeOrderDialog(
                type: "Service",
                orderId: int.parse(widget.subServiceDetails.id!)),
          );
        },
        child: const Text(
          "أطلب ألان",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
