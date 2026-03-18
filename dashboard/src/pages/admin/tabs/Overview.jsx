import { useEffect, useState } from "react";
import {
  BarChart, Bar, XAxis, YAxis, Tooltip,
  ResponsiveContainer, CartesianGrid, Cell,
} from "recharts";
import api from "../../../api/axios";

const STAT_ICONS = {
  users:      <svg width="18" height="18" viewBox="0 0 20 20" fill="none"><circle cx="10" cy="6" r="4" stroke="#a78bfa" strokeWidth="1.5"/><path d="M3 18c0-3.9 3.1-7 7-7s7 3.1 7 7" stroke="#a78bfa" strokeWidth="1.5" strokeLinecap="round"/></svg>,
  steps:      <svg width="18" height="18" viewBox="0 0 20 20" fill="none"><path d="M4 10l4 4 8-8" stroke="#34d399" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"/></svg>,
  points:     <svg width="18" height="18" viewBox="0 0 20 20" fill="none"><polygon points="10,2 12.4,7.5 18,8.2 14,12 15.1,17.5 10,14.7 4.9,17.5 6,12 2,8.2 7.6,7.5" stroke="#fbbf24" strokeWidth="1.5" strokeLinejoin="round"/></svg>,
  redeem:     <svg width="18" height="18" viewBox="0 0 20 20" fill="none"><rect x="2" y="5" width="16" height="12" rx="2" stroke="#60a5fa" strokeWidth="1.5"/><path d="M2 9h16" stroke="#60a5fa" strokeWidth="1.5"/></svg>,
  pending:    <svg width="18" height="18" viewBox="0 0 20 20" fill="none"><circle cx="10" cy="10" r="8" stroke="#fb923c" strokeWidth="1.5"/><path d="M10 6v4l2.5 2.5" stroke="#fb923c" strokeWidth="1.5" strokeLinecap="round"/></svg>,
  suspicious: <svg width="18" height="18" viewBox="0 0 20 20" fill="none"><path d="M10 3L11.8 7.6L17 8.5L13.5 11.9L14.4 17L10 14.5L5.6 17L6.5 11.9L3 8.5L8.2 7.6Z" stroke="#f87171" strokeWidth="1.5" strokeLinejoin="round"/></svg>,
};

function CustomTooltip({ active, payload, label, T }) {
  if (!active || !payload?.length) return null;
  return (
    <div style={{
      background: T.chartTooltipBg,
      border: `1px solid ${T.chartTooltipBorder}`,
      borderRadius: 10, padding: "10px 14px",
    }}>
      <p style={{ color: "#7c3aed", fontSize: 11, fontWeight: 700, marginBottom: 4, letterSpacing: 1 }}>
        {label}
      </p>
      <p style={{ color: T.chartTooltipText, fontSize: 18, fontWeight: 800, margin: 0 }}>
        {payload[0].value}{" "}
        <span style={{ fontSize: 11, color: T.textSub, fontWeight: 500 }}>хэрэглэгч</span>
      </p>
    </div>
  );
}

