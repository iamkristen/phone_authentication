import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_authentication/cubit/auth_cubit.dart';
import 'package:phone_authentication/login.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Welcome"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome to the HomePage ${user.uid.substring(1, 9)}"),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is LoggedOutState) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushReplacement(context,
                      CupertinoPageRoute(builder: (context) => LoginPage()));
                }
              },
              builder: (context, state) {
                if (state is LoadingState) {
                  return const CircularProgressIndicator(
                    color: Colors.deepOrangeAccent,
                  );
                }
                return CupertinoButton(
                    child: const Text("Logout"),
                    onPressed: () {
                      BlocProvider.of<AuthCubit>(context).logout();
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}
