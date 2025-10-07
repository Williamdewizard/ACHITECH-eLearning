import React, { useState } from "react";
import { login } from "../api/auth";

export default function Login() {
  const [username, setU] = useState("");
  const [password, setP] = useState("");
  const [msg, setMsg] = useState("");

  const onSubmit = async (e) => {
    e.preventDefault();
    setMsg("Signing in...");
    try {
      await login(username, password);
      setMsg("Logged in!");
    } catch (e) {
      setMsg("Login failed. Check credentials.");
    }
  };

  return (
    <div className="row justify-content-center">
      <div className="col-md-6">
        <div className="card">
          <div className="card-body">
            <h2 className="card-title text-center text-primary">Login</h2>
            <form onSubmit={onSubmit}>
              <div className="mb-3">
                <label className="form-label">Username</label>
                <input
                  type="text"
                  className="form-control"
                  value={username}
                  onChange={(e)=>setU(e.target.value)}
                  required
                />
              </div>
              <div className="mb-3">
                <label className="form-label">Password</label>
                <input
                  type="password"
                  className="form-control"
                  value={password}
                  onChange={(e)=>setP(e.target.value)}
                  required
                />
              </div>
              <button type="submit" className="btn btn-primary w-100">Login</button>
            </form>
            {msg && <div className={`alert mt-3 ${msg.includes("failed") ? "alert-danger" : "alert-success"}`}>{msg}</div>}
          </div>
        </div>
      </div>
    </div>
  );
}