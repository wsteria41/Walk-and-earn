import { Link } from "react-router-dom";
import "./LandingPage.css";

const ArrowIcon = () => (
  <svg width="13" height="13" viewBox="0 0 16 16" fill="none">
    <path d="M3 8h10M9 4l4 4-4 4" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" />
  </svg>
);

const FLOW_STEPS = [
  { n: "01", label: "Хэрэглэгч алхана",      sub: "Гар утасны Health API — бодит алхалт" },
  { n: "02", label: "Оноо хуримтлагдана",     sub: "Сервер баталгаажуулж оноо нэмнэ" },
  { n: "03", label: "Мерчантаас хөнгөлөлт",  sub: "Оноогоороо байгууллагад хандана" },
  { n: "04", label: "Admin хянана",            sub: "Гүйлгээ, сэжигтэй байдлыг шалгана" },
];

const MERCHANT_PERKS = [
  "Хэрэглэгчид оноогоороо таны байгууллагаас хөнгөлөлт авна",
  "Merchant dashboard-оор гүйлгээ, статистикаа хянана",
  "Хөнгөлөлтийн хувь, нөхцөлийг өөрөө тохируулна",
  "Admin бүртгэлийг баталгаажуулж, дэмжлэг үзүүлнэ",
];

const ADMIN_PERKS = [
  "Нийт хэрэглэгч, алхалт, оноог бодит цагт хянана",
  "Мерчант байгууллагуудыг баталгаажуулж удирдана",
  "Сэжигтэй үйлдлийг илрүүлж, системийн аюулгүй байдлыг хангана",
  "Гүйлгээ, redeem хүсэлтүүдийг шалгаж зөвшөөрнө",
];

const MERCHANT_TXNS = [
  { n: "Б. Отгонбаяр · 320 оноо", v: "-15% хөнгөлөлт" },
  { n: "Д. Мөнхзул · 180 оноо",   v: "-10% хөнгөлөлт" },
  { n: "Г. Энхбаяр · 500 оноо",   v: "-20% хөнгөлөлт" },
];

const MERCHANT_BARS = [35, 55, 40, 80, 65, 90, 72];
const ADMIN_BARS    = [30, 50, 35, 75, 60, 85, 70];
const ADMIN_NAV     = ["Тойм", "Хэрэглэгчид", "Гүйлгээ", "Сэжигтэй"];

