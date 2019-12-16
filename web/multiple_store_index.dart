import 'dart:html';

import 'package:over_react/over_react.dart';
import 'package:over_react/over_react_redux.dart';
import 'package:react/react_dom.dart' as react_dom;

import 'components/multiple_store_counter.dart';
import 'multiple_store.dart';

void multiple_store_main() {
  setClientConfiguration();

  react_dom.render(
      (ReduxProvider()..store = store1)(
        (ReduxProvider()
          ..store = store2
          ..context = bigCounterContext)(
          Dom.div()(
            Dom.h2()('ConnectedCounter Store1'),
            ConnectedCounter()(),
            Dom.h2()('ConnetedCounter Store2'),
            ConnectedCountWithDifferentContext()(),
          ),
        ),
      ),
      querySelector('#multiple-stores-content'));
}
