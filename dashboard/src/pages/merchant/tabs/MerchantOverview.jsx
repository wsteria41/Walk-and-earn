import { useEffect, useState } from "react";
import api from "../../../api/axios";

export default function MerchantOverview() {
  const [stats, setStats] = useState(null);

  useEffect(() => {
    api.get("/rewards/merchant-stats").then(res => setStats(res.data));
  }, []);

  if (!stats) return <p style={{ color: "#666" }}>Уншиж байна...</p>;

  const cards = [
    { label: "Нийт урамшуулал", value: stats.total_rewards },
    { label: "Нийт redeem", value: stats.total_redeems },
    { label: "Хүлээгдэж буй", value: stats.pending, warn: true },
    { label: "Зөвшөөрсөн", value: stats.approved, green: true },
    { label: "Татгалзсан", value: stats.rejected, red: true },
  ];

  return (
    <div>
      <h2 style={{ fontSize: 22, fontWeight: 700, marginBottom: 24 }}>Тойм</h2>
      <div style={{ display: "grid", gridTemplateColumns: "repeat(3, 1fr)", gap: 16 }}>
        {cards.map(c => (
          <div key={c.label} style={{
            background: "#111",
            border: `1px solid ${c.warn ? "#f59e0b33" : c.red ? "#ef444433" : "#1e1e1e"}`,
            borderRadius: 12, padding: 20,
          }}>
            <p style={{ color: "#666", fontSize: 12, marginBottom: 8 }}>{c.label}</p>
            <p style={{
              fontSize: 32, fontWeight: 800,
              color: c.warn ? "#f59e0b" : c.red ? "#ef4444" : c.green ? "#22c55e" : "#fff",
            }}>{c.value ?? 0}</p>
          </div>
        ))}
      </div>
    </div>
  );
}