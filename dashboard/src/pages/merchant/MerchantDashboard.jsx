import { useState } from "react";
import { useNavigate } from "react-router-dom";
import MerchantOverview from "./tabs/MerchantOverview";
import MyRewards from "./tabs/MyRewards";
import PendingRedemptions from "./tabs/PendingRedemptions";

const NAV = [
  {
    id: "overview",
    label: "Тойм",
    icon: (a, dark) => (
      <svg width="15" height="15" viewBox="0 0 16 16" fill="none">
        <rect
          x="1"
          y="1"
          width="6"
          height="6"
          rx="2"
          fill={a ? "#7c3aed" : dark ? "#3a3a5a" : "#aaa"}
        />
        <rect
          x="9"
          y="1"
          width="6"
          height="6"
          rx="2"
          fill={a ? "#7c3aed" : dark ? "#3a3a5a" : "#aaa"}
          opacity=".4"
        />
        <rect
          x="1"
          y="9"
          width="6"
          height="6"
          rx="2"
          fill={a ? "#7c3aed" : dark ? "#3a3a5a" : "#aaa"}
          opacity=".4"
        />
        <rect
          x="9"
          y="9"
          width="6"
          height="6"
          rx="2"
          fill={a ? "#7c3aed" : dark ? "#3a3a5a" : "#aaa"}
          opacity=".4"
        />
      </svg>
    ),
  },
  {
    id: "rewards",
    label: "Урамшуулал",
    icon: (a, dark) => (
      <svg width="15" height="15" viewBox="0 0 16 16" fill="none">
        <path
          d="M8 2l1.8 4.2L14 7l-3 2.9.7 4.1L8 11.8l-3.7 2.2.7-4.1L2 7l4.2-.8L8 2z"
          stroke={a ? "#7c3aed" : dark ? "#3a3a5a" : "#aaa"}
          strokeWidth="1.5"
          strokeLinejoin="round"
        />
      </svg>
    ),
  },
  {
    id: "redemptions",
    label: "Хүсэлтүүд",
    icon: (a, dark) => (
      <svg width="15" height="15" viewBox="0 0 16 16" fill="none">
        <path
          d="M2 4h12M2 8h12M2 12h8"
          stroke={a ? "#7c3aed" : dark ? "#3a3a5a" : "#aaa"}
          strokeWidth="1.5"
          strokeLinecap="round"
        />
      </svg>
    ),
    badge: true,
  },
];

const TYPE_CONFIG = {
  DISCOUNT: {
    label: "Хөнгөлөлт",
    color: "#7c3aed",
    bg: "#7c3aed20",
    border: "#7c3aed40",
  },
  FREEBIE: {
    label: "Үнэгүй",
    color: "#f59e0b",
    bg: "#f59e0b20",
    border: "#f59e0b40",
  },
};

const today = new Date().toLocaleDateString("mn-MN", {
  year: "numeric",
  month: "long",
  day: "numeric",
  weekday: "long",
});

