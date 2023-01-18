import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_authentication/cubit/auth_cubit.dart';
import 'package:phone_authentication/home.dart';
import 'package:phone_authentication/login.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Auth Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        home: BlocBuilder<AuthCubit, AuthState>(
          buildWhen: (previous, current) {
            return previous is AuthInitialState;
          },
          builder: (context, state) {
            if (state is LoggedInState) {
              return HomeScreen(
                user: state.firebaseUser,
              );
            } else {
              return LoginPage();
            }
          },
        ),
      ),
    );
  }
}
