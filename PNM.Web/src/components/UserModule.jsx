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

const API_BASE    = "http://localhost:5167/api/User";
const ROLE_URL    = "http://localhost:5167/api/Role/list";
const DEPT_URL    = "http://localhost:5167/api/Department";
const UPLOAD_URL  = "http://localhost:5167/api/Upload/operator-photo";
const PHOTO_BASE  = "http://localhost:5167";
const DEFAULT_PHOTO = "https://ui-avatars.com/api/?name=User&background=4f86c6&color=fff&size=200";

// Admin-level roles excluded from "User Type" — they are managed in Admin Master
const ADMIN_ROLES = ["admin", "super admin", "superadmin"];

const GENDERS  = ["Male","Female","Other"];
const STATUSES = ["Active","Inactive","On Leave","Terminated"];
const STATUS_BADGE = { Active:"success", Inactive:"secondary", "On Leave":"warning", Terminated:"danger" };
const EMPTY_FORM = {
  empId:"", roleId:"", deptId:"", fullName:"",
  dateOfBirth:"", gender:"", mobile:"",
  aadhaarNo:"", licenseNo:"", address:"",
  doj:"", status:"Active", photoPath:""
};

export default function UserModule() {
  const [users,        setUsers]       = useState([]);
  const [roles,        setRoles]       = useState([]);  // from mst_Role (non-admin)
  const [depts,        setDepts]       = useState([]);
  const [loading,      setLoading]     = useState(true);
  const [showModal,    setShowModal]   = useState(false);
  const [editingId,    setEditingId]   = useState(null);
  const [form,         setForm]        = useState(EMPTY_FORM);
  const [saving,       setSaving]      = useState(false);
  const [search,       setSearch]      = useState("");
  const [filterStatus, setFilterStatus]= useState("");
  const [filterRole,   setFilterRole]  = useState("");

  // Photo upload state
  const [photoPreview,    setPhotoPreview]    = useState(null);
  const [photoFile,       setPhotoFile]       = useState(null);
  const [uploadingPhoto,  setUploadingPhoto]  = useState(false);
  const fileInputRef = useRef(null);

  const authHeaders = () => {
    const token = localStorage.getItem("token");
    return token ? { Authorization:`Bearer ${token}` } : {};
  };

  // ── Fetch all data on mount ───────────────────────────────────────────────
  const fetchUsers = async () => {
    try {
      setLoading(true);
      const res = await fetch(API_BASE, { headers:{ "Content-Type":"application/json", ...authHeaders() } });
      const j   = await res.json();
      setUsers(j.data || []);
    } catch(e) { console.error(e); } finally { setLoading(false); }
  };

  const fetchRoles = async () => {
    try {
      const res  = await fetch(ROLE_URL);
      const json = await res.json();
      // Exclude Admin / Super Admin roles — those live in tbl_Admin
      const filtered = (json.data || []).filter(r =>
        !ADMIN_ROLES.includes(r.role?.toLowerCase())
      );
      setRoles(filtered);
    } catch(e) { console.error("Roles fetch failed", e); }
  };

  const fetchDepts = async () => {
    try {
      const res  = await fetch(DEPT_URL, { headers: authHeaders() });
      const json = await res.json();
      setDepts(json.data || []);
    } catch(e) { console.error("Dept fetch failed", e); }
  };

  useEffect(() => {
    fetchUsers();
    fetchRoles();
    fetchDepts();
  }, []);

  // ── Photo helpers ─────────────────────────────────────────────────────────
  const resolvePhotoUrl = (path) => {
    if (!path) return DEFAULT_PHOTO;
    if (path.startsWith("http") || path.startsWith("data:")) return path;
    return `${PHOTO_BASE}${path}`;
  };

  const handlePhotoSelect = (e) => {
    const file = e.target.files[0];
    if (!file) return;
    setPhotoFile(file);
    const reader = new FileReader();
    reader.onload = (ev) => setPhotoPreview(ev.target.result);
    reader.readAsDataURL(file);
  };

  const clearPhoto = () => {
    setPhotoFile(null); setPhotoPreview(null);
    if (fileInputRef.current) fileInputRef.current.value = "";
    setForm(prev => ({ ...prev, photoPath:"" }));
  };

  const uploadPhoto = async () => {
    if (!photoFile) return form.photoPath || null;
    setUploadingPhoto(true);
    try {
      const fd  = new FormData();
      fd.append("file", photoFile);
      const res  = await fetch(UPLOAD_URL, { method:"POST", body:fd, headers:authHeaders() });
      const json = await res.json();
      if (!json.success) throw new Error(json.message || "Upload failed");
      return json.path;
    } finally { setUploadingPhoto(false); }
  };

  // ── Modal helpers ─────────────────────────────────────────────────────────
  const openAdd = () => {
    setEditingId(null); setForm(EMPTY_FORM);
    setPhotoPreview(null); setPhotoFile(null); setShowModal(true);
  };

  const openEdit = (u) => {
    setEditingId(u.userId);
    setForm({
      empId:       u.empId       || "",
      roleId:      u.roleId      || "",
      deptId:      u.deptId      || "",
      fullName:    u.fullName    || "",
      dateOfBirth: u.dateOfBirth || "",
      gender:      u.gender      || "",
      mobile:      u.mobile      || "",
      aadhaarNo:   u.aadhaarNo   || "",
      licenseNo:   u.licenseNo   || "",
      address:     u.address     || "",
      doj:         u.doj         || "",
      status:      u.status      || "Active",
      photoPath:   u.photoPath   || ""
    });
    setPhotoFile(null);
    setPhotoPreview(u.photoPath ? resolvePhotoUrl(u.photoPath) : null);
    setShowModal(true);
  };

  const closeModal = () => {
    setShowModal(false); setEditingId(null);
    setForm(EMPTY_FORM); setPhotoPreview(null); setPhotoFile(null);
  };

  const handleChange = (e) => {
    const { name, value } = e.target;
    setForm(prev => ({ ...prev, [name]:value }));
  };

  // ── Submit ────────────────────────────────────────────────────────────────
  const handleSubmit = async (e) => {
    e.preventDefault(); setSaving(true);
    try {
      const uploadedPath = await uploadPhoto();
      const payload = {
        empId:       form.empId.trim(),
        roleId:      parseInt(form.roleId) || 0,
        deptId:      parseInt(form.deptId) || 0,
        fullName:    form.fullName.trim(),
        dateOfBirth: form.dateOfBirth || null,
        gender:      form.gender      || null,
        mobile:      form.mobile      || null,
        aadhaarNo:   form.aadhaarNo   || null,
        licenseNo:   form.licenseNo   || null,
        address:     form.address     || null,
        doj:         form.doj         || null,
        status:      form.status      || "Active",
        photoPath:   uploadedPath     || null
      };

      const res = await fetch(
        editingId ? `${API_BASE}/${editingId}` : API_BASE,
        { method:editingId?"PUT":"POST", headers:{ "Content-Type":"application/json", ...authHeaders() }, body:JSON.stringify(payload) }
      );
      if (!res.ok) {
        const err = await res.json().catch(() => ({}));
        throw new Error(err.message || `Server error: ${res.status}`);
      }
      await fetchUsers(); closeModal();
    } catch(err) { alert("Error: " + err.message); } finally { setSaving(false); }
  };

  const handleDelete = async (id) => {
    if (!window.confirm("Delete this user?")) return;
    try {
      await fetch(`${API_BASE}/${id}`, { method:"DELETE", headers:{ "Content-Type":"application/json", ...authHeaders() } });
      await fetchUsers();
    } catch(e) { alert("Delete failed: " + e.message); }
  };

  // ── Filter ────────────────────────────────────────────────────────────────
  const filtered = users.filter(u => {
    const q = search.toLowerCase();
    return (!q || u.fullName?.toLowerCase().includes(q) || u.empId?.toLowerCase().includes(q) || u.mobile?.includes(q))
      && (!filterStatus || u.status    === filterStatus)
      && (!filterRole   || String(u.roleId) === String(filterRole));
  });

  const counts = STATUSES.reduce((a,s) => { a[s]=users.filter(u=>u.status===s).length; return a; }, {});
  const currentPhotoSrc = photoPreview || (form.photoPath ? resolvePhotoUrl(form.photoPath) : DEFAULT_PHOTO);

  return (
    <div className="animate-fade">

{/*      
      <div style={{ display:"flex", gap:"16px", marginBottom:"24px", flexWrap:"wrap" }}>
        {[
          { label:"Total Users",  value:users.length,           icon:"ti-user",  color:"var(--primary-color)" },
          { label:"Active",       value:counts["Active"],        icon:"ti-check", color:"var(--success-color)" },
          { label:"On Leave",     value:counts["On Leave"],      icon:"ti-time",  color:"var(--warning-color)" },
          { label:"Inactive",     value:counts["Inactive"],      icon:"ti-close", color:"var(--danger-color)"  }
        ].map(c => (
          <div key={c.label} style={{ flex:"1 1 160px", background:"var(--card-bg)", border:"1px solid var(--border-color)", borderRadius:"12px", padding:"18px 20px", display:"flex", alignItems:"center", gap:"14px" }}>
            <div style={{ width:40, height:40, borderRadius:"10px", background:`${c.color}22`, display:"flex", alignItems:"center", justifyContent:"center" }}>
              <i className={c.icon} style={{ color:c.color, fontSize:18 }} />
            </div>
            <div>
              <div style={{ fontSize:"22px", fontWeight:700, color:"#fff", lineHeight:1 }}>{c.value ?? 0}</div>
              <div style={{ fontSize:"12px", color:"var(--text-secondary)", marginTop:2 }}>{c.label}</div>
            </div>
          </div>
        ))}
      </div> */}

      {/* ── Toolbar ── */}
      <div style={{ display:"flex", alignItems:"center", gap:"12px", marginBottom:"20px", flexWrap:"wrap" }}>
        <div style={{ position:"relative", flex:1, minWidth:200 }}>
          <i className="ti-search" style={{ position:"absolute", left:10, top:"50%", transform:"translateY(-50%)", color:"var(--text-muted)", fontSize:13 }} />
          <input type="text" placeholder="Search by name, EmpId, mobile…" value={search}
            onChange={e=>setSearch(e.target.value)} id="user-search"
            style={{ width:"100%", paddingLeft:32, paddingRight:10, height:36, background:"var(--bg-secondary)", border:"1px solid var(--border-color)", borderRadius:8, color:"#fff", fontSize:13 }} />
        </div>

        <select value={filterRole} onChange={e=>setFilterRole(e.target.value)} id="user-filter-role"
          style={{ height:36, background:"var(--bg-secondary)", border:"1px solid var(--border-color)", borderRadius:8, color:"#fff", fontSize:13, padding:"0 10px" }}>
          <option value="">All User Types</option>
          {roles.map(r => <option key={r.roleId} value={r.roleId}>{r.role}</option>)}
        </select>

        <select value={filterStatus} onChange={e=>setFilterStatus(e.target.value)} id="user-filter-status"
          style={{ height:36, background:"var(--bg-secondary)", border:"1px solid var(--border-color)", borderRadius:8, color:"#fff", fontSize:13, padding:"0 10px" }}>
          <option value="">All Statuses</option>
          {STATUSES.map(s => <option key={s} value={s}>{s}</option>)}
        </select>

        <button className="btn btn-carolina" onClick={openAdd} id="btn-add-user"
          style={{ height:36, display:"flex", alignItems:"center", gap:6, whiteSpace:"nowrap" }}>
          <i className="ti-plus" /> Add User
        </button>
      </div>

      {/* ── Table ── */}
      <div style={{ background:"var(--card-bg)", border:"1px solid var(--border-color)", borderRadius:12, overflow:"hidden" }}>
        <div style={{ overflowX:"auto" }}>
          <table className="table" style={{ margin:0 }}>
            <thead>
              <tr style={{ background:"var(--bg-secondary)" }}>
                <th style={{ padding:"12px 16px", fontSize:12, color:"var(--text-secondary)", fontWeight:600, textTransform:"uppercase", letterSpacing:"0.05em" }}>Photo</th>
                <th style={{ padding:"12px 16px", fontSize:12, color:"var(--text-secondary)", fontWeight:600, textTransform:"uppercase", letterSpacing:"0.05em" }}>Employee ID</th>
                <th style={{ padding:"12px 16px", fontSize:12, color:"var(--text-secondary)", fontWeight:600, textTransform:"uppercase", letterSpacing:"0.05em" }}>Full Name</th>
                <th style={{ padding:"12px 16px", fontSize:12, color:"var(--text-secondary)", fontWeight:600, textTransform:"uppercase", letterSpacing:"0.05em" }}>User Type</th>
                <th style={{ padding:"12px 16px", fontSize:12, color:"var(--text-secondary)", fontWeight:600, textTransform:"uppercase", letterSpacing:"0.05em" }}>Department</th>
                <th style={{ padding:"12px 16px", fontSize:12, color:"var(--text-secondary)", fontWeight:600, textTransform:"uppercase", letterSpacing:"0.05em" }}>Mobile</th>
                <th style={{ padding:"12px 16px", fontSize:12, color:"var(--text-secondary)", fontWeight:600, textTransform:"uppercase", letterSpacing:"0.05em" }}>Status</th>
                <th style={{ padding:"12px 16px", fontSize:12, color:"var(--text-secondary)", fontWeight:600, textTransform:"uppercase", letterSpacing:"0.05em" }}>Actions</th>
              </tr>
            </thead>
            <tbody>
              {loading ? (
                <tr><td colSpan={8} style={{ textAlign:"center", padding:40, color:"var(--text-muted)" }}>
                  <Loader2 size={24} style={{ animation:"spin 1s linear infinite" }} />
                </td></tr>
              ) : filtered.length === 0 ? (
                <tr><td colSpan={8} style={{ textAlign:"center", padding:40, color:"var(--text-muted)", fontSize:14 }}>
                  No users found.
                </td></tr>
              ) : filtered.map(u => (
                <tr key={u.userId} style={{ borderTop:"1px solid var(--border-color)" }}>
                  <td style={{ padding:"10px 16px" }}>
                    <img src={resolvePhotoUrl(u.photoPath)} alt={u.fullName}
                      style={{ width:36, height:36, borderRadius:"50%", objectFit:"cover", border:"1px solid var(--border-color)" }}
                      onError={e=>{ e.target.src=DEFAULT_PHOTO; }} />
                  </td>
                  <td style={{ padding:"10px 16px", fontSize:13, fontWeight:600, color:"var(--primary-color)" }}>{u.empId}</td>
                  <td style={{ padding:"10px 16px", fontSize:13 }}>{u.fullName || u.userName}</td>
                  <td style={{ padding:"10px 16px", fontSize:13 }}>{u.roleName || "-"}</td>
                  <td style={{ padding:"10px 16px", fontSize:13 }}>{u.deptName || "-"}</td>
                  <td style={{ padding:"10px 16px", fontSize:13 }}>{u.mobile || "-"}</td>
                  <td style={{ padding:"10px 16px" }}>
                    <span className={`badge badge-${STATUS_BADGE[u.status] || "secondary"}`} style={{ fontSize:11 }}>
                      {u.status || "Active"}
                    </span>
                  </td>
                  <td style={{ padding:"10px 16px" }}>
                    <div style={{ display:"flex", gap:6 }}>
                      <button className="btn btn-sm btn-outline-secondary" onClick={()=>openEdit(u)} title="Edit">
                        <i className="ti-pencil" />
                      </button>
                      <button className="btn btn-sm btn-outline-danger" onClick={()=>handleDelete(u.userId)} title="Delete">
                        <i className="ti-trash" />
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* ── Add / Edit Modal ── */}
      {showModal && createPortal(
        <div className="modal" style={{ display:"flex", position:"fixed", inset:0, zIndex:9999, alignItems:"center", justifyContent:"center", background:"rgba(0,0,0,0.55)", backdropFilter:"blur(2px)" }}>
          <div className="modal-dialog" style={{ width:"100%", maxWidth:680, margin:"0 auto", display:"flex", flexDirection:"column", maxHeight:"90vh" }}>
            <div className="modal-content" style={{ background:"var(--card-bg)", border:"1px solid var(--border-color)", borderRadius:14, overflow:"hidden", display:"flex", flexDirection:"column" }}>

              {/* Header */}
              <div className="modal-header" style={{ padding:"16px 24px", borderBottom:"1px solid var(--border-color)", display:"flex", alignItems:"center", justifyContent:"space-between", flexShrink:0 }}>
                <h5 style={{ margin:0, fontSize:17, fontWeight:700 }}>
                  {editingId ? "Edit User" : "Add New User"}
                </h5>
                <button className="btn btn-sm btn-outline-secondary" onClick={closeModal} id="btn-close-user-modal">
                  <X size={16} />
                </button>
              </div>

              {/* Body */}
              <div className="modal-body" style={{ padding:"20px 24px", overflowY:"auto", flex:1 }}>
                <form id="user-form" onSubmit={handleSubmit}>

                  {/* Photo */}
                  <div style={{ display:"flex", gap:20, alignItems:"flex-start", marginBottom:16 }}>
                    <div style={{ position:"relative", flexShrink:0 }}>
                      <img src={currentPhotoSrc} alt="Profile preview" id="user-photo-preview"
                        style={{ width:100, height:100, borderRadius:12, objectFit:"cover", border:"2px solid var(--border-color)", background:"var(--bg-secondary)" }}
                        onError={e=>{ e.target.src=DEFAULT_PHOTO; }} />
                      {photoFile && (
                        <button type="button" onClick={clearPhoto}
                          style={{ position:"absolute", top:-8, right:-8, width:22, height:22, borderRadius:"50%", background:"var(--danger-color)", border:"none", cursor:"pointer", display:"flex", alignItems:"center", justifyContent:"center", padding:0 }}>
                          <X size={12} color="#fff" />
                        </button>
                      )}
                    </div>
                    <div style={{ flex:1 }}>
                      <p style={{ margin:"0 0 8px 0", fontSize:12, color:"var(--text-secondary)" }}>
                        Upload a clear profile photo. Supported: JPG, PNG, WEBP. Max 5MB.
                      </p>
                      <input type="file" accept="image/*" ref={fileInputRef} onChange={handlePhotoSelect} id="user-file-photo" style={{ display:"none" }} />
                      <div style={{ display:"flex", gap:8 }}>
                        <button type="button" className="btn btn-outline-secondary btn-sm"
                          onClick={()=>fileInputRef.current?.click()} style={{ display:"flex", alignItems:"center", gap:6 }}>
                          <Camera size={14} />{photoFile ? "Change Photo" : "Select Photo"}
                        </button>
                        {photoFile && (
                          <button type="button" className="btn btn-outline-danger btn-sm" onClick={clearPhoto}
                            style={{ display:"flex", alignItems:"center", gap:6 }}>
                            <X size={14} />Remove
                          </button>
                        )}
                      </div>
                      {photoFile && <p style={{ margin:"6px 0 0", fontSize:11, color:"var(--success-color)" }}>✓ {photoFile.name} — will upload on save</p>}
                      {uploadingPhoto && <p style={{ margin:"6px 0 0", fontSize:11, color:"var(--primary-color)", display:"flex", alignItems:"center", gap:4 }}><Loader2 size={12} style={{ animation:"spin 1s linear infinite" }} />Uploading photo…</p>}
                    </div>
                  </div>

                  {/* ── Identity ── */}
                  <SectionHeader label="Identity" />
                  <FormRow>
                    <FormGroup label="Employee ID" required>
                      <input type="text" className="form-control" name="empId" value={form.empId}
                        onChange={handleChange} placeholder="e.g. 2509" required id="user-empid" />
                    </FormGroup>
                    <FormGroup label="User Type" required>
                      <select className="form-control" name="roleId" value={form.roleId}
                        onChange={handleChange} required id="user-role">
                        <option value="">Select user type…</option>
                        {roles.map(r => <option key={r.roleId} value={r.roleId}>{r.role}</option>)}
                      </select>
                    </FormGroup>
                  </FormRow>
                  <FormRow>
                    <FormGroup label="Department" required>
                      <select className="form-control" name="deptId" value={form.deptId}
                        onChange={handleChange} required id="user-dept">
                        <option value="">Select department…</option>
                        {depts.map(d => <option key={d.deptId} value={d.deptId}>{d.deptName}</option>)}
                      </select>
                    </FormGroup>
                    <FormGroup label="Status" required>
                      <select className="form-control" name="status" value={form.status}
                        onChange={handleChange} required id="user-status">
                        {STATUSES.map(s => <option key={s} value={s}>{s}</option>)}
                      </select>
                    </FormGroup>
                  </FormRow>

                  {/* ── Personal Information ── */}
                  <SectionHeader label="Personal Information" />
                  <FormRow>
                    <FormGroup label="Full Name" required>
                      <input type="text" className="form-control" name="fullName" value={form.fullName}
                        onChange={handleChange} placeholder="Enter full name" required id="user-fullname" />
                    </FormGroup>
                    <FormGroup label="Gender">
                      <select className="form-control" name="gender" value={form.gender}
                        onChange={handleChange} id="user-gender">
                        <option value="">Select gender…</option>
                        {GENDERS.map(g => <option key={g} value={g}>{g}</option>)}
                      </select>
                    </FormGroup>
                  </FormRow>
                  <FormRow>
                    <FormGroup label="Date of Birth">
                      <input type="date" className="form-control" name="dateOfBirth"
                        value={form.dateOfBirth} onChange={handleChange} id="user-dob" />
                    </FormGroup>
                    <FormGroup label="Mobile">
                      <input type="tel" className="form-control" name="mobile" value={form.mobile}
                        onChange={handleChange} placeholder="e.g. 9876543210" id="user-mobile" />
                    </FormGroup>
                  </FormRow>
                  <FormGroup label="Address">
                    <textarea className="form-control" name="address" rows={2} value={form.address}
                      onChange={handleChange} placeholder="Full residential address" id="user-address" />
                  </FormGroup>

                  {/* ── Documents ── */}
                  <SectionHeader label="Documents" />
                  <FormRow>
                    <FormGroup label="Aadhaar No">
                      <input type="text" className="form-control" name="aadhaarNo" value={form.aadhaarNo}
                        onChange={handleChange} placeholder="12-digit Aadhaar number" id="user-aadhaar" maxLength={14} />
                    </FormGroup>
                    <FormGroup label="License No">
                      <input type="text" className="form-control" name="licenseNo" value={form.licenseNo}
                        onChange={handleChange} placeholder="Driving license number" id="user-license" />
                    </FormGroup>
                  </FormRow>

                  {/* ── Employment ── */}
                  <SectionHeader label="Employment Details" />
                  <FormRow>
                    <FormGroup label="Date of Joining">
                      <input type="date" className="form-control" name="doj"
                        value={form.doj} onChange={handleChange} id="user-doj" />
                    </FormGroup>
                  </FormRow>

                </form>
              </div>

              {/* Footer */}
              <div className="modal-footer" style={{ borderTop:"1px solid var(--border-color)", padding:"14px 24px", display:"flex", justifyContent:"flex-end", gap:10, flexShrink:0 }}>
                <button type="button" className="btn btn-outline-secondary" onClick={closeModal} id="btn-cancel-user">
                  <i className="ti-close" style={{ marginRight:6 }} />Cancel
                </button>
                <button type="submit" form="user-form" className="btn btn-carolina"
                  disabled={saving||uploadingPhoto} id="btn-save-user">
                  {(saving||uploadingPhoto)
                    ? <><Loader2 size={14} style={{ animation:"spin 1s linear infinite", marginRight:6 }} />{uploadingPhoto?"Uploading…":"Saving…"}</>
                    : <><i className="ti-save" style={{ marginRight:6 }} />{editingId?"Update User":"Save User"}</>
                  }
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
