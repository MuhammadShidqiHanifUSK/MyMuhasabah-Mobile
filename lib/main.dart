import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'providers/auth_provider.dart';
import 'providers/muhasabah_provider.dart';
import 'providers/tracker_provider.dart';
import 'screens/auth/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MuhasabahProvider()),
        ChangeNotifierProvider(create: (_) => TrackerProvider()),
      ],
      child: MaterialApp(
        title: 'MyMuhasabah',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF059669),
            primary: const Color(0xFF059669),
            secondary: const Color(0xFFF59E0B),
          ),
          textTheme: GoogleFonts.interTextTheme(),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF111827),
            elevation: 0,
            centerTitle: true,
          ),
          scaffoldBackgroundColor: const Color(0xFFF4F6F3),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}