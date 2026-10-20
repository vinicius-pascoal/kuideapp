import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class KuideScaffold extends StatelessWidget {
  const KuideScaffold({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const _destinations = [
    NavigationDestination(icon: Icon(Icons.home_outlined), label: 'HOME'),
    NavigationDestination(icon: Icon(Icons.favorite_outline), label: 'SAÚDE'),
    NavigationDestination(icon: Icon(Icons.today_outlined), label: 'ROTINA'),
    NavigationDestination(icon: Icon(Icons.person_outline), label: 'PERFIL'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: navigationShell),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: _destinations,
      ),
    );
  }
}
