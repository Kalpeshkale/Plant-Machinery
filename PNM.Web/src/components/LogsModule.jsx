import React, { useState } from "react";

/* ── sample data — replace with API call ── */
const SAMPLE = [
  { id:1, code:"JSWMHR-BL-005",    ownership:"Hired", status:"Idle",    type:"BACKHOE AND LOADER",     site:"JSW Motors Limited", operator:"Nishant Vishwakarma",   reading:14282, unit:"HMR", since:"2025-07-21T08:00:00" },
  { id:2, code:"JSWMHR-BL-006",    ownership:"Hired", status:"Idle",    type:"BACKHOE AND LOADER",     site:"JSW Motors Limited", operator:"Nishant Vishwakarma",   reading:20,    unit:"HMR", since:"2025-07-21T08:00:00" },
  { id:3, code:"JSWMHR-BOLERO-003",ownership:"Hired", status:"Working", type:"VEHICLES - LMV",         site:"JSW Motors Limited", operator:"Nishant Kumar Thakur", reading:10,    unit:"KMR", since:"2025-07-20T10:42:00" },
  { id:4, code:"JSWMHR-BOLERO-005",ownership:"Hired", status:"Working", type:"VEHICLES - LMV",         site:"JSW Motors Limited", operator:"Nishant Vishwakarma",   reading:500,   unit:"KMR", since:"2025-07-18T13:33:00" },
  { id:5, code:"JSWMHR-CP1400-001",ownership:"Hired", status:"Working", type:"CONCRETE PUMP - CP1400", site:"JSW Motors Limited", operator:"Nishant Vishwakarma",   reading:0,     unit:"Hours",since:"2025-07-17T16:22:00" },
  { id:6, code:"JSWMHR-CP1400-002",ownership:"Owned", status:"Breakdown",type:"CONCRETE PUMP - CP1400",site:"JSW Motors Limited", operator:"Nishant Vishwakarma",   reading:0,     unit:"Hours",since:"2025-07-16T23:21:00" },
];

/* ── relative time helper ── */
function relativeTime(isoStr) {
  if (!isoStr) return "-";
  const diff = Math.floor((Date.now() - new Date(isoStr).getTime()) / 1000);
  if (diff < 60)     return `${diff}s ago`;
  if (diff < 3600)   return `${Math.floor(diff/60)}m ago`;
  if (diff < 86400)  return `${Math.floor(diff/3600)}h ago`;
  return `${Math.floor(diff/86400)}d ago`;
}

/* ── machine icon SVG by type keyword ── */
function MachineIcon({ type, cls }) {
  const t = (type||"").toLowerCase();
  const color = cls === "hired" ? "#c2410c" : "#1d4ed8";
  const bg    = cls === "hired" ? "#f3e4d9" : "#d6edff";
  let path;
  if (t.includes("backhoe") || t.includes("loader"))
    path = "M8 34h28v12H8zM12 26h16v10H12zM36 40l14-12 4 5-13 11zM50 28l6-9 4 4-5 10z";
  else if (t.includes("vehicle") || t.includes("lmv") || t.includes("truck"))
    path = "M4 28h34v18H4zM38 34h16v12H38zM8 22h18v8H8zM40 36h10v6H40zM6 44h52v2H6z";
  else
    path = "M6 30h26v18H6zM32 36h18v12H32zM32 36l14-14 5 5-13 13zM16 48a5 5 0 100-10 5 5 0 000 10zM46 48a5 5 0 100-10 5 5 0 000 10z";
  return (
    <svg viewBox="0 0 64 64" style={{ width:50, height:50, flexShrink:0, borderRadius:10, background:bg, border:"2px solid rgba(255,255,255,.85)" }}>
      <path d={path} fill={color} />
      <circle cx="16" cy="48" r="5" fill="#374151"/><circle cx="16" cy="48" r="2.5" fill="#9ca3af"/>
      <circle cx="46" cy="48" r="5" fill="#374151"/><circle cx="46" cy="48" r="2.5" fill="#9ca3af"/>
    </svg>
  );
}

