import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'discover_view.dart';
import 'profile_view.dart';
import 'swipe_view.dart';

class MainView extends StatefulWidget {
  static const id = 'MainView';

  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: const [DiscoverView(), SwipeView(), ProfileView()],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) => setState(() => _selectedIndex = index),
        items: [
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.tabbarDiscover,
            icon: const Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.tabbarSwipe,
            icon: const Icon(Icons.ac_unit),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.tabbarProfile,
            icon: const Icon(Icons.supervised_user_circle_outlined),
          ),
        ],
      ),
    );
  }
}
