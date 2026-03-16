import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { jwtDecode } from "jwt-decode";
import api from "../api/axios";

export default function LoginPage() {
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
      localStorage.setItem("token", token);

      const decoded = jwtDecode(token);

      if (decoded.role === "ADMIN") {
        navigate("/admin/dashboard");
      } else if (decoded.role === "MERCHANT") {
        navigate("/merchant/dashboard");
      } else {
        setError("Энэ систем зөвхөн Admin болон Merchant-д зориулагдсан");
        localStorage.removeItem("token");
      }
    } catch {
      setError("Нэвтрэх мэдээлэл буруу байна");
    } finally {
      setLoading(false);
    }
  }

  return (
    <div style={{
      minHeight: "100vh",
      background: "#0a0a0a",
      display: "flex",
      alignItems: "center",
      justifyContent: "center",
    }}>
      <div style={{
        background: "#111",
        border: "1px solid #222",
        borderRadius: 16,
        padding: "40px 36px",
        width: 360,
      }}>
        <h1 style={{
          color: "#fff",
          fontSize: 28,
          fontWeight: 900,
          letterSpacing: 4,
          textAlign: "center",
          marginBottom: 6,
        }}>WEARN</h1>
        <p style={{
          color: "#7B2FFF",
          textAlign: "center",
          fontSize: 11,
          letterSpacing: 3,
          marginBottom: 32,
        }}>ADMIN · MERCHANT PORTAL</p>

        <form onSubmit={handleLogin}>
          <div style={{ marginBottom: 16 }}>
            <label style={{ color: "#888", fontSize: 12 }}>И-мэйл</label>
            <input
              type="email"
              value={email}
              onChange={e => setEmail(e.target.value)}
              required
              style={{
                display: "block",
                width: "100%",
                marginTop: 6,
                padding: "10px 14px",
                background: "#1a1a1a",
                border: "1px solid #2a2a2a",
                borderRadius: 10,
                color: "#fff",
                fontSize: 14,
                boxSizing: "border-box",
              }}
            />
          </div>

          <div style={{ marginBottom: 24 }}>
            <label style={{ color: "#888", fontSize: 12 }}>Нууц үг</label>
            <input
              type="password"
              value={password}
              onChange={e => setPassword(e.target.value)}
              required
              style={{
                display: "block",
                width: "100%",
                marginTop: 6,
                padding: "10px 14px",
                background: "#1a1a1a",
                border: "1px solid #2a2a2a",
                borderRadius: 10,
                color: "#fff",
                fontSize: 14,
                boxSizing: "border-box",
              }}
            />
          </div>

          {error && (
            <p style={{ color: "#ff4444", fontSize: 13, marginBottom: 16 }}>
              {error}
            </p>
          )}

          <button
            type="submit"
            disabled={loading}
            style={{
              width: "100%",
              padding: "12px",
              background: "#7B2FFF",
              border: "none",
              borderRadius: 10,
              color: "#fff",
              fontSize: 15,
              fontWeight: 700,
              cursor: loading ? "not-allowed" : "pointer",
              opacity: loading ? 0.7 : 1,
            }}
          >
            {loading ? "Нэвтэрч байна..." : "Нэвтрэх"}
          </button>
        </form>
      </div>
    </div>
  );
}