/* ── CSS (card styles from old appmobile.css + enhancements) ── */
const CSS = `
.lc-grid { display:grid; grid-template-columns:repeat(3,minmax(0,1fr)); gap:16px; }
@media(max-width:1100px){ .lc-grid{ grid-template-columns:repeat(2,minmax(0,1fr)); } }
@media(max-width:680px) { .lc-grid{ grid-template-columns:1fr; } }

.lc-card { border:1px solid #cbd5e1; border-radius:14px; overflow:hidden; background:#fff;
  box-shadow:0 4px 6px -1px rgba(0,0,0,.05); display:flex; flex-direction:column;
  height:100%; transition:transform .2s,box-shadow .2s; }
.lc-card:hover { transform:translateY(-3px); box-shadow:0 8px 20px -4px rgba(0,0,0,.14); }

.lc-header { padding:12px; display:flex; align-items:center; justify-content:space-between; }
.lc-header.hired { background-color:#f3e4d9; }
.lc-header.owned { background-color:#d6edff; }

.lc-title { font-size:14px; font-weight:700; margin:0; line-height:1.2; word-break:break-word; }
.lc-title.hired { color:#7c2d12; }
.lc-title.owned { color:#1c4a77; }
.lc-own-badge { font-size:.68rem; padding:3px 8px; border-radius:6px; font-weight:600;
  background:rgba(255,255,255,.75); border:1px solid rgba(0,0,0,.1); color:#334155; display:inline-block; margin-top:3px; }
.lc-status-wrap { display:flex; align-items:center; gap:5px; flex-shrink:0; }
.lc-status-badge { font-size:.68rem; padding:4px 8px; border-radius:6px; font-weight:700; letter-spacing:.5px; }
.lc-status-badge.working   { background:#16a34a; color:#fff; }
.lc-status-badge.idle      { background:#64748b; color:#fff; }
.lc-status-badge.breakdown { background:#dc2626; color:#fff; }

/* pulse dot for Working */
.lc-pulse { width:8px; height:8px; border-radius:50%; background:#16a34a; flex-shrink:0;
  box-shadow:0 0 0 0 rgba(22,163,74,.6);
  animation:lc-pulse-anim 1.6s ease-out infinite; }
@keyframes lc-pulse-anim {
  0%   { box-shadow:0 0 0 0 rgba(22,163,74,.55); }
  70%  { box-shadow:0 0 0 8px rgba(22,163,74,0); }
  100% { box-shadow:0 0 0 0 rgba(22,163,74,0); }
}
.lc-pulse.breakdown { background:#dc2626; animation:lc-pulse-bd 1.6s ease-out infinite; }
@keyframes lc-pulse-bd {
  0%   { box-shadow:0 0 0 0 rgba(220,38,38,.55); }
  70%  { box-shadow:0 0 0 8px rgba(220,38,38,0); }
  100% { box-shadow:0 0 0 0 rgba(220,38,38,0); }
}

.lc-body { padding:12px; background:#fff; flex:1; display:flex; flex-direction:column; }
.lc-meta  { font-size:.85rem; color:#475569; display:flex; flex-direction:column; gap:6px; flex:1; min-width:0; }
.lc-meta-row { display:flex; align-items:flex-start; gap:6px; }
.lc-meta-row i { width:14px; flex-shrink:0; color:#94a3b8; margin-top:2px; }

.lc-reading-col { min-width:110px; display:flex; align-items:stretch; padding-left:8px; flex-shrink:0; }
.lc-bar { width:3px; align-self:stretch; border-radius:2px; margin-right:8px; }
.lc-bar.hired { background-color:#c2410c; }
.lc-bar.owned { background-color:#1d4ed8; }
.lc-reading-label { font-size:.6rem; letter-spacing:.05em; font-weight:600; color:#94a3b8; text-transform:uppercase; line-height:1; }
.lc-reading-value { font-size:1.15rem; font-weight:800; line-height:1.2; }
.lc-reading-value.hired { color:#c2410c; }
.lc-reading-value.owned { color:#1d4ed8; }
.lc-reading-unit  { font-size:.72rem; font-weight:400; color:#64748b; }
.lc-since-label   { font-size:.55rem; letter-spacing:.05em; font-weight:600; color:#94a3b8; text-transform:uppercase; margin-top:4px; }
.lc-since-value   { font-size:.72rem; color:#475569; font-weight:600; }
.lc-relative-time { font-size:.65rem; color:#94a3b8; font-style:italic; }

.lc-op-row { font-size:.85rem; color:#475569; border-top:1px dashed #e2e8f0;
  padding-top:6px; margin-top:6px; display:flex; align-items:center; gap:6px; }
.lc-op-row i { color:#94a3b8; width:14px; flex-shrink:0; }

.lc-actions { display:flex; flex-wrap:nowrap; align-items:center; gap:6px;
  padding-top:10px; border-top:1px solid #f1f5f9; margin-top:auto; }

/* START/STOP toggle — exact from old appmobile.css */
.lc-switch { position:relative; display:inline-block; flex-grow:1;
  min-width:86px; max-width:180px; height:34px; user-select:none; cursor:pointer; margin:0; }
.lc-switch input { opacity:0; width:0; height:0; }
.lc-slider { position:absolute; top:0; left:0; right:0; bottom:0; background:#198754;
  transition:background .35s; border-radius:11px;
  box-shadow:inset 0 2px 4px rgba(0,0,0,.15); overflow:hidden; }
.lc-slider:before { position:absolute; content:""; height:26px; width:26px;
  left:4px; bottom:4px; background:#fff; transition:left .35s;
  border-radius:8px; box-shadow:0 2px 4px rgba(0,0,0,.25); z-index:2; }
.lc-switch input:checked + .lc-slider { background:#dc3545; }
.lc-switch input:checked + .lc-slider:before { left:calc(100% - 30px); }
.lc-txt-start { position:absolute; right:8px; top:50%; transform:translateY(-50%);
  color:#fff; font-weight:800; font-size:.72rem; letter-spacing:.5px; opacity:1; z-index:1; transition:opacity .35s; }
.lc-txt-stop  { position:absolute; left:10px; top:50%; transform:translateY(-50%);
  color:#fff; font-weight:800; font-size:.72rem; letter-spacing:.5px; opacity:0; z-index:1; transition:opacity .35s; }
.lc-switch input:checked + .lc-slider .lc-txt-start { opacity:0; }
.lc-switch input:checked + .lc-slider .lc-txt-stop  { opacity:1; }

.btn-navy { background:#1b59b9 !important; border-color:#1b59b9 !important; color:#fff !important; }
.btn-navy:hover { background:#134696 !important; }
.lc-btn { padding:0; font-size:.8rem; border:none; border-radius:6px; cursor:pointer;
  width:34px; height:34px; display:inline-flex; align-items:center; justify-content:center; flex-shrink:0; }
.lc-info-btn { width:34px; height:34px; border-radius:8px; background:#64748b; border:none;
  color:#fff; display:flex; align-items:center; justify-content:center; cursor:pointer; flex-shrink:0; margin-left:auto; }
.lc-info-btn:hover { background:#475569; }

/* status filter pills */
.lc-filter-pills { display:flex; gap:6px; flex-wrap:wrap; }
.lc-pill { padding:4px 14px; border-radius:20px; font-size:.75rem; font-weight:600;
  border:1.5px solid #cbd5e1; background:#fff; color:#64748b; cursor:pointer; transition:all .15s; }
.lc-pill:hover { border-color:#94a3b8; }
.lc-pill.active-all     { background:#1b59b9; border-color:#1b59b9; color:#fff; }
.lc-pill.active-working { background:#16a34a; border-color:#16a34a; color:#fff; }
.lc-pill.active-idle    { background:#64748b; border-color:#64748b; color:#fff; }
.lc-pill.active-breakdown{ background:#dc2626; border-color:#dc2626; color:#fff; }
`;

