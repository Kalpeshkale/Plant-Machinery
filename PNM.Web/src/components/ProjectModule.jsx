import React, { useState, useEffect } from 'react';
import { createPortal } from 'react-dom';
import {
  FolderPlus, Edit, Trash2, Search, MapPin,
  User, Calendar, Briefcase, Eye, Loader2, X
} from 'lucide-react';

const API_BASE = "http://localhost:5167/api/Project";

export default function ProjectModule() {
  const [projects, setProjects] = useState([]);
  const [departments, setDepartments] = useState([]);
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [searchTerm, setSearchTerm] = useState("");
  const [statusFilter, setStatusFilter] = useState("All");

  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingId, setEditingId] = useState(null);

  const [form, setForm] = useState({
    projCode: "",
    projName: "",
    clientName: "",
    location: "",
    deptId: 0,
    projStatus: "Active",
    startDate: "",
    endDate: "",
    siteInChargeId: null,
    projectManagerId: null
  });

  useEffect(() => {
    fetchProjects();
    fetchDropdowns();
  }, []);

  const fetchDropdowns = async () => {
    try {
      const [dRes, uRes] = await Promise.all([
        fetch("http://localhost:5167/api/Department"),
        fetch("http://localhost:5167/api/User")
      ]);
      const dJson = await dRes.json();
      const uJson = await uRes.json();
      setDepartments(dJson.data || []);
      setUsers(uJson.data || []);
    } catch (err) {
      console.error("Failed to fetch dropdowns", err);
    }
  };

  const fetchProjects = async () => {
    setLoading(true);
    setError("");
    try {
      const res = await fetch(API_BASE);
      if (!res.ok) throw new Error("Failed to load projects from backend.");
      const json = await res.json();
      setProjects(json.data || []);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setForm(prev => ({
      ...prev,
      [name]: name.endsWith("Id") ? parseInt(value) || 0 : value
    }));
  };

  const openAddModal = () => {
    setEditingId(null);
    setForm({
      projCode: "",
      projName: "",
      clientName: "",
      location: "",
      deptId: departments[0]?.deptId || 0,
      projStatus: "Active",
      startDate: new Date().toISOString().split('T')[0],
      endDate: new Date().toISOString().split('T')[0],
      siteInChargeId: users[0]?.userId || null,
      projectManagerId: users[0]?.userId || null
    });
    setIsModalOpen(true);
  };

  const openEditModal = (p) => {
    setEditingId(p.projId);
    setForm({
      projCode: p.projCode || "",
      projName: p.projName || "",
      clientName: p.clientName || "",
      location: p.location || "",
      deptId: p.deptId || 0,
      projStatus: p.projStatus || "Active",
      startDate: p.startDate || "",
      endDate: p.endDate || "",
      siteInChargeId: p.siteInChargeId || null,
      projectManagerId: p.projectManagerId || null
    });
    setIsModalOpen(true);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const url = editingId ? `${API_BASE}/${editingId}` : API_BASE;
      const method = editingId ? "PUT" : "POST";

      const payload = {
        ...form,
        siteInChargeId: form.siteInChargeId || null,
        projectManagerId: form.projectManagerId || null,
        startDate: form.startDate ? form.startDate : null,
        endDate: form.endDate ? form.endDate : null
      };

      const res = await fetch(url, {
        method,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload)
      });

      if (!res.ok) {
        const errorJson = await res.json().catch(() => null);
        const errorMsg = errorJson?.message || "Failed to save project.";
        throw new Error(errorMsg);
      }

      setIsModalOpen(false);
      fetchProjects();
    } catch (err) {
      alert(err.message);
    }
  };

  const handleDelete = async (id) => {
    if (!confirm("Are you sure you want to delete this project?")) return;
    try {
      const res = await fetch(`${API_BASE}/${id}`, {
        method: "DELETE"
      });
      if (!res.ok) throw new Error("Failed to delete project.");
      fetchProjects();
    } catch (err) {
      alert(err.message);
    }
  };

  const filteredProjects = projects.filter(p => {
    const matchesSearch = p.projName.toLowerCase().includes(searchTerm.toLowerCase()) ||
      p.projCode.toLowerCase().includes(searchTerm.toLowerCase()) ||
      p.clientName?.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesStatus = statusFilter === "All" || p.projStatus === statusFilter;
    return matchesSearch && matchesStatus;
  });

  return (
    <div className="animate-fade">
      <div className="row mb-3">
        <div className="col-md-12">
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <div>
              <h2 style={{ fontSize: '24px', fontWeight: 600, color: 'var(--text-primary)' }}>Projects Management</h2>
            </div>
          </div>
        </div>
      </div>

      <div className="card">
        <div className="card-header d-flex justify-content-between align-items-center" style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', width: '100%' }}>
          <div className="caption font-carolina" style={{ display: 'flex', alignItems: 'center' }}>
            <i className="ti-folder mr-2" style={{ marginRight: '8px' }}></i>
            <span className="caption-subject bold uppercase">Projects List</span>
          </div>
          <div className="actions">
            <button onClick={openAddModal} className="btn btn-carolina btn-sm">
              <i className="ti-plus mr-1"></i> Create Project
            </button>
          </div>
        </div>

        <div className="card-body">
          {/* Filter and Search Bar */}
          <div className="row mb-4">
            <div className="col-md-8">
              <div className="input-group">
                <div className="input-group-prepend">
                  <span className="input-group-text"><i className="ti-search"></i></span>
                </div>
                <input
                  type="text"
                  className="form-control"
                  placeholder="Search projects by name, code or client..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                />
              </div>
            </div>

            <div className="col-md-4">
              <select
                className="form-control"
                value={statusFilter}
                onChange={(e) => setStatusFilter(e.target.value)}
              >
                <option value="All">All Statuses</option>
                <option value="Active">Active</option>
                <option value="Completed">Completed</option>
                <option value="On Hold">On Hold</option>
              </select>
            </div>
          </div>

          {loading ? (
            <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', minHeight: '200px' }}>
              <Loader2 size={32} className="spin" style={{ color: 'var(--primary-color)' }} />
            </div>
          ) : error ? (
            <div className="alert alert-danger" role="alert">
              <p className="mb-0">{error}</p>
              <button onClick={fetchProjects} className="btn btn-danger btn-sm mt-2">Retry</button>
            </div>
          ) : filteredProjects.length === 0 ? (
            <div style={{ textAlign: 'center', padding: '40px 20px', border: '1px dashed var(--border-color)', borderRadius: '8px' }}>
              <p style={{ color: 'var(--text-secondary)', margin: 0 }}>No projects matching the criteria were found.</p>
            </div>
          ) : (
            <div className="table-responsive">
              <table className="table table-hover table-striped">
                <thead>
                  <tr>
                    <th>Code</th>
                    <th>Name</th>
                    <th>Client</th>
                    <th>Location</th>
                    <th>Timeline</th>
                    <th>Status</th>
                    <th className="text-right" style={{ textAlign: 'right' }}>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  {filteredProjects.map(p => (
                    <tr key={p.projId}>
                      <td><strong className="text-carolina">{p.projCode}</strong></td>
                      <td>{p.projName}</td>
                      <td>{p.clientName || 'N/A'}</td>
                      <td>{p.location}</td>
                      <td>{p.startDate} to {p.endDate}</td>
                      <td>
                        <span className={`badge badge-pill badge-${p.projStatus === 'Active' ? 'success' : p.projStatus === 'Completed' ? 'primary' : 'warning'}`}>
                          {p.projStatus}
                        </span>
                      </td>
                      <td className="text-right" style={{ textAlign: 'right' }}>
                        <button className="btn btn-outline-secondary btn-sm mr-1" onClick={() => openEditModal(p)} style={{ marginRight: '4px' }}>
                          <i className="ti-pencil"></i>
                        </button>
                        <button className="btn btn-outline-danger btn-sm" onClick={() => handleDelete(p.projId)}>
                          <i className="ti-trash"></i>
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>
      </div>

      {/* Add / Edit Modal */}
      {isModalOpen && createPortal(
        <div style={{
          position: 'fixed',
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          background: 'rgba(5, 7, 12, 0.75)',
          backdropFilter: 'blur(4px)',
          display: 'flex',
          justifyContent: 'center',
          alignItems: 'center',
          zIndex: 9999
        }}>
          <div className="modal-dialog" style={{ width: '100%', maxWidth: '600px', margin: 0 }}>
            <div className="modal-content modal-content-custom">
              <div className="modal-header d-flex justify-content-between align-items-center" style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <h5 className="modal-title font-carolina bold uppercase" style={{ fontSize: '16px', fontWeight: 700, textTransform: 'uppercase', letterSpacing: '0.05em' }}>
                  {editingId ? "Edit Project" : "Add Project"}
                </h5>
                <button type="button" className="close" onClick={() => setIsModalOpen(false)} style={{ color: 'var(--text-primary)', opacity: 0.8 }}>
                  <span aria-hidden="true">&times;</span>
                </button>
              </div>

              <form onSubmit={handleSubmit}>
                <div className="modal-body" style={{ maxHeight: '75vh', overflowY: 'auto', padding: '20px' }}>
                  <div className="form-row" style={{ display: 'flex', gap: '16px', marginBottom: '16px' }}>
                    <div className="form-group" style={{ flex: 1 }}>
                      <label style={{ color: 'var(--text-secondary)', fontSize: '13px', fontWeight: 500, marginBottom: '6px' }}>Project Code</label>
                      <input
                        type="text"
                        name="projCode"
                        className="form-control"
                        required
                        value={form.projCode}
                        onChange={handleInputChange}
                      />
                    </div>
                    <div className="form-group" style={{ flex: 1 }}>
                      <label style={{ color: 'var(--text-secondary)', fontSize: '13px', fontWeight: 500, marginBottom: '6px' }}>Project Name</label>
                      <input
                        type="text"
                        name="projName"
                        className="form-control"
                        required
                        value={form.projName}
                        onChange={handleInputChange}
                      />
                    </div>
                  </div>

                  <div className="form-row" style={{ display: 'flex', gap: '16px', marginBottom: '16px' }}>
                    <div className="form-group" style={{ flex: 1 }}>
                      <label style={{ color: 'var(--text-secondary)', fontSize: '13px', fontWeight: 500, marginBottom: '6px' }}>Department</label>
                      <select
                        name="deptId"
                        className="form-control"
                        required
                        value={form.deptId}
                        onChange={handleInputChange}
                      >
                        {departments.map(d => (
                          <option key={d.deptId} value={d.deptId}>
                            {d.deptName}
                          </option>
                        ))}
                      </select>
                    </div>
                    <div className="form-group" style={{ flex: 1 }}>
                      <label style={{ color: 'var(--text-secondary)', fontSize: '13px', fontWeight: 500, marginBottom: '6px' }}>Status</label>
                      <select
                        name="projStatus"
                        className="form-control"
                        value={form.projStatus}
                        onChange={handleInputChange}
                      >
                        <option value="Active">Active</option>
                        <option value="Completed">Completed</option>
                        <option value="On Hold">On Hold</option>
                      </select>
                    </div>
                  </div>

                  <div className="form-row" style={{ display: 'flex', gap: '16px', marginBottom: '16px' }}>
                    <div className="form-group" style={{ flex: 1 }}>
                      <label style={{ color: 'var(--text-secondary)', fontSize: '13px', fontWeight: 500, marginBottom: '6px' }}>Client Name</label>
                      <input
                        type="text"
                        name="clientName"
                        className="form-control"
                        value={form.clientName}
                        onChange={handleInputChange}
                      />
                    </div>
                    <div className="form-group" style={{ flex: 1 }}>
                      <label style={{ color: 'var(--text-secondary)', fontSize: '13px', fontWeight: 500, marginBottom: '6px' }}>Location</label>
                      <input
                        type="text"
                        name="location"
                        className="form-control"
                        required
                        value={form.location}
                        onChange={handleInputChange}
                      />
                    </div>
                  </div>

                  <div className="form-row" style={{ display: 'flex', gap: '16px', marginBottom: '16px' }}>
                    <div className="form-group" style={{ flex: 1 }}>
                      <label style={{ color: 'var(--text-secondary)', fontSize: '13px', fontWeight: 500, marginBottom: '6px' }}>Site In Charge</label>
                      <select
                        name="siteInChargeId"
                        className="form-control"
                        value={form.siteInChargeId || ""}
                        onChange={(e) => setForm(prev => ({ ...prev, siteInChargeId: parseInt(e.target.value) || null }))}
                      >
                        <option value="">-- Select Site In Charge --</option>
                        {users.map(u => (
                          <option key={u.userId} value={u.userId}>
                            {u.userName}
                          </option>
                        ))}
                      </select>
                    </div>

                    <div className="form-group" style={{ flex: 1 }}>
                      <label style={{ color: 'var(--text-secondary)', fontSize: '13px', fontWeight: 500, marginBottom: '6px' }}>Project Manager</label>
                      <select
                        name="projectManagerId"
                        className="form-control"
                        value={form.projectManagerId || ""}
                        onChange={(e) => setForm(prev => ({ ...prev, projectManagerId: parseInt(e.target.value) || null }))}
                      >
                        <option value="">-- Select Project Manager --</option>
                        {users.map(u => (
                          <option key={u.userId} value={u.userId}>
                            {u.userName}
                          </option>
                        ))}
                      </select>
                    </div>
                  </div>

                  <div className="form-row" style={{ display: 'flex', gap: '16px', marginBottom: '16px' }}>
                    <div className="form-group" style={{ flex: 1 }}>
                      <label style={{ color: 'var(--text-secondary)', fontSize: '13px', fontWeight: 500, marginBottom: '6px' }}>Start Date</label>
                      <input
                        type="date"
                        name="startDate"
                        className="form-control"
                        required
                        value={form.startDate}
                        onChange={handleInputChange}
                      />
                    </div>
                    <div className="form-group" style={{ flex: 1 }}>
                      <label style={{ color: 'var(--text-secondary)', fontSize: '13px', fontWeight: 500, marginBottom: '6px' }}>End Date</label>
                      <input
                        type="date"
                        name="endDate"
                        className="form-control"
                        required
                        value={form.endDate}
                        onChange={handleInputChange}
                      />
                    </div>
                  </div>
                </div>

                <div className="modal-footer" style={{ borderTop: '1px solid var(--border-color)', padding: '14px 20px', display: 'flex', justifyContent: 'flex-end', gap: '10px' }}>
                  <button type="button" className="btn btn-secondary" onClick={() => setIsModalOpen(false)}>Cancel</button>
                  <button type="submit" className="btn btn-carolina">
                    {editingId ? "Save Changes" : "Create Project"}
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>,
        document.body
      )}
    </div>
  );
}
