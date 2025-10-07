import React from "react";

const Sidebar = () => {
  return (
    <aside className="sidebar">
      <h3>Navigation</h3>
      <ul>
        <li><a href="/dashboard">My Dashboard</a></li>
        <li><a href="/courses">Browse Courses</a></li>
        <li><a href="/assignment/1">Assignments</a></li>
        <li><a href="/login">Profile</a></li>
      </ul>
      <h3>Quick Links</h3>
      <ul>
        <li><a href="#">Calendar</a></li>
        <li><a href="#">Messages</a></li>
        <li><a href="#">Help</a></li>
      </ul>
    </aside>
  );
};

export default Sidebar;