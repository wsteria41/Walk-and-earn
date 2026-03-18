import { useState } from "react";
import { useNavigate } from "react-router-dom";
import Overview from "./tabs/Overview";
import Users from "./tabs/Users";
import Transactions from "./tabs/Transactions";
import Suspicious from "./tabs/Suspicious";
import { useTheme } from "../../context/ThemeContext.jsx";

const NAV = [
  {
    id: "overview",
    label: "Тойм",
    icon: (a, t) => (
      <svg width="15" height="15" viewBox="0 0 16 16" fill="none">
        <rect
          x="1"
          y="1"
          width="6"
          height="6"
          rx="2"
          fill={a ? "#7c3aed" : t.textNav}
        />
        <rect
          x="9"
          y="1"
          width="6"
          height="6"
          rx="2"
          fill={a ? "#7c3aed" : t.textNav}
          opacity=".5"
        />
        <rect
          x="1"
          y="9"
          width="6"
          height="6"
          rx="2"
          fill={a ? "#7c3aed" : t.textNav}
          opacity=".5"
        />
        <rect
          x="9"
          y="9"
          width="6"
          height="6"
          rx="2"
          fill={a ? "#7c3aed" : t.textNav}
          opacity=".2"
        />
      </svg>
    ),
  },
  {
    id: "users",
    label: "Хэрэглэгчид",
    icon: (a, t) => (
      <svg width="15" height="15" viewBox="0 0 16 16" fill="none">
        <circle
          cx="8"
          cy="5"
          r="3"
          stroke={a ? "#7c3aed" : t.textNav}
          strokeWidth="1.5"
        />
        <path
          d="M2 14c0-3.3 2.7-6 6-6s6 2.7 6 6"
          stroke={a ? "#7c3aed" : t.textNav}
          strokeWidth="1.5"
          strokeLinecap="round"
        />
      </svg>
    ),
  },
  {
    id: "transactions",
    label: "Гүйлгээ",
    icon: (a, t) => (
      <svg width="15" height="15" viewBox="0 0 16 16" fill="none">
        <path
          d="M2 4h12M2 8h12M2 12h8"
          stroke={a ? "#7c3aed" : t.textNav}
          strokeWidth="1.5"
          strokeLinecap="round"
        />
      </svg>
    ),
  },
  {
    id: "suspicious",
    label: "Сэжигтэй",
    badge: true,
    icon: (a, t) => (
      <svg width="15" height="15" viewBox="0 0 16 16" fill="none">
        <path
          d="M8 2L9.8 6.2L14 7L11 9.9L11.7 14L8 11.8L4.3 14L5 9.9L2 7L6.2 6.2Z"
          stroke={a ? "#7c3aed" : t.textNav}
          strokeWidth="1.5"
          strokeLinejoin="round"
        />
      </svg>
    ),
  },
];

const today = new Date().toLocaleDateString("mn-MN", {
  year: "numeric",
  month: "long",
  day: "numeric",
  weekday: "long",
});

export default function AdminDashboard() {
  const [tab, setTab] = useState("overview");
  const [suspCount, setSuspCount] = useState(0);
  const navigate = useNavigate();
  const { theme: T, toggle } = useTheme();

  function logout() {
    localStorage.removeItem("token");
    navigate("/login");
  }

  return (
    <div
      style={{
        display: "flex",
        height: "100vh",
        background: T.bg,
        color: T.text,
        fontFamily:
          "'SF Pro Display',-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif",
        overflow: "hidden",
        transition: "background .25s, color .25s",
      }}
    >
      {/* ── SIDEBAR ── */}
      <div
        style={{
          width: 220,
          background: T.bgSidebar,
          borderRight: `1px solid ${T.border}`,
          display: "flex",
          flexDirection: "column",
          flexShrink: 0,
          transition: "background .25s, border-color .25s",
        }}
      >
        {/* Logo */}
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
              fontWeight: 600,
              opacity: 0.7,
            }}
          >
            ADMIN PORTAL
          </div>
        </div>

        {/* Nav */}
        <div style={{ padding: "12px 0", flex: 1 }}>
          <SectionLabel T={T}>ҮНДСЭН</SectionLabel>
          {NAV.slice(0, 3).map((n) => (
            <NavItem
              key={n.id}
              n={n}
              active={tab === n.id}
              onClick={() => setTab(n.id)}
              T={T}
            />
          ))}
          <SectionLabel T={T}>АЮУЛГҮЙ БАЙДАЛ</SectionLabel>
          <NavItem
            n={NAV[3]}
            active={tab === "suspicious"}
            onClick={() => setTab("suspicious")}
            count={suspCount}
            T={T}
          />
        </div>

        {/* User */}
        <div
          style={{ padding: "12px 14px", borderTop: `1px solid ${T.border}` }}
        >
          <div
            style={{
              display: "flex",
              alignItems: "center",
              gap: 9,
              padding: "8px 10px",
              background: T.bgUserBox,
              borderRadius: 10,
              marginBottom: 8,
            }}
          >
            <Avatar letter="A" size={30} />
            <div>
              <div style={{ fontSize: 12, color: T.textUser, fontWeight: 600 }}>
                Admin
              </div>
              <div style={{ fontSize: 10, color: T.textEmail }}>
                admin@wearn.me
              </div>
            </div>
          </div>
          <button
            onClick={logout}
            style={{
              width: "100%",
              padding: "7px 0",
              background: "transparent",
              border: `1px solid ${T.border}`,
              borderRadius: 8,
              color: T.textNav,
              fontSize: 12,
              cursor: "pointer",
              transition: "all .15s",
            }}
            onMouseEnter={(e) => {
              e.currentTarget.style.color = "#7c3aed";
              e.currentTarget.style.borderColor = "#7c3aed44";
            }}
            onMouseLeave={(e) => {
              e.currentTarget.style.color = T.textNav;
              e.currentTarget.style.borderColor = T.border;
            }}
          >
            Гарах
          </button>
        </div>
      </div>

      {/* ── MAIN ── */}
      <div
        style={{
          flex: 1,
          display: "flex",
          flexDirection: "column",
          minWidth: 0,
        }}
      >
        {/* Topbar — minimal */}
        <div
          style={{
            height: 52,
            background: T.bgTopbar,
            borderBottom: `1px solid ${T.border}`,
            display: "flex",
            alignItems: "center",
            justifyContent: "space-between",
            padding: "0 24px",
            flexShrink: 0,
            transition: "background .25s, border-color .25s",
          }}
        >
          {/* Left: page title + date */}
          <div style={{ display: "flex", alignItems: "baseline", gap: 12 }}>
            <span style={{ fontSize: 15, fontWeight: 700, color: T.text }}>
              {NAV.find((n) => n.id === tab)?.label}
            </span>
            <span style={{ fontSize: 11, color: T.textMuted }}>{today}</span>
          </div>

          {/* Right: theme toggle + avatar only */}
          <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
            <ThemeToggle isDark={T.mode === "dark"} onToggle={toggle} />
            <Avatar letter="A" size={32} />
          </div>
        </div>

        {/* Content */}
        {/* Content */}
        <div
          style={{
            flex: 1,
            overflowY: "auto",
            padding: "22px 24px",
            background: T.bgContent,
            transition: "background .25s",
          }}
        >
          {tab === "overview" && <Overview onSuspCount={setSuspCount} T={T} />}
          {tab === "users" && <Users T={T} />}
          {tab === "transactions" && <Transactions T={T} />}
          {tab === "suspicious" && <Suspicious T={T} />}
        </div>
      </div>
    </div>
  );
}

