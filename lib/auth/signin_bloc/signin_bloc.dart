import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  SigninBloc() : super(SigninState.initial()) {
    on<SigninEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
