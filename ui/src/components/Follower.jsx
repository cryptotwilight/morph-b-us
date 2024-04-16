import React from 'react';
import PropTypes from "prop-types";

function Follower(props){
  let image = {
    width: '60x',
    height: '60px',
    marginRight: '15px'
  }

  let columns = {
    display: 'grid',
    gridTemplateColumns: '1fr 3fr',
  }
  let raised={
    marginTop: '-25px'
  }

  return(
    <div style={columns}>
      <div>
        <img style={image} src={props.img}/>
      </div>
      <div style={raised}>
        <h4>{props.text}</h4>
        <button style={buttonStyle}>Follow</button>
      </div>
    </div>
  );
}

Friend.propTypes={
  img: PropTypes.string,
  text: PropTypes.string
};

export default Follower;