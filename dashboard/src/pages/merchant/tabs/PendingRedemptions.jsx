import { useEffect, useState } from "react";
import api from "../../../api/axios";

export default function PendingRedemptions({ dark, cardBg, bdr, txt, muted, onCount }) {
  const [list, setList] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => { loadList(); }, []);

  function loadList() {
    api.get("/rewards/pending-redemptions").then(res => {
      setList(res.data.redemptions);
      setLoading(false);
      if (onCount) onCount(res.data.redemptions.length);
    });
  }

  async function approve(id) {
    try {
      await api.post(`/rewards/approve/${id}`);
      loadList();
    } catch (err) {
      alert(err.response?.data?.error || "Алдаа гарлаа");
    }
  }

  async function reject(id) {
    try {
      await api.post(`/rewards/reject/${id}`);
      loadList();
    } catch (err) {
      alert(err.response?.data?.error || "Алдаа гарлаа");
    }
  }

  if (loading) return <p style={{ color: muted }}>Уншиж байна...</p>;

  return (
    <div>
      {list.length === 0 ? (
        <div style={{
          background: cardBg, border: `1px solid ${bdr}`,
          borderRadius: 12, padding: 40, textAlign: "center",
        }}>
          <p style={{ color: muted }}>Хүлээгдэж буй хүсэлт байхгүй</p>
        </div>
      ) : (
        <div style={{ display: "flex", flexDirection: "column", gap: 12 }}>
          {list.map(r => (
            <div key={r.id} style={{
              background: cardBg, border: `1px solid ${bdr}`,
              borderRadius: 12, padding: 20,
              display: "flex", alignItems: "center", justifyContent: "space-between",
            }}>
              <div>
                <p style={{ color: txt, fontWeight: 600, marginBottom: 4 }}>{r.reward_name}</p>
                <p style={{ color: muted, fontSize: 13 }}>{r.user_name} · {r.user_email}</p>
                <p style={{ color: muted, fontSize: 12, marginTop: 4, opacity: 0.7 }}>
                  {r.points_used} оноо · {r.redeemed_at?.split("T")[0]}
                </p>
              </div>
              <div style={{ display: "flex", gap: 8 }}>
                <button onClick={() => approve(r.id)} style={{
                  padding: "8px 16px", background: "#22c55e22",
                  border: "1px solid #22c55e44", borderRadius: 8,
                  color: "#22c55e", fontSize: 13, fontWeight: 600, cursor: "pointer",
                }}>
                  Зөвшөөрөх
                </button>
                <button onClick={() => reject(r.id)} style={{
                  padding: "8px 16px", background: "#ef444422",
                  border: "1px solid #ef444444", borderRadius: 8,
                  color: "#ef4444", fontSize: 13, fontWeight: 600, cursor: "pointer",
                }}>
                  Татгалзах
                </button>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}