import React, { useState, useEffect, useMemo } from "react";
import { createPortal } from "react-dom";
import { Loader2 } from "lucide-react";

const API   = "http://localhost:5167/api";
const TODAY = new Date().toISOString().split("T")[0];

function SectionHeader({ label }) {
  return <h6 style={{ color:"var(--primary-color)", fontSize:"13px", fontWeight:700, textTransform:"uppercase", letterSpacing:"0.08em", borderBottom:"1px solid var(--border-color)", paddingBottom:"6px", marginBottom:"14px", marginTop:"20px" }}>{label}</h6>;
}
function FormRow({ children }) { return <div style={{ display:"flex", gap:"16px", marginBottom:"14px" }}>{children}</div>; }
function FormGroup({ label, required, children }) {
  return (
    <div style={{ flex:1, minWidth:0 }}>
      <label style={{ display:"block", color:"var(--text-secondary)", fontSize:"12px", fontWeight:600, marginBottom:"5px", textTransform:"uppercase", letterSpacing:"0.04em" }}>
        {label}{required && <span style={{ color:"var(--danger-color)", marginLeft:2 }}>*</span>}
      </label>
      {children}
    </div>
  );
}

const EMPTY_FORM = { projId:"", assetId:"", opId:"", allocationDate:TODAY, releaseDate:"", remarks:"" };

