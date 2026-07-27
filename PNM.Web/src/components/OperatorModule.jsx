import React, { useState, useEffect, useRef } from "react";
import { createPortal } from "react-dom";
import { Loader2, Camera, X } from "lucide-react";

function SectionHeader({ label }) {
  return (
    <h6 style={{ color:"var(--primary-color)", fontSize:"13px", fontWeight:700, textTransform:"uppercase", letterSpacing:"0.08em", borderBottom:"1px solid var(--border-color)", paddingBottom:"6px", marginBottom:"14px", marginTop:"20px" }}>{label}</h6>
  );
}
function FormRow({ children }) {
  return <div style={{ display:"flex", gap:"16px", marginBottom:"14px" }}>{children}</div>;
}
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

const API_BASE    = "http://localhost:5167/api/Operator";
const UPLOAD_URL  = "http://localhost:5167/api/Upload/operator-photo";
const PHOTO_BASE  = "http://localhost:5167";
const DEFAULT_PHOTO = "https://ui-avatars.com/api/?name=Operator&background=4f86c6&color=fff&size=200";

const OP_TYPES  = ["Driver","Operator","Helper","Supervisor","Other"];
const GENDERS   = ["Male","Female","Other"];
const STATUSES  = ["Active","Inactive","On Leave","Terminated"];
const STATUS_BADGE = { Active:"success", Inactive:"secondary", "On Leave":"warning", Terminated:"danger" };
const EMPTY_FORM = { opCode:"", opType:"", fullName:"", dateOfBirth:"", gender:"", mobile:"", aadhaarNo:"", licenseNo:"", address:"", doj:"", status:"Active", photoPath:"" };

