import { useEffect, useState } from "react";
import api from "../../../api/axios";
import { useTheme } from "../../../context/ThemeContext";

export default function Merchants() {
  const { theme } = useTheme();
  const [merchants, setMerchants] = useState([]);
  const [loading, setLoading]     = useState(true);

  useEffect(() => { fetchData(); }, []);

  async function fetchData() {
    setLoading(true);
    try {
      const res = await api.get("/admin/merchants");
      setMerchants(res.data.merchants || []);
    } finally {
      setLoading(false);
    }
  }

  async function toggle(id) {
    try {
      const res = await api.put(`/admin/merchants/${id}/toggle`);
      setMerchants(prev => prev.map(m =>
        m.id === id ? { ...m, is_active: res.data.is_active } : m
      ));
    } catch (e) {
      alert("Алдаа гарлаа");
    }
  }

  return (
    <div>

      {loading ? (
        <div style={{ color: theme.sub }}>Уншиж байна...</div>
      ) : (
        <div style={{ background: theme.card, borderRadius: 16,
                      border: `1px solid ${theme.border}`, overflow: "hidden" }}>
          <table style={{ width: "100%", borderCollapse: "collapse" }}>
            <thead>
              <tr style={{ borderBottom: `1px solid ${theme.border}` }}>
                {["ID", "НЭР", "И-МЭЙЛ", "УРАМШУУЛАЛ",
                  "БҮРТГЭГДСЭН", "ТӨЛӨВ", ""].map(h => (
                  <th key={h} style={{
                    padding: "12px 16px", textAlign: "left",
                    fontSize: 10, letterSpacing: 1.5,
                    color: theme.sub, fontWeight: 600,
                  }}>{h}</th>
                ))}
              </tr>
            </thead>
            <tbody>
              {merchants.map(m => (
                <tr key={m.id}
                  style={{ borderBottom: `1px solid ${theme.border}` }}
                  onMouseEnter={e => e.currentTarget.style.background = theme.bg}
                  onMouseLeave={e => e.currentTarget.style.background = "transparent"}>
                  <td style={{ padding: "12px 16px", color: theme.sub, fontSize: 13 }}>
                    {m.id}
                  </td>
                  <td style={{ padding: "12px 16px" }}>
                    <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
                      <div style={{
                        width: 32, height: 32, borderRadius: 8,
                        background: "#D1FAE5", display: "flex",
                        alignItems: "center", justifyContent: "center",
                        fontSize: 13, fontWeight: 700, color: "#059669",
                      }}>
                        {(m.name || "M")[0].toUpperCase()}
                      </div>
                      <span style={{ color: theme.text, fontSize: 14,
                                     fontWeight: 500 }}>
                        {m.name || "—"}
                      </span>
                    </div>
                  </td>
                  <td style={{ padding: "12px 16px", color: theme.sub, fontSize: 13 }}>
                    {m.email}
                  </td>
                  <td style={{ padding: "12px 16px" }}>
                    <span style={{
                      background: "#EDE8FF", color: "#6B3EF5",
                      padding: "3px 10px", borderRadius: 20,
                      fontSize: 12, fontWeight: 600,
                    }}>
                      {m.reward_count} урамшуулал
                    </span>
                  </td>
                  <td style={{ padding: "12px 16px", color: theme.sub, fontSize: 12 }}>
                    {m.created_at?.slice(0, 10)}
                  </td>
                  <td style={{ padding: "12px 16px" }}>
                    <span style={{
                      background: m.is_active ? "#DCFCE7" : "#F3F4F6",
                      color: m.is_active ? "#15803D" : "#9CA3AF",
                      padding: "4px 12px", borderRadius: 20,
                      fontSize: 12, fontWeight: 600,
                    }}>
                      {m.is_active ? "Идэвхтэй" : "Идэвхгүй"}
                    </span>
                  </td>
                  <td style={{ padding: "12px 16px" }}>
                    <button onClick={() => toggle(m.id)} style={{
                      padding: "6px 14px", borderRadius: 8, fontSize: 12,
                      background: m.is_active ? "#FEF2F2" : "#DCFCE7",
                      border: "none", cursor: "pointer", fontWeight: 600,
                      color: m.is_active ? "#DC2626" : "#15803D",
                    }}>
                      {m.is_active ? "Хаах" : "Идэвхжүүлэх"}
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}