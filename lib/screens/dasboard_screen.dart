import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: isExpanded,
            backgroundColor: Colors.brown,
            unselectedIconTheme: const IconThemeData(color: Colors.white, opacity: 1),
            unselectedLabelTextStyle: const TextStyle(color: Colors.white,),
            selectedIconTheme: const IconThemeData(color: Colors.brown),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.date_range),
                label: Text("Appointments"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.schedule),
                label: Text("Scheduling"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person),
                label: Text("Records"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.report),
                label: Text("Reports"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.miscellaneous_services),
                label: Text("Services"),
              ),
            ],
            selectedIndex: 0,
          ),
          Expanded(
            child: Column(
              children: [
                // Header Section: Fixed at the top
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          // Toggle the navigation rail expansion
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        icon: const Icon(Icons.menu),
                      ),
                      Text(
                        DateFormat('yyyy-MM-dd').format(DateTime.now()),
                        style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                // Scrollable Content Section


              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.deepPurple.shade400,
        child: const Icon(Icons.add),
      ),
    );
  }
}