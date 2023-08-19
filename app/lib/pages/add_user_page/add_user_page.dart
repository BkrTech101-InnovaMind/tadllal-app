import 'package:flutter/material.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _phoneController = TextEditingController();

  void handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final form = {
      "name": _userNameController.text,
      "email": _phoneController.text,
    };
    print(form);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("اضافة مستخدم"),
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
              text: "إضافة مستخدم \n",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: "تحت المعرف الخاص بك لكسب النقاط")
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
            Container(
              margin: const EdgeInsets.only(bottom: 35),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F4F8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                keyboardType: TextInputType.name,
                validator: (value) => value == null || value.isEmpty
                    ? "ألرجاء ادخل اسمك الثنائي على الاقل"
                    : null,
                controller: _userNameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_3_outlined),
                  prefixIconColor: Colors.black,
                  border: UnderlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                      UnderlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.symmetric(vertical: 25),
                  hintText: "ألاسم الكامل",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 35),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F4F8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || value.isEmpty
                    ? "الرجاء ادخال رقم الهاتف"
                    : null,
                controller: _phoneController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone_iphone_outlined),
                  prefixIconColor: Colors.black,
                  border: UnderlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                      UnderlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.symmetric(vertical: 25),
                  hintText: "رقم الهاتف",
                ),
              ),
            ),
            Container(
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
                  "إنشاء مستخدم جديد",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
