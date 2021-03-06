// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html";

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

import chat_init from "./cs/chat";

import store from './store';
import api from './api';

function init() {
  let topic = window.current_topic;
  let id = window.current_id;

  if(typeof topic != 'undefined') {
    let topicArr = topic.split('/');
    let arrLen = topicArr.length - 1;
    topic = topicArr[arrLen];
    keep_fetching_posts(topic)
    store.identity = {topic: topic, user_id: id};
    chat_init(store);
  }
}

function keep_fetching_posts(topic) {
  if(typeof topic != 'undefined') {
    api.request_posts(topic);

   setTimeout(function () {
     keep_fetching_posts(topic);
   }, 1500);
 }
}

// Use jQuery to delay until page loaded.
$(init);
