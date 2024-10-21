import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/auth/login/LoginBlocCubit.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/auth/login/LoginPage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/auth/passwordRecovery/PasswordRecoveryPage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/auth/register/RegisterBlocCubit.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/auth/register/RegisterPage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/owner/vehicles/AddCategoryPage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/owner/vehicles/AddVehiclePage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/owner/vehicles/EditCategoryPage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/owner/vehicles/VehiclesPage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/owner/vehicles/categories/bike/BikeCategoryPage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/owner/vehicles/categories/scooter/ScooterCategoryPage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/roles/RolesPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          // Rutas de autenticación
          '/login': (BuildContext context) => const LoginPage(),
          '/register': (BuildContext context) => BlocProvider(
            create: (context) => RegisterBlocCubit(),
            child: const RegisterPage(),
          ),
          '/password-recovery': (BuildContext context) => PasswordRecoveryPage(),

          // Rutas relacionadas con roles
          '/roles': (BuildContext context) => const RolesPage(),

          // Rutas para vehículos y categorías
          '/vehicles-owner': (BuildContext context) => VehiclesPage(),
          '/scooter-category': (BuildContext context) => ScooterCategoryPage(),
          '/bike-category': (BuildContext context) => BikeCategoryPage(),

          // Rutas para agregar y editar categorías
          '/add-vehicle': (BuildContext context) => AddVehiclePage(),

          // Aquí el 'EditCategoryPage' debe recibir una categoría
          '/edit-vehicle': (BuildContext context) => EditCategoryPage(
            category: ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>,
          ),

          '/add-category': (BuildContext context) => AddCategoryPage(),  // Página para agregar una categoría
        },
      ),
    );
  }
}