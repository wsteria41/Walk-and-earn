import { useEffect, useState } from "react";
import api from "../../../api/axios";

export default function Suspicious() {
  const [list, setList] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    api.get("/rewards/admin/suspicious").then(res => {
      setList(res.data.suspiciousRecords);
      setLoading(false);
    });
  }, []);

  if (loading) return <p style={{ color: "#666" }}>Уншиж байна...</p>;

  return (
    <div>
      <h2 style={{ fontSize: 22, fontWeight: 700, marginBottom: 24 }}>Сэжигтэй хэрэглэгчид</h2>
      {list.length === 0 ? (
        <p style={{ color: "#666" }}>Сэжигтэй бичлэг байхгүй</p>
      ) : (
        <div style={{ background: "#111", border: "1px solid #ff444422", borderRadius: 12, overflow: "hidden" }}>
          <table style={{ width: "100%", borderCollapse: "collapse" }}>
            <thead>
              <tr style={{ background: "#1a1a1a" }}>
                {["User ID", "Нийт алхалт", "Нэмэгдсэн", "Шалтгаан", "Огноо"].map(h => (
                  <th key={h} style={{ padding: "12px 16px", textAlign: "left", color: "#666", fontSize: 12 }}>{h}</th>
                ))}
              </tr>
            </thead>
            <tbody>
              {list.map((r, i) => (
                <tr key={i} style={{ borderTop: "1px solid #1e1e1e" }}>
                  <td style={{ padding: "12px 16px", color: "#fff" }}>{r.user_id}</td>
                  <td style={{ padding: "12px 16px", color: "#888" }}>{r.total_steps}</td>
                  <td style={{ padding: "12px 16px", color: "#ff6b6b", fontWeight: 700 }}>{r.delta_steps}</td>
                  <td style={{ padding: "12px 16px", color: "#f59e0b", fontSize: 13 }}>{r.suspicion_reason}</td>
                  <td style={{ padding: "12px 16px", color: "#555", fontSize: 12 }}>{r.recorded_at?.split("T")[0]}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}