/* ── stat card ── */
function StatCard({ icon, label, value, color }) {
  return (
    <div className="card" style={{ flex:"1 1 130px", minWidth:120, borderTop:`3px solid ${color}` }}>
      <div className="card-body" style={{ padding:16, display:"flex", alignItems:"center", gap:14 }}>
        <div style={{ width:40, height:40, borderRadius:10, background:color+"18", display:"flex", alignItems:"center", justifyContent:"center" }}>
          <i className={icon} style={{ color, fontSize:18 }} />
        </div>
        <div>
          <div style={{ fontSize:22, fontWeight:700, color:"var(--text-primary)", lineHeight:1 }}>{value}</div>
          <div style={{ fontSize:11, color:"var(--text-secondary)", marginTop:3 }}>{label}</div>
        </div>
      </div>
    </div>
  );
}

/* ── machine card ── */
function MachineCard({ m, onToggle, onLog, onService, onBreakdown, onFuel, onInfo }) {
  const isWorking   = m.status === "Working";
  const isBreakdown = m.status === "Breakdown";
  const cls         = m.ownership?.toLowerCase() === "hired" ? "hired" : "owned";
  const statusCls   = { Working:"working", Idle:"idle", Breakdown:"breakdown" }[m.status] || "idle";
  const cardBg      = isWorking ? { backgroundColor:"rgba(25,135,84,.05)" }
                    : isBreakdown ? { backgroundColor:"rgba(220,38,38,.05)" } : {};

  return (
    <div className="lc-card" style={cardBg}>
      {/* Header */}
      <div className={`lc-header ${cls}`}>
        <div style={{ display:"flex", alignItems:"center", gap:10, minWidth:0, flex:1 }}>
          <MachineIcon type={m.type} cls={cls} />
          <div style={{ minWidth:0 }}>
            <h4 className={`lc-title ${cls}`}>{m.code}</h4>
            <span className="lc-own-badge">{m.ownership}</span>
          </div>
        </div>
        <div className="lc-status-wrap">
          {(isWorking || isBreakdown) && <span className={`lc-pulse ${isBreakdown?"breakdown":""}`} />}
          <span className={`lc-status-badge ${statusCls}`}>{m.status}</span>
        </div>
      </div>

      {/* Body */}
      <div className="lc-body">
        <div style={{ display:"flex", justifyContent:"space-between", alignItems:"stretch", marginBottom:4, gap:8 }}>
          {/* Left metadata */}
          <div className="lc-meta">
            <div className="lc-meta-row">
              <i className="ti-layout-grid2-alt" />
              <span style={{ overflow:"hidden", textOverflow:"ellipsis", whiteSpace:"nowrap" }}>{m.type}</span>
            </div>
            <div className="lc-meta-row">
              <i className="ti-location-pin" />
              <span style={{ overflow:"hidden", textOverflow:"ellipsis", whiteSpace:"nowrap" }}>{m.site}</span>
            </div>
          </div>
          {/* Reading */}
          <div className="lc-reading-col">
            <div className={`lc-bar ${cls}`} />
            <div style={{ display:"flex", flexDirection:"column", justifyContent:"center" }}>
              <div className="lc-reading-label">READING</div>
              <div className={`lc-reading-value ${cls}`}>
                {m.reading.toLocaleString()} <span className="lc-reading-unit">{m.unit}</span>
              </div>
              <div className="lc-since-label">SINCE</div>
              <div className="lc-since-value">{new Date(m.since).toLocaleDateString("en-IN",{day:"numeric",month:"short"})}</div>
              <div className="lc-relative-time">{relativeTime(m.since)}</div>
            </div>
          </div>
        </div>

        {/* Operator */}
        <div className="lc-op-row">
          <i className="ti-user" /><span>{m.operator}</span>
        </div>

        {/* Actions */}
        <div className="lc-actions">
          <label className="lc-switch">
            <input type="checkbox" checked={isWorking} onChange={() => onToggle(m)} />
            <span className="lc-slider">
              <span className="lc-txt-start">START</span>
              <span className="lc-txt-stop">STOP</span>
            </span>
          </label>
          <button className="lc-btn btn-navy"               title="Add Log"       onClick={() => onLog(m)}><i className="ti-plus" /></button>
          <button className="lc-btn btn-warning text-dark"  title="Maintenance"   onClick={() => onService(m)}><i className="ti-settings" /></button>
          <button className="lc-btn btn-danger"             title="Breakdown"     onClick={() => onBreakdown(m)}><i className="ti-close" /></button>
          <button className="lc-btn btn-info text-white"    title="Fuel Entry"    onClick={() => onFuel(m)}><i className="ti-dropbox-alt" /></button>
          <button className="lc-info-btn"                   title="Details"       onClick={() => onInfo(m)}><i className="ti-info" /></button>
        </div>
      </div>
    </div>
  );
}

