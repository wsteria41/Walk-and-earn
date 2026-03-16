import { useState } from "react";
import { useNavigate } from "react-router-dom";
import Overview from "./tabs/Overview";
import Users from "./tabs/Users";
import Transactions from "./tabs/Transactions";
import Suspicious from "./tabs/Suspicious";

const tabs = [
  { id: "overview", label: "Тойм" },
  { id: "users", label: "Хэрэглэгчид" },
  { id: "transactions", label: "Гүйлгээ" },
  { id: "suspicious", label: "Сэжигтэй" },
];

export default function AdminDashboard() {
  const [activeTab, setActiveTab] = useState("overview");
  const navigate = useNavigate();

  function logout() {
    localStorage.removeItem("token");
    navigate("/login");
  }

  return (
    <div style={{ minHeight: "100vh", background: "#0a0a0a", color: "#fff" }}>
      
      {/* SIDEBAR */}
      <div style={{
        position: "fixed", top: 0, left: 0,
        width: 220, height: "100vh",
        background: "#111", borderRight: "1px solid #1e1e1e",
        display: "flex", flexDirection: "column",
        padding: "24px 0",
      }}>
        <div style={{ padding: "0 20px 24px" }}>
          <h2 style={{ color: "#fff", fontSize: 20, fontWeight: 900, letterSpacing: 3 }}>WEARN</h2>
          <p style={{ color: "#7B2FFF", fontSize: 10, letterSpacing: 2 }}>ADMIN PORTAL</p>
        </div>

        {tabs.map(tab => (
          <button key={tab.id} onClick={() => setActiveTab(tab.id)}
            style={{
              display: "block", width: "100%",
              padding: "12px 20px", textAlign: "left",
              background: activeTab === tab.id ? "#7B2FFF22" : "transparent",
              borderLeft: activeTab === tab.id ? "3px solid #7B2FFF" : "3px solid transparent",
              border: "none", borderLeft: activeTab === tab.id ? "3px solid #7B2FFF" : "3px solid transparent",
              color: activeTab === tab.id ? "#fff" : "#666",
              fontSize: 14, cursor: "pointer",
            }}>
            {tab.label}
          </button>
        ))}

        <button onClick={logout} style={{
          marginTop: "auto", marginLeft: 20, marginRight: 20,
          padding: "10px", background: "#1a1a1a",
          border: "1px solid #2a2a2a", borderRadius: 8,
          color: "#888", fontSize: 13, cursor: "pointer",
        }}>
          Гарах
        </button>
      </div>

      {/* CONTENT */}
      <div style={{ marginLeft: 220, padding: 32 }}>
        {activeTab === "overview" && <Overview />}
        {activeTab === "users" && <Users />}
        {activeTab === "transactions" && <Transactions />}
        {activeTab === "suspicious" && <Suspicious />}
      </div>
    </div>
  );
}