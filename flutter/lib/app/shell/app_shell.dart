import 'package:flutter/material.dart';

import 'package:cicwtch/app/auth/auth_provider.dart';
import 'package:cicwtch/features/clients/presentation/clients_list_screen.dart';
import 'package:cicwtch/features/dashboard/presentation/dashboard_screen.dart';
import 'package:cicwtch/features/dogs/presentation/dogs_list_screen.dart';
import 'package:cicwtch/features/invoices/presentation/invoices_list_screen.dart';
import 'package:cicwtch/features/walkers/presentation/walkers_list_screen.dart';
import 'package:cicwtch/features/walks/presentation/walks_list_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    DashboardScreen(),
    ClientsListScreen(),
    DogsListScreen(),
    WalksListScreen(),
    WalkersListScreen(),
    InvoicesListScreen(),
  ];

  static const List<_NavItem> _navItems = [
    _NavItem(icon: Icons.dashboard, label: 'Dashboard'),
    _NavItem(icon: Icons.people, label: 'Clients'),
    _NavItem(icon: Icons.pets, label: 'Dogs'),
    _NavItem(icon: Icons.directions_walk, label: 'Walks'),
    _NavItem(icon: Icons.badge, label: 'Walkers'),
    _NavItem(icon: Icons.receipt_long, label: 'Invoices'),
  ];

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 720;

    final body = IndexedStack(index: _selectedIndex, children: _screens);

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onDestinationSelected,
              labelType: NavigationRailLabelType.all,
              destinations: _navItems.map((item) => NavigationRailDestination(icon: Icon(item.icon), label: Text(item.label))).toList(),
              trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: IconButton(
                      icon: const Icon(Icons.logout),
                      tooltip: 'Sign out',
                      onPressed: () => _confirmLogout(context),
                    ),
                  ),
                ),
              ),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: body),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onDestinationSelected,
        type: BottomNavigationBarType.fixed,
        items: _navItems.map((item) => BottomNavigationBarItem(icon: Icon(item.icon), label: item.label)).toList(),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await AuthProvider.of(context).logout();
    }
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