export default function Overview({ onSuspCount, T }) {
  const [data, setData] = useState(null);
  const [hoveredBar, setHoveredBar] = useState(null);

  useEffect(() => {
    api.get("/admin/dashboard").then((res) => {
      setData(res.data);
      if (onSuspCount) onSuspCount(res.data.suspiciousRecords);
    });
  }, [onSuspCount]);

  if (!data) return (
    <div style={{ display: "flex", alignItems: "center", justifyContent: "center", height: 300, gap: 12 }}>
      <div style={{ width: 8, height: 8, borderRadius: "50%", background: "#7c3aed" }} />
      <p style={{ color: T.textSub, fontSize: 13, letterSpacing: 1 }}>Уншиж байна...</p>
    </div>
  );

  const stats = [
    { label: "Нийт хэрэглэгч", value: data.totalUsers,                 key: "users",      color: "#a78bfa", bg: "#7c3aed12", border: "#7c3aed30" },
    { label: "Нийт алхалт",    value: data.totalSteps.toLocaleString(), key: "steps",      color: "#34d399", bg: "#34d39912", border: "#34d39930" },
    { label: "Нийт оноо",      value: data.totalPoints.toLocaleString(),key: "points",     color: "#fbbf24", bg: "#fbbf2412", border: "#fbbf2430" },
    { label: "Нийт redeem",    value: data.totalRedeems,                key: "redeem",     color: "#60a5fa", bg: "#60a5fa12", border: "#60a5fa30" },
    {
      label: "Хүлээгдэж буй", value: data.pendingRedeems, key: "pending",
      color:  data.pendingRedeems  > 0 ? "#fb923c" : T.textSub,
      bg:     data.pendingRedeems  > 0 ? "#fb923c12" : T.warnOffBg,
      border: data.pendingRedeems  > 0 ? "#fb923c30" : T.warnOffBorder,
    },
    {
      label: "Сэжигтэй", value: data.suspiciousRecords, key: "suspicious",
      color:  data.suspiciousRecords > 0 ? "#f87171" : T.textSub,
      bg:     data.suspiciousRecords > 0 ? "#f8717112" : T.warnOffBg,
      border: data.suspiciousRecords > 0 ? "#f8717130" : T.warnOffBorder,
    },
  ];

  const chartData = (data.dailyActiveUsers || []).map(d => ({
    ...d,
    shortDate: d.date ? d.date.slice(5) : d.date,
  }));

  return (
    <div style={{ display: "flex", flexDirection: "column", gap: 24 }}>

      {/* Header */}
      <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between" }}>
        <p style={{ fontSize: 12, color: T.textSub, margin: 0, letterSpacing: 0.5 }}>
          Системийн ерөнхий статистик
        </p>
        <div style={{
          background: "#7c3aed18", border: "1px solid #7c3aed33",
          borderRadius: 10, padding: "6px 14px",
          fontSize: 11, color: "#a78bfa", fontWeight: 700, letterSpacing: 1,
        }}>
          ▲ Live
        </div>
      </div>

      {/* Stat grid */}
      <div style={{ display: "grid", gridTemplateColumns: "repeat(3, 1fr)", gap: 14 }}>
        {stats.map((s) => (
          <div key={s.label} style={{
            background: s.bg, border: `1px solid ${s.border}`,
            borderRadius: 14, padding: "18px 20px",
            position: "relative", overflow: "hidden",
            transition: "transform .15s, box-shadow .15s", cursor: "default",
          }}
            onMouseEnter={e => { e.currentTarget.style.transform = "translateY(-2px)"; e.currentTarget.style.boxShadow = `0 8px 32px ${s.color}18`; }}
            onMouseLeave={e => { e.currentTarget.style.transform = "none"; e.currentTarget.style.boxShadow = "none"; }}
          >
            <div style={{ position: "absolute", top: -20, right: -20, width: 70, height: 70, borderRadius: "50%", background: s.color, opacity: 0.06, filter: "blur(20px)", pointerEvents: "none" }} />
            <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: 12 }}>
              <p style={{ color: T.textSub, fontSize: 11, fontWeight: 600, letterSpacing: 0.5, margin: 0 }}>
                {s.label.toUpperCase()}
              </p>
              <div style={{ width: 32, height: 32, borderRadius: 8, background: `${s.color}18`, display: "flex", alignItems: "center", justifyContent: "center" }}>
                {STAT_ICONS[s.key]}
              </div>
            </div>
            <p style={{ fontSize: 30, fontWeight: 900, color: s.color, margin: 0, lineHeight: 1 }}>
              {s.value}
            </p>
          </div>
        ))}
      </div>

      {/* Chart */}
      <div style={{
        background: T.bgCard, border: `1px solid ${T.border}`,
        borderRadius: 16, padding: "22px 24px",
        transition: "background .25s, border-color .25s",
      }}>
        <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: 20 }}>
          <div>
            <p style={{ color: T.text, fontSize: 14, fontWeight: 700, margin: 0 }}>Өдөр тутмын идэвхтэй хэрэглэгч</p>
            <p style={{ color: T.textSub, fontSize: 11, margin: "3px 0 0" }}>Сүүлийн 7 хоног</p>
          </div>
          <div style={{ display: "flex", alignItems: "center", gap: 6, background: "#7c3aed18", border: "1px solid #7c3aed22", borderRadius: 8, padding: "4px 10px" }}>
            <div style={{ width: 8, height: 8, borderRadius: 2, background: "#7c3aed" }} />
            <span style={{ fontSize: 10, color: "#7c6ab0", fontWeight: 600, letterSpacing: 0.5 }}>ИДЭВХТЭЙ</span>
          </div>
        </div>

        <ResponsiveContainer width="100%" height={220}>
          <BarChart data={chartData} barCategoryGap="30%" margin={{ top: 4, right: 4, left: -16, bottom: 0 }}>
            <defs>
              <linearGradient id="barGrad" x1="0" y1="0" x2="0" y2="1">
                <stop offset="0%" stopColor="#7c3aed" stopOpacity={1} />
                <stop offset="100%" stopColor="#4f46e5" stopOpacity={0.7} />
              </linearGradient>
              <linearGradient id="barGradHover" x1="0" y1="0" x2="0" y2="1">
                <stop offset="0%" stopColor="#a78bfa" stopOpacity={1} />
                <stop offset="100%" stopColor="#7c3aed" stopOpacity={0.9} />
              </linearGradient>
            </defs>
            <CartesianGrid vertical={false} stroke={T.chartGrid} strokeDasharray="4 4" />
            <XAxis dataKey="shortDate" stroke="none"
              tick={{ fill: T.chartTick, fontSize: 11, fontWeight: 600 }}
              axisLine={false} tickLine={false} />
            <YAxis stroke="none"
              tick={{ fill: T.chartTick, fontSize: 11 }}
              axisLine={false} tickLine={false} allowDecimals={false} />
            <Tooltip content={<CustomTooltip T={T} />} cursor={{ fill: T.chartCursor, radius: 6 }} />
            <Bar dataKey="activeUsers" radius={[6, 6, 0, 0]} maxBarSize={48}>
              {chartData.map((_, index) => (
                <Cell
                  key={`cell-${index}`}
                  fill={hoveredBar === index ? "url(#barGradHover)" : "url(#barGrad)"}
                  onMouseEnter={() => setHoveredBar(index)}
                  onMouseLeave={() => setHoveredBar(null)}
                />
              ))}
            </Bar>
          </BarChart>
        </ResponsiveContainer>
      </div>
    </div>
  );
}