/* ── Theme toggle — icon only ── */
function ThemeToggle({ isDark, onToggle }) {
  return (
    <button
      onClick={onToggle}
      style={{
        width: 34,
        height: 34,
        borderRadius: 8,
        background: "transparent",
        border: `1px solid ${isDark ? "#2a2a40" : "#e2e2f0"}`,
        cursor: "pointer",
        transition: "all .2s",
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        fontSize: 16,
      }}
      onMouseEnter={(e) => {
        e.currentTarget.style.borderColor = "#7c3aed55";
        e.currentTarget.style.background = "#7c3aed0a";
      }}
      onMouseLeave={(e) => {
        e.currentTarget.style.borderColor = isDark ? "#2a2a40" : "#e2e2f0";
        e.currentTarget.style.background = "transparent";
      }}
    >
      {isDark ? "🌙" : "☀️"}
    </button>
  );
}

/* ── Helpers ── */
function SectionLabel({ children, T }) {
  return (
    <div
      style={{
        padding: "10px 0 3px 18px",
        fontSize: 9,
        letterSpacing: 1.5,
        color: T.sectionLabel,
        fontWeight: 600,
      }}
    >
      {children}
    </div>
  );
}

function Avatar({ letter, size }) {
  return (
    <div
      style={{
        width: size,
        height: size,
        borderRadius: "50%",
        background: "linear-gradient(135deg,#7c3aed,#4f46e5)",
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        fontSize: size * 0.38,
        fontWeight: 800,
        flexShrink: 0,
        color: "#fff",
      }}
    >
      {letter}
    </div>
  );
}

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
        fontWeight: active ? 600 : 400,
        color: active ? (T.mode === "dark" ? "#c4b0ff" : "#5b21b6") : T.textNav,
        background: active
          ? T.mode === "dark"
            ? "#7c3aed14"
            : "#ede9fe"
          : "transparent",
        border: "none",
        borderLeft: `2px solid ${active ? "#7c3aed" : "transparent"}`,
        width: "100%",
        textAlign: "left",
        cursor: "pointer",
        transition: "color .15s, background .15s",
      }}
      onMouseEnter={(e) => {
        if (!active) {
          e.currentTarget.style.color = "#7c3aed";
          e.currentTarget.style.background =
            T.mode === "dark" ? "#7c3aed08" : "#f5f3ff";
        }
      }}
      onMouseLeave={(e) => {
        if (!active) {
          e.currentTarget.style.color = T.textNav;
          e.currentTarget.style.background = "transparent";
        }
      }}
    >
      {n.icon(active, T)}
      <span>{n.label}</span>
      {count > 0 && (
        <span
          style={{
            marginLeft: "auto",
            background: "#fef2f2",
            color: "#ef4444",
            fontSize: 9,
            padding: "2px 6px",
            borderRadius: 8,
            fontWeight: 700,
          }}
        >
          {count}
        </span>
      )}
    </button>
  );
}

function BotItem({ n, active, onClick, count, T }) {
  return (
    <div
      onClick={onClick}
      style={{
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        gap: 3,
        cursor: "pointer",
        padding: "0 16px",
        opacity: active ? 1 : 0.35,
        transition: "opacity .15s",
      }}
    >
      {n.icon(active, T)}
      <span
        style={{
          fontSize: 8,
          color: active ? "#7c3aed" : T.textNav,
          letterSpacing: 1,
          fontWeight: 700,
        }}
      >
        {n.label.toUpperCase()}
      </span>
      {active && (
        <div
          style={{
            width: 3,
            height: 3,
            borderRadius: "50%",
            background: "#7c3aed",
          }}
        />
      )}
      {count > 0 && !active && (
        <div
          style={{
            width: 5,
            height: 5,
            borderRadius: "50%",
            background: "#ef4444",
            marginTop: -2,
          }}
        />
      )}
    </div>
  );
}
