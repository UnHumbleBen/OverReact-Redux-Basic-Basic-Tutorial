# Simple Counter
An beginner's tutorial to using React and Redux with Dart.

## Getting Started
We use stagehand template to begin.
```bash
mkdir simple-counter
cd simple-counter
stagehand web-simple
pub get
```

Run the app with
```bash
webdev serve
```

## Redux: Installation
Add the `redux` package as a dependency to `pubspec.yaml`

```yaml
dependencies:
  redux: '>=3.0.0'
```

## Redux: Action
First, let's define some actions.

**Actions** are payloads of information that send data from your application
to your store.
They are the only source of information for the store.
You can send them to the store using `dispatch`.

Create a new file `web/store.dart` and make an `Action` class.

```dart
class Action {
  final String type;
  final dynamic value;

  Action({this.type, this.value});
}
```

Here's an example action which represents incrementing a button.
```dart
class SmallIncrementAction extends Action {
  SmallIncrementAction() : super(type: 'SMALL_INCREMENT_ACTION', value: 1);
}
```

Actions are Dart classes.
Actions optionally have a type property that indicates the type of
action being performed.
(Note that Redux JS requires the type property.
This is optional in Dart because Dart is already a typed language)

We'll add more action types to allow for the button to decrement
as well as increment/decrement in different amounts

```dart
class SmallDecrementAction extends Action {
  SmallDecrementAction() : super(type: 'SMALL_DECREMENT_ACTION', value: 1);
}

class BigIncrementAction extends Action {
  BigIncrementAction() : super(type: 'BIG_INCREMENT_ACTION', value: 100);
}

class BigDecrementAction extends Action {
  BigDecrementAction() : super(type: 'BIG_DECREMENT_ACTION', value: 100);
}
```

Note that while Redux JS requires action creators, in Dart, class constructors are the action creators.

## Redux: Reducers
**Reducers** specify how the application's state changes in response to [actions](#redux:-action) sent to the store.
Remember that actions only describe *what happened*, but don't describe how the application's state changes.

### Designing the State Shape
In Redux, all the application state is stored as a single object.
It's a good idea to think of its shape before writing any code.
What is the minimal representation of your app's state as an object?

For our counter app, we want to store three different things.

* The count for the small counter.
* The count for the big counter.
* The name of the counter.

```dart
class CounterState {
  final int smallCount;
  final int bigCount;
  final String name;
}
```

We add a constructor
```dart
  CounterState({
    this.smallCount,
    this.bigCount,
    this.name,
  });
```

