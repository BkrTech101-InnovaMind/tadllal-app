import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:tedllal/model/api_models/location.dart';
import 'package:tedllal/model/real_estate_type.dart';
import 'package:tedllal/services/api/dio_api.dart';
import 'package:tedllal/widgets/save_dialog.dart';

Future<List<Location>> _getLocationData() async {
  var rowData = await DioApi().get("/locations");
  String jsonString = json.encode(rowData.data["data"]);
  List<Map<String, dynamic>> data = (jsonDecode(jsonString) as List)
      .map((e) => e as Map<String, dynamic>)
      .toList();
  return (data).map((itemWord) => Location.fromJson(itemWord)).toList();
}

Future<List<RealEstateType>> _getTypeData() async {
  var rowData = await DioApi().get("/types");
  String jsonString = json.encode(rowData.data["data"]);
  List<Map<String, dynamic>> data = (jsonDecode(jsonString) as List)
      .map((e) => e as Map<String, dynamic>)
      .toList();
  return (data).map((itemWord) => RealEstateType.fromJson(itemWord)).toList();
}

class AddCustomerPage extends StatefulWidget {
  const AddCustomerPage({super.key});

  @override
  State<AddCustomerPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddCustomerPage> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _customerNumberController = TextEditingController();
  final _locationController = TextEditingController();
  final _typeController = TextEditingController();
  final _propertyController = TextEditingController();
  final _budgetFromController = TextEditingController();
  final _budgetToController = TextEditingController();
  final _currencyController = TextEditingController();
  final _otherDetailsController = TextEditingController();
  String selectedLocationId = "";
  String selectedTypeId = "";
  List<Location> locations = [];
  List<RealEstateType> types = [];

  Future<void> _fetchLocationsAndTypes() async {
    locations = await _getLocationData();
    types = await _getTypeData();
  }

