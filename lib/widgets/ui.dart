import 'package:flutter/material.dart';

Widget appCard({required Widget child}) {
  return Card(
    elevation: 3,
    margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Padding(padding: const EdgeInsets.all(12), child: child),
  );
}

Widget actionButton(IconData icon, String text, VoidCallback onTap) {
  return ElevatedButton.icon(
    onPressed: onTap,
    icon: Icon(icon, size: 18),
    label: Text(text),
  );
}

Widget actionBtn(IconData icon, String text, Color color, VoidCallback onTap) {
  return ElevatedButton.icon(
    onPressed: onTap,
    icon: Icon(icon, size: 18, color: Colors.white),
    label: Text(text, style: TextStyle(color: Colors.white)),
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    ),
  );
}

Widget statusChip(String? status) {
  final isClosed = status == "CLOSED";

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: isClosed ? Colors.green.shade100 : Colors.orange.shade100,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      status ?? '',
      style: TextStyle(
        color: isClosed ? Colors.green : Colors.orange,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

// Widget dashboardCard(String title, double amount, Color color) {
//   return Container(
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(16),
//       gradient: LinearGradient(
//         colors: [color.withOpacity(0.7), color],
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//       ),
//     ),
//     child: Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Icon(Icons.account_balance_wallet, color: Colors.white),

//           Text(title, style: TextStyle(color: Colors.white70, fontSize: 14)),

//           Text(
//             "₹$amount",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

Widget dashboardCard(
  String title,
  String amount,
  List<Color> colors,
  IconData icon,
) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(18),
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: colors),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// TEXT
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.white70)),
            SizedBox(height: 6),
            Text(
              amount,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),

        /// ICON
        Icon(icon, color: Colors.white, size: 30),
      ],
    ),
  );
}

Widget smallCard(String title, String value, Color color) {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
      ],
    ),
    child: Column(
      children: [
        Text(title, style: TextStyle(color: Colors.grey)),
        SizedBox(height: 6),
        Text(
          value,
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

Widget buildField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  TextInputType keyboard = TextInputType.text,
  String? Function(String?)? validator,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboard,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}
