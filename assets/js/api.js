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

  submit_post(data) {
   $.ajax("/api/v1/posts/"+data.alert, {
     method: "post",
     dataType: "json",
     contentType: "application/json; charset=UTF-8",
     data: JSON.stringify({ post: data }),
     success: (resp) => {
       console.log(resp);
       store.dispatch({
         type: 'ADD_POST',
         post: resp.data,
       });
     },
   });
  }

}

export default new TheServer();
