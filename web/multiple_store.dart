import 'package:redux/redux.dart';

// Imports for Context.
import 'package:over_react/over_react.dart';

class Action {
  final String type;
  final dynamic value;

  Action({this.type, this.value});
}

class IncrementAction extends Action {
  IncrementAction([value]) : super(type: 'INCREMENT', value: value);
}

class DecrementAction extends Action {
  DecrementAction([value]) : super(type: 'DECREMENT', value: value);
}

class MultipleStoreCounterState {
  final int count;
  final String name;

  MultipleStoreCounterState({this.count, this.name});

  MultipleStoreCounterState.defaultState(
      {this.count = 1, this.name = 'Counter'});

  MultipleStoreCounterState.updateState(MultipleStoreCounterState oldState,
      {int count, String name})
      : count = count ?? oldState.count,
        name = name ?? oldState.name;
}

MultipleStoreCounterState smallCountReducer(
    MultipleStoreCounterState oldState, dynamic action) {
  if (action is DecrementAction) {
    return MultipleStoreCounterState.updateState(oldState,
        count: oldState.count - 1);
  } else if (action is IncrementAction) {
    return MultipleStoreCounterState.updateState(oldState,
        count: oldState.count + 1);
  } else {
    return oldState;
  }
}

Store store1 = Store<MultipleStoreCounterState>(smallCountReducer,
    initialState: MultipleStoreCounterState.defaultState());

Store store2 = Store<MultipleStoreCounterState>(smallCountReducer,
    initialState: MultipleStoreCounterState.defaultState());

final bigCounterContext = createContext();
