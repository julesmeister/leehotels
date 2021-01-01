import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lotel/Dashboard/Dashboard.dart';
import 'package:lotel/Dashboard/WelcomeOnly.dart';
import 'package:lotel/GuestEditingSpace/GuestEditingSpace.dart';
import 'package:lotel/Login/UserRepository.dart';
import 'package:lotel/NavigationBar/NavigationBar.dart';
import 'package:lotel/blocs/navigation_bloc/navigation_bloc.dart';
import 'package:velocity_x/velocity_x.dart';

import 'Login/Login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationBloc>(
            create: (BuildContext context) => NavigationBloc(UserRepository())),
      ],
      child: GetMaterialApp(
        opaqueRoute: false,
        title: "Lotel",
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.quicksandTextTheme(),
          scaffoldBackgroundColor: Colors.transparent,
        ),
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, state) {
            return Scaffold(
              body: Stack(
                children: [
                  NavigationBar(),
                  if (state.main == MainSpace.dashboard)
                    DashBoard()
                  else if (state.main == MainSpace.welcome)
                    WelcomeOnly(),
                  if (state.editing == EditingSpace.newGuest ||
                      state.editing == EditingSpace.editGuest)
                    GuestEditingSpace()
                  else if (EditingSpace.login == state.editing)
                    Login(),
                ],
              ).wh(Get.width, Get.height),
            );
          },
        ),
      ),
    );
  }
}
