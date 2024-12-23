import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_demo/screens/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _expensesNameController = TextEditingController();
  final TextEditingController _expensesDescriptionController = TextEditingController();
  final TextEditingController _expensesAmountController = TextEditingController();

  String? selectedCategory;
  List<Map<String, dynamic>> _allExpenses = [];
  List<Map<String, dynamic>> _filteredExpenses = [];

  @override
  void initState() {
    super.initState();
    fetchExpenses();
  }

  Future<void> handleAddExpenses() async {
    final String name = _expensesNameController.text.trim();
    final String description = _expensesDescriptionController.text.trim();
    final String amount = _expensesAmountController.text.trim();
    final String category = selectedCategory ?? 'Uncategorized';
    final DateTime timestamp = DateTime.now();

    if (name.isEmpty || amount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields.")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('expenses').add({
        'name': name,
        'description': description,
        'amount': double.tryParse(amount) ?? 0.0,
        'category': category,
        'timestamp': timestamp,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Expenses added successfully.")),
      );

      // Reload expenses
      fetchExpenses();

      _expensesNameController.clear();
      _expensesDescriptionController.clear();
      _expensesAmountController.clear();
      selectedCategory = null;

      fetchExpenses();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding expenses: $e")),
      );
    }
  }

  Future<void> fetchExpenses() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('expenses')
          .orderBy('timestamp', descending: true)
          .get();

      setState(() {
        _allExpenses = querySnapshot.docs.map((doc) {
          // Safely convert 'amount' to double (or 0.0 if it's invalid)
          double amount = 0.0;
          if (doc['amount'] != null) {
            // Handle if it's an int or double
            if (doc['amount'] is int) {
              amount = doc['amount'].toDouble();
            } else if (doc['amount'] is double) {
              amount = doc['amount'];
            } else if (doc['amount'] is String) {
              try {
                amount = double.parse(doc['amount']);
              } catch (e) {
                amount = 0.0; // Default value if parse fails
              }
            }
          }

          return {
            'id': doc.id,
            'name': doc['name'],
            'amount': amount,  // Ensure 'amount' is a valid double
            'category': doc['category'],
            'timestamp': doc['timestamp'],
            'description': doc['description'],
          };
        }).toList();

        _filteredExpenses = _allExpenses;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching expenses: $e")),
      );
    }
  }

  void searchExpenses(String query) {
    final lowerQuery = query.toLowerCase();

    setState(() {
      _filteredExpenses = _allExpenses.where((doc) {
        final name = doc['name'].toString().toLowerCase();
        final category = doc['category'].toString().toLowerCase();

        // If "All Expenses" is selected, show all expenses
        if (selectedCategory == 'All Expenses') {
          return name.contains(lowerQuery) || category.contains(lowerQuery);
        }

        // If no category is selected, or the selected category matches the expense category
        bool categoryMatch = selectedCategory == null || category.contains(selectedCategory!.toLowerCase());

        // Return true if either the name or category matches the search query, and category matches the selected category
        return (name.contains(lowerQuery) || category.contains(lowerQuery)) && categoryMatch;
      }).toList();
    });
  }


  // Function to handle the update
  Future<void> handleUpdateExpense(String expenseId) async {
    try {
      // Get the updated values from the text controllers and dropdown
      String updatedName = _expensesNameController.text;
      double updatedAmount = double.parse(_expensesAmountController.text);
      String updatedCategory = selectedCategory!;
      String updatedDescription = _expensesDescriptionController.text;

      // Reference to Firestore
      CollectionReference expenses = FirebaseFirestore.instance.collection('expenses');

      // Update the document
      await expenses.doc(expenseId).update({
        'name': updatedName,
        'amount': updatedAmount,
        'category': updatedCategory,
        'description': updatedDescription,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Reload expenses
      fetchExpenses();

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense updated successfully!')),
      );
    } catch (e) {
      print('Error updating expense: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update expense.')),
      );
    }
  }

  // Function to handle the deletion of an expense
  Future<void> handleDeleteExpense(String expenseId) async {
    try {
      // Reference to Firestore
      CollectionReference expenses = FirebaseFirestore.instance.collection('expenses');

      // Delete the document
      await expenses.doc(expenseId).delete();

      // Reload expenses
      fetchExpenses();

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense deleted successfully!')),
      );
    } catch (e) {
      print('Error deleting expense: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete expense.')),
      );
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
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Expenses Record",
                            style: TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkBrownColor,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              _showAddExpensesDialog(context);
                            },
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text("Add Expenses", style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.darkBrownColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: selectedCategory,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedCategory = newValue;
                                  searchExpenses(_searchController.text);  // Re-trigger the search with the current search query
                                });
                              },
                              items: [
                                'All Expenses',
                                'Personal Expenses',
                                'Business Expenses',
                                'Fixed Expenses',
                                'Variable Expenses',
                                'Recurring Expenses',
                                'One-Time Expenses',
                                'Capital Expenses',
                                'Operating Expenses',
                                'Discretionary Expenses',
                                'Non-Discretionary Expenses',
                                'Contingency Expenses',
                                'Tax-Related Expenses',
                                'Travel Expenses',
                                'Education Expenses',
                                'Medical Expenses',
                              ].map<DropdownMenuItem<String>>((String category) {
                                return DropdownMenuItem<String>(value: category, child: Text(category));
                              }).toList(),
                              underline: Container(),
                              dropdownColor: Colors.white,
                              icon: const Icon(Icons.arrow_drop_down, color: AppColors.darkBrownColor),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (query) {
                                searchExpenses(query); // Re-trigger the search with the updated query
                              },
                              decoration: const InputDecoration(
                                hintText: 'Search Expenses...',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.search, color: AppColors.darkBrownColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      SizedBox(
                        height: 400,
                        child: _filteredExpenses.isEmpty
                            ? const Center(child: Text('No matching expenses found.'))
                            : Container(
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
                                    const SizedBox(height: 10),
                                    Table(
                                      columnWidths: const {
                                        0: FlexColumnWidth(1),  // Date
                                        1: FlexColumnWidth(1),  // Name
                                        2: FlexColumnWidth(1),  // Category
                                        3: FlexColumnWidth(1),  // Amount
                                        4: FlexColumnWidth(1),  // Description
                                        5: FlexColumnWidth(1),  // Actions
                                      },
                                      children: [
                                        TableRow(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          children: const [
                                            Padding(
                                              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "DATE",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "NAME",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "CATEGORY",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "AMOUNT",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "DESCRIPTION",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "ACTIONS",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        for (var expense in _filteredExpenses)
                                          TableRow(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    DateFormat('yyyy-MM-dd').format(
                                                      (expense['timestamp'] is Timestamp)
                                                          ? (expense['timestamp'] as Timestamp).toDate()
                                                          : DateTime.now(),
                                                    ),
                                                    style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    expense['name'],
                                                    style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    expense['category'],
                                                    style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    '₱ ${expense['amount'].toStringAsFixed(2)}',
                                                    style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    expense['description'],
                                                    style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                                      onPressed: () {
                                                        // Pass the entire expense data when updating
                                                        _showEditExpensesDialog(context, expense);
                                                      },
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(Icons.delete, color: Colors.red),
                                                      onPressed: () {
                                                        // Show delete confirmation dialog with the expense ID
                                                        _showDeleteConfirmationDialog(context, expense['id']); // Pass expenseId to delete function
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Add Expenses Dialog
  void _showAddExpensesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                'Add Expenses',
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
              ),
              content: SizedBox(
                width: 500,
                height: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Divider(
                      height: 10,
                      color: Colors.grey[800],
                      thickness: 0.5,
                    ),
                    const SizedBox(height: 15.0),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Enter Expenses Details",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Expenses Name
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _expensesNameController,
                            decoration: const InputDecoration(
                              labelText: 'Expenses Name',
                              border: UnderlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Amount
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _expensesAmountController,
                            decoration: const InputDecoration(
                              labelText: 'Amount',
                              border: UnderlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Expenses Category
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Expenses Category',
                              border: UnderlineInputBorder(),
                            ),
                            items: <String>[
                              'Personal Expenses',
                              'Business Expenses',
                              'Fixed Expenses',
                              'Variable Expenses',
                              'Recurring Expenses',
                              'One-Time Expenses',
                              'Capital Expenses',
                              'Operating Expenses',
                              'Discretionary Expenses',
                              'Non-Discretionary Expenses',
                              'Contingency Expenses',
                              'Tax-Related Expenses',
                              'Travel Expenses',
                              'Education Expenses',
                              'Medical Expenses',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedCategory = newValue;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Description
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _expensesDescriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              border: UnderlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text('Add Expenses'),
                  onPressed: () async {
                    // Add Expenses to the database
                    await handleAddExpenses();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Edit Expenses Dialog
  void _showEditExpensesDialog(BuildContext context, Map<String, dynamic> expense) {
    // Populate the controllers with the existing data
    _expensesNameController.text = expense['name'];
    _expensesAmountController.text = expense['amount'].toString();
    _expensesDescriptionController.text = expense['description'];
    selectedCategory = expense['category'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                'Edit Expenses',
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
              ),
              content: SizedBox(
                width: 500,
                height: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Divider(
                      height: 10,
                      color: Colors.grey[800],
                      thickness: 0.5,
                    ),
                    const SizedBox(height: 15.0),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Edit Expenses Details",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Expenses Name
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _expensesNameController,
                            decoration: const InputDecoration(
                              labelText: 'Expenses Name',
                              border: UnderlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Amount
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _expensesAmountController,
                            decoration: const InputDecoration(
                              labelText: 'Amount',
                              border: UnderlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Expenses Category
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Expenses Category',
                              border: UnderlineInputBorder(),
                            ),
                            value: selectedCategory,
                            items: <String>[
                              'Personal Expenses',
                              'Business Expenses',
                              'Fixed Expenses',
                              'Variable Expenses',
                              'Recurring Expenses',
                              'One-Time Expenses',
                              'Capital Expenses',
                              'Operating Expenses',
                              'Discretionary Expenses',
                              'Non-Discretionary Expenses',
                              'Contingency Expenses',
                              'Tax-Related Expenses',
                              'Travel Expenses',
                              'Education Expenses',
                              'Medical Expenses',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedCategory = newValue;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Description
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _expensesDescriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              border: UnderlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text('Update Expenses'),
                  onPressed: () async {
                    // Update Expenses in Firestore
                    await handleUpdateExpense(expense['id']);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Show delete confirmation dialog
void _showDeleteConfirmationDialog(BuildContext context, String expenseId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Delete Expense',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
        ),
        content: const Text(
          'Are you sure you want to delete this expense?',
          style: TextStyle(fontSize: 18),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: const Text('Delete'),
            onPressed: () async {
              // Delete the expense from Firestore
              await handleDeleteExpense(expenseId);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}






}
