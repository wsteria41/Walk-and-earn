import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { jwtDecode } from "jwt-decode";
import api from "../api/axios";

export default function LoginPage() {
  const [selectedRole, setSelectedRole] = useState("ADMIN");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  async function handleLogin(e) {
    e.preventDefault();
    setLoading(true);
    setError("");

    try {
      const res = await api.post("/auth/login", { email, password });
      const token = res.data.token;
      const decoded = jwtDecode(token);

      // Сонгосон role-тэй таарч байна уу
      if (decoded.role !== selectedRole) {
        setError(
          selectedRole === "ADMIN"
            ? "Энэ бүртгэл Admin эрхгүй байна"
            : "Энэ бүртгэл Merchant эрхгүй байна"
        );
        return;
      }

      localStorage.setItem("token", token);

      if (decoded.role === "ADMIN") {
        navigate("/admin/dashboard");
      } else {
        navigate("/merchant/dashboard");
      }
    } catch {
      setError("И-мэйл эсвэл нууц үг буруу байна");
    } finally {
      setLoading(false);
    }
  }

  return (
    <div style={{
      minHeight: "100vh", background: "#0a0a0a",
      display: "flex", alignItems: "center", justifyContent: "center",
    }}>
      <div style={{
        background: "#111", border: "1px solid #222",
        borderRadius: 16, padding: "40px 36px", width: 380,
      }}>
        {/* LOGO */}
        <h1 style={{
          color: "#fff", fontSize: 28, fontWeight: 900,
          letterSpacing: 4, textAlign: "center", marginBottom: 6,
        }}>WEARN</h1>
        <p style={{
          color: "#555", textAlign: "center",
          fontSize: 11, letterSpacing: 2, marginBottom: 28,
        }}>MANAGEMENT PORTAL</p>

        {/* ROLE TOGGLE */}
        <div style={{
          display: "flex", background: "#1a1a1a",
          borderRadius: 10, padding: 4, marginBottom: 28,
        }}>
          {["ADMIN", "MERCHANT"].map(role => (
            <button key={role} onClick={() => { setSelectedRole(role); setError(""); }}
              style={{
                flex: 1, padding: "10px",
                background: selectedRole === role ? "#7B2FFF" : "transparent",
                border: "none", borderRadius: 8,
                color: selectedRole === role ? "#fff" : "#666",
                fontSize: 13, fontWeight: 600, cursor: "pointer",
                transition: "all 0.2s",
              }}>
              {role === "ADMIN" ? "Админ" : "Мерчант"}
            </button>
          ))}
        </div>

        {/* FORM */}
        <form onSubmit={handleLogin}>
          <div style={{ marginBottom: 16 }}>
            <label style={{ color: "#666", fontSize: 12 }}>И-мэйл</label>
            <input
              type="email" value={email}
              onChange={e => setEmail(e.target.value)}
              required placeholder="admin@wearn.me"
              style={{
                display: "block", width: "100%", marginTop: 6,
                padding: "10px 14px", background: "#1a1a1a",
                border: "1px solid #2a2a2a", borderRadius: 10,
                color: "#fff", fontSize: 14, boxSizing: "border-box",
              }}
            />
          </div>

          <div style={{ marginBottom: 24 }}>
            <label style={{ color: "#666", fontSize: 12 }}>Нууц үг</label>
            <input
              type="password" value={password}
              onChange={e => setPassword(e.target.value)}
              required placeholder="••••••••"
              style={{
                display: "block", width: "100%", marginTop: 6,
                padding: "10px 14px", background: "#1a1a1a",
                border: "1px solid #2a2a2a", borderRadius: 10,
                color: "#fff", fontSize: 14, boxSizing: "border-box",
              }}
            />
          </div>

          {error && (
            <p style={{ color: "#ff4444", fontSize: 13, marginBottom: 16 }}>
              {error}
            </p>
          )}

          <button type="submit" disabled={loading} style={{
            width: "100%", padding: "12px",
            background: selectedRole === "ADMIN" ? "#7B2FFF" : "#1D9E75",
            border: "none", borderRadius: 10,
            color: "#fff", fontSize: 15, fontWeight: 700,
            cursor: loading ? "not-allowed" : "pointer",
            opacity: loading ? 0.7 : 1,
            transition: "background 0.2s",
          }}>
            {loading ? "Нэвтэрч байна..." : `${selectedRole === "ADMIN" ? "Админ" : "Мерчант"} нэвтрэх`}
          </button>
        </form>
      </div>
    </div>
  );
}