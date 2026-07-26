import React, { useState, useEffect } from 'react';
import { createPortal } from 'react-dom';
import { Plus, Edit, Trash2, Loader2, X, Tag, Sliders, Hash } from 'lucide-react';

const API_TYPE = "http://localhost:5167/api/Type";
const API_SUBTYPE = "http://localhost:5167/api/SubType";
const API_MAKE = "http://localhost:5167/api/Make";
const API_MODEL = "http://localhost:5167/api/Model";

export default function AssetMasters() {
  const [activeTab, setActiveTab] = useState("Types");
  const [types, setTypes] = useState([]);
  const [subtypes, setSubtypes] = useState([]);
  const [makes, setMakes] = useState([]);
  const [models, setModels] = useState([]);

  const [loading, setLoading] = useState(true);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [modalType, setModalType] = useState(""); // "Type", "SubType", "Make", "Model"
  const [editingId, setEditingId] = useState(null);

  // Form states
  const [typeForm, setTypeForm] = useState({ typeName: "", catId: 1 });
  const [subtypeForm, setSubtypeForm] = useState({ subTypeName: "", typeId: 1, assetUnit: "Hours", outputUnit: "Hours", fuelType: "Diesel", fuelUnit: "Litres" });
  const [makeForm, setMakeForm] = useState({ makeName: "", subTypeId: 1 });
  const [modelForm, setModelForm] = useState({ modelNo: "", makeId: 1 });

  useEffect(() => {
    loadAllData();
  }, []);

  const loadAllData = async () => {
    setLoading(true);
    try {
      const [tRes, sRes, mkRes, mdRes] = await Promise.all([
        fetch(API_TYPE),
        fetch(API_SUBTYPE),
        fetch(API_MAKE),
        fetch(API_MODEL)
      ]);

      const tJson = await tRes.json();
      const sJson = await sRes.json();
      const mkJson = await mkRes.json();
      const mdJson = await mdRes.json();

      setTypes(tJson.data || []);
      setSubtypes(sJson.data || []);
      setMakes(mkJson.data || []);
      setModels(mdJson.data || []);
    } catch (err) {
      console.error("Failed to load master lists:", err);
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async (endpoint, id) => {
    if (!confirm("Are you sure you want to delete this record?")) return;
    try {
      const res = await fetch(`${endpoint}/${id}`, { method: "DELETE" });
      if (!res.ok) throw new Error("Failed to delete record.");
      loadAllData();
    } catch (err) {
      alert(err.message);
    }
  };

  const openAddModal = (target) => {
    setModalType(target);
    setEditingId(null);
    if (target === "Type") {
      setTypeForm({ typeName: "", catId: 1 });
    } else if (target === "SubType") {
      setSubtypeForm({ subTypeName: "", typeId: types[0]?.typeId || 1, assetUnit: "Hours", outputUnit: "Hours", fuelType: "Diesel", fuelUnit: "Litres" });
    } else if (target === "Make") {
      setMakeForm({ makeName: "", subTypeId: subtypes[0]?.subTypeId || 1 });
    } else if (target === "Model") {
      setModelForm({ modelNo: "", makeId: makes[0]?.makeId || 1 });
    }
    setIsModalOpen(true);
  };

  const openEditModal = (target, item) => {
    setModalType(target);
    if (target === "Type") {
      setEditingId(item.typeId);
      setTypeForm({ typeName: item.typeName, catId: item.catId || 1 });
    } else if (target === "SubType") {
      setEditingId(item.subTypeId);
      setSubtypeForm({ subTypeName: item.subTypeName, typeId: item.typeId || 1, assetUnit: item.assetUnit || "Hours", outputUnit: item.outputUnit || "Hours", fuelType: item.fuelType || "Diesel", fuelUnit: item.fuelUnit || "Litres" });
    } else if (target === "Make") {
      setEditingId(item.makeId);
      setMakeForm({ makeName: item.makeName, subTypeId: item.subTypeId || 1 });
    } else if (target === "Model") {
      setEditingId(item.modelId);
      setModelForm({ modelNo: item.modelNo, makeId: item.makeId || 1 });
    }
    setIsModalOpen(true);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      let endpoint = "";
      let bodyData = {};

      if (modalType === "Type") {
        endpoint = API_TYPE;
        bodyData = typeForm;
      } else if (modalType === "SubType") {
        endpoint = API_SUBTYPE;
        bodyData = subtypeForm;
      } else if (modalType === "Make") {
        endpoint = API_MAKE;
        bodyData = makeForm;
      } else if (modalType === "Model") {
        endpoint = API_MODEL;
        bodyData = modelForm;
      }

      const url = editingId ? `${endpoint}/${editingId}` : endpoint;
      const method = editingId ? "PUT" : "POST";

      const res = await fetch(url, {
        method,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(bodyData)
      });

      if (!res.ok) throw new Error("Failed to save changes.");
      setIsModalOpen(false);
      loadAllData();
    } catch (err) {
      alert(err.message);
    }
  };

  return (
    <div className="animate-fade">
      {/* Header tab buttons */}
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '28px' }}>
        <div>
          <h2 style={{ fontSize: '24px', fontWeight: 600, color: 'var(--text-primary)' }}>Equipment Specifications</h2>
          <p style={{ color: 'var(--text-secondary)', fontSize: '14px', marginTop: '4px' }}>Configure asset types, models, manufacturers and technical attributes.</p>
        </div>
        <div style={{ display: 'flex', gap: '10px' }}>
          <button 
            onClick={() => openAddModal(activeTab.slice(0, -1))}
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
              boxShadow: '0 4px 14px var(--primary-glow)'
            }}
          >
            <Plus size={18} />
            Create {activeTab.slice(0, -1)}
          </button>
        </div>
      </div>

      {/* Tabs */}
      <div style={{ display: 'flex', gap: '8px', borderBottom: '1px solid var(--border-color)', marginBottom: '24px', paddingBottom: '8px' }}>
        {["Types", "SubTypes", "Makes", "Models"].map(tab => (
          <button
            key={tab}
            onClick={() => setActiveTab(tab)}
            style={{
              padding: '8px 18px',
              background: activeTab === tab ? 'var(--primary-color)' : 'none',
              color: activeTab === tab ? '#fff' : 'var(--text-secondary)',
              border: 'none',
              borderRadius: '6px',
              cursor: 'pointer',
              fontWeight: 500,
              fontSize: '14px',
              transition: 'all 0.2s'
            }}
          >
            {tab}
          </button>
        ))}
      </div>

      {loading ? (
        <div style={{ display: 'flex', justifyContent: 'center', padding: '60px' }}>
          <Loader2 size={32} className="spin" style={{ color: 'var(--primary-color)' }} />
        </div>
      ) : (
        <div style={{ background: 'var(--card-bg)', border: '1px solid var(--border-color)', borderRadius: '12px', overflow: 'hidden' }}>
          {activeTab === "Types" && (
            <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left', fontSize: '14px' }}>
              <thead>
                <tr style={{ borderBottom: '1px solid var(--border-color)', background: 'rgba(0,0,0,0.1)' }}>
                  <th style={{ padding: '16px 20px', color: 'var(--text-secondary)' }}>Type Name</th>
                  <th style={{ padding: '16px 20px', color: 'var(--text-secondary)' }}>Unique Code</th>
                  <th style={{ padding: '16px 20px', color: 'var(--text-secondary)', textAlign: 'right' }}>Actions</th>
                </tr>
              </thead>
              <tbody>
                {types.map(t => (
                  <tr key={t.typeId} style={{ borderBottom: '1px solid var(--border-color)' }}>
                    <td style={{ padding: '16px 20px', fontWeight: 600, color: '#fff' }}>{t.typeName}</td>
                    <td style={{ padding: '16px 20px', color: 'var(--text-secondary)', fontFamily: 'monospace' }}>{t.uniqueId || 'N/A'}</td>
                    <td style={{ padding: '16px 20px', textAlign: 'right' }}>
                      <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '10px' }}>
                        <button onClick={() => openEditModal("Type", t)} style={{ background: 'none', border: 'none', color: 'var(--text-secondary)', cursor: 'pointer' }}><Edit size={16} /></button>
                        <button onClick={() => handleDelete(API_TYPE, t.typeId)} style={{ background: 'none', border: 'none', color: 'var(--danger-color)', cursor: 'pointer' }}><Trash2 size={16} /></button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}

          {activeTab === "SubTypes" && (
            <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left', fontSize: '14px' }}>
              <thead>
                <tr style={{ borderBottom: '1px solid var(--border-color)', background: 'rgba(0,0,0,0.1)' }}>
                  <th style={{ padding: '16px 20px', color: 'var(--text-secondary)' }}>SubType Name</th>
                  <th style={{ padding: '16px 20px', color: 'var(--text-secondary)' }}>Unique Code</th>
                  <th style={{ padding: '16px 20px', color: 'var(--text-secondary)' }}>Fuel Type</th>
                  <th style={{ padding: '16px 20px', color: 'var(--text-secondary)' }}>Asset Unit</th>
                  <th style={{ padding: '16px 20px', color: 'var(--text-secondary)', textAlign: 'right' }}>Actions</th>
                </tr>
              </thead>
              <tbody>
                {subtypes.map(s => (
                  <tr key={s.subTypeId} style={{ borderBottom: '1px solid var(--border-color)' }}>
                    <td style={{ padding: '16px 20px', fontWeight: 600, color: '#fff' }}>{s.subTypeName}</td>
                    <td style={{ padding: '16px 20px', color: 'var(--text-secondary)', fontFamily: 'monospace' }}>{s.uniqueId || 'N/A'}</td>
                    <td style={{ padding: '16px 20px', color: 'var(--text-secondary)' }}>{s.fuelType || 'Diesel'}</td>
                    <td style={{ padding: '16px 20px', color: 'var(--text-secondary)' }}>{s.assetUnit || 'Hours'}</td>
                    <td style={{ padding: '16px 20px', textAlign: 'right' }}>
                      <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '10px' }}>
                        <button onClick={() => openEditModal("SubType", s)} style={{ background: 'none', border: 'none', color: 'var(--text-secondary)', cursor: 'pointer' }}><Edit size={16} /></button>
                        <button onClick={() => handleDelete(API_SUBTYPE, s.subTypeId)} style={{ background: 'none', border: 'none', color: 'var(--danger-color)', cursor: 'pointer' }}><Trash2 size={16} /></button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}

          {activeTab === "Makes" && (
            <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left', fontSize: '14px' }}>
              <thead>
                <tr style={{ borderBottom: '1px solid var(--border-color)', background: 'rgba(0,0,0,0.1)' }}>
                  <th style={{ padding: '16px 20px', color: 'var(--text-secondary)' }}>Manufacturer Make Name</th>
                  <th style={{ padding: '16px 20px', color: 'var(--text-secondary)' }}>Unique Code</th>
                  <th style={{ padding: '16px 20px', color: 'var(--text-secondary)', textAlign: 'right' }}>Actions</th>
                </tr>
              </thead>
              <tbody>
                {makes.map(m => (
                  <tr key={m.makeId} style={{ borderBottom: '1px solid var(--border-color)' }}>
                    <td style={{ padding: '16px 20px', fontWeight: 600, color: '#fff' }}>{m.makeName}</td>
                    <td style={{ padding: '16px 20px', color: 'var(--text-secondary)', fontFamily: 'monospace' }}>{m.uniqueId || 'N/A'}</td>
                    <td style={{ padding: '16px 20px', textAlign: 'right' }}>
                      <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '10px' }}>
                        <button onClick={() => openEditModal("Make", m)} style={{ background: 'none', border: 'none', color: 'var(--text-secondary)', cursor: 'pointer' }}><Edit size={16} /></button>
                        <button onClick={() => handleDelete(API_MAKE, m.makeId)} style={{ background: 'none', border: 'none', color: 'var(--danger-color)', cursor: 'pointer' }}><Trash2 size={16} /></button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}

          {activeTab === "Models" && (
            <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left', fontSize: '14px' }}>
              <thead>
                <tr style={{ borderBottom: '1px solid var(--border-color)', background: 'rgba(0,0,0,0.1)' }}>
                  <th style={{ padding: '16px 20px', color: 'var(--text-secondary)' }}>Model No / Code</th>
                  <th style={{ padding: '16px 20px', color: 'var(--text-secondary)' }}>Make (Manufacturer)</th>
                  <th style={{ padding: '16px 20px', color: 'var(--text-secondary)', textAlign: 'right' }}>Actions</th>
                </tr>
              </thead>
              <tbody>
                {models.map(m => (
                  <tr key={m.modelId} style={{ borderBottom: '1px solid var(--border-color)' }}>
                    <td style={{ padding: '16px 20px', fontWeight: 600, color: '#fff' }}>{m.modelNo}</td>
                    <td style={{ padding: '16px 20px', color: 'var(--text-secondary)' }}>{m.make?.makeName || 'N/A'}</td>
                    <td style={{ padding: '16px 20px', textAlign: 'right' }}>
                      <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '10px' }}>
                        <button onClick={() => openEditModal("Model", m)} style={{ background: 'none', border: 'none', color: 'var(--text-secondary)', cursor: 'pointer' }}><Edit size={16} /></button>
                        <button onClick={() => handleDelete(API_MODEL, m.modelId)} style={{ background: 'none', border: 'none', color: 'var(--danger-color)', cursor: 'pointer' }}><Trash2 size={16} /></button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      )}

      {/* Editor Modal */}
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
            maxWidth: '460px',
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
              {editingId ? `Edit ${modalType}` : `Create New ${modalType}`}
            </h3>

            <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
              {modalType === "Type" && (
                <div>
                  <label style={{ display: 'block', fontSize: '13px', fontWeight: 500, color: 'var(--text-secondary)', marginBottom: '6px' }}>Type Name</label>
                  <input 
                    type="text" 
                    required
                    value={typeForm.typeName}
                    onChange={(e) => setTypeForm({ ...typeForm, typeName: e.target.value })}
                    style={{ width: '100%', background: 'rgba(0,0,0,0.2)', border: '1px solid var(--border-color)', padding: '10px', borderRadius: '8px', color: '#fff', outline: 'none' }}
                  />
                </div>
              )}

              {modalType === "SubType" && (
                <>
                  <div>
                    <label style={{ display: 'block', fontSize: '13px', fontWeight: 500, color: 'var(--text-secondary)', marginBottom: '6px' }}>SubType Name</label>
                    <input 
                      type="text" 
                      required
                      value={subtypeForm.subTypeName}
                      onChange={(e) => setSubtypeForm({ ...subtypeForm, subTypeName: e.target.value })}
                      style={{ width: '100%', background: 'rgba(0,0,0,0.2)', border: '1px solid var(--border-color)', padding: '10px', borderRadius: '8px', color: '#fff', outline: 'none' }}
                    />
                  </div>
                  <div>
                    <label style={{ display: 'block', fontSize: '13px', fontWeight: 500, color: 'var(--text-secondary)', marginBottom: '6px' }}>Parent Asset Type</label>
                    <select
                      value={subtypeForm.typeId}
                      onChange={(e) => setSubtypeForm({ ...subtypeForm, typeId: parseInt(e.target.value) })}
                      style={{ width: '100%', background: 'rgba(0,0,0,0.2)', border: '1px solid var(--border-color)', padding: '10px', borderRadius: '8px', color: '#fff', outline: 'none' }}
                    >
                      {types.map(t => <option key={t.typeId} value={t.typeId} style={{ background: '#131824' }}>{t.typeName}</option>)}
                    </select>
                  </div>
                  <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px' }}>
                    <div>
                      <label style={{ display: 'block', fontSize: '13px', fontWeight: 500, color: 'var(--text-secondary)', marginBottom: '6px' }}>Asset Unit</label>
                      <input 
                        type="text"
                        value={subtypeForm.assetUnit}
                        onChange={(e) => setSubtypeForm({ ...subtypeForm, assetUnit: e.target.value })}
                        style={{ width: '100%', background: 'rgba(0,0,0,0.2)', border: '1px solid var(--border-color)', padding: '10px', borderRadius: '8px', color: '#fff', outline: 'none' }}
                      />
                    </div>
                    <div>
                      <label style={{ display: 'block', fontSize: '13px', fontWeight: 500, color: 'var(--text-secondary)', marginBottom: '6px' }}>Fuel Type</label>
                      <input 
                        type="text"
                        value={subtypeForm.fuelType}
                        onChange={(e) => setSubtypeForm({ ...subtypeForm, fuelType: e.target.value })}
                        style={{ width: '100%', background: 'rgba(0,0,0,0.2)', border: '1px solid var(--border-color)', padding: '10px', borderRadius: '8px', color: '#fff', outline: 'none' }}
                      />
                    </div>
                  </div>
                </>
              )}

              {modalType === "Make" && (
                <>
                  <div>
                    <label style={{ display: 'block', fontSize: '13px', fontWeight: 500, color: 'var(--text-secondary)', marginBottom: '6px' }}>Make Name</label>
                    <input 
                      type="text" 
                      required
                      value={makeForm.makeName}
                      onChange={(e) => setMakeForm({ ...makeForm, makeName: e.target.value })}
                      style={{ width: '100%', background: 'rgba(0,0,0,0.2)', border: '1px solid var(--border-color)', padding: '10px', borderRadius: '8px', color: '#fff', outline: 'none' }}
                    />
                  </div>
                  <div>
                    <label style={{ display: 'block', fontSize: '13px', fontWeight: 500, color: 'var(--text-secondary)', marginBottom: '6px' }}>Parent SubType</label>
                    <select
                      value={makeForm.subTypeId}
                      onChange={(e) => setMakeForm({ ...makeForm, subTypeId: parseInt(e.target.value) })}
                      style={{ width: '100%', background: 'rgba(0,0,0,0.2)', border: '1px solid var(--border-color)', padding: '10px', borderRadius: '8px', color: '#fff', outline: 'none' }}
                    >
                      {subtypes.map(s => <option key={s.subTypeId} value={s.subTypeId} style={{ background: '#131824' }}>{s.subTypeName}</option>)}
                    </select>
                  </div>
                </>
              )}

              {modalType === "Model" && (
                <>
                  <div>
                    <label style={{ display: 'block', fontSize: '13px', fontWeight: 500, color: 'var(--text-secondary)', marginBottom: '6px' }}>Model No</label>
                    <input 
                      type="text" 
                      required
                      value={modelForm.modelNo}
                      onChange={(e) => setModelForm({ ...modelForm, modelNo: e.target.value })}
                      style={{ width: '100%', background: 'rgba(0,0,0,0.2)', border: '1px solid var(--border-color)', padding: '10px', borderRadius: '8px', color: '#fff', outline: 'none' }}
                    />
                  </div>
                  <div>
                    <label style={{ display: 'block', fontSize: '13px', fontWeight: 500, color: 'var(--text-secondary)', marginBottom: '6px' }}>Parent Make</label>
                    <select
                      value={modelForm.makeId}
                      onChange={(e) => setModelForm({ ...modelForm, makeId: parseInt(e.target.value) })}
                      style={{ width: '100%', background: 'rgba(0,0,0,0.2)', border: '1px solid var(--border-color)', padding: '10px', borderRadius: '8px', color: '#fff', outline: 'none' }}
                    >
                      {makes.map(m => <option key={m.makeId} value={m.makeId} style={{ background: '#131824' }}>{m.makeName}</option>)}
                    </select>
                  </div>
                </>
              )}

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
                Save {modalType}
              </button>
            </form>
          </div>
        </div>,
        document.body
      )}
    </div>
  );
}
