import React from 'react';
import Follower from "./Follower";

function Followers(){
  let container={
    border: '2px solid lightgray',
    paddingLeft: '15px',
    color: '#777777'
  }
  return(
    <div style={container}>
      <h4>All Followers</h4>
      <Follower
      img="https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
      text="Tom Jones"/>
      <Follower
      img="https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
      text="Donec eu orci et"/>
      <Follower
      img="https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
      text="Donec eu orci et"/>
    </div>
  );
}

export default Followers;