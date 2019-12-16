import 'dart:html';

import 'package:over_react/over_react.dart';
import 'package:over_react/over_react_redux.dart';
import 'package:over_react/react_dom.dart' as react_dom;

import './components/counter.dart';
import './store.dart';

import './multiple_store_index.dart';

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
            Dom.h2()('ConnectedBigCounter'),
            ConnectedBigCounter()(),
            Dom.h2()('ConnectedCounter'),
            ConnectedCounter()(),
          ),
        ),
      ),
      querySelector('#content'));

  multiple_store_main();
}
