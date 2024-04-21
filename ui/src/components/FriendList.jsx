import React from 'react';
import Friend from './Friend';

function FriendList(){
  let container={
    border: '2px solid lightgray',
    paddingLeft: '15px',
    color: '#777777'
  }
  return(
    <div style={container}>
      <h4>New Follows</h4>
      <Friend
      img="https://images.pexels.com/photos/12746159/pexels-photo-12746159.jpeg?auto=compress&cs=tinysrgb&w=600"
      text="Marcy Mellow"/>
      <Friend
      img="https://images.pexels.com/photos/16852236/pexels-photo-16852236/free-photo-of-brunette-in-cap-and-hoodie.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"
      text="Morph Gidieta"/>
      <Friend
      img="https://images.pexels.com/photos/10189410/pexels-photo-10189410.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"
      text="Donn"/>
    </div>
  );
}

export default FriendList;