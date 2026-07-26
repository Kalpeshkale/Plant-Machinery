import React, { useState, useEffect } from 'react';
import { createPortal } from 'react-dom';
import { 
  Plus, Edit, Trash2, Loader2, X, Eye, 
  EyeOff, Settings, Hash, Layers, FileCode, Check 
} from 'lucide-react';

const API_BASE = "http://localhost:5167/api/Permission";

export default function MenuManager() {
  const [menus, setMenus] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingId, setEditingId] = useState(null);

  const [form, setForm] = useState({
    perKey: "",
    menuName: "",
    sortOrder: 0,
    parentKey: "",
    menuType: "Menu",
    viewName: "",
    iconClass: "FolderClosed",
    isVisible: true
  });

  useEffect(() => {
    fetchMenus();
  }, []);

  const fetchMenus = async () => {
    setLoading(true);
    setError("");
    try {
      const res = await fetch(`${API_BASE}/all`);
      if (!res.ok) throw new Error("Failed to load menus from backend.");
      const json = await res.json();
      setMenus(json.data || []);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const handleInputChange = (e) => {
    const { name, value, type, checked } = e.target;
    setForm(prev => ({
      ...prev,
      [name]: type === 'checkbox' ? checked : (name === 'sortOrder' ? parseInt(value) || 0 : value)
    }));
  };

  const openAddModal = () => {
    setEditingId(null);
    setForm({
      perKey: "",
      menuName: "",
      sortOrder: menus.length + 1,
      parentKey: "",
      menuType: "Menu",
      viewName: "",
      iconClass: "FolderClosed",
      isVisible: true
    });
    setIsModalOpen(true);
  };

  const openEditModal = (m) => {
    setEditingId(m.id);
    setForm({
      perKey: m.perKey || "",
      menuName: m.menuName || "",
      sortOrder: m.sortOrder || 0,
      parentKey: m.parentKey || "",
      menuType: m.menuType || "Menu",
      viewName: m.viewName || "",
      iconClass: m.iconClass || "FolderClosed",
      isVisible: m.isVisible !== false
    });
    setIsModalOpen(true);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const url = editingId ? `${API_BASE}/${editingId}` : API_BASE;
      const method = editingId ? "PUT" : "POST";
      
      const res = await fetch(url, {
        method,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(form)
      });

      if (!res.ok) {
        const json = await res.json();
        throw new Error(json.message || "Failed to save menu item.");
      }
      
      setIsModalOpen(false);
      fetchMenus();
    } catch (err) {
      alert(err.message);
    }
  };

  const handleDelete = async (id) => {
    if (!confirm("Are you sure you want to delete this menu item?")) return;
    try {
      const res = await fetch(`${API_BASE}/${id}`, {
        method: "DELETE"
      });
      if (!res.ok) throw new Error("Failed to delete menu item.");
      fetchMenus();
    } catch (err) {
      alert(err.message);
    }
  };

  return (
    <div className="animate-fade">
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '24px' }}>
        <div>
          <h2 style={{ fontSize: '24px', fontWeight: 600, color: 'var(--text-primary)' }}>Dynamic Menu Catalog</h2>
          <p style={{ color: 'var(--text-secondary)', fontSize: '14px', marginTop: '4px' }}>Configure navigation links, routing targets, and sidebar layouts.</p>
        </div>
        <button 
          onClick={openAddModal}
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: '8px',
            backgroundColor: 'var(--primary-color)',
            color: '#fff',
            border: 'none',
            borderRadius: '8px',
            padding: '10px 18px',
            fontWeight: 500,
            cursor: 'pointer',
            boxShadow: '0 4px 14px var(--primary-glow)',
            transition: 'all 0.2s'
          }}
        >
          <Plus size={18} />
          Add Menu Item
        </button>
      </div>

      {loading ? (
        <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', minHeight: '200px' }}>
          <Loader2 size={32} className="spin" style={{ color: 'var(--primary-color)' }} />
        </div>
      ) : error ? (
        <div style={{ padding: '20px', background: 'rgba(239, 68, 68, 0.1)', border: '1px solid var(--danger-color)', borderRadius: '12px', color: '#fff' }}>
          <p>{error}</p>
          <button onClick={fetchMenus} style={{ marginTop: '10px', padding: '6px 12px', background: 'var(--danger-color)', border: 'none', color: '#fff', borderRadius: '4px', cursor: 'pointer' }}>Retry</button>
        </div>
      ) : (
        <div style={{ background: 'var(--card-bg)', border: '1px solid var(--border-color)', borderRadius: '12px', overflow: 'hidden' }}>
          <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left', fontSize: '14px' }}>
            <thead>
              <tr style={{ borderBottom: '1px solid var(--border-color)', background: 'rgba(0,0,0,0.1)' }}>
                <th style={{ padding: '16px 20px', color: 'var(--text-secondary)', fontWeight: 500 }}>Menu Name</th>
                <th style={{ padding: '16px 20px', color: 'var(--text-secondary)', fontWeight: 500 }}>Permission Key</th>
                <th style={{ padding: '16px 20px', color: 'var(--text-secondary)', fontWeight: 500 }}>View / Tab Target</th>
                <th style={{ padding: '16px 20px', color: 'var(--text-secondary)', fontWeight: 500 }}>Sort Order</th>
                <th style={{ padding: '16px 20px', color: 'var(--text-secondary)', fontWeight: 500 }}>Type</th>
                <th style={{ padding: '16px 20px', color: 'var(--text-secondary)', fontWeight: 500 }}>Visible</th>
                <th style={{ padding: '16px 20px', color: 'var(--text-secondary)', fontWeight: 500, textAlign: 'right' }}>Actions</th>
              </tr>
            </thead>
            <tbody>
              {menus.map(m => (
                <tr key={m.id} style={{ borderBottom: '1px solid var(--border-color)', transition: 'background 0.2s' }} className="table-row-hover">
                  <td style={{ padding: '16px 20px', fontWeight: 600, color: '#fff' }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                      <span style={{ color: 'var(--primary-color)' }}>[ {m.iconClass || 'FolderClosed'} ]</span>
                      {m.menuName}
                    </div>
                  </td>
                  <td style={{ padding: '16px 20px', color: 'var(--text-secondary)', fontFamily: 'monospace' }}>{m.perKey}</td>
                  <td style={{ padding: '16px 20px', color: 'var(--text-secondary)' }}>{m.viewName || 'N/A'}</td>
                  <td style={{ padding: '16px 20px', color: '#fff' }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                      <Hash size={14} color="var(--text-muted)" />
                      {m.sortOrder}
                    </div>
                  </td>
                  <td style={{ padding: '16px 20px' }}>
                    <span style={{
                      fontSize: '11px',
                      fontWeight: 600,
                      padding: '2px 6px',
                      borderRadius: '4px',
                      background: m.menuType === 'SubMenu' ? 'rgba(245, 158, 11, 0.15)' : 'rgba(99, 102, 241, 0.15)',
                      color: m.menuType === 'SubMenu' ? 'var(--warning-color)' : 'var(--primary-color)'
                    }}>{m.menuType || 'Menu'}</span>
                  </td>
                  <td style={{ padding: '16px 20px' }}>
                    {m.isVisible ? (
                      <Eye size={16} style={{ color: 'var(--success-color)' }} />
                    ) : (
                      <EyeOff size={16} style={{ color: 'var(--text-muted)' }} />
                    )}
                  </td>
                  <td style={{ padding: '16px 20px', textAlign: 'right' }}>
                    <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '10px' }}>
                      <button 
                        onClick={() => openEditModal(m)}
                        style={{ background: 'none', border: 'none', color: 'var(--text-secondary)', cursor: 'pointer', padding: '4px', borderRadius: '4px' }}
                      >
                        <Edit size={16} />
                      </button>
                      <button 
                        onClick={() => handleDelete(m.id)}
                        style={{ background: 'none', border: 'none', color: 'var(--danger-color)', cursor: 'pointer', padding: '4px', borderRadius: '4px' }}
                      >
                        <Trash2 size={16} />
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      {/* Add / Edit Menu Item Modal */}
      {isModalOpen && createPortal(
        <div style={{
          position: 'fixed',
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          background: 'rgba(5, 7, 12, 0.85)',
          backdropFilter: 'blur(8px)',
          display: 'flex',
          justifyContent: 'center',
          alignItems: 'center',
          zIndex: 9999
        }}>
          <div style={{
            background: '#131824',
            border: '1px solid var(--border-color)',
            borderRadius: '16px',
            width: '100%',
            maxWidth: '480px',
            padding: '28px',
            position: 'relative',
            maxHeight: '90vh',
            overflowY: 'auto',
            boxShadow: '0 20px 25px -5px rgba(0, 0, 0, 0.5)'
          }}>
            <button 
              onClick={() => setIsModalOpen(false)}
              style={{ position: 'absolute', top: '20px', right: '20px', background: 'none', border: 'none', color: 'var(--text-secondary)', cursor: 'pointer' }}
            >
              <X size={20} />
            </button>

            <h3 style={{ fontSize: '20px', fontWeight: 600, color: '#fff', marginBottom: '20px' }}>
              {editingId ? "Edit Menu Configuration" : "Add Menu Item"}
            </h3>

            <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
              <div>
                <label style={{ display: 'block', fontSize: '13px', fontWeight: 500, color: 'var(--text-secondary)', marginBottom: '6px' }}>Permission Key (Must be unique)</label>
                <input 
                  type="text" 
                  name="perKey"
                  required
                  value={form.perKey}
                  onChange={handleInputChange}
                  placeholder="e.g. DailyLogs"
                  style={{ width: '100%', background: 'rgba(0,0,0,0.2)', border: '1px solid var(--border-color)', padding: '10px', borderRadius: '8px', color: '#fff', outline: 'none' }}
                />
              </div>

              <div>
                <label style={{ display: 'block', fontSize: '13px', fontWeight: 500, color: 'var(--text-secondary)', marginBottom: '6px' }}>Menu Name (Display Label)</label>
                <input 
                  type="text" 
                  name="menuName"
                  required
                  value={form.menuName}
                  onChange={handleInputChange}
                  placeholder="e.g. Daily Logs"
                  style={{ width: '100%', background: 'rgba(0,0,0,0.2)', border: '1px solid var(--border-color)', padding: '10px', borderRadius: '8px', color: '#fff', outline: 'none' }}
                />
              </div>

              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px' }}>
                <div>
                  <label style={{ display: 'block', fontSize: '13px', fontWeight: 500, color: 'var(--text-secondary)', marginBottom: '6px' }}>Tab View Component</label>
                  <input 
                    type="text" 
                    name="viewName"
                    required
                    value={form.viewName}
                    onChange={handleInputChange}
                    placeholder="e.g. DailyLogs"
                    style={{ width: '100%', background: 'rgba(0,0,0,0.2)', border: '1px solid var(--border-color)', padding: '10px', borderRadius: '8px', color: '#fff', outline: 'none' }}
                  />
                </div>
                <div>
                  <label style={{ display: 'block', fontSize: '13px', fontWeight: 500, color: 'var(--text-secondary)', marginBottom: '6px' }}>Sort Order</label>
                  <input 
                    type="number" 
                    name="sortOrder"
                    required
                    value={form.sortOrder}
                    onChange={handleInputChange}
                    style={{ width: '100%', background: 'rgba(0,0,0,0.2)', border: '1px solid var(--border-color)', padding: '10px', borderRadius: '8px', color: '#fff', outline: 'none' }}
                  />
                </div>
              </div>

              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px' }}>
                <div>
                  <label style={{ display: 'block', fontSize: '13px', fontWeight: 500, color: 'var(--text-secondary)', marginBottom: '6px' }}>Menu Icon</label>
                  <input 
                    type="text"
                    name="iconClass"
                    placeholder="e.g. ti-folder, ti-user, ti-settings"
                    required
                    value={form.iconClass}
                    onChange={handleInputChange}
                    style={{ width: '100%', background: 'rgba(0,0,0,0.2)', border: '1px solid var(--border-color)', padding: '10px', borderRadius: '8px', color: '#fff', outline: 'none' }}
                  />
                </div>
                <div>
                  <label style={{ display: 'block', fontSize: '13px', fontWeight: 500, color: 'var(--text-secondary)', marginBottom: '6px' }}>Menu Type</label>
                  <select 
                    name="menuType"
                    value={form.menuType}
                    onChange={handleInputChange}
                    style={{ width: '100%', background: 'rgba(0,0,0,0.2)', border: '1px solid var(--border-color)', padding: '10px', borderRadius: '8px', color: '#fff', outline: 'none' }}
                  >
                    <option value="Menu" style={{ background: '#131824' }}>Menu</option>
                    <option value="SubMenu" style={{ background: '#131824' }}>SubMenu</option>
                  </select>
                </div>
              </div>

              <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginTop: '4px' }}>
                <input 
                  type="checkbox" 
                  name="isVisible"
                  id="isVisible"
                  checked={form.isVisible}
                  onChange={handleInputChange}
                  style={{ width: '16px', height: '16px', accentColor: 'var(--primary-color)' }}
                />
                <label htmlFor="isVisible" style={{ fontSize: '13px', color: '#fff', cursor: 'pointer' }}>Visible in Sidebar Navigation</label>
              </div>

              <button 
                type="submit"
                style={{
                  marginTop: '10px',
                  backgroundColor: 'var(--primary-color)',
                  color: '#fff',
                  border: 'none',
                  borderRadius: '8px',
                  padding: '12px',
                  fontWeight: 500,
                  cursor: 'pointer',
                  boxShadow: '0 4px 14px var(--primary-glow)'
                }}
              >
                {editingId ? "Save Configurations" : "Save Menu Item"}
              </button>
            </form>
          </div>
        </div>,
        document.body
      )}
    </div>
  );
}
