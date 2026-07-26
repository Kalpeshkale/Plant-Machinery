import React, { useState, useEffect } from 'react';
import { Shield, CheckSquare, Square, Save, Loader2 } from 'lucide-react';

const API_ROLE_ACCESS = "http://localhost:5167/api/Permission/role-access";
const API_ALL_PERMISSIONS = "http://localhost:5167/api/Permission/all";

const ROLES = [
  { id: 1, name: "Administrator" },
  { id: 2, name: "Site Incharge" },
  { id: 3, name: "Operator" }
];

export default function PermissionManager() {
  const [selectedRoleId, setSelectedRoleId] = useState(1);
  const [permissions, setPermissions] = useState([]);
  const [selectedIds, setSelectedIds] = useState([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    fetchPermissions();
  }, []);

  useEffect(() => {
    // When selectedRoleId changes, load that role's current assigned permissions
    // We can query our GetUserMenuPermissions endpoint for a user of that role to prefill, 
    // or simulate since we are testing. Let's prefill from user/role mapping query if possible.
    // For convenience in testing, we resolve it dynamically.
    fetchRolePermissions();
  }, [selectedRoleId]);

  const fetchPermissions = async () => {
    try {
      const res = await fetch(API_ALL_PERMISSIONS);
      if (!res.ok) throw new Error("Failed to load permissions catalog.");
      const json = await res.json();
      setPermissions(json.data || []);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const fetchRolePermissions = async () => {
    // We will query the dynamic user permissions endpoint for mock users matching the roles
    // Administrator: userId 1, Site Incharge: userId 2, Operator: userId 3
    try {
      const res = await fetch(`http://localhost:5167/api/Permission/user/${selectedRoleId}`);
      if (res.ok) {
        const json = await res.json();
        const ids = (json.data || []).map(x => x.id);
        setSelectedIds(ids);
      }
    } catch (err) {
      console.error(err);
    }
  };

  const handleToggle = (id) => {
    setSelectedIds(prev => 
      prev.includes(id) ? prev.filter(x => x !== id) : [...prev, id]
    );
  };

  const handleSave = async () => {
    setSaving(true);
    try {
      const res = await fetch(API_ROLE_ACCESS, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          roleId: selectedRoleId,
          permissionIds: selectedIds
        })
      });
      if (!res.ok) throw new Error("Failed to save mapping.");
      alert("Role permissions updated successfully! Dynamic sidebar will refresh.");
    } catch (err) {
      alert(err.message);
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="animate-fade" style={{ maxWidth: '600px', margin: '0 auto' }}>
      <div style={{ marginBottom: '24px' }}>
        <h2 style={{ fontSize: '24px', fontWeight: 600, color: 'var(--text-primary)' }}>Role Permissions Mapping</h2>
        <p style={{ color: 'var(--text-secondary)', fontSize: '14px', marginTop: '4px' }}>Map navigation menu and sidebar item permissions dynamically per user role profile.</p>
      </div>

      <div style={{
        background: 'var(--card-bg)',
        border: '1px solid var(--border-color)',
        borderRadius: '12px',
        padding: '24px'
      }}>
        <div style={{ marginBottom: '20px' }}>
          <label style={{ display: 'block', fontSize: '13px', fontWeight: 500, color: 'var(--text-secondary)', marginBottom: '8px' }}>Select Target Role</label>
          <div style={{ display: 'flex', gap: '10px' }}>
            {ROLES.map(r => (
              <button
                key={r.id}
                onClick={() => setSelectedRoleId(r.id)}
                style={{
                  flex: 1,
                  padding: '10px',
                  borderRadius: '8px',
                  border: selectedRoleId === r.id ? '1px solid var(--primary-color)' : '1px solid var(--border-color)',
                  background: selectedRoleId === r.id ? 'var(--primary-glow)' : 'rgba(0,0,0,0.15)',
                  color: '#fff',
                  cursor: 'pointer',
                  fontWeight: 500,
                  fontSize: '14px',
                  transition: 'all 0.2s'
                }}
              >
                {r.name}
              </button>
            ))}
          </div>
        </div>

        <div style={{ borderTop: '1px solid var(--border-color)', paddingTop: '20px', marginBottom: '24px' }}>
          <label style={{ display: 'block', fontSize: '13px', fontWeight: 500, color: 'var(--text-secondary)', marginBottom: '12px' }}>Allow Access To Navigation Menus</label>
          
          {loading ? (
            <div style={{ display: 'flex', justifyContent: 'center', padding: '20px' }}>
              <Loader2 className="spin" style={{ color: 'var(--primary-color)' }} />
            </div>
          ) : (
            <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
              {permissions.map(p => {
                const isChecked = selectedIds.includes(p.id);
                return (
                  <div 
                    key={p.id}
                    onClick={() => handleToggle(p.id)}
                    style={{
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'space-between',
                      padding: '12px 16px',
                      borderRadius: '8px',
                      background: 'rgba(0,0,0,0.15)',
                      border: '1px solid var(--border-color)',
                      cursor: 'pointer',
                      transition: 'all 0.15s'
                    }}
                  >
                    <span style={{ fontSize: '14px', fontWeight: 500, color: '#fff' }}>{p.menuName}</span>
                    <div style={{ color: isChecked ? 'var(--primary-color)' : 'var(--text-secondary)' }}>
                      {isChecked ? <CheckSquare size={20} /> : <Square size={20} />}
                    </div>
                  </div>
                );
              })}
            </div>
          )}
        </div>

        <button
          onClick={handleSave}
          disabled={saving}
          style={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            gap: '8px',
            width: '100%',
            backgroundColor: 'var(--primary-color)',
            color: '#fff',
            border: 'none',
            borderRadius: '8px',
            padding: '12px',
            fontWeight: 500,
            cursor: 'pointer',
            boxShadow: '0 4px 14px var(--primary-glow)',
            transition: 'all 0.2s'
          }}
        >
          {saving ? <Loader2 size={18} className="spin" /> : <Save size={18} />}
          Save Changes & Apply Mappings
        </button>
      </div>
    </div>
  );
}
