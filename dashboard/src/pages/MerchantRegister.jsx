import { useState } from "react";
import { useNavigate } from "react-router-dom";
import api from "../api/axios";

export default function MerchantRegister() {
  const [form, setForm] = useState({ name: "", email: "", password: "", secret: "" });
  const [error, setError] = useState("");
  const [success, setSuccess] = useState(false);
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  async function handleSubmit(e) {
    e.preventDefault();
    setLoading(true);
    setError("");

    try {
      await api.post("/auth/merchant/register", form);
      setSuccess(true);
      setTimeout(() => navigate("/login"), 2000);
    } catch (err) {
      setError(err.response?.data?.error || "Алдаа гарлаа");
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
        background: "#111", border: "1px solid #1e1e1e",
        borderRadius: 16, padding: "40px 36px", width: 400,
      }}>
        <h1 style={{
          color: "#fff", fontSize: 24, fontWeight: 900,
          letterSpacing: 3, textAlign: "center", marginBottom: 6,
        }}>WEARN</h1>
        <p style={{
          color: "#1D9E75", textAlign: "center",
          fontSize: 11, letterSpacing: 2, marginBottom: 28,
        }}>MERCHANT БҮРТГЭЛ</p>

        {success ? (
          <div style={{
            textAlign: "center", padding: 20,
            color: "#1D9E75", fontSize: 15,
          }}>
            Бүртгэл амжилттай! Login хуудас руу шилжиж байна...
          </div>
        ) : (
          <form onSubmit={handleSubmit}>
            {[
              { key: "name", label: "Байгууллагын нэр", type: "text", placeholder: "Wearn Coffee" },
              { key: "email", label: "И-мэйл", type: "email", placeholder: "merchant@gmail.com" },
              { key: "password", label: "Нууц үг", type: "password", placeholder: "••••••••" },
              { key: "secret", label: "Нууц код", type: "password", placeholder: "Adminаас авсан код" },
            ].map(f => (
              <div key={f.key} style={{ marginBottom: 16 }}>
                <label style={{ color: "#666", fontSize: 12 }}>{f.label}</label>
                <input
                  type={f.type}
                  value={form[f.key]}
                  placeholder={f.placeholder}
                  onChange={e => setForm({ ...form, [f.key]: e.target.value })}
                  required
                  style={{
                    display: "block", width: "100%", marginTop: 6,
                    padding: "10px 14px", background: "#1a1a1a",
                    border: "1px solid #2a2a2a", borderRadius: 10,
                    color: "#fff", fontSize: 14, boxSizing: "border-box",
                  }}
                />
              </div>
            ))}

            {error && (
              <p style={{ color: "#ff4444", fontSize: 13, marginBottom: 16 }}>{error}</p>
            )}

            <button type="submit" disabled={loading} style={{
              width: "100%", padding: "12px",
              background: "#1D9E75", border: "none",
              borderRadius: 10, color: "#fff",
              fontSize: 15, fontWeight: 700,
              cursor: loading ? "not-allowed" : "pointer",
              opacity: loading ? 0.7 : 1,
              marginTop: 8,
            }}>
              {loading ? "Бүртгэж байна..." : "Бүртгүүлэх"}
            </button>

            <p style={{
              color: "#555", fontSize: 11,
              textAlign: "center", marginTop: 16,
            }}>
              Нууц кодыг зөвхөн WEARN админаас авна
            </p>
          </form>
        )}
      </div>
    </div>
  );
}