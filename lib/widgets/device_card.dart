import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';

class DeviceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isOn;
  final ValueChanged<bool> onTap;

  const DeviceCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isOn = false,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double fontScale = screenWidth/360;

    return SizedBox(
      width: 150,
      height: 150,
      child: Stack(
        children: [
          Positioned(
            top: 2,
            right: 0,
            left: 1,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: isOn ? Colors.black : Colors.transparent,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: isOn ? Colors.black : Colors.transparent, width: 1.5),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 1,
            bottom: 2,
            child: Container(
              padding: EdgeInsets.only(left: 15 * fontScale, right: 15 * fontScale, top: 15 * fontScale, bottom: 15 * fontScale),
              decoration: BoxDecoration(
                color: isOn ? Colors.white : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: isOn ? Colors.black : Colors.grey.shade300, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 24 * fontScale, color: isOn ? Colors.black : Colors.grey.shade500,),
                      Spacer(),
                      FlutterSwitch(
                        width: 50 * fontScale,
                        height: 25 * fontScale,
                        padding: 3 * fontScale,
                        borderRadius: 100,
                        valueFontSize: 12 * fontScale,
                        toggleSize: 20 * fontScale,
                        activeTextColor: Colors.white,
                        inactiveTextColor: Colors.white.withValues(alpha: 0.8),
                        showOnOff: true,
                        value: isOn,
                        onToggle: (val) => onTap(val),
                        activeToggleColor: Colors.white,
                        activeColor: Colors.black,
                        inactiveToggleColor: Colors.grey.shade600,
                        inactiveColor: Colors.grey.shade400,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, maxLines : 2, overflow: TextOverflow.ellipsis,style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 16  * fontScale,  color: isOn ? Colors.black : Colors.grey.shade500,)),
                      if(subtitle.isNotEmpty)
                        Text(
                            subtitle,
                            style: GoogleFonts.quicksand(
                                color: isOn ? Colors.black : Colors.grey.shade500.withValues(alpha: 0.5),
                                fontSize: 14 * fontScale,
                                fontWeight: FontWeight.w500
                            )
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}