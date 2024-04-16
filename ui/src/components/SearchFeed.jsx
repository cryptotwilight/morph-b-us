import React from 'react';

function SearchFeed() {
  let buttonStyle = {
    margin: '20px 10px 0 40px',
    float: 'left',
    backgroundColor: 'white'
  }
  let inputStyle = {
    height: '30px',
    width: '200px',
    marginTop: '20px',
    border: '2px solid #00ddff'
  }
  let divStyle = {
    backgroundColor: 'lightblue',
    paddingBottom: '20px'

  }
  return (
    <div style={divStyle}>
      <button style={buttonStyle}>Post</button>
      <input style={inputStyle} type="text" placeholder="What's happening?"/>
    </div>
  );
}

export default SearchFeed;

