import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';
import { Provider, connect } from 'react-redux';

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
     <table className="table">
      <thead>
       <tr>
        <th>Username</th>
        <th>Post</th>
      </tr>
    </thead>
    <tbody>
    { posts }
     </tbody>
    </table>
   </div>
  );
});


function Post(params) {
  let post = params.post;
  return (
    <tr>
        <td>{ post.username }</td>
        <td>{ post.body }</td>
    </tr>
  );
}
