import 'package:redux/redux.dart';

class Action {
  final String type;
  final dynamic value;

  Action({this.type, this.value});
}

class SmallIncrementAction extends Action {
  SmallIncrementAction() : super(type: 'SMALL_INCREMENT_ACTION', value: 1);
}

class SmallDecrementAction extends Action {
  SmallDecrementAction() : super(type: 'SMALL_DECREMENT_ACTION', value: 1);
}

class BigIncrementAction extends Action {
  BigIncrementAction() : super(type: 'BIG_INCREMENT_ACTION', value: 100);
}

class BigDecrementAction extends Action {
  BigDecrementAction() : super(type: 'BIG_DECREMENT_ACTION', value: 100);
}

Store store = Store<CounterState>(stateReducer,
    initialState: CounterState.defaultState());

class CounterState {
  final int smallCount;
  final int bigCount;
  final String name;

  CounterState({
    this.smallCount,
    this.bigCount,
    this.name,
  });

  CounterState.defaultState(
      {this.smallCount = 1, this.bigCount = 100, this.name = 'Counter'});

  CounterState.updateState(CounterState oldState,
      {int smallCount, int bigCount, String name})
      : smallCount = smallCount ?? oldState.smallCount,
        bigCount = bigCount ?? oldState.bigCount,
        name = name ?? oldState.name;
}

int smallCountReducer(CounterState oldState, dynamic action) {
  if (action is SmallDecrementAction) {
    return oldState.smallCount - action.value;
  } else if (action is SmallIncrementAction) {
    return oldState.smallCount + action.value;
  } else {
    return oldState.smallCount;
  }
}

int bigCountReducer(CounterState oldState, dynamic action) {
  if (action is BigDecrementAction) {
    return oldState.bigCount - action.value;
  } else if (action is BigIncrementAction) {
    return oldState.bigCount + action.value;
  } else {
    return oldState.bigCount;
  }
}

String nameReducer(CounterState oldState, dynamic action) {
  return oldState.name;
}

CounterState stateReducer([CounterState state, action]) => CounterState(
      bigCount: bigCountReducer(state, action),
      smallCount: smallCountReducer(state, action),
      name: nameReducer(state, action),
    );
