import 'package:classbridge/firebase_options.dart';
import 'package:classbridge/viewmodels/data_viewmodel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:classbridge/constants/color_const.dart';
import 'package:classbridge/views/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FetchData()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Gilroy',
          colorScheme: ColorScheme.fromSeed(seedColor: primaryBlueCustomColor),
          useMaterial3: true,
        ),
        home: SplashScreen(
          bifurcation: false,
        ),
      ),
    );
  }
}
