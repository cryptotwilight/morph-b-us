import React from "react";
import Navbar from './Navbar';
import Badge from './Badge';
import Bio from './Bio';
import Feed from './Feed'
import FriendList from './FriendList';
import FollowerList from "./FollowerList";
import Messages from "./Messages";
import AllFollowerList from "./AllFollowerList";

function App() {
  let columns = {
    display: 'grid',
    gridTemplateColumns: 'repeat(4, 1fr)',
    marginLeft: '2px',
    marginRight: '2px'
  }
  return (
    <div>
      <Navbar/>
      <div style={columns}>
        <div>
          <Badge/>
          <Messages/>
          <Bio/>
        </div>
        <div>
          <Feed/>
        </div> 
        <div>
          <FriendList/>
          <FollowerList/>
        </div>
        <div>
          <AllFollowerList/>
        </div>
      </div>
    </div>
  );
}

export default App;