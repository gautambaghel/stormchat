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
  case 'ADD_POST':
    return [action.post, ...state];
  default:
    return state;
  }
}


let empty_form = {
  user_id: "",
  body: "",
  alert: "",
};

function form(state = empty_form, action) {
  switch (action.type) {
    case 'UPDATE_FORM':
      return Object.assign({}, state, action.data);
    case 'CLEAR_FORM':
      return empty_form;
    default:
      return state;
  }
}

function root_reducer(state0, action) {
  // {posts: posts}
  let reducer = combineReducers({posts, form});
  let state1 = reducer(state0, action);
  return deepFreeze(state1);
};

let store = createStore(root_reducer);
export default store;
