import store from './store';

class TheServer {
  request_posts(topic) {
    $.ajax("/api/v1/posts/"+topic, {
      method: "get",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      success: (resp) => {
        store.dispatch({
          type: 'POSTS_LIST',
          posts: resp.data,
        });
      },
    });
  }
}

export default new TheServer();
