import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';
import { Provider, connect } from 'react-redux';

export default function chat_init(store) {
  ReactDOM.render(
    <Provider store={store}>
      <Chat state={store.getState()} />
    </Provider>,
    document.getElementById('react-chat'),
  );
}


let Chat = connect((state) => state)((props) => {
  return ( <div> <p> React App running </p> </div> );
});
