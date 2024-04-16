import { MetaMaskButton } from "@metamask/sdk-react-ui";
import React, { useState } from "react";

function Navbar() {
  let floatRight = {
    float: 'right'
  }
  let buttonStyles = {
    padding: '10px 10px 10px 10px',
    backgroundColor: 'white',
    width: '100px'  }
  let searchbarStyles = {
    height: '30px',
    marginRight: '40px',
    paddingLeft: '15px',
    width: '200px'
  }
  let borderRadius = {
    borderRadius: '15px 15px 15px 15px',
    border: '2px solid #34abef'
  }
  return (
    <div>
      <nav>
        <button style={buttonStyles}>Home</button>
        <button style={buttonStyles}>Morph Notifications</button>
        <button style={buttonStyles}>Morph Messages</button>
        <button style={buttonStyles}>New Morph Profile</button>
        <MetaMaskButton theme={"light"} color="white"></MetaMaskButton>

      </nav>
      <hr/>
    </div>
  );
}

export default Navbar;