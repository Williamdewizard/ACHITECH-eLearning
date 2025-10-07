import React, { useEffect, useState } from "react";

const OfflineBanner = () => {
  const [isOffline, setIsOffline] = useState(!navigator.onLine);

  useEffect(() => {
    const goOnline = () => setIsOffline(false);
    const goOffline = () => setIsOffline(true);
    window.addEventListener("online", goOnline);
    window.addEventListener("offline", goOffline);
    return () => {
      window.removeEventListener("online", goOnline);
      window.removeEventListener("offline", goOffline);
    };
  }, []);

  return isOffline ? (
    <div style={{ background: "orange", color: "white", padding: "8px", textAlign: "center" }}>
      You are offline. Changes will sync when internet is available.
    </div>
  ) : null;
};

export default OfflineBanner;