import 'package:flutter/material.dart';
// import '../screen/home_screen.dart';
import '../provider/finance_provider.dart';
import 'package:provider/provider.dart';
import '../screen/list_loan_screen.dart';
import '../widgets/ui_color.dart';
import '../screen/landing_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => FinanceProvider()..loadLoans(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: scaffoldcolor,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        cardTheme: CardThemeData(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(16),
          ),
        ),
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LandingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
