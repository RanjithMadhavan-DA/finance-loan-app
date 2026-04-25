import 'package:flutter/material.dart';
import '../provider/finance_provider.dart';
// import '../model/fin_model.dart';/

// import 'dart:convert';

import 'package:provider/provider.dart';
// import 'package:uuid/uuid.dart';
// import '../provider/finance_provider.dart';
//
// import '../model/fin_model.dart';
// import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../widgets/ui.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Dashboard'),
      ),
      body: Consumer<FinanceProvider>(
        builder: (context, value, child) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                /// 🔥 TOTAL GIVEN
                dashboardCard("Total Given", "₹${value.totalGiven}", [
                  Colors.indigo,
                  Colors.blue,
                ], Icons.arrow_upward),

                SizedBox(height: 12),

                /// 🔥 TOTAL RECEIVED
                dashboardCard("Total Received", "₹${value.totalRecieved}", [
                  Colors.green,
                  Colors.teal,
                ], Icons.arrow_downward),

                SizedBox(height: 12),

                /// 🔥 TOTAL PENDING
                dashboardCard("Total Pending", "₹${value.totalPending}", [
                  Colors.orange,
                  Colors.deepOrange,
                ], Icons.pending),

                SizedBox(height: 20),

                /// 🔥 STATUS ROW
                Row(
                  children: [
                    Expanded(
                      child: smallCard(
                        "Open Loans",
                        value.openLoans.toString(),
                        Colors.orange,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: smallCard(
                        "Closed Loans",
                        value.closedLoans.toString(),
                        Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildStatusRow(FinanceProvider value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        statusCard("Open", value.openLoans, Colors.orange),
        statusCard("Closed", value.closedLoans, Colors.green),
      ],
    );
  }

  Widget statusCard(String title, int count, Color color) {
    return Container(
      width: 120,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            "$count",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// Widget buildGrid(FinanceProvider value) {
//   return GridView.count(
//     crossAxisCount: 2,
//     shrinkWrap: true,
//     physics: NeverScrollableScrollPhysics(),
//     crossAxisSpacing: 10,
//     mainAxisSpacing: 10,
//     children: [
//       dashboardCard("Total Given", value.totalGiven, Colors.blue),
//       dashboardCard("Received", value.totalRecieved, Colors.green),
//       dashboardCard("Pending", value.totalPending, Colors.orange),
//       dashboardCard("Loans", value.finance.length.toDouble(), Colors.purple),
//     ],
//   );
// }