Notice the usage of [optional named parameters](https://dart.dev/guides/language/language-tour#named-parameters).

We also create a default state [named constructor](https://dart.dev/guides/language/language-tour#named-constructors), which is useful for creating the initial or resetting the state to default (if needed).

```dart
  CounterState.defaultState(
      {this.smallCount = 1, this.bigCount = 100, this.name = 'Counter'});
```

Because Redux is pure and does not allow direct
state mutations, a constructor that defaults to
setting properties to the old state allows for
DRYer code in the reducers.

```dart
  CounterState.updateState(CounterState oldState,
      {int smallCount, int bigCount, String name})
      : smallCount = smallCount ?? oldState.smallCount,
        bigCount = bigCount ?? oldState.bigCount,
        name = name ?? oldState.name;
```

Using the `??` operator, if a field needs to be updated, then
it will be non-null, otherwise, it will be null, so the oldState's
field is used.

Personal Change Note: I removed `this` in front of the fields in the initializer
list of this function in order to statisfy [unncecessary_this lint rule](https://dart-lang.github.io/linter/lints/unnecessary_this.html)

### Handling Actions

Now that we've decided what our state object looks like, we're ready to write a reducer for it.
The reducer is a pure function that takes the previous state and
an action, and returns the next state.

```dart
  /// Sample signiture, do not add to code yet.
  CounterState stateReducer([CounterState state, action]);
```

Note the usage of [positional parameters](https://dart.dev/guides/language/language-tour#positional-parameters). This means that
when 

It's called a reducer because it's the type of function you would
would pass to [Array.prototype.reduce(reducer, ?initialValue)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/Reduce).
It's very important that reducer stays pure.
Things you should **never** do inside a reducer:

* Mutate its arguments;
* Perform side effects like API calls and routing transitions;
* Call non-pure functions, e.g. `DateTime.now()` and `Random()` 
  * These functions violates the requirement that a pure function
must return the same value for the same arguments.

Let's start writing our reducer by gradually teaching it to understand
the [actions](#Actions) we defined earlier.

```dart
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
```

Personal Change Note: I added `nameReducer` for more consistency

Redux provides a method called `combineReducers` to facilitate this,
but for simplicity, we avoid using that method here.

## Redux: Store
In the previous sections, we defined the [actions](#redux:-action)
that represent the facts about "what happened" and the
[reducers](#redux:-reducers) that update the state according
to those actions.

The **Store** is the object that brings them together. The store
has the following responsbilities:

* Holds application state;
* Allows access to state;
* Allows state to be updated;
* Registers listeners;
* Handles unregistering of listeners;

It's important to note that you'll only have a single store in
a Redux application. When you want to split your data handling
logic, you'll use a reducer composition instead of many stores.

It's easy to create a store if you have a reducer.

```dart
import 'package:redux/redux.dart';

// -- rest of the code --

Store store = Store<CounterState>(stateReducer,
    initialState: CounterState.defaultState());
```

We are now done with `web/store.dart`.

## Usage with OverReact
From the very beginning, we need to stress that Redux has no
relation to React. You can write Redux apps with React,
Angular, or plain Dart.

That said, Redux works especially well with libraries like
[OverReact](https://github.com/Workiva/over_react/tree/master)
because they let you describe UI as a function of state,
and Redux emits state updates in response to actions.

We will use OverReact to build our simple counter app, and cover
the basics of how to use OverReact with Redux.
Add OverReact to `pubspec.yaml`.

### Installing OverReact

OverReact is not included in Reduxc by default. You need to install
them explicitly: Add this to `pub_spec.yaml`

```yaml
dependencies:
  over_react: ^3.1.0
```

Note, we need at least version 3.1.0 to use [UiComponent2](https://github.com/Workiva/over_react/blob/CPLAT-6104_over_react_redux_example_app/doc/ui_component2_transition.md)

### Designing Components
I see the following presentational components and their props
from this brief:
* `ConnectedCounter` is a single counter.
* `ConnectedBigCounter` is a single big counter.
* `Counter` is the component that both counters implement.
  * `int currentCount` is the number to show.
  * `Map<String, dynamic> wrapperStyles` is the styles to add.
  * `Function() increment` is a callback to invoke when increment
  is clicked
  * `Function() decrement` is a callback to invoke when decrement
  is clicked

### Implementing Components
Make a `web/components/` directory and in it, counter component
in `web/components/counter.dart`.

```dart
import 'package:over_react/over_react.dart';

part 'counter.over_react.g.dart';

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
  render() {
    // TODO: implement render
    return null;
  }
}
```

Run `webdev serve` so that OverReact's builder runs and generates
the boilerplate code. (Refresh your IDE if needed so that static
analysis works as needed).

We now implement the `render` function
```dart
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
```

Personal Change Note: added return type to `render` to fix
[dart(always_declare_return_types)](https://dart-lang.github.io/linter/lints/always_declare_return_types.html)

### Implementing Redux Components
OverReact includes a wrapper around React Redux. We will use
it along with our store to implement `ConnectedCounter` and
`ConnectedBigCounter`.

Add these imports to the top of `counter.dart`
```dart
import 'package:over_react/over_react_redux.dart';
import '../store.dart';
```

You could write these components by hand, but we suggest instead
generating these components with OverReact Redux library's
[`connect`](https://github.com/Workiva/over_react/blob/master/doc/over_react_redux_documentation.md#connect) function, which provides
many useful optimizations to prevent unnecessary re-renders.

To use `connect()`, you will need to define a special function
`mapStateToProps` that describes how to transform the current
Redux store state into the props you want to pass to the
component you are wrapping. For example, `ConnectedCounter` needs
to calculate `currentCount`, so we need to define a function
that returns the `state.smallCount`.

```dart
  // Do not write this yet. Just an example.
  mapStateToProps: (state) =>
      (Counter()..currentCount = state.smallCount)
```

In addition to reading the state, container components can
dispatch actions. In a similar fashion, you can define a function
called `mapDispatchToProps` that recieves the [`dispatch`](https://pub.dev/documentation/redux/latest/redux/Store/dispatch.html) method
and returns callback props that you want to inject into the
component. For example, we want the `ConnectedBigCounter` to
inject a prop called `increment` and `decrement` into the
`Counter` component, and we want `increment` to dispatch
a `BigIncrementAction` and `decrement` to dispatch a
`BigDecrementAction`.

```dart
  // Do not write this yet. Just an example.
  mapDispatchToProps: (dispatch) => (Counter()
    ..increment = () {
      dispatch(BigIncrementAction());
    }
    ..decrement = () {
      dispatch(BigDecrementAction());
    }),
```

Finally, we create the `ConnectedCounter` and `ConnectedBigCounter`
components by calling `connect` and passing the appropriate
functions:

```dart
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
```

Personal Change Note: I removed the hacky placement of
`SmallIncrementAction` for better consistency. Admittingly, this
prevents me from showcasing `ConnectPropsMixin`, but it does not
seem useful in this example.

These are the basics of the OverReact Redux API, but there are
a few shortcuts and power options so we encourage you to check
out [its documentation](https://github.com/Workiva/over_react/blob/master/doc/over_react_redux_documentation.md#connect) in detail.

## Passing the Store
All container components need access to the Redux store so they
can subscribe to it. One option would be to pass it as a
prop to every container component. However it gets tedious
to wire `store` even through components just because they
happen to render deep in the component tree.

The option we recommend is to use a special React Redux component
called [`ReduxProvider`](https://github.com/Workiva/over_react/blob/master/doc/over_react_redux_documentation.md#reduxprovider) to magically make the store availiable
to all components in the applications wihtout passing it
explicitly. You only need to use it once when you render the root
component:

`web/index.dart`
```dart
import 'dart:html';

import 'package:over_react/over_react.dart';
import 'package:over_react/over_react_redux.dart';
import 'package:over_react/react_dom.dart' as react_dom;

import './components/counter.dart';
import './store.dart';

void main() {
  setClientConfiguration();

  react_dom.render(
      (ReduxProvider()..store = store)(
        (Dom.div()
          ..style = {
            'display': 'flex',
            'flexDirection': 'row',
            'justifyContent': 'space-evenly'
          })(
          (Dom.div())(
            Dom.h2()('ConnectedBigCounter'),
            ConnectedBigCounter()(),
            Dom.h2()('ConnectedCounter'),
            ConnectedCounter()(),
          ),
          (Dom.div())(
            Dom.h2()('ConnectedBigCOunter'),
            ConnectedBigCounter()(),
            Dom.h2()('ConnectedCounter'),
            ConnectedCounter()(),
          ),
        ),
      ),
      querySelector('#content'));
}
```

Personal Change Note: Removed import of `react_client.dart` which
is shadowed by `over_react.dart`. Removed `ErrorBoundary`, which
is I did not think is too important for a beginner tutorial.

## Finishing Touches
Remove `main.dart` and the corresponding script tag from `index.html`.
Add React libraries and `index.dart`:

```html
<!DOCTYPE html>

<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="scaffolded-by" content="https://github.com/dart-lang/stagehand">
    <title>simple_counter</title>
    <link rel="stylesheet" href="styles.css">
    <link rel="icon" href="favicon.ico">
</head>

<body>

  <div id="content"></div>

  <script src="packages/react/react.js"></script>
  <script src="packages/react/react_dom.js"></script>

  <script defer src="index.dart.js"></script>  

</body>
</html>
```

## Next Steps
And we're done! We now have a working counter application!

Check out a [full-featured example application](https://github.com/Workiva/over_react/pull/439) that showcases
what Redux and OverReact can do!

## Disclaimer
This tutorial is based **heavily** on the official [Redux documentation](https://redux.js.org/) as well as [OverReact
simple example](https://github.com/Workiva/over_react/tree/master/web/over_react_redux/examples/simple).
I copied and paste much of the information and do not claim any credit. This tutorial is for the viewer's (probably just me)
convenience.
