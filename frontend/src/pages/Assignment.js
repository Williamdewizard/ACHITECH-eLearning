import React, { useState } from "react";
import { getAuthHeader } from "../api/auth";

export default function Assignment() {
  const [file, setFile] = useState(null);
  const [assignmentId, setAssignmentId] = useState("");
  const [msg, setMsg] = useState("");

  const submit = async (e) => {
    e.preventDefault();
    if (!file || !assignmentId) { setMsg("Pick a file and enter assignment ID"); return; }
    const fd = new FormData();
    fd.append("assignment", assignmentId);
    const studentId = localStorage.getItem("studentId") || "1";
    fd.append("student", studentId);
    fd.append("file", file);

    setMsg("Uploading...");
    const res = await fetch("/api/submissions/", {
      method: "POST",
      headers: { ...getAuthHeader() },
      body: fd,
    });
    if (!res.ok) {
      setMsg("Upload failed: " + res.status);
      return;
    }
    setMsg("Uploaded!");
  };

  return (
    <div className="row justify-content-center">
      <div className="col-md-6">
        <div className="card">
          <div className="card-body">
            <h2 className="card-title text-center text-success">Assignment Submission</h2>
            <form onSubmit={submit}>
              <div className="mb-3">
                <label className="form-label">Assignment ID</label>
                <input
                  type="text"
                  className="form-control"
                  value={assignmentId}
                  onChange={(e)=>setAssignmentId(e.target.value)}
                  required
                />
              </div>
              <div className="mb-3">
                <label className="form-label">Upload File</label>
                <input
                  type="file"
                  className="form-control"
                  onChange={(e)=>setFile(e.target.files?.[0] || null)}
                  required
                />
              </div>
              <button type="submit" className="btn btn-success w-100">Submit</button>
            </form>
            {msg && <div className={`alert mt-3 ${msg.includes("failed") ? "alert-danger" : "alert-success"}`}>{msg}</div>}
            {!navigator.onLine && <div className="alert alert-warning">You are offline — consider queuing uploads for later.</div>}
          </div>
        </div>
      </div>
    </div>
  );
}