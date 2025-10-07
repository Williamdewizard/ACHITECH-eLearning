import React from "react";
import { BrowserRouter, Route, Routes, Link } from "react-router-dom";
import Home from "./pages/Home";
import Courses from "./pages/Courses";
import Assignment from "./pages/Assignment";
import Login from "./pages/Login";
import OfflineBanner from "./components/OfflineBanner";
import 'bootstrap/dist/css/bootstrap.min.css'; // Add this if not in index.js

function App() {
  return (
    <BrowserRouter>
      <OfflineBanner />
      <nav className="navbar navbar-expand-lg navbar-dark bg-primary">
        <div className="container">
          <Link className="navbar-brand" to="/">MUBS E-Learning</Link>
          <div className="navbar-nav ms-auto">
            <Link className="nav-link" to="/">Home</Link>
            <Link className="nav-link" to="/courses">Courses</Link>
            <Link className="nav-link" to="/login">Login</Link>
          </div>
        </div>
      </nav>
      <div className="container mt-4">
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/courses" element={<Courses />} />
          <Route path="/assignment/:id" element={<Assignment />} />
          <Route path="/login" element={<Login />} />
        </Routes>
      </div>
    </BrowserRouter>
  );
}

export default App;