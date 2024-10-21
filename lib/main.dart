// main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/user_repository.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/auth/login/LoginBlocCubit.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/auth/login/LoginPage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/auth/passwordRecovery/PasswordRecoveryPage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/auth/register/RegisterBlocCubit.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/auth/register/RegisterPage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/roles/RolesPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Proveer el UserRepository a toda la aplicación
    return RepositoryProvider(
      create: (context) => UserRepository(),
      child: MultiBlocProvider(
        providers: [
          // Proveer el LoginBlocCubit
          BlocProvider<LoginBlocCubit>(
            create: (context) => LoginBlocCubit(context.read<UserRepository>()),
          ),
          // Proveer el RegisterBlocCubit
          BlocProvider<RegisterBlocCubit>(
            create: (context) => RegisterBlocCubit(context.read<UserRepository>()),
          ),
        ],
        child: MaterialApp(
          builder: FToastBuilder(),
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            useMaterial3: true,
          ),
          initialRoute: '/login',
          routes: {
            // Rutas de autenticación
            '/login': (BuildContext context) => const LoginPage(),
            '/register': (BuildContext context) => const RegisterPage(),
            '/password-recovery': (BuildContext context) => PasswordRecoveryPage(),

            // Rutas relacionadas con roles
            '/roles': (BuildContext context) => const RolesPage(),
          },
        ),
      ),
    );
  }
}
