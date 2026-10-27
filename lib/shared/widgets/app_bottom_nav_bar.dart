import 'package:flutter/material.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    required this.currentIndex,
    required this.onDestinationSelected,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  static const _destinations = [
    NavigationDestination(icon: Icon(Icons.home_outlined), label: 'HOME'),
    NavigationDestination(icon: Icon(Icons.favorite_outline), label: 'SAÚDE'),
    NavigationDestination(icon: Icon(Icons.today_outlined), label: 'ROTINA'),
    NavigationDestination(icon: Icon(Icons.person_outline), label: 'PERFIL'),
  ];

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
    child: NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: _destinations,
    ),
  );
}
