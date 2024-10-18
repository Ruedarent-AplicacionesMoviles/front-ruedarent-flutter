import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/auth/login/LoginBlocCubit.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/auth/login/LoginPage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/auth/register/RegisterBlocCubit.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/auth/register/RegisterPage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/roles/RolesPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBlocCubit(),
      child: MaterialApp(
        builder: FToastBuilder(),
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/login',
        routes: {
          // '/': (context) => const MyHomePage(title: 'Flutter Demo Home Page'),
          '/login': (BuildContext context) => const LoginPage(),
          '/register': (BuildContext context) => BlocProvider(
              create: (context) =>
                  RegisterBlocCubit(),
              child: const RegisterPage()
          ),
          '/roles': (BuildContext context) => const RolesPage(),
        },
      ),
    );
  }
}
