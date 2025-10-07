import React from "react";

export default function Home() {
  return (
    <div className="text-center">
      <h1 className="display-4 text-primary">Welcome to MUBS E-Learning!</h1>
      <p className="lead">Access your courses, submit assignments, and learn offline.</p>
      <div className="row mt-4">
        <div className="col-md-4">
          <div className="card">
            <div className="card-body">
              <h5 className="card-title">Courses</h5>
              <p className="card-text">Browse and access your enrolled courses.</p>
              <a href="/courses" className="btn btn-primary">Go to Courses</a>
            </div>
          </div>
        </div>
        <div className="col-md-4">
          <div className="card">
            <div className="card-body">
              <h5 className="card-title">Assignments</h5>
              <p className="card-text">Submit your assignments easily.</p>
              <a href="/assignment/1" className="btn btn-success">Submit Assignment</a>
            </div>
          </div>
        </div>
        <div className="col-md-4">
          <div className="card">
            <div className="card-body">
              <h5 className="card-title">Login</h5>
              <p className="card-text">Securely access your account.</p>
              <a href="/login" className="btn btn-secondary">Login</a>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}