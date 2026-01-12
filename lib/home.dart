import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:micko_smart_home/screens/kitchen.dart';
import 'package:micko_smart_home/screens/living_room.dart';

import 'hanging_light_rope/hanging_light_rope.dart';

class Home extends StatefulWidget {
  const Home({super.key,});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _currentIndex = 0;
  int _previousIndex = 0;

  List<NavItem> tabs = [
    NavItem(name: 'Living Room',),
    NavItem(name: 'Kitchen',),
    NavItem(name: 'Dining',),
    NavItem(name: 'Work Place',),
    NavItem(name: 'Bedroom',)
  ];

  List<Widget> tabPages = [
    LivingRoom(),
    Kitchen(),
    Container(),
    Container(),
    Container(),
  ];

  @override
  Widget build(BuildContext context) {

    final double screenWidth = MediaQuery.of(context).size.width;
    final double fontScale = screenWidth/360;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Stack(
        children: [
          Positioned.fill(
            child: SafeArea(
              child: Column(
                crossAxisAlignment:  .start,
                mainAxisAlignment: .start,
                children: [
                  // Top Navigation Menu
                  SizedBox(height: 10 * fontScale,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20 * fontScale),
                    child: Row(
                      crossAxisAlignment: .start,
                      mainAxisAlignment: .start,
                      children: [
                        Icon(Icons.short_text_rounded, size: 50 * fontScale),
                        SizedBox(width: 20 * fontScale,),
                        Expanded(child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: buildTabs(fontScale),
                        ))
                      ],
                    ),
                  ),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) {
                        final isForward = _currentIndex > _previousIndex;

                        final offsetAnimation = Tween<Offset>(
                          begin: Offset(isForward ? 0.15 : -0.15, 0),
                          end: Offset.zero,
                        ).animate(animation);

                        final fadeAnimation =
                        Tween<double>(begin: 0.0, end: 1.0).animate(animation);

                        return SlideTransition(
                          position: offsetAnimation,
                          child: FadeTransition(
                            opacity: fadeAnimation,
                            child: child,
                          ),
                        );
                      },
                      child: KeyedSubtree(
                        key: ValueKey(_currentIndex),
                        child: tabPages[_currentIndex],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          // Hanging Light Rope
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: HangingLightRope(
              bulbColor: Colors.grey.shade900,
              bulbBorderColor: Colors.grey.shade800,
              bulbBgColor: Colors.white,
              inactiveBulbColor: Colors.black,
              isGlowEnabled: false,
              bulbRadius: 15,
              glowRadius: 5,
              ropeColor: Colors.grey.shade800,
              pullThreshold: 550 * fontScale,
              sluggishness: 0.5,
              initialRopeLength: 250 * fontScale,
              returnDuration: Duration(milliseconds: 5000),
              onPulled: () {
                HapticFeedback.heavyImpact();
                if(tabs[_currentIndex].name == 'Living Room'){
                  livingRoomKey.currentState?.masterToggle();
                }

                if(tabs[_currentIndex].name == 'Kitchen'){
                  kitchenKey.currentState?.masterToggle();
                }
              },
            ),
          )

        ],
      ),
    );
  }


  Widget buildTabs(double fontScale) {
    return SizedBox(
      height: 60 * fontScale, // Increased height slightly for indicator padding
      child: Stack(
        children: [
          // 1. The Scrollable List
          ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: tabs.length,
            // Add padding to the start/end so items don't start under the fade
            padding: EdgeInsets.symmetric(horizontal: 10 * fontScale),
            itemBuilder: (context, index) {
              final tabItem = tabs[index];
              bool isActive = _currentIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _previousIndex = _currentIndex;
                    _currentIndex = index;
                  });
                },
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.only(right: 25 * fontScale),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        style: GoogleFonts.quicksand(
                          fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 18 * fontScale,
                          color: isActive
                              ? Colors.black
                              : Colors.black.withValues(alpha: 0.4),
                        ),
                        child: Text(tabItem.name),
                      ),

                      SizedBox(height: 7 * fontScale),

                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        width: isActive ? 40 * fontScale : 0,
                        height: 4 * fontScale,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),

          // 2. Left Faded Edge
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 30 * fontScale,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.grey.shade200, // Matches your Scaffold background
                    Colors.grey.shade200.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),

          // 3. Right Faded Edge
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 30 * fontScale,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [
                    Colors.grey.shade200,
                    Colors.grey.shade200.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class NavItem {
  final String name;
  NavItem({
    required this.name,
  });
}