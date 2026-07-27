import React, { useState, useEffect, useMemo } from "react";
import { createPortal } from "react-dom";
import { Loader2, AlertTriangle, Save, Unlock } from "lucide-react";

const API   = "http://localhost:5167/api";
const TODAY = new Date().toISOString().split("T")[0];

/* -- Toast ------------------------------------------------------- */
function Toast({ message, type, onClose }) {
  useEffect(() => { const t = setTimeout(onClose, 4000); return () => clearTimeout(t); }, []);
  const bg = type === "success" ? "#2ecc71" : "#e74c3c";
  return createPortal(
    <div style={{ position:"fixed", bottom:24, right:24, zIndex:9999, background:bg, color:"#fff", padding:"12px 20px", borderRadius:"10px", boxShadow:"0 4px 20px rgba(0,0,0,0.3)", display:"flex", alignItems:"center", gap:"10px", maxWidth:420, fontSize:"14px", fontWeight:500 }}>
      {message}
      <button onClick={onClose} style={{ marginLeft:"auto", background:"none", border:"none", color:"#fff", cursor:"pointer", fontSize:"18px", lineHeight:1 }}>&times;</button>
    </div>,
    document.body
  );
}

/* -- Status pill -------------------------------------------------- */
function StatusPill({ label, color }) {
  const colors = {
    Available:  { bg:"#d4edda", text:"#155724" },
    Active:     { bg:"#cce5ff", text:"#004085" },
    "On This Project": { bg:"#fff3cd", text:"#856404" },
    "Other Project":   { bg:"#f8d7da", text:"#721c24" },
  };
  const c = colors[label] || { bg:"#e2e3e5", text:"#383d41" };
  return (
    <span style={{ background:c.bg, color:c.text, padding:"2px 10px", borderRadius:12, fontSize:"11px", fontWeight:700, whiteSpace:"nowrap" }}>
      {label}
    </span>
  );
}

/* -- Filter tabs --------------------------------------------------- */
const TABS = ["All","Free","On This Project","Other Project"];

