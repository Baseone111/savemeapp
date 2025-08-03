import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trafficking_detector/core/commons/cubits/app_user/app_user_cubit.dart';
import 'package:trafficking_detector/core/network/connection.dart';
import 'package:trafficking_detector/core/theme/theme.dart';

import 'package:trafficking_detector/screens/alert_screen.dart';
import 'package:trafficking_detector/screens/authScreens/data/datasources/auth_remote_datasource.dart';
import 'package:trafficking_detector/screens/authScreens/data/repositories/auth_repository_impl.dart';
import 'package:trafficking_detector/screens/authScreens/domain/usecase/current_user.dart';
import 'package:trafficking_detector/screens/authScreens/domain/usecase/user_login.dart';
import 'package:trafficking_detector/screens/authScreens/domain/usecase/user_signup.dart';
import 'package:trafficking_detector/screens/authScreens/signUp.dart';
import 'package:trafficking_detector/screens/bloc/auth_bloc.dart';
import 'package:trafficking_detector/screens/bloc/repot_bloc.dart';
import 'package:trafficking_detector/screens/emmergency_screen.dart';
import 'dart:io';
import 'dart:async';

import 'package:trafficking_detector/screens/main_screen.dart';
import 'package:trafficking_detector/screens/missingperson_screen.dart';
import 'package:trafficking_detector/screens/registration_screen.dart';
import 'package:trafficking_detector/screens/report_screen.dart';
import 'package:trafficking_detector/screens/resources_screen.dart';
import 'package:trafficking_detector/screens/settings_screen.dart';
import 'package:trafficking_detector/screens/splash_screen.dart';

// Add this import for your report repository
import 'package:trafficking_detector/models/services/repositories/reportRepository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: "https://kwdgndvthynlaoxcrslw.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt3ZGduZHZ0aHlubGFveGNyc2x3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI2NzczNzIsImV4cCI6MjA2ODI1MzM3Mn0.Q4R5I-iOHYG__TNrm4pSoPxGYq6nfTrXKGuhPWrDg04");
  final appUserCubit = AppUserCubit();
  final supabaseClient = Supabase.instance.client;

  final internetConnection = InternetConnection();
  final connectionChecker = ConnectionCheckerImpl(internetConnection);

  final authRepository = AuthRepositoryImpl(
    AuthRemoteDataSourceImpl(supabaseClient),
    connectionChecker,
  );

  // Create the report repository instance
  final reportRepository = ReportRepositoryImpl(supabaseClient);

  //runApp(SafeGuardApp());

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            userSignUp: UserSignUp(authRepository), // provide your real usecase
            userLogin: UserLogin(authRepository), // provide your real usecase
            currentUser:
                CurrentUser(authRepository), // provide your real usecase
            appUserCubit: appUserCubit,
          ),
        ),
        BlocProvider(create: (_) => appUserCubit),
        BlocProvider(
          create: (_) => ReportBloc(
            reportRepository: reportRepository,
            supabaseClient: supabaseClient,
          ),
        ),
      ],
      child: SafeGuardApp(),
    ),
  );
}

class SafeGuardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FootPrintToFreedom',
      theme: AppTheme.darkThemeMode,
      //home: SplashScreen(),

      home: SignUpPage(),

      routes: {
        '/report': (context) => ReportScreen(),
        '/emergency': (context) => EmergencyScreen(),
        '/missing': (context) => MissingPersonScreen(),
        '/alerts': (context) => AlertsScreen(),
        '/resources': (context) => ResourcesScreen(),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}
