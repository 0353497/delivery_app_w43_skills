import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:parcel_delivery_app/pages/content_of_parcel_page.dart';
import 'package:parcel_delivery_app/pages/welcome_page.dart';

class SizeOfParcelPage extends StatefulWidget {
  const SizeOfParcelPage({super.key, required this.type});
  final String type;

  @override
  State<SizeOfParcelPage> createState() => _SizeOfParcelPageState();
}

class _SizeOfParcelPageState extends State<SizeOfParcelPage> {
  var underlineInputBorderLeft = UnderlineInputBorder(
    borderSide: BorderSide(color: Color(0xff54B541)),
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(8),
      bottomLeft: Radius.circular(8),
    ),
  );
  var underlineInputBorderRight = UnderlineInputBorder(
    borderSide: BorderSide(color: Color(0xff54B541)),
    borderRadius: BorderRadius.only(
      topRight: Radius.circular(8),
      bottomRight: Radius.circular(8),
    ),
  );
  final inputDecoration = InputDecoration(
    border: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xff54B541)),
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xff54B541)),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xff54B541)),
      borderRadius: BorderRadius.circular(8),
    ),
    fillColor: Color(0xffF4F4F4),
    filled: true,
  );

  String selectedDimensionUnit = 'cm';
  String selectedWeightUnit = 'g';
  TextEditingController heightController = TextEditingController();
  TextEditingController widthController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  Widget _buildDimensionInputField({
    required String label,
    required TextEditingController controller,
    required String selectedUnit,
    required List<String> units,
    required Function(String?) onUnitChanged,
    required String hintText,
  }) {
    var inputDecoration = InputDecoration(
      border: underlineInputBorderLeft,
      enabledBorder: underlineInputBorderLeft,
      focusedBorder: underlineInputBorderLeft,
      fillColor: Color(0xffF4F4F4),
      filled: true,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 16,
      children: [
        Text(label, style: TextStyle(fontSize: 18)),
        Row(
          children: [
            SizedBox(
              width: 80,
              child: DropdownButtonFormField<String>(
                value: selectedUnit,
                decoration: inputDecoration,
                items: units
                    .map(
                      (unit) =>
                          DropdownMenuItem(value: unit, child: Text(unit)),
                    )
                    .toList(),
                onChanged: onUnitChanged,
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  fillColor: Color(0xffF4F4F4),
                  filled: true,
                  hintText: hintText,
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  border: underlineInputBorderRight,
                  enabledBorder: underlineInputBorderRight,
                  focusedBorder: underlineInputBorderRight,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: Get.width / 4,
        leading: GestureDetector(
          onTap: Get.back,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/back.png", width: 16, height: 24),
              SizedBox(width: 10),
              Text(
                "Back",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => Get.to(() => WelcomePage()),
            child: Text(
              "Cancel Order",
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                spacing: 30,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Provide more details about your ${widget.type}",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  _buildDimensionInputField(
                    label: "Height of Package",
                    controller: heightController,
                    selectedUnit: selectedDimensionUnit,
                    units: ['cm', 'in', 'm'],
                    onUnitChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          selectedDimensionUnit = value;
                        });
                      }
                    },
                    hintText: "Height in $selectedDimensionUnit",
                  ),
                  _buildDimensionInputField(
                    label: "Width of Package",
                    controller: widthController,
                    selectedUnit: selectedDimensionUnit,
                    units: ['cm', 'in', 'm'],
                    onUnitChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          selectedDimensionUnit = value;
                        });
                      }
                    },
                    hintText: "Width in $selectedDimensionUnit",
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 10,
                    children: [
                      Flexible(
                        flex: 2,
                        child: _buildDimensionInputField(
                          label: "Weight of Package",
                          controller: weightController,
                          selectedUnit: selectedWeightUnit,
                          units: ['kg', 'lbs', 'g'],
                          onUnitChanged: (String? value) {
                            if (value != null) {
                              setState(() {
                                selectedWeightUnit = value;
                              });
                            }
                          },
                          hintText: "Weight",
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Column(
                          spacing: 16,
                          children: [
                            Text("Quantity", style: TextStyle(fontSize: 18)),
                            TextFormField(
                              decoration: inputDecoration,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SafeArea(
              child: SizedBox(
                width: double.maxFinite,
                height: 60,
                child: TextButton(
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    backgroundColor: WidgetStatePropertyAll(Color(0xff079A4B)),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                  onPressed: () async {
                    Get.to(() => ContentOfParcelPage(type: widget.type));
                  },
                  child: Text("Next"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
