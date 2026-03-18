import { useEffect, useState } from "react";
import api from "../../../api/axios";

export default function Suspicious({ T }) {
  const [list, setList] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    api.get("/rewards/admin/suspicious").then(res => {
      setList(res.data.suspiciousRecords);
      setLoading(false);
    });
  }, []);

  if (loading) return <p style={{ color: T.textMuted }}>Уншиж байна...</p>;

  return (
    <div>
      {list.length === 0 ? (
        <div style={{ background: T.bgCard, border: `1px solid ${T.border}`, borderRadius: 12, padding: 40, textAlign: "center" }}>
          <p style={{ color: T.textMuted }}>Сэжигтэй бичлэг байхгүй</p>
        </div>
      ) : (
        <div style={{ background: T.bgCard, border: "1px solid #ef444433", borderRadius: 12, overflow: "hidden" }}>
          <table style={{ width: "100%", borderCollapse: "collapse" }}>
            <thead>
              <tr style={{ background: T.bgInput }}>
                {["User ID", "Нийт алхалт", "Нэмэгдсэн", "Шалтгаан", "Огноо"].map(h => (
                  <th key={h} style={{ padding: "12px 16px", textAlign: "left", color: T.textSub, fontSize: 11, fontWeight: 600, letterSpacing: ".5px", textTransform: "uppercase" }}>
                    {h}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {list.map((r, i) => (
                <tr key={i} style={{ borderTop: `1px solid ${T.border}`, background: i % 2 === 0 ? T.bgCard : T.bgInput }}>
                  <td style={{ padding: "12px 16px", color: T.text, fontWeight: 600 }}>{r.user_id}</td>
                  <td style={{ padding: "12px 16px", color: T.textSub }}>{r.total_steps}</td>
                  <td style={{ padding: "12px 16px", color: "#f87171", fontWeight: 700 }}>{r.delta_steps}</td>
                  <td style={{ padding: "12px 16px", color: "#f59e0b", fontSize: 13 }}>{r.suspicion_reason}</td>
                  <td style={{ padding: "12px 16px", color: T.textMuted, fontSize: 12 }}>{r.recorded_at?.split("T")[0]}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}