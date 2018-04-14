import { createStore, combineReducers } from 'redux';
import deepFreeze from 'deep-freeze';

/*
 *  state layout:
 *  {
 *   posts: [... Posts ...],
 * }
 *
 * */

 function posts(state = [], action) {
  switch (action.type) {
  case 'POSTS_LIST':
    return [...action.posts];
  case 'ADD_POSTS':
    return [action.post, ...state];
  default:
    return state;
  }
}

function root_reducer(state0, action) {
  // {posts: posts}
  let reducer = combineReducers({posts});
  let state1 = reducer(state0, action);
  return deepFreeze(state1);
};

let store = createStore(root_reducer);
export default store;
