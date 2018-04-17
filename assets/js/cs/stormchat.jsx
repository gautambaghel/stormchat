import React from 'react';
import ReactDOM from 'react-dom';
import { Provider, connect } from 'react-redux';

export default function stormchat_init(store) {
  ReactDOM.render(
    <Provider store={store}>
      <Stormchat state={store.getState()} />
    </Provider>,
    document.getElementById('root')
  );
}

class Stormchat extends React.Component {
  
}
