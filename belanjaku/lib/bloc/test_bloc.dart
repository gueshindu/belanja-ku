import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class BlocCounterState {
  final int value;

  const BlocCounterState(this.value);
}

class BlocCounterStateValid extends BlocCounterState {
  const BlocCounterStateValid(int value) : super(value);
}

class BlocCounterStateInvalid extends BlocCounterState {
  final String invalidValue;

  const BlocCounterStateInvalid(
      {required this.invalidValue, required int prevValue})
      : super(prevValue);
}

@immutable
abstract class BlocCounterEvent {
  final String value;

  const BlocCounterEvent(this.value);
}

class BlocIncrementEvent extends BlocCounterEvent {
  const BlocIncrementEvent(String val) : super(val);
}

class BlocDecrementEvent extends BlocCounterEvent {
  const BlocDecrementEvent(String val) : super(val);
}

class CounterBloc extends Bloc<BlocCounterEvent, BlocCounterState> {
  CounterBloc() : super(const BlocCounterStateValid(0)) {
    on<BlocIncrementEvent>(
      (event, emit) {
        final integer = int.tryParse(event.value);
        if (integer != null) {
          emit(BlocCounterStateValid(state.value + integer));
        } else {
          emit(BlocCounterStateInvalid(
              invalidValue: event.value, prevValue: state.value));
        }
      },
    );

    on<BlocDecrementEvent>(
      (event, emit) {
        final integer = int.tryParse(event.value);
        if (integer != null) {
          emit(BlocCounterStateValid(state.value - integer));
        } else {
          emit(BlocCounterStateInvalid(
              invalidValue: event.value, prevValue: state.value));
        }
      },
    );
  }
}
