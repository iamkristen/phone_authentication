import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_authentication/cubit/auth_cubit.dart';
import 'package:phone_authentication/home.dart';

class OTPScreen extends StatelessWidget {
  OTPScreen({super.key});
  TextEditingController otpController = TextEditingController();
  int number = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Auth Demo"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return TextFormField(
                  controller: otpController,
                  keyboardType: TextInputType.phone,
                  maxLength: 6,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      label: const Text("6-digit OTP"),
                      counterText:
                          "6/${state is NumberChangedState ? state.number : 0}"),
                  onChanged: (value) {
                    BlocProvider.of<AuthCubit>(context)
                        .changeVerifyNumber(value);
                  },
                );
              },
            ),
            const SizedBox(
              height: 12,
            ),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is LoggedInState) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(
                          builder: (context) =>
                              HomeScreen(user: state.firebaseUser)));
                } else if (state is ErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage)));
                }
              },
              builder: (context, state) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  decoration: BoxDecoration(
                      shape: state is LoadingState
                          ? BoxShape.circle
                          : BoxShape.rectangle),
                  width: state is LoadingState
                      ? 50
                      : MediaQuery.of(context).size.width,
                  child: CupertinoButton(
                    padding: const EdgeInsets.all(6),
                    color: Colors.deepOrangeAccent,
                    onPressed: () {
                      BlocProvider.of<AuthCubit>(context)
                          .verifiedOtp(otpController.text);
                    },
                    child: state is LoadingState
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text("Verify"),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