export default function MachineOperatorModule() {
  const [records,      setRecords]      = useState([]);
  const [projects,     setProjects]     = useState([]);
  const [projAssets,   setProjAssets]   = useState([]);   // active project-asset allocations
  const [projOps,      setProjOps]      = useState([]);   // active project-operator allocations
  const [assetOpAlloc, setAssetOpAlloc] = useState([]);   // existing machine-operator allocations (active)
  const [loading,      setLoading]      = useState(true);
  const [showModal,    setShowModal]    = useState(false);
  const [editingId,    setEditingId]    = useState(null);
  const [form,         setForm]         = useState(EMPTY_FORM);
  const [saving,       setSaving]       = useState(false);
  const [filterProj,   setFilterProj]   = useState("");
  const [filterStatus, setFilterStatus] = useState("");

  const hdr = () => ({ "Content-Type":"application/json" });

  const load = async () => {
    setLoading(true);
    try {
      const [r, p, pa, po, aoa] = await Promise.all([
        fetch(`${API}/AssetOpAllocation`,   { headers:hdr() }).then(x=>x.json()),
        fetch(`${API}/Project`,             { headers:hdr() }).then(x=>x.json()),
        fetch(`${API}/ProjAssetAllocation`, { headers:hdr() }).then(x=>x.json()),
        fetch(`${API}/ProjOpAllocation`,    { headers:hdr() }).then(x=>x.json()),
        fetch(`${API}/AssetOpAllocation`,   { headers:hdr() }).then(x=>x.json()),
      ]);
      setRecords(r.data  || []);
      setProjects(p.data || []);
      setProjAssets((pa.data  || []).filter(x => !x.releaseDate));
      setProjOps(   (po.data  || []).filter(x => !x.releaseDate));
      setAssetOpAlloc((aoa.data || []).filter(x => !x.releaseDate));
    } catch(e) { console.error(e); } finally { setLoading(false); }
  };

  useEffect(() => { load(); }, []);

  const handleChange = (e) => {
    const { name, value } = e.target;
    if (name === "projId") {
      setForm(p => ({ ...p, projId:value, assetId:"", opId:"" }));
    } else {
      setForm(p => ({ ...p, [name]:value }));
    }
  };


  const projectMachines = useMemo(() =>
    projAssets.filter(pa => String(pa.projId) === String(form.projId)),
    [projAssets, form.projId]
  );

  // Operators allocated to the selected project (active only)
  const projectOperators = useMemo(() =>
    projOps.filter(po => String(po.projId) === String(form.projId)),
    [projOps, form.projId]
  );

  // Enrich records with project name for display (look up from projAssets/projOps)
  const enrichedRecords = useMemo(() => {
    return records.map(r => {
      const pa = projAssets.find(a => a.assetId === r.assetId) || null;
      const po = projOps.find(o => o.opId === r.opId) || null;
      // Try to find project from active allocations; fall back to any record match
      const projName = pa?.projName || po?.projName || "�";
      return { ...r, projName };
    });
  }, [records, projAssets, projOps]);

  const isActive = (r) => !r.releaseDate;

  const openAdd = () => { setEditingId(null); setForm(EMPTY_FORM); setShowModal(true); };
  const openEdit = (r) => {
    setEditingId(r.assetOpAllocId);
    // Find which project this machine belongs to
    const pa = projAssets.find(a => a.assetId === r.assetId);
    setForm({ projId: pa ? String(pa.projId) : "", assetId:String(r.assetId), opId:String(r.opId), allocationDate:r.allocationDate||TODAY, releaseDate:r.releaseDate||"", remarks:r.remarks||"" });
    setShowModal(true);
  };
  const closeModal = () => { setShowModal(false); setEditingId(null); setForm(EMPTY_FORM); };

  const handleSubmit = async (e) => {
    e.preventDefault(); setSaving(true);
    try {
      const payload = { assetId:parseInt(form.assetId), opId:parseInt(form.opId), allocationDate:form.allocationDate, releaseDate:form.releaseDate||null, remarks:form.remarks||null };
      const url    = editingId ? `${API}/AssetOpAllocation/${editingId}` : `${API}/AssetOpAllocation`;
      const method = editingId ? "PUT" : "POST";
      const res    = await fetch(url, { method, headers:hdr(), body:JSON.stringify(payload) });
      const json   = await res.json();
      if (!res.ok) throw new Error(json.message || `Error ${res.status}`);
      await load(); closeModal();
    } catch(err) { alert("Error: "+err.message); } finally { setSaving(false); }
  };

  const handleDeallocate = async (id) => {
    if (!window.confirm("Release this operator from the machine?")) return;
    try {
      const res = await fetch(`${API}/AssetOpAllocation/${id}/deallocate`, { method:"PATCH", headers:hdr() });
      if (!res.ok) throw new Error("Deallocate failed");
      await load();
    } catch(e) { alert("Error: "+e.message); }
  };

  const handleDelete = async (id) => {
    if (!window.confirm("Delete this machine-operator record?")) return;
    try {
      await fetch(`${API}/AssetOpAllocation/${id}`, { method:"DELETE", headers:hdr() });
      await load();
    } catch(e) { alert("Error: "+e.message); }
  };

  const filtered = enrichedRecords.filter(r => {
    const pa = projAssets.find(a => a.assetId === r.assetId);
    const matchProj = !filterProj || (pa && String(pa.projId) === filterProj);
    const matchStatus = !filterStatus || (filterStatus === "active" ? isActive(r) : !isActive(r));
    return matchProj && matchStatus;
  });

  const activeCount   = records.filter(r =>  isActive(r)).length;
  const releasedCount = records.filter(r => !isActive(r)).length;

  return (
    <div className="animate-fade">
      <div style={{ display:"flex", gap:"16px", marginBottom:"24px", flexWrap:"wrap" }}>
        {[
          { label:"Total Assignments", value:records.length, icon:"ti-link",   color:"var(--primary-color)" },
          { label:"Active",            value:activeCount,     icon:"ti-check",  color:"var(--success-color)" },
          { label:"Released",          value:releasedCount,   icon:"ti-unlock", color:"var(--text-secondary)"},
        ].map((c,i)=>(
          <div key={i} className="card" style={{ flex:"1 1 150px", minWidth:"130px", borderTop:`3px solid ${c.color}` }}>
            <div className="card-body" style={{ padding:"16px", display:"flex", alignItems:"center", gap:"14px" }}>
              <div style={{ width:40, height:40, borderRadius:"10px", background:c.color+"18", display:"flex", alignItems:"center", justifyContent:"center" }}>
                <i className={c.icon} style={{ color:c.color, fontSize:"18px" }} />
              </div>
              <div>
                <div style={{ fontSize:"22px", fontWeight:700, color:"var(--text-primary)", lineHeight:1 }}>{c.value??0}</div>
                <div style={{ fontSize:"11px", color:"var(--text-secondary)", marginTop:"3px" }}>{c.label}</div>
              </div>
            </div>
          </div>
        ))}
      </div>

      <div className="card">
        <div className="card-header" style={{ display:"flex", alignItems:"center", justifyContent:"space-between", flexWrap:"wrap", gap:"12px" }}>
          <div style={{ display:"flex", alignItems:"center", gap:"10px" }}>
            <i className="ti-settings" style={{ color:"var(--primary-color)", fontSize:"18px" }} />
            <h5 style={{ margin:0, fontWeight:700, color:"var(--text-primary)" }}>Machine Operator Assignment</h5>
            <span className="badge badge-pill badge-secondary" style={{ fontSize:"11px" }}>{filtered.length} records</span>
          </div>
          <button className="btn btn-carolina btn-sm" onClick={openAdd} id="btn-add-machine-op">
            <i className="ti-plus" style={{ marginRight:6 }} />Assign Operator
          </button>
        </div>

        <div className="card-body">
          <div style={{ display:"flex", gap:"12px", marginBottom:"18px", flexWrap:"wrap" }}>
            <select className="form-control" style={{ flex:"1 1 180px", maxWidth:"240px" }} value={filterProj} onChange={e=>setFilterProj(e.target.value)} id="mo-filter-proj">
              <option value="">All Projects</option>
              {projects.map(p=><option key={p.projId} value={p.projId}>{p.projName}</option>)}
            </select>
            <select className="form-control" style={{ flex:"1 1 140px", maxWidth:"180px" }} value={filterStatus} onChange={e=>setFilterStatus(e.target.value)} id="mo-filter-status">
              <option value="">All Status</option>
              <option value="active">Active</option>
              <option value="released">Released</option>
            </select>
          </div>

          {loading ? (
            <div style={{ textAlign:"center", padding:"60px", color:"var(--text-secondary)" }}>
              <Loader2 size={32} style={{ animation:"spin 1s linear infinite", color:"var(--primary-color)" }} />
              <p style={{ marginTop:12 }}>Loading assignments�</p>
            </div>
          ) : filtered.length === 0 ? (
            <div style={{ textAlign:"center", padding:"60px", color:"var(--text-secondary)" }}>
              <i className="ti-settings" style={{ fontSize:"48px", opacity:0.2, display:"block", marginBottom:"12px" }} />
              <p style={{ fontWeight:600 }}>No machine-operator assignments found.</p>
              <p style={{ fontSize:"12px" }}>First allocate machines and operators to a project, then assign here.</p>
              <button className="btn btn-carolina btn-sm" onClick={openAdd} style={{ marginTop:8 }}><i className="ti-plus" style={{ marginRight:6 }} />Assign First Operator</button>
            </div>
          ) : (
            <div style={{ overflowX:"auto" }}>
              <table className="table table-hover table-striped" style={{ marginBottom:0 }}>
                <thead>
                  <tr>
                    <th style={{ width:40 }}>#</th>
                    <th>Project</th><th>Machine</th><th>Operator</th><th>Alloc. Date</th><th>Release Date</th><th>Status</th><th>Remarks</th>
                    <th style={{ width:120 }}>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  {filtered.map((r,idx)=>(
                    <tr key={r.assetOpAllocId}>
                      <td style={{ color:"var(--text-secondary)", fontSize:"12px" }}>{idx+1}</td>
                      <td style={{ fontWeight:600, fontSize:"12px" }}>{r.projName}</td>
                      <td style={{ fontWeight:600 }}>{r.assetName}</td>
                      <td>{r.opFullName}</td>
                      <td style={{ fontSize:"12px" }}>{r.allocationDate}</td>
                      <td style={{ fontSize:"12px" }}>{r.releaseDate || <span style={{ color:"var(--text-secondary)", fontStyle:"italic" }}>Active</span>}</td>
                      <td>{isActive(r) ? <span className="badge badge-pill badge-success" style={{ fontSize:"11px" }}>Active</span> : <span className="badge badge-pill badge-secondary" style={{ fontSize:"11px" }}>Released</span>}</td>
                      <td style={{ fontSize:"12px", color:"var(--text-secondary)" }}>{r.remarks||"�"}</td>
                      <td>
                        <div style={{ display:"flex", gap:"4px" }}>
                          <button className="btn btn-sm btn-outline-secondary" style={{ padding:"3px 8px" }} title="Edit" onClick={()=>openEdit(r)}><i className="ti-pencil" /></button>
                          {isActive(r) && <button className="btn btn-sm btn-outline-warning" style={{ padding:"3px 8px" }} title="Release" onClick={()=>handleDeallocate(r.assetOpAllocId)}><i className="ti-unlock" /></button>}
                          <button className="btn btn-sm btn-outline-danger" style={{ padding:"3px 8px" }} title="Delete" onClick={()=>handleDelete(r.assetOpAllocId)}><i className="ti-trash" /></button>
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>
      </div>

      {showModal && createPortal(
        <div className="modal fade show" style={{ display:"block", background:"rgba(0,0,0,0.55)", position:"fixed", inset:0, zIndex:1055, overflowY:"auto" }}
          onClick={e=>{ if(e.target===e.currentTarget) closeModal(); }}>
          <div className="modal-dialog" style={{ margin:"60px auto", maxWidth:"580px" }}>
            <div className="modal-content modal-content-custom">
              <div className="modal-header" style={{ borderBottom:"1px solid var(--border-color)", padding:"18px 24px" }}>
                <div style={{ display:"flex", alignItems:"center", gap:"10px" }}>
                  <div style={{ width:36, height:36, borderRadius:"8px", background:"var(--primary-color)", display:"flex", alignItems:"center", justifyContent:"center" }}>
                    <i className="ti-settings" style={{ color:"#fff", fontSize:"16px" }} />
                  </div>
                  <div>
                    <h5 className="modal-title" style={{ margin:0, fontWeight:700, color:"var(--text-primary)" }}>{editingId?"Edit Assignment":"Assign Operator to Machine"}</h5>
                    <p style={{ margin:0, fontSize:"12px", color:"var(--text-secondary)" }}>
                      Select a project first � machine & operator lists will filter to that project.
                    </p>
                  </div>
                </div>
                <button className="close" onClick={closeModal} style={{ background:"none", border:"none", fontSize:"22px", cursor:"pointer", color:"var(--text-secondary)", lineHeight:1 }}>&times;</button>
              </div>
              <div className="modal-body" style={{ padding:"24px" }}>
                <form onSubmit={handleSubmit} id="machine-op-form">
                  <SectionHeader label="Step 1 � Select Project" />
                  <FormGroup label="Project" required>
                    <select className="form-control" name="projId" value={form.projId} onChange={handleChange} required id="mo-proj">
                      <option value="">Select project�</option>
                      {projects.map(p=><option key={p.projId} value={p.projId}>{p.projName}</option>)}
                    </select>
                  </FormGroup>

                  {form.projId && (
                    <>
                      <SectionHeader label="Step 2 � Assign" />
                      {projectMachines.length === 0 && (
                        <div className="alert alert-warning" style={{ fontSize:"12px", marginBottom:12 }}>
                          <i className="ti-alert" style={{ marginRight:6 }} />No machines are allocated to this project yet. Go to <strong>Project Machine</strong> first.
                        </div>
                      )}
                      {projectOperators.length === 0 && (
                        <div className="alert alert-warning" style={{ fontSize:"12px", marginBottom:12 }}>
                          <i className="ti-alert" style={{ marginRight:6 }} />No operators are allocated to this project yet. Go to <strong>Project Operator</strong> first.
                        </div>
                      )}
                      <FormRow>
                        <FormGroup label="Machine" required>
                          <select className="form-control" name="assetId" value={form.assetId} onChange={handleChange} required id="mo-asset">
                            <option value="">Select machine�</option>
                            {projectMachines.map(pa=><option key={pa.assetId} value={pa.assetId}>{pa.assetName}</option>)}
                          </select>
                        </FormGroup>
                        <FormGroup label="Operator" required>
                          <select className="form-control" name="opId" value={form.opId} onChange={handleChange} required id="mo-op">
                            <option value="">Select operator�</option>
                            {projectOperators.map(po=><option key={po.opId} value={po.opId}>{po.opFullName}</option>)}
                          </select>
                        </FormGroup>
                      </FormRow>
                    </>
                  )}

                  <SectionHeader label="Dates & Remarks" />
                  <FormRow>
                    <FormGroup label="Allocation Date" required>
                      <input type="date" className="form-control" name="allocationDate" value={form.allocationDate} onChange={handleChange} required id="mo-alloc-date" />
                    </FormGroup>
                    <FormGroup label="Release Date">
                      <input type="date" className="form-control" name="releaseDate" value={form.releaseDate} onChange={handleChange} id="mo-release-date" />
                    </FormGroup>
                  </FormRow>
                  <FormGroup label="Remarks">
                    <textarea className="form-control" name="remarks" rows={2} value={form.remarks} onChange={handleChange} placeholder="Optional remarks�" id="mo-remarks" />
                  </FormGroup>
                </form>
              </div>
              <div className="modal-footer" style={{ borderTop:"1px solid var(--border-color)", padding:"14px 24px", display:"flex", justifyContent:"flex-end", gap:"10px" }}>
                <button type="button" className="btn btn-outline-secondary" onClick={closeModal}><i className="ti-close" style={{ marginRight:6 }} />Cancel</button>
                <button type="submit" form="machine-op-form" className="btn btn-carolina" disabled={saving||!form.projId}>
                  {saving ? <><Loader2 size={14} style={{ animation:"spin 1s linear infinite", marginRight:6 }} />Saving�</> : <><i className="ti-save" style={{ marginRight:6 }} />{editingId?"Update":"Save Assignment"}</>}
                </button>
              </div>
            </div>
          </div>
        </div>,
        document.body
      )}
    </div>
  );
}
