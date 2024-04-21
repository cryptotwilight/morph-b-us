import React from 'react';
import SearchFeed from './SearchFeed';
import Post from './Post';

function Feed() {
  let container = {
    border: '2px solid lightgray',
    width: '300px'
  }
  return (
    <div style={container}>
      <SearchFeed/>
      <Post
      img="https://images.pexels.com/photos/19056722/pexels-photo-19056722/free-photo-of-bearded-man-in-a-denim-shirt-with-a-tattoo-on-his-chest.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"
      name="Jim Max"
      text="Lorem ipsum dolor sit amet, consectetur adipisicing elit. Nullam"/>
      <Post
      img="https://images.pexels.com/photos/16759924/pexels-photo-16759924/free-photo-of-woman-in-black-dress-and-fishnet-stockings.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"
      name="Mary Payne"
      text="Lorem ipsum dolor sit amet, consectetur adipisicing elit. Nullam"/>
      <Post
      img="https://images.pexels.com/photos/17156715/pexels-photo-17156715/free-photo-of-portrait-fo-brunette.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load"
      name="Me"
      text="Lorem ipsum dolor sit amet, consectetur adipisicing elit. Nullam"/>
      <Post
      img="https://images.pexels.com/photos/8441486/pexels-photo-8441486.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"
      name="Rex"
      text="Lorem ipsum dolor sit amet, consectetur adipisicing elit. Nullam"/>
      <Post
      img="https://images.pexels.com/photos/3214138/pexels-photo-3214138.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"
      name="Tina"
      text="Lorem ipsum dolor sit amet, consectetur adipisicing elit. Nullam"/>
    </div>
  );
}

export default Feed;