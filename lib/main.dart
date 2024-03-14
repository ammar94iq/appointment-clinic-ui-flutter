import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'provider/auth/auth_provider.dart';
import 'provider/auth/personal_file.dart';
import 'provider/doctors/doctor_provider.dart';
import 'provider/users/users_provider.dart';
import 'screens/auth/login.dart';
import 'screens/doctors/doctor_home.dart';
import 'screens/users/user_home.dart';

late SharedPreferences sharedPre;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sharedPre = await SharedPreferences.getInstance();

  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => PersonalFileProvider()),
        ChangeNotifierProvider(create: (context) => DoctorsProvider()),
        ChangeNotifierProvider(create: (context) => UsersProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'نظام حجوزات العيادة الطبية',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          textTheme: const TextTheme(
            bodyMedium: TextStyle(fontFamily: 'Cairo-Regular'),
          ),
        ),
        locale: const Locale('ar'),
        home: sharedPre.getString("randomId") != null &&
                sharedPre.getString("userType") != null
            ? sharedPre.getString("userType") == "مستخدم"
                ? const UserHome()
                : const DoctorHome()
            : const Login(),
      ),
    );
  }
}
