import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/profile/EditProfilePage.dart';
import 'package:provider/provider.dart';

import 'package:front_ruedarent_flutter/src/data/UserProvider.dart';
import 'package:front_ruedarent_flutter/src/data/models/user_model.dart';
import 'package:front_ruedarent_flutter/src/data/models/vehicle_model.dart';
import 'package:front_ruedarent_flutter/src/data/models/vehicle_type_model.dart';
import 'package:front_ruedarent_flutter/src/data/repositories/user_repository.dart';

import 'package:front_ruedarent_flutter/src/presentation/pages/NotificationsPage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/auth/login/LoginBlocCubit.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/auth/login/LoginPage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/auth/passwordRecovery/PasswordRecoveryPage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/auth/register/RegisterBlocCubit.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/auth/register/RegisterPage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/owner/vehicles/AddCategoryPage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/owner/vehicles/EditCategoryPage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/owner/vehicles/VehiclesPage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/owner/vehicles/vehicle/AddVehiclePage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/owner/vehicles/vehicle/EditVehiclePage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/profile/UserProfilePage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/renter/RentadorVehiclesPage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/renter/address/AddressSelectionPage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/reservation/ReservationPage.dart';
import 'package:front_ruedarent_flutter/src/presentation/pages/roles/RolesPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final userProvider = UserProvider();
  await userProvider.loadUserId();

  runApp(
    ChangeNotifierProvider.value(
      value: userProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return MultiProvider(
      providers: [
        Provider<UserRepository>(
          create: (_) => UserRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LoginBlocCubit>(
            create: (context) => LoginBlocCubit(
              context.read<UserRepository>(),
              context.read<UserProvider>(),
            ),
          ),
          BlocProvider<RegisterBlocCubit>(
            create: (_) => RegisterBlocCubit(),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          initialRoute: userProvider.isLoggedIn ? '/auto-redirect' : '/login',
          routes: {
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
            '/roles': (context) {
              final userId = Provider.of<UserProvider>(context, listen: false).userId;

              if (userId == null) {
                return const Scaffold(
                  body: Center(child: Text('Error: usuario no logueado')),
                );
              }

              // Obtiene el UserModel desde el backend usando el ID
              return FutureBuilder<UserModel?>(
                future: UserRepository().getUserById(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(body: Center(child: CircularProgressIndicator()));
                  } else if (snapshot.hasError || snapshot.data == null) {
                    return const Scaffold(body: Center(child: Text('Error al cargar usuario')));
                  } else {
                    return RolesPage(
                      user: snapshot.data!,
                      onLogout: () => handleLogout(context),
                    );
                  }
                },
              );
            },
            '/password-recovery': (context) => PasswordRecoveryPage(),
            '/vehicles-owner': (context) => const VehiclesPage(),
            '/notifications': (context) {
              final userProvider = Provider.of<UserProvider>(context, listen: false);

              // Validar si el usuario está logueado
              if (!userProvider.isLoggedIn || userProvider.userId == null) {
                return const Scaffold(
                  body: Center(child: Text('Error: Usuario no logueado')),
                );
              }

              return const NotificationsPage();
            },
            '/edit-profile': (context) {
              final user = ModalRoute.of(context)!.settings.arguments;
              if (user is UserModel) {
                return EditProfilePage(user: user);
              }
              return const Scaffold(body: Center(child: Text('Error: argumentos inválidos')));
            },
            '/add-vehicle': (context) {
              final args = ModalRoute.of(context)!.settings.arguments;
              if (args is Map<String, dynamic> && args.containsKey('vehicleTypeId')) {
                return AddVehiclePage(vehicleTypeId: args['vehicleTypeId'] as int);
              } else {
                return const Scaffold(body: Center(child: Text('Error: argumentos inválidos')));
              }
            },
            '/edit-vehicle': (context) {
              final vehicle = ModalRoute.of(context)!.settings.arguments;
              if (vehicle is VehicleModel) {
                return EditVehiclePage(vehicle: vehicle);
              } else {
                return const Scaffold(body: Center(child: Text('Error: argumentos inválidos')));
              }
            },
            '/edit-category-vehicle': (context) {
              final args = ModalRoute.of(context)!.settings.arguments;
              if (args is VehicleTypeModel) {
                return EditCategoryPage(vehicleType: args);
              } else {
                return const Scaffold(body: Center(child: Text('Error: argumentos inválidos')));
              }
            },
            '/reservations': (context) => ReservationPage(),
            '/add-category-vehicle': (context) => AddCategoryPage(),
            '/address-selection': (context) {
              final args = ModalRoute.of(context)!.settings.arguments;
              if (args is Map<String, dynamic> &&
                  args.containsKey('userId') &&
                  args.containsKey('vehicle')) {
                return AddressSelectionPage(
                  userId: args['userId'],
                  vehicle: args['vehicle'],
                );
              } else {
                return const Scaffold(body: Center(child: Text('Error: argumentos inválidos')));
              }
            },
            '/vehicles-renter': (context) => const RentadorVehiclesPage(),
            '/user-profile': (context) {
              final userId = ModalRoute.of(context)!.settings.arguments as int?;
              if (userId != null) {
                return UserProfilePage(userId: userId);
              } else {
                return const Scaffold(body: Center(child: Text('Error: User data is null')));
              }
            },
            '/auto-redirect': (context) {
              final userId = Provider.of<UserProvider>(context, listen: false).userId;

              return FutureBuilder<UserModel?>(
                future: UserRepository().getUserById(userId!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(body: Center(child: CircularProgressIndicator()));
                  } else if (snapshot.hasError || snapshot.data == null) {
                    return const Scaffold(body: Center(child: Text('Error al cargar usuario')));
                  } else {
                    // Redirige a /roles con el UserModel
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pushReplacementNamed(
                        context,
                        '/roles',
                        arguments: snapshot.data!,
                      );
                    });

                    return const Scaffold(); // Página vacía mientras redirige
                  }
                },
              );
            },
          },
        ),
      ),
    );
  }

  /// Función de logout global
  void handleLogout(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.clearUser();

    // Redirigir al login y eliminar historial de navegación
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}
