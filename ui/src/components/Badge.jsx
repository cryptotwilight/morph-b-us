import React from 'react';

function Badge() {
  let image = {
    width: '75px',
    border: '2px solid white',
    borderRadius: '30px',
    marginTop: '-60px'
  }
  let blue = {
    backgroundColor: '#34abef',
    height: '92px'
  }
  let container = {
    width: '300px'
  }
  let nameFloat={
    float: 'right',
    marginBottom: '0',
    color: '#333333'
  }
  let paddingAll = {
    padding: '0 20px 0 20px',
    border: '2px solid lightgray'
  }
  let wordsColor={
    color: 'gray'
  }
  return (
    <div style={container}>
      <div style={blue}>

      </div>
      <div style={paddingAll}>
        <img style={image} src="https://images.pexels.com/photos/17156715/pexels-photo-17156715/free-photo-of-portrait-fo-brunette.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load"/>
        <h3 style={nameFloat}>I am Morph</h3>
        <br/>
        <h5 style={wordsColor}>FOLLOWING:10 FOLLOWERS: 23345 REWARDS: 876 MBUT</h5>
      </div>
    </div>
  );
}

export default Badge;