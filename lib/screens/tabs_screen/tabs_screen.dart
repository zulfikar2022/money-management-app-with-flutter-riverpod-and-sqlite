import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_management_app/providers/entry_provider.dart';
import 'package:flutter_money_management_app/screens/tabs_screen/tabs_all_screen.dart';
import 'package:flutter_money_management_app/screens/tabs_screen/tabs_borrowing_screen.dart';
import 'package:flutter_money_management_app/screens/tabs_screen/tabs_completed_screen.dart';
import 'package:flutter_money_management_app/screens/tabs_screen/tabs_providing_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int selectedIndex = 0;
  List<Widget> screens = [
    TabsAllScreen(),
    TabsProvidingScreen(),
    TabsBorrowingScreen(),
    TabsCompletedScreen(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blueGrey, // color for selected icon & label
        unselectedItemColor: Colors.grey, // color for others
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.task_alt), label: 'All'),
          BottomNavigationBarItem(
            // backgroundColor: Colors.teal[50],
            icon: Icon(Icons.payments_outlined),
            label: 'Providing',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Borrowings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done_all),
            label: 'Completed',
          ),
        ],
      ),
    );
  }
}
