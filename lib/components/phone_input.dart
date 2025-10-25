import 'package:flutter/material.dart';

class PhoneInput extends StatefulWidget {
  const PhoneInput({super.key, this.controller});
  final TextEditingController? controller;

  @override
  State<PhoneInput> createState() => _PhoneInputState();
}

class _PhoneInputState extends State<PhoneInput> {
  String selectedCountryCode = '+31';
  String selectedCountryFlag = '🇳🇱';

  final List<Map<String, String>> countries = [
    {
      'flag': 'assets/images/flags/nl.png',
      'code': '+31',
      'name': 'Netherlands',
    },
    {'flag': 'assets/images/flags/de.png', 'code': '+49', 'name': 'Germany'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Receiver Phone Number"),
        Container(
          decoration: BoxDecoration(
            color: Color(0xffF4F4F4),
            borderRadius: BorderRadius.circular(12),
            border: Border(bottom: BorderSide(color: Color(0xff079a4b))),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                child: DropdownButton<String>(
                  value: selectedCountryCode,
                  underline: Container(),
                  icon: Icon(Icons.keyboard_arrow_down, size: 20),
                  items: countries.map((country) {
                    return DropdownMenuItem<String>(
                      value: country['code'],
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundImage: AssetImage(country['flag']!),
                            backgroundColor: Colors.transparent,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedCountryCode = newValue;
                        selectedCountryFlag = countries.firstWhere(
                          (country) => country['code'] == newValue,
                        )['flag']!;
                      });
                    }
                  },
                ),
              ),
              Container(height: 40, width: 1, color: Colors.black),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  selectedCountryCode,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "000000000000",
                    hintStyle: TextStyle(
                      color: Color(0xffCBCBCB),
                      fontSize: 16,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
