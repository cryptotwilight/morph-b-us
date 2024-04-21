import React from 'react';
import Follower from './Follower';

function FollowerList(){
  let container={
    border: '2px solid lightgray',
    paddingLeft: '15px',
    color: '#777777'
  }
  return(
    <div style={container}>
      <h4>New Followers</h4>
      <Follower
      img="https://images.pexels.com/photos/13440736/pexels-photo-13440736.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"
      text="Marcy"/>
      <Follower
      img="https://images.pexels.com/photos/17045058/pexels-photo-17045058/free-photo-of-smiling-woman-with-tattoos.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"
      text="Gidieta"/>
      <Follower
      img="https://images.pexels.com/photos/6016477/pexels-photo-6016477.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"
      text="Donna"/>
    </div>
  );
}

export default FollowerList;