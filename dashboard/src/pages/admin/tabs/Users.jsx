import { useEffect, useState } from "react";
import api from "../../../api/axios";

export default function Users({ T }) {
  const [users, setUsers] = useState([]);
  const [search, setSearch] = useState("");
  const [selected, setSelected] = useState(null);
  const [detail, setDetail] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchUsers();
  }, []);

  async function fetchUsers(q = "") {
    setLoading(true);

    try {
      const res = await api.get(`/admin/users${q ? `?search=${q}` : ""}`);

      setUsers(res.data.users || []);
    } finally {
      setLoading(false);
    }
  }

  async function openDetail(id) {
    setSelected(id);

    const res = await api.get(`/admin/users/${id}`);

    setDetail(res.data);
  }

  function handleSearch(e) {
    setSearch(e.target.value);

    if (e.key === "Enter") {
      fetchUsers(e.target.value);
    }
  }

  if (loading) {
    return <div style={{ color: T.textSub }}>Уншиж байна...</div>;
  }

  return (
    <div>
      {/* HEADER */}

      <div
        style={{
          display: "flex",
          justifyContent: "space-between",
          marginBottom: 24,
        }}
      >

        <input
          placeholder="Нэр, и-мэйлээр хайх..."
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          onKeyDown={handleSearch}
          style={{
            padding: "9px 16px",
            borderRadius: 10,
            fontSize: 13,
            background: T.bgInput,
            border: `1px solid ${T.border}`,
            color: T.text,
            width: 240,
          }}
        />
      </div>

      {/* TABLE */}

      <div
        style={{
          background: T.bgCard,
          borderRadius: 16,
          border: `1px solid ${T.border}`,
          overflow: "hidden",
        }}
      >
        <table
          style={{
            width: "100%",
            borderCollapse: "collapse",
          }}
        >
          <thead>
            <tr
              style={{
                borderBottom: `1px solid ${T.border}`,
              }}
            >
              {["ID", "НЭР", "И-МЭЙЛ", "ОНОО", "ЗОРИЛГО", "ОГНОО", ""].map(
                (h) => (
                  <th
                    key={h}
                    style={{
                      padding: "12px 16px",
                      textAlign: "left",
                      fontSize: 10,
                      letterSpacing: 1.5,
                      color: T.textSub,
                    }}
                  >
                    {h}
                  </th>
                ),
              )}
            </tr>
          </thead>

          <tbody>
            {users.map((u) => (
              <tr
                key={u.id}
                style={{
                  borderBottom: `1px solid ${T.border}`,
                }}
              >
                <td
                  style={{
                    padding: "12px 16px",
                    color: T.textSub,
                  }}
                >
                  {u.id}
                </td>

                <td
                  style={{
                    padding: "12px 16px",
                  }}
                >
                  <div
                    style={{
                      display: "flex",
                      alignItems: "center",
                      gap: 10,
                    }}
                  >
                    <div
                      style={{
                        width: 32,
                        height: 32,
                        borderRadius: "50%",
                        background: "#EDE8FF",
                        display: "flex",
                        alignItems: "center",
                        justifyContent: "center",
                        fontWeight: 700,
                        color: "#6B3EF5",
                      }}
                    >
                      {(u.name || u.email || "U")[0].toUpperCase()}
                    </div>

                    <span
                      style={{
                        color: T.text,
                      }}
                    >
                      {u.name || "—"}
                    </span>
                  </div>
                </td>

                <td
                  style={{
                    padding: "12px 16px",
                    color: T.textSub,
                  }}
                >
                  {u.email}
                </td>

                <td
                  style={{
                    padding: "12px 16px",
                  }}
                >
                  <span
                    style={{
                      background: "#EDE8FF",
                      color: "#6B3EF5",
                      padding: "3px 10px",
                      borderRadius: 20,
                      fontSize: 12,
                    }}
                  >
                    {u.total_points} pts
                  </span>
                </td>

                <td
                  style={{
                    padding: "12px 16px",
                    color: T.textSub,
                  }}
                >
                  {Number(u.daily_goal || 10000).toLocaleString()}
                </td>

                <td
                  style={{
                    padding: "12px 16px",
                    color: T.textSub,
                  }}
                >
                  {u.created_at?.slice(0, 10)}
                </td>

                <td
                  style={{
                    padding: "12px 16px",
                  }}
                >
                  <button
                    onClick={() => openDetail(u.id)}
                    style={{
                      padding: "5px 12px",
                      borderRadius: 8,
                      fontSize: 12,
                      background: T.bgInput,
                      border: `1px solid ${T.border}`,
                      color: T.text,
                      cursor: "pointer",
                    }}
                  >
                    Дэлгэрэнгүй
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* DETAIL MODAL */}

      {selected && detail && (
        <div
          style={{
            position: "fixed",
            inset: 0,
            background: "rgba(0,0,0,0.4)",
            display: "flex",
            justifyContent: "center",
            alignItems: "center",
          }}
          onClick={() => {
            setSelected(null);
            setDetail(null);
          }}
        >
          <div
            style={{
              background: T.bgCard,
              borderRadius: 20,
              padding: 28,
              width: 520,
              border: `1px solid ${T.border}`,
            }}
            onClick={(e) => e.stopPropagation()}
          >
            <div
              style={{
                display: "flex",
                justifyContent: "space-between",
                marginBottom: 20,
              }}
            >
              <div
                style={{
                  fontWeight: 800,
                  color: T.text,
                }}
              >
                {detail.user?.name || "Хэрэглэгч"}
              </div>

              <button
                onClick={() => {
                  setSelected(null);
                  setDetail(null);
                }}
                style={{
                  background: "none",
                  border: "none",
                  color: T.textSub,
                  fontSize: 18,
                  cursor: "pointer",
                }}
              >
                ✕
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
