import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seaaegis/helpers/dark_mode.dart';

class ThemeButton extends StatelessWidget {
  final VoidCallback onTap;
  final double? height;
  final double? width;
  final String icon;
  final String modeName;
  const ThemeButton(
      {super.key,
      required this.onTap,
      this.height,
      this.width,
      required this.modeName,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                height: height ?? 32,
                width: width ?? 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.isDarkMode
                      ? Colors.black.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.2),
                ),
                child: SvgPicture.asset(
                  colorFilter: ColorFilter.mode(
                      context.isDarkMode ? Colors.white : Colors.black,
                      BlendMode.srcIn),
                  icon,
                  fit: BoxFit.none,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            modeName,
            style: const TextStyle(
                fontWeight: FontWeight.w500, fontSize: 17, color: Colors.grey),
          )
        ],
      ),
    );
  }
}
