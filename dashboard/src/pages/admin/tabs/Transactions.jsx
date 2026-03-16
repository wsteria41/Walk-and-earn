import { useEffect, useState } from "react";
import api from "../../../api/axios";

const statusColor = {
  PENDING: "#f59e0b",
  APPROVED: "#22c55e",
  REJECTED: "#ef4444",
};

export default function Transactions() {
  const [list, setList] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    api.get("/admin/transactions").then(res => {
      setList(res.data.transactions);
      setLoading(false);
    });
  }, []);

  if (loading) return <p style={{ color: "#666" }}>Уншиж байна...</p>;

  return (
    <div>
      <h2 style={{ fontSize: 22, fontWeight: 700, marginBottom: 24 }}>Гүйлгээнүүд</h2>
      <div style={{ background: "#111", border: "1px solid #1e1e1e", borderRadius: 12, overflow: "hidden" }}>
        <table style={{ width: "100%", borderCollapse: "collapse" }}>
          <thead>
            <tr style={{ background: "#1a1a1a" }}>
              {["ID", "Хэрэглэгч", "Урамшуулал", "Оноо", "Төлөв", "Огноо"].map(h => (
                <th key={h} style={{ padding: "12px 16px", textAlign: "left", color: "#666", fontSize: 12 }}>{h}</th>
              ))}
            </tr>
          </thead>
          <tbody>
            {list.map((t, i) => (
              <tr key={t.id} style={{ borderTop: "1px solid #1e1e1e", background: i % 2 === 0 ? "#111" : "#0f0f0f" }}>
                <td style={{ padding: "12px 16px", color: "#666", fontSize: 13 }}>{t.id}</td>
                <td style={{ padding: "12px 16px", color: "#fff", fontSize: 14 }}>{t.user_name}</td>
                <td style={{ padding: "12px 16px", color: "#888", fontSize: 13 }}>{t.reward_name}</td>
                <td style={{ padding: "12px 16px", color: "#7B2FFF", fontWeight: 700 }}>{t.points_used}</td>
                <td style={{ padding: "12px 16px" }}>
                  <span style={{
                    padding: "3px 10px", borderRadius: 20, fontSize: 11, fontWeight: 600,
                    color: statusColor[t.status], background: statusColor[t.status] + "22",
                  }}>{t.status}</span>
                </td>
                <td style={{ padding: "12px 16px", color: "#555", fontSize: 12 }}>{t.redeemed_at?.split("T")[0]}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}