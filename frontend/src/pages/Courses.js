import React, { useEffect, useState } from "react";
import { getCourses } from "../api";

const CACHE_KEY = "cache:courses";

export default function Courses() {
  const [courses, setCourses] = useState([]);
  const [state, setState] = useState({ loading: true, error: "" });

  useEffect(() => {
    const cached = localStorage.getItem(CACHE_KEY);
    if (cached) {
      try { setCourses(JSON.parse(cached)); } catch {}
    }
    let isMounted = true;
    getCourses()
      .then((data) => {
        if (!isMounted) return;
        setCourses(data);
        localStorage.setItem(CACHE_KEY, JSON.stringify(data));
      })
      .catch((err) => {
        if (!cached) setState((s) => ({ ...s, error: err.message }));
      })
      .finally(() => setState((s) => ({ ...s, loading: false })));
    return () => { isMounted = false; };
  }, []);

  if (state.loading && courses.length === 0) return <div className="text-center"><div className="spinner-border" role="status"></div></div>;
  if (state.error && courses.length === 0) return <div className="alert alert-danger">{state.error}</div>;

  return (
    <div>
      <h2 className="text-primary">Your Courses</h2>
      {courses.length === 0 ? (
        <div className="alert alert-info">No courses yet. Add one in the Django Admin.</div>
      ) : (
        <div className="row">
          {courses.map((c) => (
            <div key={c.id} className="col-md-4 mb-4">
              <div className="card h-100">
                <div className="card-body">
                  <h5 className="card-title">{c.title}</h5>
                  <p className="card-text">{c.description}</p>
                  <small className="text-muted">Version: {c.version}</small>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
      {!navigator.onLine && <div className="alert alert-warning">Offline — showing cached data.</div>}
    </div>
  );
}