export default function ProjectMachineModule() {
  const [projects,    setProjects]    = useState([]);
  const [assets,      setAssets]      = useState([]);
  const [allocations, setAllocations] = useState([]); // all active (no releaseDate)
  const [loading,     setLoading]     = useState(true);
  const [saving,      setSaving]      = useState(false);
  const [toast,       setToast]       = useState(null);

  // Controls
  const [selectedProjId, setSelectedProjId] = useState("");
  const [allocDate,      setAllocDate]      = useState(TODAY);
  const [activeTab,      setActiveTab]      = useState("All");
  const [searchQ,        setSearchQ]        = useState("");

  // Checked state: Set of assetIds the user has checked
  const [checkedIds, setCheckedIds] = useState(new Set());
  // Track which machines were originally on this project (for delta)
  const [originalOnProject, setOriginalOnProject] = useState(new Set());

  const showToast = (msg, type = "error") => setToast({ message: msg, type });
  const hdr = () => ({ "Content-Type": "application/json" });

  /* -- Load data ----------------------------------------------- */
  const load = async () => {
    setLoading(true);
    try {
      const [pRes, aRes, allocRes] = await Promise.all([
        fetch(`${API}/Project`,             { headers: hdr() }),
        fetch(`${API}/Asset`,               { headers: hdr() }),
        fetch(`${API}/ProjAssetAllocation`, { headers: hdr() }),
      ]);
      const p     = await pRes.json();
      const a     = await aRes.json();
      const alloc = await allocRes.json();
      setProjects(p.data    || []);
      setAssets(a.data      || []);
      const active = (alloc.data || []).filter(x => !x.releaseDate);
      setAllocations(active);
    } catch(e) { showToast("Failed to load data."); }
    finally    { setLoading(false); }
  };

  useEffect(() => { load(); }, []);

  /* -- When project changes, re-compute initial checked set --- */
  useEffect(() => {
    if (!selectedProjId) { setCheckedIds(new Set()); setOriginalOnProject(new Set()); return; }
    const onThis = new Set(
      allocations
        .filter(a => a.projId === parseInt(selectedProjId))
        .map(a => a.assetId)
    );
    setCheckedIds(new Set(onThis));       // pre-check machines on this project
    setOriginalOnProject(new Set(onThis)); // remember original state for delta
  }, [selectedProjId, allocations]);

  /* -- Per-machine status derivation --------------------------- */
  const enriched = useMemo(() => {
    const projIdNum = parseInt(selectedProjId) || null;
    return assets.map(a => {
      const alloc = allocations.find(al => al.assetId === a.assetId);
      let status;
      if (!alloc) {
        status = "Free";
      } else if (alloc.projId === projIdNum) {
        status = "On This Project";
      } else {
        status = "Other Project";
      }
      return {
        ...a,
        status,
        currentProject: alloc?.projName || null,
        allocSince:     alloc?.allocationDate || null,
        allocId:        alloc?.projAssetAllocId || null,
      };
    });
  }, [assets, allocations, selectedProjId]);

  /* -- Counts for tabs --------------------------------------- */
  const counts = useMemo(() => ({
    All:             enriched.length,
    Free:            enriched.filter(a => a.status === "Free").length,
    "On This Project": enriched.filter(a => a.status === "On This Project").length,
    "Other Project":   enriched.filter(a => a.status === "Other Project").length,
  }), [enriched]);

  /* -- Filtered list ----------------------------------------- */
  const visible = useMemo(() => {
    let list = enriched;
    if (activeTab !== "All") list = list.filter(a => a.status === activeTab);
    if (searchQ.trim())      list = list.filter(a =>
      a.assetName?.toLowerCase().includes(searchQ.toLowerCase()) ||
      a.assetCode?.toLowerCase().includes(searchQ.toLowerCase())
    );
    return list;
  }, [enriched, activeTab, searchQ]);

  /* -- Checkbox helpers -------------------------------------- */
  const isDisabled = (a) => a.status === "Other Project"; // cannot touch machines on other projects

  const toggle = (assetId) => {
    setCheckedIds(prev => {
      const next = new Set(prev);
      if (next.has(assetId)) next.delete(assetId);
      else                   next.add(assetId);
      return next;
    });
  };

  const toggleAll = () => {
    const toggleable = visible.filter(a => !isDisabled(a));
    const allChecked = toggleable.every(a => checkedIds.has(a.assetId));
    setCheckedIds(prev => {
      const next = new Set(prev);
      if (allChecked) toggleable.forEach(a => next.delete(a.assetId));
      else            toggleable.forEach(a => next.add(a.assetId));
      return next;
    });
  };

  /* -- Save: compute delta and call API --------------------- */
  /* -- Save: compute delta and call API ------------------------- */
  const handleSave = async () => {
    if (!selectedProjId) { showToast("Please select a project first."); return; }
    setSaving(true);
    try {
      const toAllocate   = [...checkedIds].filter(id => !originalOnProject.has(id));
      const toDeallocate = [...originalOnProject].filter(id => !checkedIds.has(id));

      // Allocate new
      const allocResults = await Promise.allSettled(
        toAllocate.map(assetId =>
          fetch(`${API}/ProjAssetAllocation`, {
            method: "POST", headers: hdr(),
            body: JSON.stringify({ projId: parseInt(selectedProjId), assetId, allocationDate: allocDate, releaseDate: null, remarks: null })
          }).then(async res => { if (!res.ok) { const j = await res.json().catch(()=>{}); throw new Error(j?.message || `Allocate failed (${res.status})`); } return res.json(); })
        )
      );

      // Deallocate removed
      const deallocResults = await Promise.allSettled(
        toDeallocate.map(assetId => {
          const alloc = allocations.find(a => a.assetId === assetId && a.projId === parseInt(selectedProjId));
          if (!alloc) return Promise.resolve();
          return fetch(`${API}/ProjAssetAllocation/${alloc.projAssetAllocId}/deallocate`, {
            method: "PATCH", headers: hdr()
          }).then(async res => { if (!res.ok) { const j = await res.json().catch(()=>{}); throw new Error(j?.message || `Deallocate failed (${res.status})`); } return res.json(); });
        })
      );

      await load();

      const failed = [...allocResults, ...deallocResults].filter(r => r.status === "rejected");
      if (failed.length) showToast(`${failed.length} operation(s) failed: ${failed[0].reason?.message}`);
      else               showToast(`Saved! ${toAllocate.length} allocated, ${toDeallocate.length} released.`, "success");
    } catch(e) { showToast(e.message); }
    finally    { setSaving(false); }
  };

  /* -- Release All: deallocate every machine on this project -- */
  const handleReleaseAll = async () => {
    if (!selectedProjId) { showToast("Please select a project first."); return; }
    const onThis = allocations.filter(a => a.projId === parseInt(selectedProjId));
    if (!onThis.length) { showToast("No machines are currently allocated to this project."); return; }
    if (!window.confirm(`Release all ${onThis.length} machine(s) from this project?`)) return;
    setSaving(true);
    try {
      const results = await Promise.allSettled(
        onThis.map(a =>
          fetch(`${API}/ProjAssetAllocation/${a.projAssetAllocId}/deallocate`, {
            method: "PATCH", headers: hdr()
          }).then(async res => {
            if (!res.ok) {
              const j = await res.json().catch(() => ({}));
              throw new Error(j?.message || `Failed for allocation #${a.projAssetAllocId} (HTTP ${res.status})`);
            }
            return res.json();
          })
        )
      );
      await load();
      const failed = results.filter(r => r.status === "rejected");
      if (failed.length) showToast(`${failed.length} release(s) failed: ${failed[0].reason?.message}`);
      else               showToast(`All ${onThis.length} machine(s) released successfully.`, "success");
    } catch(e) { showToast(e.message); }
    finally    { setSaving(false); }
  };

  /* -- Stats ------------------------------------------------- */
  const allocatedCount = enriched.filter(a => a.status === "On This Project").length;

  const visibleToggleable = visible.filter(a => !isDisabled(a));
  const allVisibleChecked = visibleToggleable.length > 0 && visibleToggleable.every(a => checkedIds.has(a.assetId));

  /* -- Render ------------------------------------------------ */
  return (
    <div className="animate-fade" style={{ display:"flex", flexDirection:"column", gap:0 }}>
      {toast && <Toast message={toast.message} type={toast.type} onClose={() => setToast(null)} />}

      {/* -- Top header bar ----------------------------------- */}
      <div className="card" style={{ marginBottom:0, borderBottomLeftRadius:0, borderBottomRightRadius:0, borderBottom:"none" }}>
        <div className="card-body" style={{ padding:"16px 20px", display:"flex", alignItems:"center", flexWrap:"wrap", gap:"14px" }}>
          <div style={{ display:"flex", alignItems:"center", gap:10, flex:"none" }}>
            <i className="ti-truck" style={{ color:"var(--primary-color)", fontSize:"22px" }} />
            <h4 style={{ margin:0, fontWeight:700, color:"var(--text-primary)", fontSize:"20px" }}>Project Allocation</h4>
          </div>

          <div style={{ display:"flex", alignItems:"center", gap:10, flex:"1 1 300px", flexWrap:"wrap" }}>
            {/* Project selector */}
            <select
              value={selectedProjId}
              onChange={e => setSelectedProjId(e.target.value)}
              className="form-control"
              style={{ maxWidth:260, fontWeight:600 }}
              id="pm-select-project"
            >
              <option value="">— Select Project —</option>
              {projects.map(p => <option key={p.projId} value={p.projId}>{p.projName}</option>)}
            </select>

            {/* Date */}
            <input
              type="date"
              value={allocDate}
              onChange={e => setAllocDate(e.target.value)}
              className="form-control"
              style={{ maxWidth:170 }}
              id="pm-alloc-date"
            />
          </div>

          {/* Action buttons */}
          <div style={{ display:"flex", gap:10, marginLeft:"auto" }}>
            <button className="btn btn-outline-danger btn-sm" onClick={handleReleaseAll} disabled={saving || !selectedProjId} id="btn-release-all"
              style={{ display:"flex", alignItems:"center", gap:6 }}>
              <Unlock size={14} />Release All
            </button>
            <button className="btn btn-carolina btn-sm" onClick={handleSave} disabled={saving || !selectedProjId} id="btn-save-alloc"
              style={{ display:"flex", alignItems:"center", gap:6, minWidth:90 }}>
              {saving ? <><Loader2 size={14} style={{ animation:"spin 1s linear infinite" }} />Saving…</> : <><Save size={14} />Save</>}
            </button>
          </div>
        </div>
      </div>

      {/* -- Sub-header: count + filter tabs + search ----------- */}
      <div className="card" style={{ borderRadius:0, borderTop:"none", borderBottom:"none", marginBottom:0 }}>
        <div className="card-body" style={{ padding:"10px 20px", display:"flex", alignItems:"center", flexWrap:"wrap", gap:"12px" }}>
          <div style={{ display:"flex", alignItems:"center", gap:8 }}>
            <i className="ti-settings" style={{ color:"var(--text-secondary)" }} />
            <span style={{ fontWeight:600, color:"var(--text-primary)" }}>Machinery List</span>
            <span style={{ fontSize:"13px", color:"var(--text-secondary)" }}>
              {selectedProjId ? `${allocatedCount} allocated` : "select a project to see allocations"}
            </span>
          </div>

          {/* Search */}
          <div className="input-group" style={{ maxWidth:240, marginLeft:"auto" }}>
            <div className="input-group-prepend"><span className="input-group-text"><i className="ti-search" /></span></div>
            <input className="form-control" placeholder="Search machine…" value={searchQ} onChange={e=>setSearchQ(e.target.value)} id="pm-search" />
          </div>

          {/* Tab filters */}
          <div style={{ display:"flex", gap:4 }}>
            {TABS.map(tab => (
              <button key={tab}
                onClick={() => setActiveTab(tab)}
                style={{
                  padding:"4px 12px", borderRadius:20, border:"1px solid var(--border-color)", fontSize:"12px", fontWeight:600, cursor:"pointer",
                  background: activeTab===tab ? "var(--primary-color)" : "transparent",
                  color:      activeTab===tab ? "#fff" : "var(--text-secondary)",
                  transition:"all 0.15s"
                }}
              >
                {tab} <span style={{ opacity:0.75 }}>({counts[tab]??0})</span>
              </button>
            ))}
          </div>
        </div>
      </div>

      {/* -- Table ----------------------------------------------- */}
      <div className="card" style={{ borderTopLeftRadius:0, borderTopRightRadius:0, borderTop:"none" }}>
        <div className="card-body" style={{ padding:0 }}>
          {loading ? (
            <div style={{ textAlign:"center", padding:"60px", color:"var(--text-secondary)" }}>
              <Loader2 size={32} style={{ animation:"spin 1s linear infinite", color:"var(--primary-color)" }} />
              <p style={{ marginTop:12 }}>Loading machinery list…</p>
            </div>
          ) : (
            <div style={{ overflowX:"auto" }}>
              <table className="table table-hover" style={{ marginBottom:0 }}>
                <thead>
                  <tr style={{ background:"var(--bg-secondary)" }}>
                    <th style={{ width:48, paddingLeft:20 }}>
                      <input type="checkbox"
                        checked={allVisibleChecked}
                        onChange={toggleAll}
                        disabled={!selectedProjId}
                        title="Select / deselect all visible"
                        style={{ width:16, height:16, cursor: selectedProjId ? "pointer" : "not-allowed" }}
                      />
                    </th>
                    <th>MACHINERY</th>
                    <th>TYPE</th>
                    <th>CATEGORY</th>
                    <th>SINCE / TILL</th>
                    <th>CURRENT PROJECT</th>
                    <th>STATUS</th>
                  </tr>
                </thead>
                <tbody>
                  {visible.length === 0 ? (
                    <tr>
                      <td colSpan={7} style={{ textAlign:"center", padding:"50px", color:"var(--text-secondary)" }}>
                        <i className="ti-truck" style={{ fontSize:"40px", opacity:0.15, display:"block", marginBottom:10 }} />
                        No machinery found.
                      </td>
                    </tr>
                  ) : visible.map(a => {
                    const checked   = checkedIds.has(a.assetId);
                    const disabled  = isDisabled(a);
                    const isOnThis  = a.status === "On This Project";
                    const rowBg     = checked && isOnThis ? "rgba(52,152,219,0.08)"
                                    : checked            ? "rgba(46,204,113,0.07)"
                                    : "transparent";
                    return (
                      <tr key={a.assetId}
                        style={{ background:rowBg, opacity: disabled ? 0.55 : 1, cursor: disabled ? "not-allowed" : "pointer", transition:"background 0.15s" }}
                        onClick={() => { if (!disabled && selectedProjId) toggle(a.assetId); }}
                      >
                        <td style={{ paddingLeft:20 }} onClick={e => e.stopPropagation()}>
                          <input type="checkbox"
                            checked={checked}
                            disabled={disabled || !selectedProjId}
                            onChange={() => { if (!disabled && selectedProjId) toggle(a.assetId); }}
                            style={{ width:16, height:16, cursor: disabled || !selectedProjId ? "not-allowed" : "pointer", accentColor:"var(--primary-color)" }}
                          />
                        </td>
                        <td>
                          <div style={{ fontWeight:600, color:"var(--text-primary)", fontSize:"13px" }}>{a.assetName}</div>
                          <div style={{ fontSize:"11px", color:"var(--text-secondary)", marginTop:2 }}>{a.assetCode}</div>
                        </td>
                        <td style={{ fontSize:"13px", color:"var(--text-secondary)" }}>{a.typeName || "—"}</td>
                        <td style={{ fontSize:"13px", color:"var(--text-secondary)" }}>{a.catName  || "—"}</td>
                        <td style={{ fontSize:"12px", color:"var(--text-secondary)" }}>{a.allocSince || "—"}</td>
                        <td style={{ fontSize:"13px", fontWeight: isOnThis ? 600 : 400, color: isOnThis ? "var(--primary-color)" : "var(--text-secondary)" }}>
                          {a.currentProject || "—"}
                        </td>
                        <td>
                          <StatusPill label={
                            a.status === "Free" ? "Available" :
                            a.status === "On This Project" ? "Active" :
                            "Other Project"
                          } />
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

