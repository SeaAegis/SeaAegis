import 'package:flutter/material.dart';
import 'package:seaaegis/helpers/dark_mode.dart';

class BasicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final bool? centerTitle;
  final bool isBack;
  const BasicAppBar(
      {super.key, this.title, this.centerTitle, this.isBack = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      title: title,
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: isBack
          ? IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: context.isDarkMode
                      ? Colors.white.withOpacity(0.03)
                      : Colors.black.withOpacity(0.04),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 24,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
