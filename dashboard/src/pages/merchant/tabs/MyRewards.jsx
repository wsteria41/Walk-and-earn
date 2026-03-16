import { useEffect, useState } from "react";
import api from "../../../api/axios";

export default function MyRewards() {
  const [rewards, setRewards] = useState([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [form, setForm] = useState({ name: "", description: "", required_points: "", stock_limit: "" });
  const [saving, setSaving] = useState(false);

  useEffect(() => { loadRewards(); }, []);

  function loadRewards() {
    api.get("/rewards/my-rewards").then(res => {
      setRewards(res.data.rewards);
      setLoading(false);
    });
  }

  async function handleCreate(e) {
    e.preventDefault();
    setSaving(true);
    try {
      await api.post("/rewards/create", {
        name: form.name,
        description: form.description,
        required_points: Number(form.required_points),
        stock_limit: Number(form.stock_limit),
      });
      setForm({ name: "", description: "", required_points: "", stock_limit: "" });
      setShowForm(false);
      loadRewards();
    } catch (err) {
      alert(err.response?.data?.error || "Алдаа гарлаа");
    } finally {
      setSaving(false);
    }
  }

  if (loading) return <p style={{ color: "#666" }}>Уншиж байна...</p>;

  return (
    <div>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 24 }}>
        <h2 style={{ fontSize: 22, fontWeight: 700 }}>Урамшуулалууд</h2>
        <button onClick={() => setShowForm(!showForm)} style={{
          padding: "10px 20px", background: "#1D9E75",
          border: "none", borderRadius: 8, color: "#fff",
          fontSize: 14, fontWeight: 600, cursor: "pointer",
        }}>
          {showForm ? "Болих" : "+ Шинэ урамшуулал"}
        </button>
      </div>

      {/* CREATE FORM */}
      {showForm && (
        <form onSubmit={handleCreate} style={{
          background: "#111", border: "1px solid #1e1e1e",
          borderRadius: 12, padding: 24, marginBottom: 24,
        }}>
          <h3 style={{ marginBottom: 16, color: "#fff", fontSize: 16 }}>Шинэ урамшуулал үүсгэх</h3>
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 16 }}>
            {[
              { key: "name", label: "Нэр", type: "text" },
              { key: "description", label: "Тайлбар", type: "text" },
              { key: "required_points", label: "Шаардлагатай оноо", type: "number" },
              { key: "stock_limit", label: "Нөөц тоо", type: "number" },
            ].map(f => (
              <div key={f.key}>
                <label style={{ color: "#666", fontSize: 12 }}>{f.label}</label>
                <input
                  type={f.type}
                  value={form[f.key]}
                  onChange={e => setForm({ ...form, [f.key]: e.target.value })}
                  required
                  style={{
                    display: "block", width: "100%", marginTop: 6,
                    padding: "10px 14px", background: "#1a1a1a",
                    border: "1px solid #2a2a2a", borderRadius: 8,
                    color: "#fff", fontSize: 14, boxSizing: "border-box",
                  }}
                />
              </div>
            ))}
          </div>
          <button type="submit" disabled={saving} style={{
            marginTop: 16, padding: "10px 24px",
            background: "#1D9E75", border: "none",
            borderRadius: 8, color: "#fff",
            fontSize: 14, fontWeight: 600, cursor: "pointer",
          }}>
            {saving ? "Хадгалж байна..." : "Хадгалах"}
          </button>
        </form>
      )}

      {/* REWARDS LIST */}
      <div style={{ background: "#111", border: "1px solid #1e1e1e", borderRadius: 12, overflow: "hidden" }}>
        <table style={{ width: "100%", borderCollapse: "collapse" }}>
          <thead>
            <tr style={{ background: "#1a1a1a" }}>
              {["Нэр", "Тайлбар", "Оноо", "Нөөц", "Үлдсэн", "Төлөв"].map(h => (
                <th key={h} style={{ padding: "12px 16px", textAlign: "left", color: "#666", fontSize: 12 }}>{h}</th>
              ))}
            </tr>
          </thead>
          <tbody>
            {rewards.length === 0 ? (
              <tr><td colSpan={6} style={{ padding: 24, textAlign: "center", color: "#555" }}>Урамшуулал байхгүй</td></tr>
            ) : rewards.map((r, i) => (
              <tr key={r.id} style={{ borderTop: "1px solid #1e1e1e", background: i % 2 === 0 ? "#111" : "#0f0f0f" }}>
                <td style={{ padding: "12px 16px", color: "#fff", fontWeight: 600 }}>{r.name}</td>
                <td style={{ padding: "12px 16px", color: "#888", fontSize: 13 }}>{r.description}</td>
                <td style={{ padding: "12px 16px", color: "#1D9E75", fontWeight: 700 }}>{r.required_points}</td>
                <td style={{ padding: "12px 16px", color: "#888" }}>{r.stock_limit}</td>
                <td style={{ padding: "12px 16px", color: "#fff" }}>{r.remaining_stock}</td>
                <td style={{ padding: "12px 16px" }}>
                  <span style={{
                    padding: "3px 10px", borderRadius: 20, fontSize: 11, fontWeight: 600,
                    color: r.is_active ? "#22c55e" : "#ef4444",
                    background: r.is_active ? "#22c55e22" : "#ef444422",
                  }}>{r.is_active ? "Идэвхтэй" : "Идэвхгүй"}</span>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}