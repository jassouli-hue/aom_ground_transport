import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;

  const AomAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: subtitle != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                Text(subtitle!,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.white70, fontWeight: FontWeight.w400)),
              ],
            )
          : Text(title),
      actions: actions,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
