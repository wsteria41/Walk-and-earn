import { useEffect, useState } from "react";
import api from "../../../api/axios";

export default function Users({ T })  {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const rowEven = T.bgCard;
  const rowOdd  = T.bgInput;
  const head    = T.bgInput

  useEffect(() => {
    api.get("/admin/users").then(res => {
      setUsers(res.data.users);
      setLoading(false);
    });
  }, []);

  if (loading) return <p style={{ color: T.textMuted }}>Уншиж байна...</p>;

  return (
    <div>
      <div style={{ background: T.bgCard, border: `1px solid ${T.border}`, borderRadius: 12, overflow: "hidden" }}>
        <table style={{ width: "100%", borderCollapse: "collapse" }}>
          <thead>
            <tr style={{ background: head }}>
              {["ID", "Нэр", "И-мэйл", "Оноо", "Зорилго", "Огноо"].map(h => (
                <th key={h} style={{ padding: "12px 16px", textAlign: "left", color: T.textSub, fontSize: 11, fontWeight: 600, letterSpacing: ".5px", textTransform: "uppercase" }}>
                  {h}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {users.length === 0 ? (
              <tr>
                <td colSpan={6} style={{ padding: 32, textAlign: "center", color: T.textMuted }}>
                  Хэрэглэгч байхгүй
                </td>
              </tr>
            ) : users.map((u, i) => (
              <tr key={u.id} style={{ borderTop: `1px solid ${T.border}`, background: i % 2 === 0 ? rowEven : rowOdd }}>
                <td style={{ padding: "12px 16px", color: T.textSub, fontSize: 12 }}>{u.id}</td>
                <td style={{ padding: "12px 16px", fontSize: 14 }}>
                  <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
                    <div style={{ width: 28, height: 28, borderRadius: "50%", background: "#7c3aed22", border: "1px solid #7c3aed44", display: "flex", alignItems: "center", justifyContent: "center", fontSize: 11, fontWeight: 800, color: "#a78bfa", flexShrink: 0 }}>
                      {u.name?.[0]?.toUpperCase() || "U"}
                    </div>
                    <span style={{ color: T.text, fontWeight: 600 }}>{u.name}</span>
                  </div>
                </td>
                <td style={{ padding: "12px 16px", color: T.textSub, fontSize: 13 }}>{u.email}</td>
                <td style={{ padding: "12px 16px", fontSize: 14, fontWeight: 700 }}>
                  <span style={{ color: "#a78bfa", background: "#7c3aed22", padding: "2px 10px", borderRadius: 20, fontSize: 12 }}>
                    {u.total_points} pts
                  </span>
                </td>
                <td style={{ padding: "12px 16px", color: T.textSub, fontSize: 13 }}>{u.daily_goal?.toLocaleString()}</td>
                <td style={{ padding: "12px 16px", color: T.textMuted, fontSize: 12 }}>{u.created_at?.split("T")[0]}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}