export default function OperatorModule() {
  const [operators,     setOperators]    = useState([]);
  const [loading,       setLoading]      = useState(true);
  const [showModal,     setShowModal]    = useState(false);
  const [editingId,     setEditingId]    = useState(null);
  const [form,          setForm]         = useState(EMPTY_FORM);
  const [saving,        setSaving]       = useState(false);
  const [search,        setSearch]       = useState("");
  const [filterStatus,  setFilterStatus] = useState("");
  const [filterType,    setFilterType]   = useState("");

  // Photo upload state
  const [photoPreview,  setPhotoPreview] = useState(null);
  const [photoFile,     setPhotoFile]    = useState(null);
  const [uploadingPhoto, setUploadingPhoto] = useState(false);
  const fileInputRef = useRef(null);

  const authHeaders = () => {
    const token = localStorage.getItem("token");
    return token ? { Authorization:`Bearer ${token}` } : {};
  };

  const fetchOperators = async () => {
    try { setLoading(true); const res = await fetch(API_BASE, { headers:{ "Content-Type":"application/json", ...authHeaders() } }); const j = await res.json(); setOperators(j.data || []); }
    catch(e) { console.error(e); } finally { setLoading(false); }
  };

  useEffect(() => { fetchOperators(); }, []);

  /* -- Resolve photo URL for display -- */
  const resolvePhotoUrl = (path) => {
    if (!path) return DEFAULT_PHOTO;
    if (path.startsWith("http")) return path;
    if (path.startsWith("data:")) return path;
    return `${PHOTO_BASE}${path}`;
  };

  /* -- Photo file selection -- */
  const handlePhotoSelect = (e) => {
    const file = e.target.files[0];
    if (!file) return;
    setPhotoFile(file);
    const reader = new FileReader();
    reader.onload = (ev) => setPhotoPreview(ev.target.result);
    reader.readAsDataURL(file);
  };

  const clearPhoto = () => {
    setPhotoFile(null);
    setPhotoPreview(null);
    if (fileInputRef.current) fileInputRef.current.value = "";
    setForm(prev => ({ ...prev, photoPath:"" }));
  };

  /* -- Upload photo to API -- */
  const uploadPhoto = async () => {
    if (!photoFile) return form.photoPath || null;
    setUploadingPhoto(true);
    try {
      const fd = new FormData();
      fd.append("file", photoFile);
      const res  = await fetch(UPLOAD_URL, { method:"POST", body:fd, headers:authHeaders() });
      const json = await res.json();
      if (!json.success) throw new Error(json.message || "Upload failed");
      return json.path;
    } finally { setUploadingPhoto(false); }
  };

  /* -- Modal open -- */
  const openAdd  = () => { setEditingId(null); setForm(EMPTY_FORM); setPhotoPreview(null); setPhotoFile(null); setShowModal(true); };
  const openEdit = (op) => {
    setEditingId(op.opId);
    setForm({ opCode:op.opCode||"", opType:op.opType||"", fullName:op.fullName||"", dateOfBirth:op.dateOfBirth||"", gender:op.gender||"", mobile:op.mobile||"", aadhaarNo:op.aadhaarNo||"", licenseNo:op.licenseNo||"", address:op.address||"", doj:op.doj||"", status:op.status||"Active", photoPath:op.photoPath||"" });
    setPhotoFile(null);
    setPhotoPreview(op.photoPath ? resolvePhotoUrl(op.photoPath) : null);
    setShowModal(true);
  };
  const closeModal = () => { setShowModal(false); setEditingId(null); setForm(EMPTY_FORM); setPhotoPreview(null); setPhotoFile(null); };
  const handleChange = (e) => { const { name, value } = e.target; setForm(prev => ({ ...prev, [name]:value })); };

  /* -- Submit -- */
  const handleSubmit = async (e) => {
    e.preventDefault(); setSaving(true);
    try {
      const uploadedPath = await uploadPhoto();
      const payload = { opCode:form.opCode.trim(), opType:form.opType||null, fullName:form.fullName.trim(), dateOfBirth:form.dateOfBirth||null, gender:form.gender||null, mobile:form.mobile||null, aadhaarNo:form.aadhaarNo||null, licenseNo:form.licenseNo||null, address:form.address||null, doj:form.doj||null, status:form.status||"Active", photoPath:uploadedPath||null };
      const res = await fetch(editingId ? `${API_BASE}/${editingId}` : API_BASE, { method:editingId?"PUT":"POST", headers:{ "Content-Type":"application/json", ...authHeaders() }, body:JSON.stringify(payload) });
      if (!res.ok) throw new Error(`Server error: ${res.status}`);
      await fetchOperators(); closeModal();
    } catch(err) { alert("Error: "+err.message); } finally { setSaving(false); }
  };

  const handleDelete = async (id) => {
    if (!window.confirm("Delete this operator?")) return;
    try { await fetch(`${API_BASE}/${id}`, { method:"DELETE", headers:{ "Content-Type":"application/json", ...authHeaders() } }); await fetchOperators(); }
    catch(e) { alert("Delete failed: "+e.message); }
  };

  const filtered = operators.filter(op => {
    const q = search.toLowerCase();
    return (!q || op.fullName?.toLowerCase().includes(q) || op.opCode?.toLowerCase().includes(q) || op.mobile?.includes(q))
      && (!filterStatus || op.status === filterStatus)
      && (!filterType   || op.opType  === filterType);
  });

  const counts = STATUSES.reduce((a,s) => { a[s]=operators.filter(o=>o.status===s).length; return a; }, {});

  const currentPhotoSrc = photoPreview || (form.photoPath ? resolvePhotoUrl(form.photoPath) : DEFAULT_PHOTO);

  return (
    <div className="animate-fade">
      {/* Summary cards */}
      <div style={{ display:"flex", gap:"16px", marginBottom:"24px", flexWrap:"wrap" }}>
        {[
          { label:"Total Operators", value:operators.length,                                  icon:"ti-user",  color:"var(--primary-color)" },
          { label:"Active",          value:counts["Active"],                                  icon:"ti-check", color:"var(--success-color)" },
          { label:"On Leave",        value:counts["On Leave"],                                icon:"ti-timer", color:"var(--warning-color)" },
          { label:"Inactive / Out",  value:(counts["Inactive"]||0)+(counts["Terminated"]||0), icon:"ti-close", color:"var(--danger-color)"  },
        ].map((c,i) => (
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

      {/* Main card */}
      <div className="card">
        <div className="card-header" style={{ display:"flex", alignItems:"center", justifyContent:"space-between", flexWrap:"wrap", gap:"12px" }}>
          <div style={{ display:"flex", alignItems:"center", gap:"10px" }}>
            <i className="ti-user" style={{ color:"var(--primary-color)", fontSize:"18px" }} />
            <h5 style={{ margin:0, fontWeight:700, color:"var(--text-primary)" }}>Operator Management</h5>
            <span className="badge badge-pill badge-secondary" style={{ fontSize:"11px" }}>{filtered.length} records</span>
          </div>
          <button className="btn btn-carolina btn-sm" onClick={openAdd} id="btn-add-operator">
            <i className="ti-plus" style={{ marginRight:6 }} />Add Operator
          </button>
        </div>

        <div className="card-body">
          {/* Filters */}
          <div style={{ display:"flex", gap:"12px", marginBottom:"18px", flexWrap:"wrap" }}>
            <div className="input-group" style={{ flex:"2 1 220px", maxWidth:"340px" }}>
              <div className="input-group-prepend"><span className="input-group-text"><i className="ti-search" /></span></div>
              <input type="text" className="form-control" placeholder="Search name, code, mobile…" value={search} onChange={e=>setSearch(e.target.value)} id="op-search" />
            </div>
            <select className="form-control" style={{ flex:"1 1 140px", maxWidth:"180px" }} value={filterStatus} onChange={e=>setFilterStatus(e.target.value)} id="op-filter-status">
              <option value="">All Status</option>
              {STATUSES.map(s=><option key={s} value={s}>{s}</option>)}
            </select>
            <select className="form-control" style={{ flex:"1 1 140px", maxWidth:"180px" }} value={filterType} onChange={e=>setFilterType(e.target.value)} id="op-filter-type">
              <option value="">All Types</option>
              {OP_TYPES.map(t=><option key={t} value={t}>{t}</option>)}
            </select>
          </div>

          {/* Table */}
          {loading ? (
            <div style={{ textAlign:"center", padding:"60px", color:"var(--text-secondary)" }}>
              <Loader2 size={32} style={{ animation:"spin 1s linear infinite", color:"var(--primary-color)" }} />
              <p style={{ marginTop:12 }}>Loading operators…</p>
            </div>
          ) : filtered.length === 0 ? (
            <div style={{ textAlign:"center", padding:"60px", color:"var(--text-secondary)" }}>
              <i className="ti-user" style={{ fontSize:"48px", opacity:0.2, display:"block", marginBottom:"12px" }} />
              <p style={{ fontWeight:600 }}>{search||filterStatus||filterType ? "No operators match your filters." : "No operators added yet."}</p>
              {!search && !filterStatus && !filterType && (
                <button className="btn btn-carolina btn-sm" onClick={openAdd} style={{ marginTop:8 }}>
                  <i className="ti-plus" style={{ marginRight:6 }} />Add First Operator
                </button>
              )}
            </div>
          ) : (
            <div style={{ overflowX:"auto" }}>
              <table className="table table-hover table-striped" style={{ marginBottom:0 }}>
                <thead>
                  <tr>
                    <th style={{ width:40 }}>#</th>
                    <th style={{ width:56 }}>Photo</th>
                    <th>Code</th><th>Full Name</th><th>Type</th><th>Mobile</th><th>License No</th><th>D.O.J</th><th>Status</th>
                    <th style={{ width:100 }}>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  {filtered.map((op,idx) => (
                    <tr key={op.opId}>
                      <td style={{ color:"var(--text-secondary)", fontSize:"12px" }}>{idx+1}</td>
                      <td>
                        <img src={resolvePhotoUrl(op.photoPath)} alt={op.fullName}
                          style={{ width:36, height:36, borderRadius:"50%", objectFit:"cover", border:"2px solid var(--border-color)" }}
                          onError={e=>{ e.target.src=DEFAULT_PHOTO; }} />
                      </td>
                      <td><strong style={{ fontFamily:"monospace", color:"var(--primary-color)" }}>{op.opCode}</strong></td>
                      <td style={{ fontWeight:600 }}>{op.fullName}</td>
                      <td><span style={{ fontSize:"12px", color:"var(--text-secondary)" }}>{op.opType||"—"}</span></td>
                      <td>{op.mobile||"—"}</td>
                      <td><span style={{ fontFamily:"monospace", fontSize:"12px" }}>{op.licenseNo||"—"}</span></td>
                      <td style={{ fontSize:"12px" }}>{op.doj||"—"}</td>
                      <td><span className={`badge badge-pill badge-${STATUS_BADGE[op.status]||"secondary"}`} style={{ fontSize:"11px" }}>{op.status||"Unknown"}</span></td>
                      <td>
                        <div style={{ display:"flex", gap:"6px" }}>
                          <button className="btn btn-sm btn-outline-secondary" style={{ padding:"3px 8px" }} title="Edit" onClick={()=>openEdit(op)} id={`btn-edit-op-${op.opId}`}><i className="ti-pencil" /></button>
                          <button className="btn btn-sm btn-outline-danger"    style={{ padding:"3px 8px" }} title="Delete" onClick={()=>handleDelete(op.opId)} id={`btn-delete-op-${op.opId}`}><i className="ti-trash" /></button>
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

      {/* Modal */}
      {showModal && createPortal(
        <div className="modal fade show" style={{ display:"block", background:"rgba(0,0,0,0.55)", position:"fixed", inset:0, zIndex:1055, overflowY:"auto" }}
          onClick={e => { if (e.target===e.currentTarget) closeModal(); }}>
          <div className="modal-dialog modal-lg" style={{ margin:"40px auto", maxWidth:"780px" }}>
            <div className="modal-content modal-content-custom">
              {/* Header */}
              <div className="modal-header" style={{ borderBottom:"1px solid var(--border-color)", padding:"18px 24px" }}>
                <div style={{ display:"flex", alignItems:"center", gap:"10px" }}>
                  <div style={{ width:36, height:36, borderRadius:"8px", background:"var(--primary-color)", display:"flex", alignItems:"center", justifyContent:"center" }}>
                    <i className="ti-user" style={{ color:"#fff", fontSize:"16px" }} />
                  </div>
                  <div>
                    <h5 className="modal-title" style={{ margin:0, fontWeight:700, color:"var(--text-primary)" }}>{editingId?"Edit Operator":"Add New Operator"}</h5>
                    <p style={{ margin:0, fontSize:"12px", color:"var(--text-secondary)" }}>{editingId?"Update operator details below.":"Fill in operator information below."}</p>
                  </div>
                </div>
                <button className="close" onClick={closeModal} style={{ background:"none", border:"none", fontSize:"22px", cursor:"pointer", color:"var(--text-secondary)", lineHeight:1 }}>&times;</button>
              </div>

              {/* Body */}
              <div className="modal-body" style={{ padding:"24px", maxHeight:"calc(100vh - 200px)", overflowY:"auto" }}>
                <form onSubmit={handleSubmit} id="operator-form">

                  {/* -- Photo Upload Section -- */}
                  <SectionHeader label="Profile Photo" />
                  <div style={{ display:"flex", alignItems:"flex-end", gap:"20px", marginBottom:"20px" }}>
                    {/* Preview */}
                    <div style={{ position:"relative", flexShrink:0 }}>
                      <img src={currentPhotoSrc} alt="Profile preview"
                        id="op-photo-preview"
                        style={{ width:100, height:100, borderRadius:"12px", objectFit:"cover", border:"2px solid var(--border-color)", background:"var(--bg-secondary)" }}
                        onError={e=>{ e.target.src=DEFAULT_PHOTO; }} />
                      {/* Clear button if photo selected */}
                      {(photoFile || (form.photoPath && !photoPreview?.startsWith("http://localhost") === false)) && (
                        <button type="button" onClick={clearPhoto}
                          style={{ position:"absolute", top:-8, right:-8, width:22, height:22, borderRadius:"50%", background:"var(--danger-color)", border:"none", cursor:"pointer", display:"flex", alignItems:"center", justifyContent:"center", padding:0 }}>
                          <X size={12} color="#fff" />
                        </button>
                      )}
                    </div>
                    {/* Upload controls */}
                    <div style={{ flex:1 }}>
                      <p style={{ margin:"0 0 8px 0", fontSize:"12px", color:"var(--text-secondary)" }}>
                        Upload a clear profile photo. Supported: JPG, PNG, GIF, WEBP. Max 5MB.
                      </p>
                      <input
                        type="file" accept="image/*" ref={fileInputRef}
                        onChange={handlePhotoSelect} id="op-file-photo"
                        style={{ display:"none" }} />
                      <div style={{ display:"flex", gap:"8px" }}>
                        <button type="button" className="btn btn-outline-secondary btn-sm"
                          onClick={()=>fileInputRef.current?.click()}
                          style={{ display:"flex", alignItems:"center", gap:"6px" }}>
                          <Camera size={14} />{photoFile ? "Change Photo" : "Select Photo"}
                        </button>
                        {photoFile && (
                          <button type="button" className="btn btn-outline-danger btn-sm" onClick={clearPhoto}
                            style={{ display:"flex", alignItems:"center", gap:"6px" }}>
                            <X size={14} />Remove
                          </button>
                        )}
                      </div>
                      {photoFile && (
                        <p style={{ margin:"6px 0 0", fontSize:"11px", color:"var(--success-color)" }}>
                          ? {photoFile.name} ({(photoFile.size/1024).toFixed(1)} KB) — will upload on save
                        </p>
                      )}
                      {uploadingPhoto && (
                        <p style={{ margin:"6px 0 0", fontSize:"11px", color:"var(--primary-color)", display:"flex", alignItems:"center", gap:4 }}>
                          <Loader2 size={12} style={{ animation:"spin 1s linear infinite" }} />Uploading photo…
                        </p>
                      )}
                    </div>
                  </div>

                  {/* -- Personal Information -- */}
                  <SectionHeader label="Personal Information" />
                  <FormRow>
                    <FormGroup label="Operator Code" required>
                      <input type="text" className="form-control" name="opCode" value={form.opCode} onChange={handleChange} placeholder="e.g. OP-001" required id="op-code" />
                    </FormGroup>
                    <FormGroup label="Operator Type">
                      <select className="form-control" name="opType" value={form.opType} onChange={handleChange} id="op-type">
                        <option value="">Select type…</option>
                        {OP_TYPES.map(t=><option key={t} value={t}>{t}</option>)}
                      </select>
                    </FormGroup>
                  </FormRow>
                  <FormRow>
                    <FormGroup label="Full Name" required>
                      <input type="text" className="form-control" name="fullName" value={form.fullName} onChange={handleChange} placeholder="Enter full name" required id="op-fullname" />
                    </FormGroup>
                    <FormGroup label="Gender">
                      <select className="form-control" name="gender" value={form.gender} onChange={handleChange} id="op-gender">
                        <option value="">Select gender…</option>
                        {GENDERS.map(g=><option key={g} value={g}>{g}</option>)}
                      </select>
                    </FormGroup>
                  </FormRow>
                  <FormRow>
                    <FormGroup label="Date of Birth">
                      <input type="date" className="form-control" name="dateOfBirth" value={form.dateOfBirth} onChange={handleChange} id="op-dob" />
                    </FormGroup>
                    <FormGroup label="Mobile">
                      <input type="tel" className="form-control" name="mobile" value={form.mobile} onChange={handleChange} placeholder="e.g. 9876543210" id="op-mobile" />
                    </FormGroup>
                  </FormRow>
                  <FormGroup label="Address">
                    <textarea className="form-control" name="address" rows={2} value={form.address} onChange={handleChange} placeholder="Full residential address" id="op-address" />
                  </FormGroup>

                  {/* -- Documents & License -- */}
                  <SectionHeader label="Documents & License" />
                  <FormRow>
                    <FormGroup label="Aadhaar No">
                      <input type="text" className="form-control" name="aadhaarNo" value={form.aadhaarNo} onChange={handleChange} placeholder="12-digit Aadhaar number" id="op-aadhaar" maxLength={14} />
                    </FormGroup>
                    <FormGroup label="License No">
                      <input type="text" className="form-control" name="licenseNo" value={form.licenseNo} onChange={handleChange} placeholder="Driving license number" id="op-license" />
                    </FormGroup>
                  </FormRow>

                  {/* -- Employment Details -- */}
                  <SectionHeader label="Employment Details" />
                  <FormRow>
                    <FormGroup label="Date of Joining">
                      <input type="date" className="form-control" name="doj" value={form.doj} onChange={handleChange} id="op-doj" />
                    </FormGroup>
                    <FormGroup label="Status" required>
                      <select className="form-control" name="status" value={form.status} onChange={handleChange} required id="op-status">
                        {STATUSES.map(s=><option key={s} value={s}>{s}</option>)}
                      </select>
                    </FormGroup>
                  </FormRow>

                </form>
              </div>

              {/* Footer */}
              <div className="modal-footer" style={{ borderTop:"1px solid var(--border-color)", padding:"14px 24px", display:"flex", justifyContent:"flex-end", gap:"10px" }}>
                <button type="button" className="btn btn-outline-secondary" onClick={closeModal} id="btn-cancel-operator">
                  <i className="ti-close" style={{ marginRight:6 }} />Cancel
                </button>
                <button type="submit" form="operator-form" className="btn btn-carolina" disabled={saving||uploadingPhoto} id="btn-save-operator">
                  {(saving||uploadingPhoto) ? <><Loader2 size={14} style={{ animation:"spin 1s linear infinite", marginRight:6 }} />{uploadingPhoto?"Uploading…":"Saving…"}</> : <><i className="ti-save" style={{ marginRight:6 }} />{editingId?"Update Operator":"Save Operator"}</>}
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
