import { useState } from "react";
import { Routes, Route, useNavigate } from "react-router-dom";

import Overview from "./tabs/Overview";
import Users from "./tabs/Users";
import Transactions from "./tabs/Transactions";
import Suspicious from "./tabs/Suspicious";
import Merchants from "./tabs/Merchants";

import { useTheme } from "../../context/ThemeContext.jsx";

const NAV = [
  { id: "overview", label: "Тойм" },
  { id: "users", label: "Хэрэглэгчид" },
  { id: "transactions", label: "Гүйлгээ" },
  { id: "suspicious", label: "Сэжигтэй", badge: true },
  { id: "merchants", label: "Merchant" }, // NEW
];

export default function AdminDashboard() {
  const [tab, setTab] = useState("overview");
  const [suspCount, setSuspCount] = useState(0);

  const navigate = useNavigate();
  const { theme: T, toggle } = useTheme();

  function logout() {
    localStorage.removeItem("token");
    navigate("/login");
  }

  const today = new Date().toLocaleDateString("mn-MN", {
    year: "numeric",
    month: "long",
    day: "numeric",
    weekday: "long",
  });

  return (
    <div
      style={{
        display: "flex",
        height: "100vh",
        background: T.bg,
        color: T.text,
        overflow: "hidden",
      }}
    >
      {/* SIDEBAR */}
      <div
        style={{
          width: 220,
          background: T.bgSidebar,
          borderRight: `1px solid ${T.border}`,
          display: "flex",
          flexDirection: "column",
        }}
      >
        {/* LOGO */}
        <div
          style={{
            padding: "22px 20px 18px",
            borderBottom: `1px solid ${T.border}`,
          }}
        >
          <div
            style={{
              fontSize: 20,
              fontWeight: 900,
              letterSpacing: 5,
              color: "#a78bfa",
            }}
          >
            WEARN
          </div>
          <div
            style={{
              fontSize: 9,
              letterSpacing: 2.5,
              color: "#7c3aed",
              marginTop: 2,
            }}
          >
            ADMIN PORTAL
          </div>
        </div>

        {/* NAV */}
        <div style={{ padding: "12px 0", flex: 1 }}>
          {NAV.map((n) => (
            <NavItem
              key={n.id}
              n={n}
              active={tab === n.id}
              onClick={() => setTab(n.id)}
              count={n.id === "suspicious" ? suspCount : null}
              T={T}
            />
          ))}
        </div>

        {/* FOOTER */}
        <div
          style={{
            padding: "12px 14px",
            borderTop: `1px solid ${T.border}`,
          }}
        >
          <button
            onClick={toggle}
            style={{
              width: "100%",
              padding: 8,
              borderRadius: 8,
              border: `1px solid ${T.border}`,
              marginBottom: 8,
            }}
          >
            {T.mode === "dark" ? "☀️ Light" : "🌙 Dark"}
          </button>

          <button
            onClick={logout}
            style={{
              width: "100%",
              padding: 8,
              borderRadius: 8,
              border: `1px solid ${T.border}`,
            }}
          >
            Гарах
          </button>
        </div>
      </div>

      {/* MAIN */}
      <div
        style={{
          flex: 1,
          display: "flex",
          flexDirection: "column",
        }}
      >
        {/* TOPBAR */}
        <div
          style={{
            height: 52,
            borderBottom: `1px solid ${T.border}`,
            display: "flex",
            alignItems: "center",
            justifyContent: "space-between",
            padding: "0 24px",
          }}
        >
          <div style={{ display: "flex", gap: 12 }}>
            <span style={{ fontSize: 15, fontWeight: 700 }}>
              {NAV.find((n) => n.id === tab)?.label}
            </span>

            <span style={{ fontSize: 11, color: T.textMuted }}>
              {today}
            </span>
          </div>
        </div>

        {/* CONTENT */}
        {/* CONTENT */}
<div
  style={{
    flex: 1,
    overflowY: "auto",
    padding: "22px 24px",
  }}
>
  {tab === "overview" && (
    <Overview onSuspCount={setSuspCount} T={T} />
  )}

  {tab === "users" && <Users T={T} />}

  {tab === "transactions" && <Transactions T={T} />}

  {tab === "suspicious" && <Suspicious T={T} />}

  {tab === "merchants" && <Merchants T={T} />}
</div>
      </div>
    </div>
  );
}

/* NAV ITEM */
function NavItem({ n, active, onClick, count, T }) {
  return (
    <button
      onClick={onClick}
      style={{
        display: "flex",
        alignItems: "center",
        gap: 9,
        padding: "9px 18px",
        fontSize: 13,
        width: "100%",
        border: "none",
        textAlign: "left",
        cursor: "pointer",

        color: active
          ? "#7c3aed"
          : T.textNav,

        background: active
          ? "#ede9fe"
          : "transparent",
      }}
    >
      {n.label}

      {count > 0 && (
        <span
          style={{
            marginLeft: "auto",
            background: "#fef2f2",
            color: "#ef4444",
            fontSize: 9,
            padding: "2px 6px",
            borderRadius: 8,
          }}
        >
          {count}
        </span>
      )}
    </button>
  );
}