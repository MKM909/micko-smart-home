import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:micko_smart_home/widgets/animation_widgets/fade_from_bottom.dart';
import 'package:micko_smart_home/widgets/animation_widgets/fade_from_left.dart';

import '../widgets/animation_widgets/fade_from_right.dart';
import '../widgets/device_card.dart';

final GlobalKey<_KitchenState> kitchenKey = GlobalKey<_KitchenState>();

class Kitchen extends StatefulWidget {
  Kitchen() : super(key: kitchenKey);

  @override
  State<Kitchen> createState() => _KitchenState();
}

class _KitchenState extends State<Kitchen> with SingleTickerProviderStateMixin{

  late AnimationController _controller;
  late Animation<double> _numberAnimation;

  List<Map<String, dynamic>> devices = [
    {"title": "LG InstaView", "subtitle": "3°C", "icon": Icons.kitchen, "isOn": true},
    {"title": "Coffee Machine", "subtitle": "Ready", "icon": Icons.coffee, "isOn": true},
    {"title": "Dishwasher", "subtitle": "Eco Mode", "icon": Icons.wash, "isOn": false},
    {"title": "Smart Oven", "subtitle": "200°C • 15m left", "icon": FontAwesomeIcons.bowlFood, "isOn": true},
  ];

  void masterToggle() {
    setState(() {
      // Check how many devices are currently ON
      int onCount = devices.where((d) => d['isOn'] == true).length;

      bool majorityIsOn = onCount > (devices.length / 2);

      bool targetState = !majorityIsOn;

      for (var device in devices) {
        device['isOn'] = targetState;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _numberAnimation = Tween<double>(begin: 25, end: 180).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(Duration(milliseconds: 600) , null);
    _controller.forward(from: 0);

  }

  @override
  void dispose() {
    _controller.dispose(); // Always dispose to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final double screenWidth = MediaQuery.of(context).size.width;
    final double fontScale = screenWidth/360;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0  * fontScale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeFromRight(
              duration: Duration(milliseconds: 600),
              play: true,
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                      "Good Morning,",
                      style: GoogleFonts.quicksand(
                          fontSize: 22 * fontScale,
                          color: Colors.black,
                          fontWeight: FontWeight.w600
                      )
                  ),

                  SizedBox(height: 2 * fontScale,),

                  Text(
                      "Micah 😀",
                      style: GoogleFonts.quicksand(
                          fontSize: 26 * fontScale,
                          fontWeight: FontWeight.w700,
                          color: Colors.black
                      )
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),

            // Energy Estimate Card
            AnimatedBuilder(
                animation: _numberAnimation,
                builder: (context, child) {
                  return FadeFromLeft(
                    duration: Duration(milliseconds: 600),
                    play: true,
                    child: Container(
                      padding: EdgeInsets.all(15 * fontScale),
                      margin: EdgeInsets.only(right: 50 * fontScale),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.bolt, color: Colors.black, size: 24 * fontScale,),
                              SizedBox(width: 10 * fontScale),
                              Expanded(child: Text("Estimate energy \nexpenses this month", maxLines: 2, style: GoogleFonts.quicksand(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 15 * fontScale))),
                              Icon(Icons.more_horiz, size: 22 * fontScale, color: Colors.black,),
                            ],
                          ),
                          SizedBox(height: 18 * fontScale),
                          Container(
                            height: 40 * fontScale,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              crossAxisAlignment: .center,
                              children: [
                                Container(
                                  width: _numberAnimation.value,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: .end,
                                    mainAxisAlignment: .end,
                                    children: [
                                      VerticalDivider(color: Colors.white, indent: 10, endIndent: 10, thickness: 4, radius: BorderRadius.circular(50), width: 10,),
                                      SizedBox(width: 10 * fontScale,)
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 15.0),
                                  child: Text("₹1.5K", style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: 13 * fontScale, color: Colors.black)),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
            ),
            SizedBox(height: 30  * fontScale),

            // Device Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.2,
                ),
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  bool isFirst = devices.first == devices[index];
                  return FadeFromBottom(
                    duration: Duration(milliseconds: ((index + 1) * 200) + 400),
                    offset: (index + 1) * 30,
                    play: true,
                    child: DeviceCard(
                      title: devices[index]['title'],
                      subtitle: devices[index]['subtitle'],
                      icon: devices[index]['icon'],
                      isOn: devices[index]['isOn'], // This listens to the master state
                      onTap: (bool newValue) {
                        // This handles individual toggling
                        setState(() {
                          devices[index]['isOn'] = newValue;
                        });
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void onTap() => debugPrint('tapped');

}