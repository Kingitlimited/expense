import 'package:flutter/material.dart';

class CenterIconAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CenterIconAppBar({super.key, required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon), const SizedBox(width: 8), Text(title)],
      ),
      elevation: 0,
    );
  }
}
