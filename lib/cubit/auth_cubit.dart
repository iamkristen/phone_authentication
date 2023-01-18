import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitialState()) {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      emit(LoggedInState(currentUser));
    } else {
      emit(LoggedOutState());
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;
  int _number = 0;
  int _verifyNumber = 0;

  void changeNumber(String number) {
    _number = number.length;
    emit(NumberChangedState(_number));
  }

  void changeVerifyNumber(String number) {
    _verifyNumber = number.length;
    emit(NumberChangedState(_verifyNumber));
  }

  void sendPhoneNumber(String phone) async {
    emit(LoadingState());
    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (authCredential) {
          signInWithPhone(authCredential);
        },
        verificationFailed: (error) {
          emit(ErrorState(error.message.toString()));
        },
        codeSent: (verificationId, token) {
          _verificationId = verificationId;
          emit(PhoneSubmitState());
        },
        codeAutoRetrievalTimeout: (verificationId) {
          _verificationId = verificationId;
        });
  }

  void verifiedOtp(String code) async {
    emit(LoadingState());
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!, smsCode: code);
    signInWithPhone(credential);
  }

  void signInWithPhone(AuthCredential credential) async {
    try {
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        emit(LoggedInState(userCredential.user!));
      }
    } on FirebaseAuthException catch (error) {
      emit(ErrorState(error.message.toString()));
    }
  }

  void logout() async {
    emit(LoadingState());
    await _auth.signOut();
    emit(LoggedOutState());
  }
}
