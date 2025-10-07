import React from "react";
import { BrowserRouter, Route, Routes, Link } from "react-router-dom";
import Home from "./pages/Home";
import Courses from "./pages/Courses";
import Assignment from "./pages/Assignment";
import Login from "./pages/Login";
import Dashboard from "./pages/Dashboard";
import Sidebar from "./components/Sidebar";
import Footer from "./components/Footer";
import './App.css';

function App() {
  return (
    <BrowserRouter>
      <header>
        <div className="container">
          <div className="logo">
            <img src="/logo.png" alt="MUBS Logo" />
            <h1>MUBS E-Learning</h1>
          </div>
          <nav>
            <ul>
              <li><Link to="/">Home</Link></li>
              <li><Link to="/dashboard">Dashboard</Link></li>
              <li><Link to="/courses">Courses</Link></li>
              <li><Link to="/login">Login</Link></li>
            </ul>
          </nav>
        </div>
      </header>
      <main className="main-layout">
        <Sidebar />
        <div className="content">
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/dashboard" element={<Dashboard />} />
            <Route path="/courses" element={<Courses />} />
            <Route path="/assignment/:id" element={<Assignment />} />
            <Route path="/login" element={<Login />} />
          </Routes>
        </div>
      </main>
      <Footer />
    </BrowserRouter>
  );
}

export default App;