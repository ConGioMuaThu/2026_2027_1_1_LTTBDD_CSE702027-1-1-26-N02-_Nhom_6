import 'package:flutter/material.dart';
import 'package:greenlife_app/l10n/app_localizations.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onItemTapped,
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFE2F4E4),
        shadowColor: Colors.transparent,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: strings.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.local_florist_outlined),
            selectedIcon: const Icon(Icons.local_florist),
            label: strings.library,
          ),
          NavigationDestination(
            icon: const Icon(Icons.yard_outlined),
            selectedIcon: const Icon(Icons.yard),
            label: strings.garden,
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_month_outlined),
            selectedIcon: const Icon(Icons.calendar_month),
            label: strings.care,
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book),
            label: strings.journal,
          ),
          NavigationDestination(
            icon: const Icon(Icons.tips_and_updates_outlined),
            selectedIcon: const Icon(Icons.tips_and_updates),
            label: strings.tips,
          ),
          NavigationDestination(
            icon: const Icon(Icons.groups_outlined),
            selectedIcon: const Icon(Icons.groups),
            label: strings.teamInfo,
          ),
        ],
      ),
    );
  }
}
