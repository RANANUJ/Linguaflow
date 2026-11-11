import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linguaflow/core/localization/translation_provider.dart';

import '../../../../core/localization/translation_helper.dart';
import '../../../../core/localization/translation_keys.dart';
import 'create_story_screen.dart';
import 'explore_screen.dart';
import 'home_screen.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState
    extends ConsumerState<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ExploreScreen(),
    CreateStoryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watches the language state so navigation labels rebuild
    // when the user changes the app language.
    ref.watch(translationVersionProvider);

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Color(0xFFE6E5DD),
            ),
          ),
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            height: 68,
            backgroundColor: Colors.white,
            indicatorColor: const Color(0xFFEAF0EC),
            labelTextStyle: WidgetStateProperty.resolveWith(
              (states) {
                if (states.contains(WidgetState.selected)) {
                  return const TextStyle(
                    color: Color(0xFF245C48),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  );
                }

                return const TextStyle(
                  color: Color(0xFF777C73),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                );
              },
            ),
            iconTheme: WidgetStateProperty.resolveWith(
              (states) {
                if (states.contains(WidgetState.selected)) {
                  return const IconThemeData(
                    color: Color(0xFF245C48),
                  );
                }

                return const IconThemeData(
                  color: Color(0xFF777C73),
                );
              },
            ),
          ),
          child: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home_rounded),
                label: translate(
                  ref,
                  TranslationKeys.home,
                ),
              ),
              NavigationDestination(
                icon: const Icon(Icons.explore_outlined),
                selectedIcon: const Icon(Icons.explore_rounded),
                label: translate(
                  ref,
                  TranslationKeys.explore,
                ),
              ),
              NavigationDestination(
                icon: const Icon(Icons.add_circle_outline),
                selectedIcon: const Icon(Icons.add_circle_rounded),
                label: translate(
                  ref,
                  TranslationKeys.create,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}