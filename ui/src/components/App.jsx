import React from "react";
import Navbar from './Navbar';
import Badge from './Badge';
import Bio from './Bio';
import Feed from './Feed';
import FollowerList from './FollowerList';
import FriendList from './FriendList';

function App() {
  let columns = {
    display: 'grid',
    gridTemplateColumns: 'repeat(4, 2fr)',
    marginLeft: '2px',
    marginRight: '2px'
  }
  return (
    <div>
      <Navbar/>
      <div style={columns}>
        <div>
          <Badge/>
          <Bio/>
        </div>
        <div>
          <Feed/>
        </div> 
        <div>
          <FriendList/>
        </div>
        <div>
          <FollowerList/>
        </div>
      </div>
    </div>
  );
}

export default App;