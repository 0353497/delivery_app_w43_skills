import 'dart:math';
import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:parcel_delivery_app/components/own_input.dart';
import 'package:parcel_delivery_app/components/phone_input.dart';
import 'package:parcel_delivery_app/pages/welcome_page.dart';
import 'package:video_player/video_player.dart';

class DeliveryPage extends StatefulWidget {
  const DeliveryPage({super.key});

  @override
  State<DeliveryPage> createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  int currentView = 0;

  @override
  Widget build(BuildContext context) {
    if (currentView == 3 || currentView == 5) {
      return Scaffold(
        appBar: OwnAppbar(),
        backgroundColor: Colors.white,
        body: _buildCurrentView(),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: OwnAppbar(),

      body: Stack(
        children: [
          Transform.rotate(
            angle: pi,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/map.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Align(
              alignment: Alignment(0, 1),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                width: Get.width,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildCurrentView(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (currentView) {
      case 0:
        return FormDeliveryView(onTap: _nextStep);
      case 1:
        return TimeView(onTap: _nextStep);
      case 2:
        return VehicleView(onTap: _nextStep);
      case 3:
        return VehicleMapView(onTap: _nextStep);
      case 4:
        return DriverFoundView(onTap: _nextStep);
      case 5:
        return TrackingView(onTap: _nextStep);
      default:
        return Center(child: Text("Unknown step"));
    }
  }

  void _nextStep() => setState(() {
    currentView++;
  });
}

class OwnAppbar extends StatelessWidget implements PreferredSizeWidget {
  const OwnAppbar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
    );
  }
}

class FindingView extends StatelessWidget {
  const FindingView({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Status"),
        Text(
          "Finding a rider near you",
          style: TextStyle(
            color: Color(0xff079A4B),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        ExpansionTile(
          tilePadding: EdgeInsets.zero,
          trailing: TextButton(
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(8),
                ),
              ),
              side: WidgetStatePropertyAll(BorderSide(color: Colors.black)),
            ),
            onPressed: null,
            child: Text(
              "View Progress",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          title: Text(
            "Cancel",
            style: TextStyle(
              color: Color(0xff079A4B),
              decorationColor: Color(0xff079A4B),
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}

class VehicleView extends StatefulWidget {
  const VehicleView({super.key, required this.onTap});
  final VoidCallback onTap;
  @override
  State<VehicleView> createState() => _VehicleViewState();
}

class _VehicleViewState extends State<VehicleView> {
  int selectedVehicle = -1;

  final List<Map<String, dynamic>> vehicles = [
    {
      'name': 'Bicycle Delivery',
      'image': 'assets/images/vehicles/bicycle.png',
      'price': '€16.00',
      'time': '60 mins to deliver',
    },
    {
      'name': 'Motorbike Delivery',
      'image': 'assets/images/vehicles/motorbike.png',
      'price': '€20.00',
      'time': '60 mins to deliver',
    },
    {
      'name': 'Car Delivery',
      'image': 'assets/images/vehicles/car.png',
      'price': '€34.00',
      'time': '60 mins to deliver',
    },
    {
      'name': 'Van Delivery',
      'image': 'assets/images/vehicles/car-van.png',
      'price': '€60.00',
      'time': '60 mins to deliver',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select a Vehicle Type",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        SizedBox(height: 20),
        ...vehicles.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> vehicle = entry.value;

          return Container(
            margin: EdgeInsets.only(bottom: 12),
            height: 90,
            decoration: BoxDecoration(
              border: Border.all(
                color: selectedVehicle == index
                    ? Color(0xff079A4B)
                    : Colors.grey,
                width: selectedVehicle == index ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Radio<int>(
                  value: index,
                  groupValue: selectedVehicle,
                  onChanged: (value) {
                    setState(() {
                      selectedVehicle = value!;
                    });
                  },
                  activeColor: Color(0xff079A4B),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Image.asset(vehicle['image'], fit: BoxFit.contain),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicle['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        vehicle['price'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff079a4b),
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        vehicle['time'],
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        SizedBox(height: 30),
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
              onPressed: selectedVehicle != -1 ? widget.onTap : null,
              child: Text(
                "Find driver",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TimeView extends StatefulWidget {
  const TimeView({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  State<TimeView> createState() => _TimeViewState();
}

class _TimeViewState extends State<TimeView> {
  int isSelected = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Schedule a pickup time",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),

        Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Color(0xffeeeeee),
          ),
          child: Row(
            spacing: 2,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isSelected = 0;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: isSelected == 0
                          ? Colors.white
                          : Colors.transparent,
                    ),
                    height: 30,
                    alignment: Alignment.center,
                    child: Text(
                      "Depart after",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isSelected = 1;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: isSelected == 1
                          ? Colors.white
                          : Colors.transparent,
                    ),
                    height: 30,
                    alignment: Alignment.center,
                    child: Text(
                      "Arrive by",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: 160,
          child: CupertinoDatePicker(
            use24hFormat: true,
            minimumDate: DateTime.now(),
            maximumDate: DateTime.now().add(Duration(days: 7)),
            initialDateTime: DateTime.now().add(Duration(minutes: 30)),
            onDateTimeChanged: (DateTime value) {},
          ),
        ),
        SizedBox(height: 200),
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
              onPressed: widget.onTap,
              child: Text("Next"),
            ),
          ),
        ),
      ],
    );
  }
}

class FormDeliveryView extends StatelessWidget {
  const FormDeliveryView({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 24,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          spacing: 12,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff92dab3),
              ),
              alignment: Alignment.center,
              child: Image.asset(
                "assets/images/icons/arrow_navigation.png",
                width: 25,
                height: 25,
              ),
            ),
            Flexible(
              child: Text(
                "Where is the package being delivered to?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
          ],
        ),
        OwnInput(labelText: "Enter Postcode"),
        OwnInput(labelText: "Street adress"),
        OwnInput(labelText: "Street adress 2 (optional)"),
        OwnInput(labelText: "City / Town"),
        OwnInput(labelText: "Name of Receiver"),
        PhoneInput(),
        Row(
          spacing: 12,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff92dab3),
              ),
              alignment: Alignment.center,
              child: Image.asset(
                "assets/images/icons/marker.png",
                width: 25,
                height: 25,
              ),
            ),
            Flexible(
              child: SizedBox(
                width: Get.width / 2,
                child: Text(
                  "Provide the pickup location",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
            ),
          ],
        ),
        OwnInput(labelText: "Enter postcode"),
        OwnInput(labelText: "Street Address"),
        OwnInput(labelText: "Street Address 2 (optional)"),
        OwnInput(labelText: "City / Town"),
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
              onPressed: onTap,
              child: Text("Next"),
            ),
          ),
        ),
      ],
    );
  }
}

class VehicleMapView extends StatefulWidget {
  const VehicleMapView({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  State<VehicleMapView> createState() => _VehicleMapViewState();
}

class _VehicleMapViewState extends State<VehicleMapView> {
  List<Map<String, dynamic>> drivers = [];
  Map<String, dynamic>? selectedDriver;
  Timer? _selectionTimer;
  bool isSearching = true;
  final ExpansibleController controller = ExpansibleController();

  @override
  void initState() {
    super.initState();
    _loadDrivers();
    _startDriverSelection();
  }

  Future<void> _loadDrivers() async {
    final String response = await rootBundle.loadString(
      'assets/data/drivers.json',
    );
    final List<dynamic> data = json.decode(response);
    setState(() {
      drivers = data.cast<Map<String, dynamic>>();
    });
  }

  void _startDriverSelection() {
    _selectionTimer = Timer(Duration(seconds: 5), () async {
      if (drivers.isNotEmpty) {
        final random = Random();
        final selectedIndex = random.nextInt(drivers.length);
        setState(() {
          selectedDriver = drivers[selectedIndex];
          isSearching = false;
        });
        final controller = VideoPlayerController.asset(
          "assets/sounds/driver_found.mp3",
        );
        await controller.initialize();
        controller.play();
        HapticFeedback.heavyImpact();
      }
    });
  }

  @override
  void dispose() {
    _selectionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: Get.width,
            height: Get.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/map.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Align(
            alignment: Alignment(0, .2),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Color(0xff00CF7A).withAlpha(50),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xff00CF7A).withAlpha(110),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Color(0xff079a4b),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),

          ...drivers.map((driver) {
            final position = driver['position'];

            final left =
                (position['left'] as num).toDouble() * (Get.width / 400);
            final top =
                (position['top'] as num).toDouble() * (Get.height / 400);

            return Positioned(
              left: left,
              top: top,
              child: Image.asset(
                "assets/images/vehicles/bicycle_map.png",
                width: 60,
                height: 60,
              ),
            );
          }),

          if (selectedDriver != null)
            CustomPaint(
              size: Size(Get.width, Get.height),
              painter: DottedLinePainter(
                start: Offset(Get.width / 2, Get.height / 2),
                end: Offset(
                  (selectedDriver!['position']['left'] as num).toDouble() *
                          (Get.width / 400) +
                      25,
                  (selectedDriver!['position']['top'] as num).toDouble() *
                          (Get.height / 400) +
                      25,
                ),
              ),
            ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSearching)
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 200,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 12,
                            spreadRadius: 12,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 5,
                        children: [
                          Icon(Icons.pedal_bike, color: Colors.grey),
                          Text.rich(
                            TextSpan(
                              text: "${drivers.length} Bikes ",
                              style: TextStyle(
                                color: Color(0xff079a4b),
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: "Close to you",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (isSearching) SizedBox(height: 32),
                if (selectedDriver != null)
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xff151516),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xff079a4b)),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/images/${selectedDriver!['driver']}.png",
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedDriver!['driver'].toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),

                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 5,
                                  children: [
                                    Text(
                                      "4.7",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Icon(Icons.star, color: Color(0xffffce00)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton.filled(
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Color(0xff079a4b),
                              ),
                            ),
                            onPressed: () {},
                            icon: Icon(Icons.phone),
                          ),
                        ],
                      ),
                    ),
                  ),
                Container(
                  width: Get.width,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: (selectedDriver == null)
                        ? BorderRadius.circular(20)
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Status"),
                              Text(
                                isSearching
                                    ? "Finding a driver near you"
                                    : "Driver is enroute",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff079A4B),
                                ),
                              ),
                            ],
                          ),
                          if (selectedDriver != null)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 5,
                              children: [
                                Icon(Icons.timer_outlined),
                                Text(
                                  "${selectedDriver?["travelTimeInMinutes"].toString()} Mins Away",
                                ),
                              ],
                            ),
                        ],
                      ),

                      SizedBox(height: 12),
                      ExpansionTile(
                        controller: controller,
                        tilePadding: EdgeInsets.zero,
                        title: (controller.isExpanded)
                            ? Column(
                                spacing: 5,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Track Progress"),
                                  Container(
                                    width: 30,
                                    height: 2,
                                    color: Color(0xff079A4B),
                                  ),
                                ],
                              )
                            : Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Color(0xff079A4B),
                                  decorationColor: Color(0xff079A4B),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                        trailing: (controller.isExpanded)
                            ? Text(
                                "Collapse",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              )
                            : TextButton(
                                style: ButtonStyle(
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(8),
                                      side: BorderSide(color: Colors.black),
                                    ),
                                  ),
                                ),
                                onPressed: null,
                                child: Text(
                                  "View Progress",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                        children: [
                          SizedBox(
                            height: Get.height / 2,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ProgressTile(
                                    tileHeight: 150,
                                    child: Container(
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Color(0xff115b33),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/stars.png",
                                              width: 40,
                                            ),
                                            Expanded(
                                              child: Column(
                                                spacing: 5,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Are you satisfied with the job",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      SizedBox(width: 20),
                                                      TextButton(
                                                        style: ButtonStyle(
                                                          padding:
                                                              WidgetStatePropertyAll(
                                                                EdgeInsets.symmetric(
                                                                  vertical: 8,
                                                                  horizontal:
                                                                      20,
                                                                ),
                                                              ),
                                                          shape: WidgetStatePropertyAll(
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadiusGeometry.circular(
                                                                    8,
                                                                  ),
                                                              side: BorderSide(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        onPressed: () {},
                                                        child: Text(
                                                          "I am not",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        style: ButtonStyle(
                                                          padding:
                                                              WidgetStatePropertyAll(
                                                                EdgeInsets.symmetric(
                                                                  vertical: 8,
                                                                  horizontal:
                                                                      20,
                                                                ),
                                                              ),
                                                          backgroundColor:
                                                              WidgetStatePropertyAll(
                                                                Colors.white,
                                                              ),
                                                          shape: WidgetStatePropertyAll(
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadiusGeometry.circular(
                                                                    8,
                                                                  ),
                                                              side: BorderSide(
                                                                color: Color(
                                                                  0xff115b33,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        onPressed: () {},
                                                        child: Text(
                                                          "Yes I am",
                                                          style: TextStyle(
                                                            color: Color(
                                                              0xff115b33,
                                                            ),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  ProgressTile(
                                    child: Container(
                                      margin: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Color(0xffdce3e8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              spacing: 5,
                                              children: [
                                                Icon(
                                                  Icons.check_circle_outline,
                                                  color: Color(0xff079A4B),
                                                ),
                                                Text(
                                                  "Package Delivered",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Spacer(),
                                                Text(
                                                  "02:47pm",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                      "assets/images/package.png",
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  ProgressTile(
                                    tileHeight: 80,
                                    child: Container(
                                      margin: EdgeInsets.all(8),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Color(0xffdce3e8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Delivery in progress"),
                                          Text(
                                            "02:47pm",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  ProgressTile(
                                    tileHeight: 150,
                                    child: Container(
                                      height: 80,
                                      margin: EdgeInsets.all(8),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Color(0xffdce3e8),
                                      ),
                                      child: Stack(
                                        children: [
                                          Row(
                                            spacing: 5,
                                            children: [
                                              Icon(
                                                Icons.check_circle_outline,
                                                color: Color(0xff079A4B),
                                              ),
                                              Text(
                                                "Package has been picked up",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Spacer(),
                                            ],
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: Text(
                                              "02:47pm",
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  ProgressTile(
                                    tileHeight: 200,
                                    child: Container(
                                      height: 150,
                                      margin: EdgeInsets.all(8),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Color(0xffdce3e8),
                                      ),
                                      child: Stack(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            spacing: 5,
                                            children: [
                                              Text(
                                                "Invoice Generated",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                "Call out charges will be refunded on acceptance",
                                                style: TextStyle(fontSize: 11),
                                              ),
                                              SizedBox(height: 5),
                                              Badge.count(
                                                padding: EdgeInsets.all(4),
                                                count: 1,
                                                backgroundColor: Color(
                                                  0xffC70000,
                                                ),
                                                child: TextButton(
                                                  style: ButtonStyle(
                                                    padding:
                                                        WidgetStatePropertyAll(
                                                          EdgeInsets.symmetric(
                                                            vertical: 8,
                                                            horizontal: 20,
                                                          ),
                                                        ),
                                                    shape: WidgetStatePropertyAll(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadiusGeometry.circular(
                                                              8,
                                                            ),
                                                        side: BorderSide(
                                                          color: Color(
                                                            0xff079A4B,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  onPressed: () {},
                                                  child: Text(
                                                    "View Invoice",
                                                    style: TextStyle(
                                                      color: Color(0xff079A4B),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: Text(
                                              "02:47pm",
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  ProgressTile(
                                    isLast: true,
                                    tileHeight: 150,
                                    child: Container(
                                      height: 80,
                                      margin: EdgeInsets.all(8),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Color(0xffdce3e8),
                                      ),
                                      child: Stack(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            spacing: 5,
                                            children: [
                                              Text(
                                                "Rider has Arrived at the location",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text("Rider has arrived"),
                                            ],
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: Text(
                                              "02:47pm",
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressTile extends StatelessWidget {
  const ProgressTile({
    super.key,
    this.child,
    this.tileHeight,
    this.isLast = false,
  });
  final Widget? child;
  final double? tileHeight;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 10, maxHeight: tileHeight ?? 200),
      child: Row(
        children: [
          Transform.translate(
            offset: Offset(0, 30),
            child: SizedBox(
              width: 40,
              child: Column(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff079A4B),
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(width: 2, color: Color(0xff079A4B)),
                    ),
                ],
              ),
            ),
          ),
          Expanded(child: child ?? SizedBox()),
        ],
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  final Offset start;
  final Offset end;

  DottedLinePainter({required this.start, required this.end});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xff079A4B)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    const dashWidth = 10.0;
    const dashSpace = 4.0;

    final distance = (end - start).distance;
    final normalized = (end - start) / distance;

    double currentDistance = 0;
    while (currentDistance < distance) {
      final dashEnd = currentDistance + dashWidth;
      if (dashEnd > distance) break;

      final dashStart = start + (normalized * currentDistance);
      final dashEndPoint = start + (normalized * dashEnd);

      canvas.drawLine(dashStart, dashEndPoint, paint);
      currentDistance += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DriverFoundView extends StatelessWidget {
  const DriverFoundView({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.check_circle, color: Color(0xff079A4B), size: 30),
            SizedBox(width: 12),
            Text(
              "Driver Found!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xff079A4B),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),

        Text(
          "Your driver is on the way to pick up your package.",
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),

        SizedBox(height: 30),

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
              onPressed: onTap,
              child: Text(
                "Track Driver",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TrackingView extends StatefulWidget {
  const TrackingView({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  State<TrackingView> createState() => _TrackingViewState();
}

class _TrackingViewState extends State<TrackingView> {
  String currentStatus = "Driver is on the way to pickup location";
  List<Map<String, dynamic>> trackingSteps = [
    {"title": "Order Confirmed", "completed": true, "time": "2:30 PM"},
    {"title": "Driver Assigned", "completed": true, "time": "2:32 PM"},
    {"title": "En Route to Pickup", "completed": true, "time": "2:35 PM"},
    {"title": "Package Picked Up", "completed": false, "time": ""},
    {"title": "En Route to Delivery", "completed": false, "time": ""},
    {"title": "Delivered", "completed": false, "time": ""},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Track Your Delivery",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          currentStatus,
          style: TextStyle(
            fontSize: 16,
            color: Color(0xff079A4B),
            fontWeight: FontWeight.w500,
          ),
        ),

        SizedBox(height: 30),

        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage("assets/images/liam.png"),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Liam",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Bicycle • 4.8 ⭐",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Text(
                      "Arriving in 15 mins",
                      style: TextStyle(
                        color: Color(0xff079A4B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.phone, color: Color(0xff079A4B)),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.message, color: Color(0xff079A4B)),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: 30),

        Text(
          "Delivery Progress",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),

        ...trackingSteps.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> step = entry.value;
          bool isLast = index == trackingSteps.length - 1;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: step['completed']
                          ? Color(0xff079A4B)
                          : Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    child: step['completed']
                        ? Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 40,
                      color: Colors.grey.shade300,
                    ),
                ],
              ),
              SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: step['completed'] ? Colors.black : Colors.grey,
                        ),
                      ),
                      if (step['time'].isNotEmpty)
                        Text(
                          step['time'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),

        SizedBox(height: 30),

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
              onPressed: () => Get.to(() => WelcomePage()),
              child: Text(
                "Back to Home",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