  Future<void> _showLocationDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('اختر موقعاً'),
          content: SizedBox(
            width: double.maxFinite,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F4F8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: locations.length,
                itemBuilder: (context, index) {
                  final location = locations[index];
                  return ListTile(
                    title: Text(location.attributes!.name!),
                    onTap: () {
                      setState(() {
                        _locationController.text = location.attributes!.name!;
                        selectedLocationId = location.id!;
                      });
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('إلغاء'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showTypeDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('اختر نوعاً'),
          content: SizedBox(
            width: double.maxFinite,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F4F8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: types.length,
                itemBuilder: (context, index) {
                  final type = types[index];
                  return ListTile(
                    title: Text(type.attributes!.name!),
                    onTap: () {
                      setState(() {
                        _typeController.text = type.attributes!.name!;
                        selectedTypeId = type.id!;
                      });
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('إلغاء'),
            ),
          ],
        );
      },
    );
  }

  List<DropdownMenuItem> dropDownItems = [
    const DropdownMenuItem(
      value: "YER",
      child: Text("ريال يمني"),
    ),
    const DropdownMenuItem(
      value: "SAR",
      child: Text("ريال سعودي"),
    ),
    const DropdownMenuItem(
      value: "USD",
      child: Text("دولار امريكي"),
    )
  ];

  @override
  void initState() {
    super.initState();
    _fetchLocationsAndTypes();
  }

  void handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final budgetFrom = int.tryParse(_budgetFromController.text.trim());
    final budgetTo = int.tryParse(_budgetToController.text.trim());
    final form = {
      "customer_name": _customerNameController.text.trim(),
      "customer_number": _customerNumberController.text.trim(),
      "location_id": selectedLocationId,
      "type_id": selectedTypeId,
      "property": _propertyController.text.trim(),
      "budget_from": budgetFrom,
      "budget_to": budgetTo,
      "currency": _currencyController.text.trim(),
      "other_details": _otherDetailsController.text.trim(),
    };

    print("form: $form");

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context2) => SaveDialog(
        formValue: [
          {"path": "/profile/customerRequest", "myData": form}
        ],
        onUrlChanged: (data) {
          Navigator.of(context2).pop();
          Navigator.of(context).pop();
        },
      ),
    );
    print("form: $form");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("اضافة عميل"),
        backgroundColor: const Color(0xFF194706),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            buildText(),
            buildForm(),
          ],
        ),
      ),
    );
  }

  // Text widget
  Widget buildText() {
    return Container(
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.only(top: 50, bottom: 60, right: 20),
      child: const Text.rich(
        TextSpan(
          text: "من خلال هذه الصفحة تستطيع ",
          style: TextStyle(fontSize: 20, color: Color(0xFF234F68)),
          children: [
            TextSpan(
              text: "إضافة عميل \n",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: "تحت المعرف الخاص بك ")
          ],
        ),
      ),
    );
  }

  // Form widget
  Widget buildForm() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildCustomerNameAndNumberFields(),
            buildCustomerLocationAndTypeFields(),
            buildCustomerPropertyAndBudgetsFields(),
            buildCustomerDetailsField(),
            buildSubmitButton(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget buildCustomerNameAndNumberFields() {
    return Column(
      children: [
        // Name field
        Container(
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F4F8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "ألرجاء إدخال اسم العميل الثنائي على الأقل";
              }
              List<String> nameParts = value.split(' ');
              if (nameParts.length < 2) {
                return "إسم العميل الثاني مطلوب";
              }
              return null;
            },
            controller: _customerNameController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person_3_outlined),
              prefixIconColor: Colors.black,
              border: UnderlineInputBorder(borderSide: BorderSide.none),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
              contentPadding: EdgeInsets.symmetric(vertical: 25),
              hintText: "اسم العميل",
            ),
          ),
        ),
        // Number field
        Container(
          margin: const EdgeInsets.only(bottom: 35),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F4F8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber number) {},
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "يرجى ادخال رقم العميل";
              } else {
                return null;
              }
            },
            countries: const ['YE'],
            selectorConfig: const SelectorConfig(
              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
            ),
            textFieldController: _customerNumberController,
            formatInput: true,
            keyboardType: const TextInputType.numberWithOptions(
                signed: true, decimal: false),
            inputDecoration: const InputDecoration(
              border: UnderlineInputBorder(borderSide: BorderSide.none),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
              contentPadding: EdgeInsets.symmetric(vertical: 25),
              hintText: "رقم العميل",
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCustomerLocationAndTypeFields() {
    return Column(
      children: [
        // Location field
        Container(
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F4F8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            controller: _locationController,
            readOnly: true,
            validator: (value) =>
                value == null || value.isEmpty ? "هذا الحقل مطلوب" : null,
            onTap: _showLocationDialog,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.location_on_outlined),
              prefixIconColor: Colors.black,
              border: UnderlineInputBorder(borderSide: BorderSide.none),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
              contentPadding: EdgeInsets.symmetric(vertical: 25),
              hintText: "الموقع المرغوب",
            ),
          ),
        ),
        // Type field
        Container(
          margin: const EdgeInsets.only(bottom: 35),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F4F8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            controller: _typeController,
            readOnly: true,
            onTap: _showTypeDialog,
            validator: (value) =>
                value == null || value.isEmpty ? "هذا الحقل مطلوب" : null,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.type_specimen_outlined),
              prefixIconColor: Colors.black,
              border: UnderlineInputBorder(borderSide: BorderSide.none),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
              contentPadding: EdgeInsets.symmetric(vertical: 25),
              hintText: "النوع المرغوب",
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCustomerPropertyAndBudgetsFields() {
    return Column(
      children: [
        // Property field
        Container(
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F4F8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            controller: _propertyController,
            maxLines: 1,
            validator: (value) =>
                value == null || value.isEmpty ? "هذا الحقل مطلوب" : null,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.offline_pin_outlined),
              prefixIconColor: Colors.black,
              border: UnderlineInputBorder(borderSide: BorderSide.none),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
              contentPadding: EdgeInsets.symmetric(vertical: 25),
              hintText: "ملكية العقار, مثال: حرة, غير حرة, وغيرها",
            ),
          ),
        ),
        // Budget field
        Container(
          padding: const EdgeInsets.only(bottom: 35),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "السعر",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F4F8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _budgetFromController,
                  validator: (value) =>
                      value == null || value.isEmpty ? "هذا الحقل مطلوب" : null,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    prefixIconColor: Colors.black,
                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder:
                        UnderlineInputBorder(borderSide: BorderSide.none),
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                    hintText: "من",
                    hintStyle:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Text(
                ":",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F4F8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _budgetToController,
                  validator: (value) =>
                      value == null || value.isEmpty ? "هذا الحقل مطلوب" : null,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    prefixIconColor: Colors.black,
                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder:
                        UnderlineInputBorder(borderSide: BorderSide.none),
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                    hintText: "إلى",
                    hintStyle:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3.5,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F4F8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonFormField(
                  validator: (value) =>
                      value == null || value.isEmpty ? "هذا الحقل مطلوب" : null,
                  icon: const Icon(Icons.currency_exchange_outlined),
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder:
                        UnderlineInputBorder(borderSide: BorderSide.none),
                    contentPadding: EdgeInsets.symmetric(horizontal: 2),
                  ),
                  items: dropDownItems,
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  onChanged: (value) => {
                    setState(() {
                      _currencyController.text = value.toString();
                    })
                  },
                  hint: const Text("العملة"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildCustomerDetailsField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F4F8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        keyboardType: TextInputType.text,
        maxLines: null,
        controller: _otherDetailsController,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.info_outline),
          prefixIconColor: Colors.black,
          border: UnderlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
          contentPadding: EdgeInsets.symmetric(vertical: 25),
          hintText: "تفاصيل اخرى",
        ),
      ),
    );
  }

  Widget buildSubmitButton() {
    return Container(
      margin: const EdgeInsets.only(top: 35),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF8BC83F),
          fixedSize: const Size(278, 63),
          side: const BorderSide(color: Color(0xFF8BC83F), width: 2),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
        onPressed: () {
          handleSubmit();
        },
        child: const Text(
          "إضافة",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
