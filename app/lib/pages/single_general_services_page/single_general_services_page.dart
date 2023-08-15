import 'package:flutter/material.dart';
import 'package:tadllal/pages/single_sub_service_page/single_sub_service_page.dart';

class SingleGeneralServicesPage extends StatefulWidget {
  final Map<String, dynamic> generalServiceDetails;
  const SingleGeneralServicesPage(
      {required this.generalServiceDetails, super.key});

  @override
  State<SingleGeneralServicesPage> createState() =>
      _SingleGeneralServicesPageState();
}

class _SingleGeneralServicesPageState extends State<SingleGeneralServicesPage> {
  late Map<String, dynamic> generalServicesDetails;

  @override
  void initState() {
    generalServicesDetails = widget.generalServiceDetails;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${generalServicesDetails['title']}"),
        centerTitle: true,
        backgroundColor: const Color(0xFF194706),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Text(
              "${generalServicesDetails['subtitle']}",
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            ListView.separated(
              shrinkWrap: true,
              itemCount: generalServicesDetails.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SingleSubServicesPage(
                            serviceDetails:
                                generalServicesDetails["subServices"][index],
                          ),
                        ),
                      );
                    },
                    title: Text(
                        "${generalServicesDetails["subServices"][index]['title']}"),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "${generalServicesDetails["subServices"][index]['image']}"),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(thickness: 2);
              },
            ),
          ],
        ),
      ),
    );
  }
}
