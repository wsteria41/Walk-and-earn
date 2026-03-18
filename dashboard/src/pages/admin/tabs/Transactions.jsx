import { useEffect, useState } from "react";
import api from "../../../api/axios";

const statusColor = {
  PENDING: "#f59e0b",
  APPROVED: "#22c55e",
  REJECTED: "#ef4444",
};

export default function Transactions({ T }) {
  const [list, setList] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    api.get("/admin/transactions").then(res => {
      setList(res.data.transactions);
      setLoading(false);
    });
  }, []);

   if (loading) return <p style={{ color: T.textMuted }}>Уншиж байна...</p>;

  return (
    <div>
      <div style={{ background: T.bgCard, border: `1px solid ${T.border}`, borderRadius: 12, overflow: "hidden" }}>
        <table style={{ width: "100%", borderCollapse: "collapse" }}>
          <thead>
            <tr style={{ background: T.bgInput }}>
              {["ID", "Хэрэглэгч", "Урамшуулал", "Оноо", "Төлөв", "Огноо"].map(h => (
                <th key={h} style={{ padding: "12px 16px", textAlign: "left", color: T.textSub, fontSize: 11, fontWeight: 600, letterSpacing: ".5px", textTransform: "uppercase" }}>
                  {h}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {list.length === 0 ? (
              <tr>
                <td colSpan={6} style={{ padding: 32, textAlign: "center", color: T.textMuted }}>
                  Гүйлгээ байхгүй
                </td>
              </tr>
            ) : list.map((t, i) => (
              <tr key={t.id} style={{ borderTop: `1px solid ${T.border}`, background: i % 2 === 0 ? T.bgCard : T.bgInput }}>
                <td style={{ padding: "12px 16px", color: T.textSub, fontSize: 12 }}>{t.id}</td>
                <td style={{ padding: "12px 16px" }}>
                  <div style={{ color: T.text, fontWeight: 600, fontSize: 13 }}>{t.user_name}</div>
                  <div style={{ color: T.textSub, fontSize: 11 }}>{t.user_email}</div>
                </td>
                <td style={{ padding: "12px 16px", color: T.textSub, fontSize: 13 }}>{t.reward_name}</td>
                <td style={{ padding: "12px 16px" }}>
                  <span style={{ color: "#a78bfa", background: "#7c3aed22", padding: "2px 10px", borderRadius: 20, fontSize: 12, fontWeight: 700 }}>
                    {t.points_used}
                  </span>
                </td>
                <td style={{ padding: "12px 16px" }}>
                  <span style={{
                    padding: "3px 10px", borderRadius: 20, fontSize: 11, fontWeight: 600,
                    color: statusColor[t.status],
                    background: statusColor[t.status] + "22",
                    border: `1px solid ${statusColor[t.status]}44`,
                  }}>{t.status}</span>
                </td>
                <td style={{ padding: "12px 16px", color: T.textMuted, fontSize: 12 }}>{t.redeemed_at?.split("T")[0]}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}