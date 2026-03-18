import { useEffect, useState } from "react";
import api from "../../../api/axios";

export default function MerchantOverview({ dark, cardBg, bdr, txt, muted }) {
  const [stats, setStats] = useState(null);

  useEffect(() => {
    api.get("/rewards/merchant-stats").then(res => setStats(res.data));
  }, []);

  if (!stats) return <p style={{ color: muted }}>Уншиж байна...</p>;

  const cards = [
    { label: "Нийт урамшуулал", value: stats.total_rewards, color: "#1D9E75" },
    { label: "Нийт redeem",     value: stats.total_redeems, color: txt },
    { label: "Хүлээгдэж буй",  value: stats.pending,       color: "#f59e0b", accent: "#f59e0b" },
    { label: "Зөвшөөрсөн",     value: stats.approved,      color: "#22c55e" },
    { label: "Татгалзсан",      value: stats.rejected,      color: "#ef4444", accent: "#ef4444" },
  ];

  return (
    <div>
     
      <div style={{ display: "grid", gridTemplateColumns: "repeat(3, 1fr)", gap: 12 }}>
        {cards.map(c => (
          <div key={c.label} style={{
            background: cardBg,
            border: `1px solid ${c.accent ? c.accent + "33" : bdr}`,
            borderRadius: 12, padding: 20,
          }}>
            <p style={{ color: muted, fontSize: 11, marginBottom: 8, textTransform: "uppercase", letterSpacing: ".5px" }}>
              {c.label}
            </p>
            <p style={{ fontSize: 32, fontWeight: 800, color: c.color }}>
              {c.value ?? 0}
            </p>
          </div>
        ))}
      </div>
    </div>
  );
}