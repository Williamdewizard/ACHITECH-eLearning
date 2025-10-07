import React from "react";

export default function Dashboard() {
  return (
    <div>
      <h2>My Dashboard</h2>
      <div className="blocks">
        <div className="block">
          <h4>Course Progress</h4>
          <p>Complete: 70%</p>
          <div style={{ height: '10px', background: '#e0e0e0', borderRadius: '5px' }}>
            <div style={{ width: '70%', height: '100%', background: '#f98012', borderRadius: '5px' }}></div>
          </div>
        </div>
        <div className="block">
          <h4>Upcoming Events</h4>
          <ul>
            <li>Assignment Due: 2024-10-10</li>
            <li>Quiz: 2024-10-12</li>
          </ul>
        </div>
        <div className="block">
          <h4>Messages</h4>
          <p>You have 3 unread messages.</p>
        </div>
      </div>
    </div>
  );
}