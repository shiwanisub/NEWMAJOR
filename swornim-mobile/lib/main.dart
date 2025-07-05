import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swornim/pages/Client/ClientDashboard.dart';
import 'package:swornim/pages/auth/login.dart';
// import 'package:swornim/pages/introduction/userhomepage.dart';
import 'package:swornim/pages/introduction/welcome_screen.dart';

import 'package:swornim/pages/widgets/auth/auth_lifecycle_handler.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AuthLifecycleHandler(
      child: MaterialApp(
        title: 'Swornim',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFFAFAFA), // neutral light gray

          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2563EB), // professional blue seed
            brightness: Brightness.light,
            primary: const Color(0xFF2563EB), // professional blue
            secondary: const Color(0xFF64748B), // slate gray
            tertiary: const Color(0xFF0F172A), // dark slate
            surface: Colors.white,
            background: const Color(0xFFFAFAFA), // light neutral background
            error: const Color(0xFFDC2626), // professional red
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: const Color(0xFF1E293B), // dark slate text
            onBackground: const Color(0xFF1E293B),
          ),

          textTheme: TextTheme(
            displayLarge: GoogleFonts.inter(
              textStyle: const TextStyle(
                color: Color(0xFF0F172A), // very dark slate
                fontSize: 32,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            displayMedium: GoogleFonts.inter(
              textStyle: const TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 28,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
              ),
            ),
            headlineLarge: GoogleFonts.inter(
              textStyle: const TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 24,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
            ),
            headlineMedium: GoogleFonts.inter(
              textStyle: const TextStyle(
                color: Color(0xFF0F172A),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            headlineSmall: GoogleFonts.inter(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            titleLarge: GoogleFonts.inter(
              textStyle: const TextStyle(
                color: Color(0xFF334155),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            titleMedium: GoogleFonts.inter(
              textStyle: const TextStyle(
                color: Color(0xFF475569),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            titleSmall: GoogleFonts.inter(
              textStyle: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            bodyLarge: GoogleFonts.inter(
              textStyle: const TextStyle(
                color: Color(0xFF334155),
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
            bodyMedium: GoogleFonts.inter(
              textStyle: const TextStyle(
                color: Color(0xFF475569),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
            bodySmall: GoogleFonts.inter(
              textStyle: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
            labelLarge: GoogleFonts.inter(
              textStyle: const TextStyle(
                color: Color(0xFF334155),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
              ),
            ),
            labelMedium: GoogleFonts.inter(
              textStyle: const TextStyle(
                color: Color(0xFF475569),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
              ),
            ),
          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB), // professional blue
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
              shadowColor: const Color(0xFF2563EB).withOpacity(0.25),
              textStyle: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),

          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF2563EB), // professional blue
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: const BorderSide(
                color: Color(0xFF2563EB),
                width: 1.5,
              ),
              textStyle: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2563EB),
              ),
            ),
          ),

          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF2563EB),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              textStyle: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2563EB),
              ),
            ),
          ),

          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF1E293B),
            elevation: 0,
            centerTitle: true,
            titleTextStyle: GoogleFonts.inter(
              color: const Color(0xFF1E293B),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            iconTheme: const IconThemeData(
              color: Color(0xFF475569),
              size: 24,
            ),
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
            ),
          ),

          cardTheme: CardTheme(
            elevation: 2,
            shadowColor: Colors.black.withOpacity(0.08),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(
                color: Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            color: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),

          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF2563EB),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFDC2626),
                width: 1,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            hintStyle: GoogleFonts.inter(
              color: const Color(0xFF94A3B8),
              fontSize: 14,
            ),
            labelStyle: GoogleFonts.inter(
              color: const Color(0xFF64748B),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          iconTheme: const IconThemeData(
            color: Color(0xFF64748B),
            size: 24,
          ),

          dividerTheme: const DividerThemeData(
            color: Color(0xFFE2E8F0),
            thickness: 1,
            space: 16,
          ),

          chipTheme: ChipThemeData(
            backgroundColor: const Color(0xFFF1F5F9),
            labelStyle: GoogleFonts.inter(
              color: const Color(0xFF475569),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            elevation: 0,
            pressElevation: 1,
          ),

          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: Color(0xFF2563EB),
            unselectedItemColor: Color(0xFF94A3B8),
            elevation: 8,
            type: BottomNavigationBarType.fixed,
          ),

          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF2563EB),
            foregroundColor: Colors.white,
            elevation: 4,
            shape: CircleBorder(),
          ),
        ),

        // home: const PhotographerDashboard(),
        // home: const ClientDashboard(),
        // home: const WelcomeScreen(),
        home: LoginPage(onSignupClicked: () {  },)
      ),
    );
  }
}