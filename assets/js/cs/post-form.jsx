import React from 'react';
import { connect } from 'react-redux';
import { Button, FormGroup, Label, Input } from 'reactstrap';
import api from '../api';

function PostForm(props) {

  function update(ev) {
    let tgt = $(ev.target);

    let data = {};
    data[tgt.attr('name')] = tgt.val();
    let action = {
      type: 'UPDATE_FORM',
      data: data,
    };
    props.dispatch(action);
  }

  function submit(ev) {
      let new_form = Object.assign({},props.form);
      new_form.user_id = props.params.user_id;
      new_form.alert = props.params.topic;
      api.submit_post(new_form);
    }

  function clear(ev) {
      props.dispatch({
        type: 'CLEAR_FORM',
      });
  }

  return <div style={{padding: "4ex"}}>
    <h2>Say Something</h2>
    <FormGroup>
      <Input type="textarea" placeholder="write.." name="body" value={props.form.body} onChange={update} />
    </FormGroup>
    <Button onClick={submit} color="primary">Post</Button> &nbsp;
    <Button onClick={clear}>Clear</Button>
  </div>;
}

function state2props(state) {
  return {
    form: state.form,
  };
}

export default connect(state2props)(PostForm);
