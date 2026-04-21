import { useState } from "react";
import { useNavigate, Link } from "react-router-dom";
import { jwtDecode } from "jwt-decode";
import api from "../api/axios";

const ROLES = [
  { role: "ADMIN",    label: "Админ",    accent: "#6d28d9", accentLight: "#ede9fe", accentBorder: "#ddd6fe" },
  { role: "MERCHANT", label: "Мерчант",  accent: "#059669", accentLight: "#d1fae5", accentBorder: "#a7f3d0" },
];

export default function LoginPage() {
  const [selectedRole, setSelectedRole] = useState("ADMIN");
  const [email, setEmail]       = useState("");
  const [password, setPassword] = useState("");
  const [error, setError]       = useState("");
  const [loading, setLoading]   = useState(false);
  const navigate = useNavigate();

  const current = ROLES.find(r => r.role === selectedRole);
  const { accent, accentLight, accentBorder } = current;

  async function handleLogin(e) {
    e.preventDefault();
    setLoading(true);
    setError("");
    try {
      const res     = await api.post("/auth/login", { email, password });
      const token   = res.data.token;
      const decoded = jwtDecode(token);
      if (decoded.role !== selectedRole) {
        setError(selectedRole === "ADMIN" ? "Admin эрхгүй байна" : "Merchant эрхгүй байна");
        return;
      }
      localStorage.setItem("token", token);
      navigate(decoded.role === "ADMIN" ? "/admin/dashboard" : "/merchant/dashboard");
    } catch {
      setError("И-мэйл эсвэл нууц үг буруу байна");
    } finally {
      setLoading(false);
    }
  }

  const S = {
    page: {
      minHeight: "100vh",
      background: "#fafaf8",
      display: "flex", alignItems: "center", justifyContent: "center",
      fontFamily: "'DM Sans', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif",
      position: "relative", overflow: "hidden",
      padding: "24px",
    },
    orb1: {
      position: "fixed", top: -120, right: -120,
      width: 500, height: 500, borderRadius: "50%",
      background: "#7c3aed", opacity: 0.07,
      filter: "blur(90px)", pointerEvents: "none",
    },
    orb2: {
      position: "fixed", bottom: -80, left: -80,
      width: 360, height: 360, borderRadius: "50%",
      background: "#059669", opacity: 0.06,
      filter: "blur(80px)", pointerEvents: "none",
    },
    card: {
      width: "100%", maxWidth: 400,
      background: "#ffffff",
      border: "1px solid #e8e8e2",
      borderRadius: 20,
      padding: "40px 36px",
      position: "relative", zIndex: 1,
      boxShadow: "0 4px 40px rgba(0,0,0,0.06)",
    },
    logoWrap: { textAlign: "center", marginBottom: 28 },
    logoIcon: {
      display: "inline-flex", alignItems: "center", justifyContent: "center",
      width: 48, height: 48, borderRadius: 14, marginBottom: 14,
      background: accentLight, border: `1px solid ${accentBorder}`,
      fontSize: 22, transition: "background 0.2s, border-color 0.2s",
    },
    logoText: {
      fontFamily: "'DM Serif Display', serif",
      fontSize: 22, letterSpacing: 4,
      color: "#6d28d9", margin: 0,
    },
    logoSub: {
      color: "#9090a8", fontSize: 10,
      letterSpacing: 2.5, marginTop: 4,
      fontWeight: 500,
    },
    roleWrap: {
      display: "flex",
      background: "#f4f4f0",
      borderRadius: 10, padding: 3,
      marginBottom: 24,
      border: "1px solid #e8e8e2",
    },
    label: {
      color: "#4b4b63", fontSize: 12,
      display: "block", marginBottom: 6, fontWeight: 500,
    },
    input: {
      width: "100%", padding: "10px 14px",
      background: "#fafaf8",
      border: "1px solid #e8e8e2",
      borderRadius: 10, color: "#111118",
      fontSize: 13, boxSizing: "border-box",
      outline: "none", fontFamily: "inherit",
      transition: "border-color 0.2s",
    },
    error: {
      padding: "9px 12px",
      background: "#fef2f2",
      border: "1px solid #fecaca",
      borderRadius: 8,
      color: "#dc2626", fontSize: 12,
      marginBottom: 14,
    },
    submit: {
      width: "100%", padding: "11px",
      background: accent,
      border: "none", borderRadius: 10,
      color: "#fff", fontSize: 14, fontWeight: 600,
      cursor: loading ? "not-allowed" : "pointer",
      opacity: loading ? 0.7 : 1,
      fontFamily: "inherit",
      transition: "background 0.2s, opacity 0.2s",
    },
    backLink: {
      display: "flex", alignItems: "center", justifyContent: "center",
      gap: 6, marginTop: 20,
      fontSize: 12, color: "#9090a8",
      textDecoration: "none", transition: "color 0.2s",
    },
    footer: {
      textAlign: "center", marginTop: 20,
      color: "#c0c0cc", fontSize: 11, letterSpacing: 0.3,
    },
  };

  return (
    <>
      <link
        href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600&family=DM+Serif+Display&display=swap"
        rel="stylesheet"
      />
      <div style={S.page}>
        <div style={S.orb1} />
        <div style={S.orb2} />

        <div style={S.card}>

          {/* LOGO */}
          <div style={S.logoWrap}>
            <div style={S.logoIcon}>👟</div>
            <h1 style={S.logoText}>WEARN</h1>
            <p style={S.logoSub}>MANAGEMENT PORTAL</p>
          </div>

          {/* ROLE TOGGLE */}
          <div style={S.roleWrap}>
            {ROLES.map(r => {
              const active = selectedRole === r.role;
              return (
                <button
                  key={r.role}
                  onClick={() => { setSelectedRole(r.role); setError(""); }}
                  style={{
                    flex: 1, padding: "8px",
                    background: active ? "#fff" : "transparent",
                    border: `1px solid ${active ? "#e8e8e2" : "transparent"}`,
                    borderRadius: 8,
                    color: active ? r.accent : "#9090a8",
                    fontSize: 13, fontWeight: 600,
                    cursor: "pointer", fontFamily: "inherit",
                    transition: "all 0.2s",
                  }}
                >
                  {r.label}
                </button>
              );
            })}
          </div>

          {/* FORM */}
          <form onSubmit={handleLogin}>
            <div style={{ marginBottom: 14 }}>
              <label style={S.label}>И-мэйл</label>
              <input
                type="email" value={email}
                onChange={e => setEmail(e.target.value)}
                required placeholder="email@example.com"
                style={S.input}
                onFocus={e => e.target.style.borderColor = accent}
                onBlur={e  => e.target.style.borderColor = "#e8e8e2"}
              />
            </div>

            <div style={{ marginBottom: 22 }}>
              <label style={S.label}>Нууц үг</label>
              <input
                type="password" value={password}
                onChange={e => setPassword(e.target.value)}
                required placeholder="••••••••"
                style={S.input}
                onFocus={e => e.target.style.borderColor = accent}
                onBlur={e  => e.target.style.borderColor = "#e8e8e2"}
              />
            </div>

            {error && <div style={S.error}>{error}</div>}

            <button type="submit" disabled={loading} style={S.submit}>
              {loading
                ? "Нэвтэрч байна..."
                : `${selectedRole === "ADMIN" ? "Админ" : "Мерчант"} нэвтрэх`}
            </button>
          </form>

          {/* MERCHANT REGISTER */}
          {selectedRole === "MERCHANT" && (
            <p style={{ textAlign: "center", marginTop: 16, color: "#9090a8", fontSize: 12 }}>
              Бүртгэлгүй юу?{" "}
              <Link to="/merchant/register" style={{ color: "#059669", textDecoration: "none", fontWeight: 600 }}>
                Бүртгүүлэх
              </Link>
            </p>
          )}

          {/* BACK */}
          <Link to="/" style={S.backLink}
            onMouseEnter={e => e.currentTarget.style.color = "#6d28d9"}
            onMouseLeave={e => e.currentTarget.style.color = "#9090a8"}
          >
            <svg width="12" height="12" viewBox="0 0 16 16" fill="none">
              <path d="M10 3L5 8l5 5" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"/>
            </svg>
            Нүүр хуудас руу буцах
          </Link>

          <p style={S.footer}>WEARN v1.0 · Walk. Earn. Repeat.</p>
        </div>
      </div>
    </>
  );
}