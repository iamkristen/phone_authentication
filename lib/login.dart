import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_authentication/cubit/auth_cubit.dart';
import 'package:phone_authentication/verify_phone.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  TextEditingController phoneController = TextEditingController();

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
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      label: const Text("Phone number"),
                      counterText:
                          "10/${state is NumberChangedState ? state.number : 0}"),
                  onChanged: (value) {
                    BlocProvider.of<AuthCubit>(context).changeNumber(value);
                  },
                );
              },
            ),
            const SizedBox(
              height: 12,
            ),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is PhoneSubmitState) {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => OTPScreen()));
                } else if (state is ErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage)));
                }
              },
              builder: (context, state) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: state is LoadingState
                      ? 50
                      : MediaQuery.of(context).size.width,
                  child: CupertinoButton(
                    padding: const EdgeInsets.all(6),
                    color: Colors.deepOrangeAccent,
                    onPressed: () {
                      String phoneNumber = "+44${phoneController.text}";
                      BlocProvider.of<AuthCubit>(context)
                          .sendPhoneNumber(phoneNumber);
                    },
                    child: state is LoadingState
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text("SignIn"),
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