/* ── Module root ── */
export default function LogsModule() {
  const [machines,    setMachines]    = useState(SAMPLE);
  const [siteFilter,  setSiteFilter]  = useState("");
  const [statusFilter,setStatusFilter]= useState("");

  const sites     = [...new Set(machines.map(m => m.site))];

  const filtered = machines.filter(m =>
    (!siteFilter  || m.site   === siteFilter) &&
    (!statusFilter || m.status === statusFilter)
  );

  const handleToggle = (m) =>
    setMachines(prev => prev.map(x =>
      x.id === m.id ? { ...x, status: x.status === "Working" ? "Idle" : "Working" } : x
    ));

  const noop = (label) => (m) => console.log(label, m.code);

  const pillCls = (val, type) =>
    statusFilter === val ? `lc-pill active-${type}` : "lc-pill";

  return (
    <div className="animate-fade">
      <style>{CSS}</style>


      {/* ── Main card ── */}
      <div className="card">
        <div className="card-header" style={{ display:"flex", alignItems:"center", justifyContent:"space-between", flexWrap:"wrap", gap:12 }}>
          <div style={{ display:"flex", alignItems:"center", gap:10 }}>
            <i className="ti-calendar" style={{ color:"var(--primary-color)", fontSize:18 }} />
            <h5 style={{ margin:0, fontWeight:700, color:"var(--text-primary)" }}>Logs</h5>
            <span className="badge badge-pill badge-secondary" style={{ fontSize:11 }}>{filtered.length} machines</span>
          </div>

          {/* Filters */}
          <div style={{ display:"flex", alignItems:"center", gap:12, flexWrap:"wrap" }}>
            {/* Status pills */}
            <div className="lc-filter-pills">
              <button className={pillCls("","all")}         onClick={() => setStatusFilter("")}>All</button>
              <button className={pillCls("Working","working")}    onClick={() => setStatusFilter("Working")}>Working</button>
              <button className={pillCls("Idle","idle")}         onClick={() => setStatusFilter("Idle")}>Idle</button>
              <button className={pillCls("Breakdown","breakdown")} onClick={() => setStatusFilter("Breakdown")}>Breakdown</button>
            </div>
            {/* Site dropdown */}
            <select className="form-control form-control-sm" style={{ width:160 }}
              value={siteFilter} onChange={e => setSiteFilter(e.target.value)}>
              <option value="">All Sites</option>
              {sites.map(s => <option key={s} value={s}>{s}</option>)}
            </select>
          </div>
        </div>

        <div className="card-body">
          {filtered.length === 0 ? (
            <div style={{ textAlign:"center", padding:"60px", color:"var(--text-secondary)" }}>
              <i className="ti-search" style={{ fontSize:48, opacity:.2, display:"block", marginBottom:12 }} />
              <p style={{ fontWeight:600 }}>No machines found.</p>
            </div>
          ) : (
            <div className="lc-grid">
              {filtered.map(m => (
                <MachineCard key={m.id} m={m}
                  onToggle={handleToggle}
                  onLog={noop("LOG")} onService={noop("SERVICE")}
                  onBreakdown={noop("BREAKDOWN")} onFuel={noop("FUEL")} onInfo={noop("INFO")}
                />
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