export default function MerchantDashboard() {
  const [tab, setTab] = useState("overview");
  const [dark, setDark] = useState(true);
  const [pendingCount, setPendingCount] = useState(0);
  const [showSideProfile, setShowSideProfile] = useState(false);
  const [showTopProfile, setShowTopProfile] = useState(false);
  const navigate = useNavigate();

  function logout() {
    localStorage.removeItem("token");
    navigate("/login");
  }

  const bg = dark ? "#080812" : "#f4f4f8";
  const sb = dark ? "#13131f" : "#ffffff";
  const bdr = dark ? "#2a2a3e" : "#e5e5ea";
  const txt = dark ? "#fff" : "#111";
  const muted = dark ? "#3a3a5a" : "#999";
  const cardBg = dark ? "#16162a" : "#ffffff";

  return (
    <div
      style={{
        display: "flex",
        height: "100vh",
        background: bg,
        color: txt,
        fontFamily: "-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif",
        overflow: "hidden",
      }}
    >
      {/* SIDEBAR */}
      <div
        style={{
          width: 230,
          background: sb,
          borderRight: `1px solid ${bdr}`,
          display: "flex",
          flexDirection: "column",
          flexShrink: 0,
        }}
      >
        {/* LOGO */}
        <div
          style={{
            padding: "22px 20px 18px",
            borderBottom: `1px solid ${bdr}`,
          }}
        >
          <div
            style={{
              fontSize: 22,
              fontWeight: 900,
              letterSpacing: 5,
              background: "linear-gradient(90deg,#c4b5fd,#a78bfa,#7c3aed)",
              WebkitBackgroundClip: "text",
              WebkitTextFillColor: "transparent",
              backgroundClip: "text", 
              display: "inline-block", 
            }}
          >
            WEARN
          </div>
          <div
            style={{
              fontSize: 9,
              letterSpacing: 2.5,
              color: "#7c3aed",
              marginTop: 3,
              fontWeight: 600,
            }}
          >
            MERCHANT PORTAL
          </div>
        </div>

        {/* NAV */}
        <div style={{ padding: "12px 0 4px" }}>
          <div
            style={{
              padding: "8px 0 4px 20px",
              fontSize: 9,
              letterSpacing: 1.5,
              color: muted,
              fontWeight: 600,
            }}
          >
            ҮНДСЭН
          </div>
          {NAV.map((n) => (
            <button
              key={n.id}
              onClick={() => setTab(n.id)}
              style={{
                display: "flex",
                alignItems: "center",
                gap: 10,
                padding: "10px 20px",
                fontSize: 13,
                color: tab === n.id ? txt : muted,
                background: tab === n.id ? "#7c3aed18" : "transparent",
                border: "none",
                borderLeft: `3px solid ${tab === n.id ? "#7c3aed" : "transparent"}`,
                width: "100%",
                textAlign: "left",
                cursor: "pointer",
              }}
            >
              {n.icon(tab === n.id, dark)}
              {n.label}
              {n.badge && pendingCount > 0 && (
                <span
                  style={{
                    marginLeft: "auto",
                    background: "#f59e0b22",
                    color: "#f59e0b",
                    fontSize: 9,
                    padding: "1px 6px",
                    borderRadius: 10,
                    fontWeight: 700,
                  }}
                >
                  {pendingCount}
                </span>
              )}
            </button>
          ))}
        </div>

        {/* TYPE LEGEND */}
        <div
          style={{
            margin: "12px 16px",
            padding: "12px 14px",
            background: dark ? "#1a1a2e" : "#f0fdf4",
            borderRadius: 10,
            border: `1px solid ${bdr}`,
          }}
        >
          <div
            style={{
              fontSize: 9,
              letterSpacing: 1.5,
              color: muted,
              fontWeight: 600,
              marginBottom: 10,
            }}
          >
            УРАМШУУЛЛЫН ТӨРӨЛ
          </div>
          {Object.entries(TYPE_CONFIG).map(([key, c]) => (
            <div
              key={key}
              style={{
                display: "flex",
                alignItems: "center",
                gap: 8,
                marginBottom: 6,
              }}
            >
              <div
                style={{
                  width: 8,
                  height: 8,
                  borderRadius: "50%",
                  background: c.color,
                  flexShrink: 0,
                }}
              />
              <span style={{ fontSize: 11, color: c.color, fontWeight: 600 }}>
                {c.label}
              </span>
            </div>
          ))}
        </div>

        {/* SIDEBAR USER */}
        <div
          style={{
            marginTop: "auto",
            padding: "14px 16px",
            borderTop: `1px solid ${bdr}`,
          }}
        >
          <div
            onClick={() => setShowSideProfile(!showSideProfile)}
            style={{
              display: "flex",
              alignItems: "center",
              gap: 10,
              padding: "8px 10px",
              background: dark ? "#1a1a2e" : "#f0fdf4",
              borderRadius: 10,
              marginBottom: 10,
              cursor: "pointer",
            }}
          >
            <div
              style={{
                width: 30,
                height: 30,
                borderRadius: "50%",
                background: "linear-gradient(135deg,#7c3aed,#4f46e5)",
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                fontSize: 11,
                fontWeight: 800,
                color: "#fff",
                flexShrink: 0,
              }}
            >
              M
            </div>
            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{ fontSize: 12, color: txt, fontWeight: 600 }}>
                Merchant
              </div>
              <div
                style={{
                  fontSize: 10,
                  color: muted,
                  overflow: "hidden",
                  textOverflow: "ellipsis",
                  whiteSpace: "nowrap",
                }}
              >
                merchant@wearn.me
              </div>
            </div>
            <svg width="12" height="12" viewBox="0 0 12 12" fill="none">
              <path
                d={showSideProfile ? "M2 8l4-4 4 4" : "M2 4l4 4 4-4"}
                stroke={muted}
                strokeWidth="1.5"
                strokeLinecap="round"
              />
            </svg>
          </div>

          {/* SIDE PROFILE POPUP */}
          {showSideProfile && (
            <div
              style={{
                background: dark ? "#1a1a2e" : "#f9f9f9",
                border: `1px solid ${bdr}`,
                borderRadius: 10,
                padding: "12px 14px",
                marginBottom: 10,
                fontSize: 12,
              }}
            >
              <div style={{ color: muted, fontSize: 10, marginBottom: 6 }}>
                ДЭЛГЭРЭНГҮЙ
              </div>
              <div style={{ color: txt, marginBottom: 4 }}>
                📧 merchant@wearn.me
              </div>
              <div style={{ color: muted, fontSize: 11 }}>{today}</div>
            </div>
          )}

          <button
            onClick={logout}
            style={{
              width: "100%",
              padding: 8,
              background: "transparent",
              border: `1px solid ${bdr}`,
              borderRadius: 8,
              color: muted,
              fontSize: 12,
              cursor: "pointer",
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
          minWidth: 0,
        }}
      >
        {/* TOPBAR */}
        <div
          style={{
            height: 54,
            background: sb,
            borderBottom: `1px solid ${bdr}`,
            display: "flex",
            alignItems: "center",
            justifyContent: "space-between",
            padding: "0 24px",
            flexShrink: 0,
          }}
        >
          <div>
            <div style={{ fontSize: 17, fontWeight: 700, color: txt }}>
              {NAV.find((n) => n.id === tab)?.label}
            </div>
            <div style={{ fontSize: 11, color: muted, marginTop: 1 }}>
              {today}
            </div>
          </div>
          <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
            {/* THEME TOGGLE */}
            <button
              onClick={() => setDark(!dark)}
              style={{
                width: 36,
                height: 36,
                borderRadius: "50%",
                background: dark ? "#1a1a2e" : "#e5e5ea",
                border: `1px solid ${bdr}`,
                cursor: "pointer",
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
              }}
            >
              {dark ? (
                <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                  <path
                    d="M8 1v1M8 14v1M1 8H0M16 8h-1M2.9 2.9l.7.7M12.4 12.4l.7.7M2.9 13.1l.7-.7M12.4 3.6l.7-.7"
                    stroke="#f59e0b"
                    strokeWidth="1.5"
                    strokeLinecap="round"
                  />
                  <circle
                    cx="8"
                    cy="8"
                    r="3"
                    stroke="#f59e0b"
                    strokeWidth="1.5"
                  />
                </svg>
              ) : (
                <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                  <path
                    d="M13 8.5A5.5 5.5 0 0 1 7.5 14 5.5 5.5 0 0 1 2 8.5 5.5 5.5 0 0 1 7.5 3c-.5 1-.8 2.1-.8 3.2A5.3 5.3 0 0 0 12 11.5c.6-.9.9-2 1-3z"
                    stroke="#555"
                    strokeWidth="1.5"
                    strokeLinejoin="round"
                  />
                </svg>
              )}
            </button>

            {/* TOPBAR AVATAR */}
            <div style={{ position: "relative" }}>
              <div
                onClick={() => setShowTopProfile(!showTopProfile)}
                style={{
                  width: 34,
                  height: 34,
                  borderRadius: "50%",
                  background: "linear-gradient(135deg,#7c3aed,#4f46e5)",
                  display: "flex",
                  alignItems: "center",
                  justifyContent: "center",
                  fontSize: 12,
                  fontWeight: 800,
                  color: "#fff",
                  cursor: "pointer",
                }}
              >
                M
              </div>

              {/* TOP PROFILE DROPDOWN */}
              {showTopProfile && (
                <div
                  style={{
                    position: "absolute",
                    top: 44,
                    right: 0,
                    width: 220,
                    background: sb,
                    border: `1px solid ${bdr}`,
                    borderRadius: 12,
                    padding: 16,
                    zIndex: 100,
                    boxShadow: "0 8px 32px rgba(0,0,0,0.3)",
                  }}
                >
                  <div
                    style={{
                      display: "flex",
                      alignItems: "center",
                      gap: 10,
                      marginBottom: 12,
                    }}
                  >
                    <div
                      style={{
                        width: 36,
                        height: 36,
                        borderRadius: "50%",
                        background: "linear-gradient(135deg,#7c3aed,#4f46e5)",
                        display: "flex",
                        alignItems: "center",
                        justifyContent: "center",
                        fontSize: 14,
                        fontWeight: 800,
                        color: "#fff",
                      }}
                    >
                      M
                    </div>
                    <div>
                      <div
                        style={{ fontSize: 13, color: txt, fontWeight: 700 }}
                      >
                        Merchant
                      </div>
                      <div style={{ fontSize: 11, color: "#7c3aed" }}>
                        MERCHANT
                      </div>
                    </div>
                  </div>
                  <div
                    style={{
                      borderTop: `1px solid ${bdr}`,
                      paddingTop: 10,
                      fontSize: 12,
                      color: muted,
                    }}
                  >
                    <div style={{ marginBottom: 6 }}>📧 merchant@wearn.me</div>
                    <div>📅 {today}</div>
                  </div>
                  <button
                    onClick={logout}
                    style={{
                      marginTop: 12,
                      width: "100%",
                      padding: "8px",
                      background: "#ef444422",
                      border: "1px solid #ef444444",
                      borderRadius: 8,
                      color: "#ef4444",
                      fontSize: 12,
                      cursor: "pointer",
                      fontWeight: 600,
                    }}
                  >
                    Гарах
                  </button>
                </div>
              )}
            </div>
          </div>
        </div>

        {/* CONTENT */}
        <div
          style={{
            flex: 1,
            overflowY: "auto",
            padding: "20px 24px",
            background: bg,
          }}
        >
          {tab === "overview" && (
            <MerchantOverview
              dark={dark}
              cardBg={cardBg}
              bdr={bdr}
              txt={txt}
              muted={muted}
            />
          )}
          {tab === "rewards" && (
            <MyRewards
              dark={dark}
              cardBg={cardBg}
              bdr={bdr}
              txt={txt}
              muted={muted}
              typeConfig={TYPE_CONFIG}
            />
          )}
          {tab === "redemptions" && (
            <PendingRedemptions
              dark={dark}
              cardBg={cardBg}
              bdr={bdr}
              txt={txt}
              muted={muted}
              onCount={setPendingCount}
            />
          )}
        </div>
      </div>
    </div>
  );
}
