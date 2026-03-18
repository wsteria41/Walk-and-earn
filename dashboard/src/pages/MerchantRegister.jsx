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
      minHeight: "100vh",
      background: "#f6f8fb",
      display: "flex",
      alignItems: "center",
      justifyContent: "center",
    }}>
      <div style={{
        background: "#fff",
        border: "1px solid #e5e7eb",
        borderRadius: 20,
        padding: "40px 36px",
        width: 400,
        boxShadow: "0 10px 30px rgba(0,0,0,0.05)",
      }}>
        <h1 style={{
          color: "#111",
          fontSize: 26,
          fontWeight: 900,
          letterSpacing: 2,
          textAlign: "center",
          marginBottom: 6,
        }}>WEARN</h1>

        <p style={{
          color: "#1D9E75",
          textAlign: "center",
          fontSize: 12,
          letterSpacing: 2,
          marginBottom: 28,
          fontWeight: 600
        }}>
          MERCHANT БҮРТГЭЛ
        </p>

        {success ? (
          <div style={{
            textAlign: "center",
            padding: 20,
            color: "#1D9E75",
            fontSize: 15,
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
              <div key={f.key} style={{ marginBottom: 18 }}>
                <label style={{
                  color: "#374151",
                  fontSize: 12,
                  fontWeight: 500
                }}>
                  {f.label}
                </label>

                <input
                  type={f.type}
                  value={form[f.key]}
                  placeholder={f.placeholder}
                  onChange={e => setForm({ ...form, [f.key]: e.target.value })}
                  required
                  style={{
                    display: "block",
                    width: "100%",
                    marginTop: 6,
                    padding: "12px 14px",
                    background: "#f9fafb",
                    border: "1px solid #e5e7eb",
                    borderRadius: 10,
                    color: "#111",
                    fontSize: 14,
                    boxSizing: "border-box",
                    outline: "none",
                  }}
                />
              </div>
            ))}

            {error && (
              <p style={{
                color: "#dc2626",
                fontSize: 13,
                marginBottom: 16
              }}>
                {error}
              </p>
            )}

            <button
              type="submit"
              disabled={loading}
              style={{
                width: "100%",
                padding: "13px",
                background: "#1D9E75",
                border: "none",
                borderRadius: 12,
                color: "#fff",
                fontSize: 15,
                fontWeight: 700,
                cursor: loading ? "not-allowed" : "pointer",
                opacity: loading ? 0.7 : 1,
                marginTop: 10,
                transition: "0.2s",
              }}
            >
              {loading ? "Бүртгэж байна..." : "Бүртгүүлэх"}
            </button>

            <p style={{
              color: "#6b7280",
              fontSize: 11,
              textAlign: "center",
              marginTop: 16,
            }}>
              Нууц кодыг зөвхөн WEARN админаас авна
            </p>
          </form>
        )}
      </div>
    </div>
  );
}