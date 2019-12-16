import 'package:over_react/over_react.dart';
import 'package:over_react/over_react_redux.dart';
import '../multiple_store.dart';

part 'multiple_store_counter.over_react.g.dart';

UiFactory<CounterProps> ConnectedCounter =
    connect<MultipleStoreCounterState, CounterProps>(
  mapStateToProps: (state) => (Counter()..currentCount = state.count),
  mapDispatchToProps: (dispatch) => (Counter()
    ..increment = () {
      dispatch(IncrementAction());
    }
    ..decrement = () {
      dispatch(DecrementAction());
    }),
)(Counter);

UiFactory<CounterProps> ConnectedCountWithDifferentContext =
    connect<MultipleStoreCounterState, CounterProps>(
  mapStateToProps: (state) => (Counter()..currentCount = state.count),
  mapDispatchToProps: (dispatch) => (Counter()
    ..increment = () {
      dispatch(IncrementAction());
    }
    ..decrement = () {
      dispatch(DecrementAction());
    }),
  context: bigCounterContext,
)(Counter);

@Factory()
UiFactory<CounterProps> Counter = _$Counter;

@Props()
class _$CounterProps extends UiProps {
  int currentCount;

  Map<String, dynamic> wrapperStyles;

  void Function() increment;

  void Function() decrement;
}

@Component2()
class CounterComponent extends UiComponent2<CounterProps> {
  @override
  ReactElement render() {
    return (Dom.div()..style = props.wrapperStyles)(
      Dom.div()('Count: ${props.currentCount}'),
      (Dom.button()
        ..onClick = (_) {
          if (props.increment != null) {
            props.increment();
          }
        })('+'),
      (Dom.button()
        ..onClick = (_) {
          if (props.decrement != null) {
            props.decrement();
          }
        })('-'),
      props.children,
    );
  }
}
