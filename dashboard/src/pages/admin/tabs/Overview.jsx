import { useEffect, useState } from "react";
import { LineChart, Line, XAxis, YAxis, Tooltip, ResponsiveContainer } from "recharts";
import api from "../../../api/axios";

export default function Overview() {
  const [data, setData] = useState(null);

  useEffect(() => {
    api.get("/admin/dashboard").then(res => setData(res.data));
  }, []);

  if (!data) return <p style={{ color: "#666" }}>Уншиж байна...</p>;

  const stats = [
    { label: "Нийт хэрэглэгч", value: data.totalUsers },
    { label: "Нийт алхалт", value: data.totalSteps.toLocaleString() },
    { label: "Нийт оноо", value: data.totalPoints.toLocaleString() },
    { label: "Нийт redeem", value: data.totalRedeems },
    { label: "Хүлээгдэж буй", value: data.pendingRedeems, warn: true },
    { label: "Сэжигтэй", value: data.suspiciousRecords, warn: true },
  ];

  return (
    <div>
      <h2 style={{ fontSize: 22, fontWeight: 700, marginBottom: 24 }}>Тойм</h2>

      {/* STAT CARDS */}
      <div style={{ display: "grid", gridTemplateColumns: "repeat(3, 1fr)", gap: 16, marginBottom: 32 }}>
        {stats.map(s => (
          <div key={s.label} style={{
            background: "#111", border: `1px solid ${s.warn && s.value > 0 ? "#ff444433" : "#1e1e1e"}`,
            borderRadius: 12, padding: 20,
          }}>
            <p style={{ color: "#666", fontSize: 12, marginBottom: 8 }}>{s.label}</p>
            <p style={{
              fontSize: 28, fontWeight: 800,
              color: s.warn && s.value > 0 ? "#ff6b6b" : "#fff",
            }}>{s.value}</p>
          </div>
        ))}
      </div>

      {/* CHART */}
      <div style={{ background: "#111", border: "1px solid #1e1e1e", borderRadius: 12, padding: 24 }}>
        <p style={{ color: "#888", fontSize: 13, marginBottom: 16 }}>Өдөр тутмын идэвхтэй хэрэглэгч (7 хоног)</p>
        <ResponsiveContainer width="100%" height={240}>
          <LineChart data={data.dailyActiveUsers}>
            <XAxis dataKey="date" stroke="#444" tick={{ fill: "#666", fontSize: 11 }} />
            <YAxis stroke="#444" tick={{ fill: "#666", fontSize: 11 }} />
            <Tooltip contentStyle={{ background: "#1a1a1a", border: "1px solid #333", borderRadius: 8 }} />
            <Line type="monotone" dataKey="activeUsers" stroke="#7B2FFF" strokeWidth={2} dot={{ fill: "#7B2FFF" }} />
          </LineChart>
        </ResponsiveContainer>
      </div>
    </div>
  );
}