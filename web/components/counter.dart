import 'package:over_react/over_react.dart';
import 'package:over_react/over_react_redux.dart';
import '../store.dart';

part 'counter.over_react.g.dart';

UiFactory<CounterProps> ConnectedCounter = connect<CounterState, CounterProps>(
  mapStateToProps: (state) => (Counter()..currentCount = state.smallCount),
  mapDispatchToProps: (dispatch) => (Counter()
    ..increment = () {
      dispatch(SmallIncrementAction());
    }
    ..decrement = () {
      dispatch(SmallDecrementAction());
    }),
)(Counter);

UiFactory<CounterProps> ConnectedBigCounter =
    connect<CounterState, CounterProps>(
  mapStateToProps: (state) => (Counter()..currentCount = state.bigCount),
  mapDispatchToProps: (dispatch) => (Counter()
    ..increment = () {
      dispatch(BigIncrementAction());
    }
    ..decrement = () {
      dispatch(BigDecrementAction());
    }),
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
