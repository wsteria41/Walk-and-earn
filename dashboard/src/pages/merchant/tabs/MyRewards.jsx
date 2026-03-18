import { useEffect, useState } from "react";
import axios from "axios";
import api from "../../../api/axios";

export default function MyRewards() {
  const [rewards, setRewards] = useState([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [form, setForm] = useState({
    name: "", description: "", required_points: "",
    stock_limit: "", discount_percent: "", reward_type: "DISCOUNT"
  });
  const [imageFile, setImageFile] = useState(null);
  const [imagePreview, setImagePreview] = useState(null);
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
      let imageUrl = null;

      if (imageFile) {
        const formData = new FormData();
        formData.append("image", imageFile);
        const uploadRes = await axios.post(
          "https://wearn.me/rewards/upload-image",
          formData,
          {
            headers: {
              "Content-Type": "multipart/form-data",
              Authorization: `Bearer ${localStorage.getItem("token")}`,
            },
          }
        );
        imageUrl = uploadRes.data.url;
      }

      await api.post("/rewards/create", {
        name: form.name,
        description: form.description,
        required_points: Number(form.required_points),
        stock_limit: Number(form.stock_limit),
        discount_percent: form.discount_percent ? Number(form.discount_percent) : null,
        reward_type: form.reward_type,
        image_url: imageUrl,
      });

      setForm({ name: "", description: "", required_points: "", stock_limit: "", discount_percent: "", reward_type: "DISCOUNT" });
      setImageFile(null);
      setImagePreview(null);
      setShowForm(false);
      loadRewards();
    } catch (err) {
      alert(err.response?.data?.error || "Алдаа гарлаа");
    } finally {
      setSaving(false);
    }
  }

  const typeLabel = { DISCOUNT: "Хөнгөлөлт", VOUCHER: "Ваучер", FREEBIE: "Үнэгүй" };
  const typeColor = { DISCOUNT: "#1D9E75", VOUCHER: "#a78bfa", FREEBIE: "#f59e0b" };

  if (loading) return <p style={{ color: "#666" }}>Уншиж байна...</p>;

  return (
    <div>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 24 }}>
        <h2 style={{ fontSize: 22, fontWeight: 700 }}>Урамшуулалууд</h2>
        <button onClick={() => setShowForm(!showForm)} style={{
          padding: "10px 20px", background: showForm ? "#1a1a1a" : "#1D9E75",
          border: showForm ? "1px solid #2a2a2a" : "none",
          borderRadius: 8, color: "#fff", fontSize: 14, fontWeight: 600, cursor: "pointer",
        }}>
          {showForm ? "Болих" : "+ Шинэ урамшуулал"}
        </button>
      </div>

      {/* FORM */}
      {showForm && (
        <form onSubmit={handleCreate} style={{
          background: "#111", border: "1px solid #1e1e1e",
          borderRadius: 12, padding: 24, marginBottom: 24,
        }}>
          <h3 style={{ marginBottom: 16, color: "#fff", fontSize: 16 }}>Шинэ урамшуулал үүсгэх</h3>
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 16 }}>

            {[
              { key: "name", label: "Нэр", type: "text", placeholder: "10% хөнгөлөлт" },
              { key: "description", label: "Тайлбар", type: "text", placeholder: "Бүх бараанд 10% хөнгөлөлт" },
              { key: "required_points", label: "Шаардлагатай оноо", type: "number", placeholder: "50" },
              { key: "stock_limit", label: "Нөөц тоо", type: "number", placeholder: "100" },
              { key: "discount_percent", label: "Хөнгөлөлтийн хувь (%)", type: "number", placeholder: "10" },
            ].map(f => (
              <div key={f.key}>
                <label style={{ color: "#666", fontSize: 12 }}>{f.label}</label>
                <input
                  type={f.type} value={form[f.key]}
                  placeholder={f.placeholder}
                  onChange={e => setForm({ ...form, [f.key]: e.target.value })}
                  style={{
                    display: "block", width: "100%", marginTop: 6,
                    padding: "10px 14px", background: "#1a1a1a",
                    border: "1px solid #2a2a2a", borderRadius: 8,
                    color: "#fff", fontSize: 14, boxSizing: "border-box",
                  }}
                />
              </div>
            ))}

            {/* REWARD TYPE */}
            <div>
              <label style={{ color: "#666", fontSize: 12 }}>Төрөл</label>
              <select
                value={form.reward_type}
                onChange={e => setForm({ ...form, reward_type: e.target.value })}
                style={{
                  display: "block", width: "100%", marginTop: 6,
                  padding: "10px 14px", background: "#1a1a1a",
                  border: "1px solid #2a2a2a", borderRadius: 8,
                  color: "#fff", fontSize: 14, boxSizing: "border-box",
                }}
              >
                <option value="DISCOUNT">Хөнгөлөлт (%)</option>
                <option value="VOUCHER">Ваучер</option>
                <option value="FREEBIE">Үнэгүй бараа</option>
              </select>
            </div>

            {/* IMAGE UPLOAD */}
            <div style={{ gridColumn: "1 / -1" }}>
              <label style={{ color: "#666", fontSize: 12 }}>Зураг (заавал биш)</label>
              <div style={{
                marginTop: 6, border: "1px dashed #2a2a2a", borderRadius: 8,
                padding: 16, textAlign: "center", cursor: "pointer",
                position: "relative", background: "#1a1a1a",
              }}>
                {imagePreview ? (
                  <img src={imagePreview} style={{ height: 80, borderRadius: 8, objectFit: "cover" }} />
                ) : (
                  <div style={{ color: "#444", fontSize: 13 }}>Зураг сонгохын тулд дарна уу</div>
                )}
                <input
                  type="file" accept="image/*"
                  onChange={e => {
                    const f = e.target.files[0];
                    if (f) { setImageFile(f); setImagePreview(URL.createObjectURL(f)); }
                  }}
                  style={{ position: "absolute", inset: 0, opacity: 0, cursor: "pointer", width: "100%" }}
                />
              </div>
            </div>
          </div>

          <button type="submit" disabled={saving} style={{
            marginTop: 16, padding: "10px 24px", background: "#1D9E75",
            border: "none", borderRadius: 8, color: "#fff",
            fontSize: 14, fontWeight: 600, cursor: "pointer",
          }}>
            {saving ? "Хадгалж байна..." : "Хадгалах"}
          </button>
        </form>
      )}

      {/* LIST */}
      <div style={{ display: "flex", flexDirection: "column", gap: 12 }}>
        {rewards.length === 0 ? (
          <p style={{ color: "#555", textAlign: "center", padding: 40 }}>Урамшуулал байхгүй</p>
        ) : rewards.map(r => (
          <div key={r.id} style={{
            background: "#111", border: "1px solid #1e1e1e",
            borderRadius: 12, padding: 16,
            display: "flex", alignItems: "center", gap: 16,
          }}>
            {/* IMAGE / ICON */}
            {r.image_url ? (
              <img src={r.image_url} style={{ width: 64, height: 64, borderRadius: 10, objectFit: "cover", flexShrink: 0 }} />
            ) : (
              <div style={{
                width: 64, height: 64, borderRadius: 10, flexShrink: 0,
                background: (typeColor[r.reward_type] || "#a78bfa") + "22",
                border: `1px solid ${(typeColor[r.reward_type] || "#a78bfa")}44`,
                display: "flex", alignItems: "center", justifyContent: "center",
                fontSize: 22,
              }}>
                {r.reward_type === "DISCOUNT" ? "%" : r.reward_type === "FREEBIE" ? "🎁" : "🎫"}
              </div>
            )}

            {/* INFO */}
            <div style={{ flex: 1 }}>
              <div style={{ display: "flex", alignItems: "center", gap: 8, marginBottom: 4 }}>
                <span style={{ color: "#fff", fontWeight: 700, fontSize: 15 }}>{r.name}</span>
                <span style={{
                  fontSize: 10, padding: "2px 8px", borderRadius: 10, fontWeight: 600,
                  color: typeColor[r.reward_type], background: typeColor[r.reward_type] + "22",
                  border: `1px solid ${typeColor[r.reward_type]}44`,
                }}>{typeLabel[r.reward_type]}</span>
              </div>
              <div style={{ color: "#666", fontSize: 13, marginBottom: 6 }}>{r.description}</div>
              <div style={{ display: "flex", gap: 16, fontSize: 12 }}>
                <span style={{ color: "#a78bfa" }}>{r.required_points} оноо</span>
                {r.discount_percent && (
                  <span style={{ color: "#1D9E75", fontWeight: 700 }}>{r.discount_percent}% хөнгөлөлт</span>
                )}
                <span style={{ color: "#555" }}>Үлдсэн: {r.remaining_stock}</span>
              </div>
            </div>

            {/* STATUS */}
            <span style={{
              padding: "4px 12px", borderRadius: 20, fontSize: 11, fontWeight: 600,
              color: r.is_active ? "#22c55e" : "#ef4444",
              background: r.is_active ? "#22c55e22" : "#ef444422",
              border: `1px solid ${r.is_active ? "#22c55e44" : "#ef444444"}`,
              flexShrink: 0,
            }}>{r.is_active ? "Идэвхтэй" : "Идэвхгүй"}</span>
          </div>
        ))}
      </div>
    </div>
  );
}