export default function LandingPage() {
  return (
    <div className="lp">

      {/* NAV */}
      <nav className="lp-nav">
        <Link to="/" className="lp-logo">WEARN</Link>
        <div className="lp-nav-right">
          <Link to="/login" className="lp-btn-ghost">Нэвтрэх</Link>
          <Link to="/merchant/register" className="lp-btn-solid">Мерчант бүртгэл</Link>
        </div>
      </nav>

      {/* HERO */}
      <section className="lp-hero">
        <div className="lp-hero-orb lp-hero-orb-1" />
        <div className="lp-hero-orb lp-hero-orb-2" />
        <div className="lp-hero-inner">
          <div className="lp-hero-eyebrow lp-f1">
            <span className="lp-eyebrow-dot" />
            Алхалтад суурилсан урамшууллын платформ
          </div>
          <h1 className="lp-hero-title lp-f2">
            Хэрэглэгчийн алхалтад суурилж,<br /><em>бизнесээ</em> өргөжүүл
          </h1>
          <p className="lp-hero-sub lp-f3">
            WEARN нь хэрэглэгчдийн алхалтын идэвхийг дэмжиж, байгууллагуудад шинэ хэрэглэгч татах, үнэнч байдлыг нэмэгдүүлэх боломж олгодог платформ.
          </p>
          <div className="lp-hero-cards lp-f4">
            <Link to="/login" className="lp-portal-card admin">
              <div className="lp-portal-icon">🛡</div>
              <div className="lp-portal-label">ADMIN PORTAL</div>
              <div className="lp-portal-title">Системийн удирдлага</div>
              <div className="lp-portal-desc">Хэрэглэгч, гүйлгээ, мерчант байгууллагуудыг бүгдийг нэг газраас удирд.</div>
              <div className="lp-portal-action">Нэвтрэх <ArrowIcon /></div>
            </Link>
            <Link to="/merchant/register" className="lp-portal-card merchant">
              <div className="lp-portal-icon">🏪</div>
              <div className="lp-portal-label">MERCHANT PORTAL</div>
              <div className="lp-portal-title">Байгууллагын портал</div>
              <div className="lp-portal-desc">Платформд нэгдэж, идэвхтэй хэрэглэгчидтэй байгууллагаа холбо.</div>
              <div className="lp-portal-action">Бүртгүүлэх <ArrowIcon /></div>
            </Link>
          </div>
        </div>
      </section>

      <div className="lp-divider" />

      {/* HOW IT WORKS */}
      <section className="lp-what">
        <div className="lp-what-inner">
          <div>
            <div className="lp-tag">ПЛАТФОРМ ХЭРХЭН АЖИЛЛАДАГ</div>
            <h2 className="lp-section-title">Алхалтыг<br /><em>урамшуулал</em> болгоно</h2>
            <p className="lp-section-desc" style={{ marginTop: 14 }}>
              Хэрэглэгчийн гар утасны аппаар хэмжигдсэн алхалтыг баталгаажуулна. Тодорхой алхам тутамд оноо цуглуулж, таны байгууллагаас хөнгөлөлт авах боломжтой болно. Admin системийг бүхэлд нь хянана.
            </p>
          </div>
          <div className="lp-flow">
            {FLOW_STEPS.map(s => (
              <div className="lp-flow-step" key={s.n}>
                <div className="lp-flow-num">{s.n}</div>
                <div>
                  <div className="lp-flow-label">{s.label}</div>
                  <div className="lp-flow-sub">{s.sub}</div>
                </div>
                <div className="lp-flow-arrow">→</div>
              </div>
            ))}
          </div>
        </div>
      </section>

      <div className="lp-divider" />

      {/* MERCHANT */}
      <section className="lp-merchant">
        <div className="lp-merchant-orb lp-merchant-orb-1" />
        <div className="lp-merchant-orb lp-merchant-orb-2" />
        <div className="lp-merchant-inner">
          <div style={{ position: "relative", zIndex: 1 }}>
            <div className="lp-merchant-tag">МЕРЧАНТ БАЙГУУЛЛАГА</div>
            <h2 className="lp-merchant-title">Идэвхтэй<br /><em>хэрэглэгчид</em>тэй<br />холбогдоорой</h2>
            <p className="lp-merchant-desc">
              WEARN платформд нэгдсэн байгууллага нь алхалтаараа оноо цуглуулсан хэрэглэгчидтэй шууд холбогдоно. Хөнгөлөлт өгч, шинэ хэрэглэгч татаж, үнэнч байдлыг бий болго.
            </p>
            <div className="lp-merchant-perks">
              {MERCHANT_PERKS.map(p => (
                <div className="lp-merchant-perk" key={p}>
                  <div className="lp-perk-check" />
                  <span className="lp-perk-text">{p}</span>
                </div>
              ))}
            </div>
            <Link to="/merchant/register" className="lp-btn-merchant">
              Мерчант бүртгэл үүсгэх <ArrowIcon />
            </Link>
          </div>

          {/* Merchant mockup */}
          <div className="lp-mockup">
            <div className="lp-mockup-bar">
              <div className="lp-mockup-logo">WEARN</div>
              <div className="lp-mockup-status">● Merchant Portal</div>
            </div>
            <div className="lp-mockup-grid">
              <div className="lp-mockup-card">
                <div className="lp-mockup-card-label">НИЙТ ГҮЙЛГЭЭ</div>
                <div className="lp-mockup-card-val">142</div>
              </div>
              <div className="lp-mockup-card">
                <div className="lp-mockup-card-label">ОЛГОСОН ХӨНГӨЛӨЛТ</div>
                <div className="lp-mockup-card-val g">₮840K</div>
              </div>
            </div>
            <div className="lp-mockup-chart-wrap">
              <div className="lp-mockup-chart-lbl">7 ХОНОГИЙН ГҮЙЛГЭЭ</div>
              <div className="lp-mockup-bars">
                {MERCHANT_BARS.map((h, i) => (
                  <div key={i} className="lp-mockup-b" style={{ height: `${h}%` }} />
                ))}
              </div>
            </div>
            <div className="lp-mockup-rows">
              {MERCHANT_TXNS.map(r => (
                <div className="lp-mockup-row" key={r.n}>
                  <div className="lp-mockup-row-name">{r.n}</div>
                  <div className="lp-mockup-row-val">{r.v}</div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>

      <div className="lp-divider" />

      {/* ADMIN */}
      <section className="lp-admin">
        <div className="lp-admin-inner">
          {/* Admin mockup */}
          <div className="lp-admin-mockup">
            <div className="lp-admin-topbar">
              <div className="lp-admin-topbar-logo">WEARN</div>
              <div className="lp-admin-topbar-status">● Систем ажиллаж байна</div>
            </div>
            <div className="lp-admin-body">
              <div className="lp-admin-sidebar">
                {ADMIN_NAV.map((n, i) => (
                  <div key={n} className={`lp-admin-nav${i === 0 ? " active" : ""}`}>{n}</div>
                ))}
              </div>
              <div className="lp-admin-content">
                <div className="lp-admin-stat-row">
                  <div className="lp-admin-stat">
                    <div className="lp-admin-stat-lbl">ХЭРЭГЛЭГЧ</div>
                    <div className="lp-admin-stat-val">10</div>
                  </div>
                  <div className="lp-admin-stat">
                    <div className="lp-admin-stat-lbl">АЛХАЛТ</div>
                    <div className="lp-admin-stat-val">12K</div>
                  </div>
                  <div className="lp-admin-stat">
                    <div className="lp-admin-stat-lbl">СЭЖИГТЭЙ</div>
                    <div className="lp-admin-stat-val r">3</div>
                  </div>
                </div>
                <div className="lp-admin-chart-card">
                  <div className="lp-admin-chart-lbl">ӨДӨР ТУТМЫН ИДЭВХТЭЙ ХЭРЭГЛЭГЧ</div>
                  <div className="lp-admin-bars">
                    {ADMIN_BARS.map((h, i) => (
                      <div key={i} className="lp-admin-bar" style={{ height: `${h}%` }} />
                    ))}
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div>
            <div className="lp-admin-tag">ADMIN PORTAL</div>
            <h2 className="lp-section-title">Системийг бүхэлд нь<br /><em>хяналтандаа</em> авч</h2>
            <div className="lp-admin-perks">
              {ADMIN_PERKS.map(p => (
                <div className="lp-admin-perk" key={p}>
                  <div className="lp-admin-perk-dot" />
                  <span className="lp-admin-perk-text">{p}</span>
                </div>
              ))}
            </div>
            <Link to="/login" className="lp-btn-admin">
              Admin нэвтрэх <ArrowIcon />
            </Link>
          </div>
        </div>
      </section>

      {/* FOOTER */}
      <footer className="lp-footer">
        <Link to="/" className="lp-footer-logo">WEARN</Link>
        <div className="lp-footer-links">
          <Link to="/login">Admin нэвтрэх</Link>
          <Link to="/merchant/register">Мерчант бүртгэл</Link>
        </div>
        <div className="lp-footer-copy">© 2026 WEARN · Walk. Earn. Repeat.</div>
      </footer>

    </div>
  );
}