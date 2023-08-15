import 'package:flutter/material.dart';
import 'package:tadllal/components/order_pop_up.dart';

class SingleSubServicesPage extends StatefulWidget {
  final Map serviceDetails;
  const SingleSubServicesPage({required this.serviceDetails, super.key});

  @override
  State<SingleSubServicesPage> createState() => _SingleSubServicesPageState();
}

class _SingleSubServicesPageState extends State<SingleSubServicesPage> {
  Map? serviceDetails;

  @override
  void initState() {
    serviceDetails = widget.serviceDetails;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تفاصيل الخدمة"),
        centerTitle: true,
        backgroundColor: const Color(0xFF194706),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                "${serviceDetails?['image']}",
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: Container(
            color: Colors.black.withOpacity(0.3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildServiceCard(),
                buildOrderButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildServiceCard() {
    return Card(
      color: Colors.white.withOpacity(0.3),
      child: Column(
        children: [
          Text(
            "${serviceDetails?['title']}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 25,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Divider(
              thickness: 3,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          Text(
            "${serviceDetails?['sub_title']}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOrderButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF1F4C6B),
          backgroundColor: Colors.white.withOpacity(0.5),
          fixedSize: const Size(278, 63),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          side: const BorderSide(color: Color(0xFF8BC83F), width: 3),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => OrderPopup(order: serviceDetails),
          );
        },
        child: const Text(
          "طلب الخدمة",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
