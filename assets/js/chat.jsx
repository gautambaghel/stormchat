import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

export default function chat_init(root) {
  ReactDOM.render(<Chat/>, root);
}


class Chat extends React.Component {
  constructor(props) {
    super(props);
    this.state = {}
  }

  render() {
    return (
     <div> <p> React App running </p> </div>
    );
   }

 }
