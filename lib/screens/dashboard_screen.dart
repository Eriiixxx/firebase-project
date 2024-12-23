import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart'; // Import intl for DateFormat
import 'package:flutter_demo/screens/app_colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<ExpenseData> expenseByCategory = [];
  List<ExpenseData> expenseByMonth = [];
  bool isLoading = true;
  int _currentYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      // Fetch expenses from Firestore
      QuerySnapshot snapshot = await _firestore.collection('expenses').get();

      // Aggregating data for the pie chart (by category)
      Map<String, double> categoryData = {};
      // Aggregating data for the bar chart (by month)
      Map<String, double> monthData = {};

      // Loop through each document and aggregate the data
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        // Check for missing fields
        if (!data.containsKey('amount') || !data.containsKey('timestamp')) {
          print('Skipping document with missing fields: ${doc.id}');
          continue;
        }

        double? amount = data['amount'] is num ? (data['amount'] as num).toDouble() : null;
        Timestamp? timestamp = data['timestamp'] as Timestamp?;

        if (amount == null || timestamp == null) {
          print('Skipping document with invalid data types: ${doc.id}');
          continue;
        }

        DateTime date = timestamp.toDate();
        
        // Check if the data is from the current year
        if (date.year != _currentYear) continue;

        // For the pie chart (by category)
        String category = data['category'] ?? 'Unknown';
        categoryData[category] = (categoryData[category] ?? 0) + amount;

        // For the bar chart (by month)
        String month = DateFormat('MMMM').format(date);
        monthData[month] = (monthData[month] ?? 0) + amount;
      }

      // Ensure all categories are included (even if they have no data)
      List<String> months = [
        'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 
        'September', 'October', 'November', 'December'
      ];

      // Fill missing months with zero data
      Map<String, double> allMonthsData = {};
      for (var month in months) {
        allMonthsData[month] = monthData[month] ?? 0;
      }

      // Set the data for the charts
      setState(() {
        expenseByCategory = categoryData.entries
            .map((entry) => ExpenseData(entry.key, entry.value))
            .toList();

        expenseByMonth = allMonthsData.entries
            .map((entry) => ExpenseData(entry.key, entry.value))
            .toList();
        isLoading = false;
      });
    } catch (e, stackTrace) {
      print('Error fetching Firestore data: $e');
      print(stackTrace);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TITLE
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: const Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Dashboard",
                            style: TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkBrownColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Charts Section
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          
                          // Expense by Month Bar Chart
                          _buildMonthBarChart(),
                          const SizedBox(height: 30),
                          // Expense by Category Pie Chart
                          _buildCategoryPieChart(),
                          
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Pie Chart for Expense Categories
  Widget _buildCategoryPieChart() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const Text(
            "Expenses by Category",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBrownColor,
            ),
          ),
          const SizedBox(height: 20),
          SfCircularChart(
            legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
            series: <CircularSeries>[
              PieSeries<ExpenseData, String>(
                dataSource: expenseByCategory,
                xValueMapper: (ExpenseData data, _) => data.category,
                yValueMapper: (ExpenseData data, _) => data.amount,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Bar Chart for Expense Trends by Month
  Widget _buildMonthBarChart() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Year navigation button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_left),
                onPressed: () {
                  setState(() {
                    _currentYear--;
                    fetchData();
                  });
                },
              ),
              // Title and Year
              Text(
                "Expenses by Month - $_currentYear",
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBrownColor,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_right),
                onPressed: () {
                  setState(() {
                    _currentYear++;
                    fetchData();
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(labelFormat: '{value} PHP'),
            legend: Legend(isVisible: false),
            series: <CartesianSeries>[
              ColumnSeries<ExpenseData, String>(
                dataSource: expenseByMonth,
                xValueMapper: (ExpenseData data, _) => data.category, // This maps the month name
                yValueMapper: (ExpenseData data, _) => data.amount,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Data Model for the charts
class ExpenseData {
  final String category;
  final double amount;

  ExpenseData(this.category, this.amount);
}
