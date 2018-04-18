import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';
import { Provider, connect } from 'react-redux';
import { Card, CardText, CardBody, Modal } from 'reactstrap';

import PostForm from './post-form';

export default function chat_init(store) {
  ReactDOM.render(
    <Provider store={store}>
      <Chat state={store.getState()} identity={store.identity} />
    </Provider>,
    document.getElementById('react-chat'),
  );
}


let Chat = connect((state) => state)((props) => {
  let posts = _.map(props.posts, (pp) => <Post key={pp.id} post={pp} />);
  let params = props.identity;

  return (
    <div>
     <PostForm params={params}/>
     &nbsp;
      <div>
        { posts }
      </div>
     &nbsp;
    </div>
  );
});


function Post(params) {
  let post = params.post;
  let time = convertTime(params.post.time);

  return (
   <div>
   <Card>
     <CardBody>
         <p> <b>{ post.username } : &nbsp; </b> { post.body } </p>
         <CardText>
           <small className="text-muted">Posted on { time } </small>
         </CardText>
     </CardBody>
   </Card>
   &nbsp;
   </div>);
}

function convertTime(time) {

    var res = time.split("T");

    var date = res[0].split("-");
    var time = res[1].split(":");

    var year = date[0].slice(-2);
    var month = date[1];
    var day = date[2];

    var hour = time[0];
    var min = time[1];

    res = day + " " + monthNumToName(month) + "'" + year +
          " at "+ hour + ":" + min

    return res;
}

var months = [
    'January', 'February', 'March', 'April', 'May',
    'June', 'July', 'August', 'September',
    'October', 'November', 'December'
    ];

function monthNumToName(monthnum) {
    return months[monthnum - 1] || '';
}
