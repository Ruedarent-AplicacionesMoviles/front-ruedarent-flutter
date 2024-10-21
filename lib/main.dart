import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_ruedarent_flutter/src/data/models/user_model.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBlocCubit>(
          create: (context) => LoginBlocCubit(),
        ),
        BlocProvider<RegisterBlocCubit>(
          create: (context) => RegisterBlocCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/roles': (context) {
            final user = ModalRoute.of(context)!.settings.arguments as UserModel;
            return RolesPage(user: user);
          },
          '/password-recovery': (context) => PasswordRecoveryPage(),
          // Agrega otras rutas si es necesario...
        },
      ),
    );
  }
}
