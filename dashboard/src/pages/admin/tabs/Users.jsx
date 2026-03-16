import { useEffect, useState } from "react";
import api from "../../../api/axios";

export default function Users() {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    api.get("/admin/users").then(res => {
      setUsers(res.data.users);
      setLoading(false);
    });
  }, []);

  if (loading) return <p style={{ color: "#666" }}>Уншиж байна...</p>;

  return (
    <div>
      <h2 style={{ fontSize: 22, fontWeight: 700, marginBottom: 24 }}>Хэрэглэгчид</h2>
      <div style={{ background: "#111", border: "1px solid #1e1e1e", borderRadius: 12, overflow: "hidden" }}>
        <table style={{ width: "100%", borderCollapse: "collapse" }}>
          <thead>
            <tr style={{ background: "#1a1a1a" }}>
              {["ID", "Нэр", "И-мэйл", "Оноо", "Зорилго", "Огноо"].map(h => (
                <th key={h} style={{ padding: "12px 16px", textAlign: "left", color: "#666", fontSize: 12, fontWeight: 600 }}>{h}</th>
              ))}
            </tr>
          </thead>
          <tbody>
            {users.map((u, i) => (
              <tr key={u.id} style={{ borderTop: "1px solid #1e1e1e", background: i % 2 === 0 ? "#111" : "#0f0f0f" }}>
                <td style={{ padding: "12px 16px", color: "#666", fontSize: 13 }}>{u.id}</td>
                <td style={{ padding: "12px 16px", color: "#fff", fontSize: 14 }}>{u.name}</td>
                <td style={{ padding: "12px 16px", color: "#888", fontSize: 13 }}>{u.email}</td>
                <td style={{ padding: "12px 16px", color: "#7B2FFF", fontSize: 14, fontWeight: 700 }}>{u.total_points}</td>
                <td style={{ padding: "12px 16px", color: "#888", fontSize: 13 }}>{u.daily_goal}</td>
                <td style={{ padding: "12px 16px", color: "#555", fontSize: 12 }}>{u.created_at?.split("T")[0]}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}