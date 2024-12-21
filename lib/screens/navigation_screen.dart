import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_demo/screens/app_colors.dart';
import 'package:flutter_demo/screens/dashboard_screen.dart';
import 'package:flutter_demo/screens/expenses_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  bool isExpanded = false;
  int selectedIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const DashboardScreen(),
      const ExpensesScreen(),
      
    ];
  }

  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop();
                _performLogout();
              },
            ),
          ],
        );
      },
    );
  }

  void _performLogout() {
    Navigator.of(context).pushReplacementNamed('/');
  }


   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColors.darkBrownColor,
              borderRadius: BorderRadius.horizontal(right: Radius.circular(10)),
            ),
            child: NavigationRail(
              selectedIndex: selectedIndex,
              extended: isExpanded,
              onDestinationSelected: (int index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              labelType: isExpanded
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.all,
              backgroundColor: Colors.transparent,
              groupAlignment: -1.0,
              leading: Column(
                children: [
                  Ink.image(
                    width: isExpanded ? 100 : 80,
                    height: isExpanded ? 100 : 80,
                    fit: BoxFit.fitHeight,
                    image: const AssetImage('assets/images/YNS Logo1.png'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Expensees',
                    style: TextStyle(
                      fontSize: isExpanded ? 16 : 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.end, // Align at the bottom
                children: [
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.red),
                    onPressed: _showLogoutDialog,
                    tooltip: 'Logout',
                  ),
                ],
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard, color: Colors.white),
                  selectedIcon: Icon(Icons.dashboard, color: AppColors.mainBrownColor),
                  label: Text("Dashboard", style: TextStyle(color: Colors.white)),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.monetization_on_sharp, color: Colors.white),
                  selectedIcon: Icon(Icons.person, color: AppColors.mainBrownColor),
                  label: Text("Expenses", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                          icon: Icon(
                            isExpanded ? Icons.menu_open : Icons.menu,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 20.0),
                            const SizedBox(width: 8.0),
                            Text(
                              DateFormat('EEEE, MMMM d, yyyy')
                                  .format(DateTime.now()),
                              style: const TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  // child: _screens[selectedIndex], // Display the selected screen\
                    child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(opacity: animation, child: child);
                    }, // Display the selected screen
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeOut,
                    layoutBuilder: (currentChild, previousChildren) => Stack(
                      children: <Widget>[
                        ...previousChildren,
                        if (currentChild != null) currentChild,
                      ],
                    ),
                    child: _screens[selectedIndex],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}