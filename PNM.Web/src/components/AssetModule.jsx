import React, { useState, useEffect } from 'react';
import { createPortal } from 'react-dom';
import { Loader2 } from 'lucide-react';

/* ── Defined OUTSIDE the component to keep stable identity across renders ── */
function SectionHeader({ label }) {
  return (
    <h6 style={{
      color: 'var(--primary-color)', fontSize: '13px', fontWeight: 700,
      textTransform: 'uppercase', letterSpacing: '0.08em',
      borderBottom: '1px solid var(--border-color)',
      paddingBottom: '6px', marginBottom: '14px', marginTop: '20px'
    }}>{label}</h6>
  );
}

function FormRow({ children }) {
  return (
    <div style={{ display: 'flex', gap: '16px', marginBottom: '14px' }}>{children}</div>
  );
}

function FormGroup({ label, required, children }) {
  return (
    <div style={{ flex: 1, minWidth: 0 }}>
      <label style={{ display: 'block', color: 'var(--text-secondary)', fontSize: '12px', fontWeight: 600, marginBottom: '5px', textTransform: 'uppercase', letterSpacing: '0.04em' }}>
        {label}{required && <span style={{ color: 'var(--danger-color)', marginLeft: 2 }}>*</span>}
      </label>
      {children}
    </div>
  );
}

const API_BASE   = "http://localhost:5167/api/Asset";
const API_DEPT   = "http://localhost:5167/api/Department";
// Category removed — hierarchy starts from Type
const API_TYPE   = "http://localhost:5167/api/Type";
const API_SUBTYPE= "http://localhost:5167/api/SubType";
const API_MAKE   = "http://localhost:5167/api/Make";
const API_MODEL  = "http://localhost:5167/api/Model";
const API_OWNER  = "http://localhost:5167/api/OwnerType";

const STATUS_BADGE = {
  Active:      'success',
  Breakdown:   'danger',
  Maintenance: 'warning',
  Inactive:    'secondary',
};

const EMPTY_FORM = {
  deptId: 0, assetCode: '', assetName: '',
  typeId: 0, subTypeId: 0, makeId: 0, modelId: 0, ownerId: 0,
  registrationNo: '', chassisNo: '', engineNo: '', serialNo: '',
  meterType: 'Hours', currentMeterReading: 0,
  fuelType: 'Diesel', fuelTankCapacity: '',
  purchaseDate: '', purchaseCost: '', supplierName: '', invoiceNo: '',
  assetStatus: 'Active', remarks: ''
};

export default function AssetModule() {
  /* ── State ── */
  const [assets,      setAssets]      = useState([]);
  const [departments, setDepartments] = useState([]);
  // categories state removed — Category field not used
  const [allTypes,    setAllTypes]    = useState([]);
  const [allSubTypes, setAllSubTypes] = useState([]);
  const [allMakes,    setAllMakes]    = useState([]);
  const [allModels,   setAllModels]   = useState([]);
  const [owners,      setOwners]      = useState([]);

  const [loading,      setLoading]      = useState(true);
  const [error,        setError]        = useState('');
  const [searchTerm,   setSearchTerm]   = useState('');
  const [statusFilter, setStatusFilter] = useState('All');
  const [deptFilter,   setDeptFilter]   = useState('All');

  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingId,   setEditingId]   = useState(null);
  const [form,        setForm]        = useState(EMPTY_FORM);
  const [saving,      setSaving]      = useState(false);

  /* ── Boot ── */
  useEffect(() => {
    fetchAssets();
    fetchDropdowns();
  }, []);

  /* ── Data fetching ── */
  const fetchDropdowns = async () => {
    try {
      const [dR, tR, sR, mR, mdR, oR] = await Promise.all([
        fetch(API_DEPT), fetch(API_TYPE),
        fetch(API_SUBTYPE), fetch(API_MAKE), fetch(API_MODEL), fetch(API_OWNER)
      ]);
      const [dJ, tJ, sJ, mJ, mdJ, oJ] = await Promise.all([
        dR.json(), tR.json(), sR.json(), mR.json(), mdR.json(), oR.json()
      ]);
      setDepartments(dJ.data || []);
      setAllTypes(tJ.data || []);
      setAllSubTypes(sJ.data || []);
      setAllMakes(mJ.data || []);
      setAllModels(mdJ.data || []);
      setOwners(oJ.data || []);
    } catch (err) {
      console.error('Failed to fetch dropdown data:', err);
    }
  };

  const fetchAssets = async () => {
    setLoading(true);
    setError('');
    try {
      const res = await fetch(API_BASE);
      if (!res.ok) throw new Error('Failed to load assets from backend.');
      const json = await res.json();
      setAssets(json.data || []);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  /* ── Form helpers ── */
  const handleInput = (e) => {
    const { name, value } = e.target;
    setForm(prev => ({
      ...prev,
      [name]: name.endsWith('Id') ? (value === '' ? 0 : parseInt(value) || 0) : value
    }));
  };

  // handleCatChange removed — Category field not used
  const handleTypeChange = (e) => {
    const typeId = parseInt(e.target.value) || 0;
    setForm(prev => ({ ...prev, typeId, subTypeId: 0, makeId: 0, modelId: 0 }));
  };
  const handleSubTypeChange = (e) => {
    const subTypeId = parseInt(e.target.value) || 0;
    setForm(prev => ({ ...prev, subTypeId, makeId: 0, modelId: 0 }));
  };
  const handleMakeChange = (e) => {
    const makeId = parseInt(e.target.value) || 0;
    setForm(prev => ({ ...prev, makeId, modelId: 0 }));
  };

  /* ── Cascading selects ── */
  const filteredTypes    = allTypes; // show all types — no category filter
  const filteredSubTypes = allSubTypes.filter(s => s.typeId  === form.typeId);
  const filteredMakes    = allMakes.filter(m => m.subTypeId  === form.subTypeId);
  const filteredModels   = allModels.filter(m => m.makeId    === form.makeId);

  /* ── Modal open ── */
  const openAdd = () => {
    setEditingId(null);
    setForm({
      ...EMPTY_FORM,
      deptId: departments[0]?.deptId || 0,
      ownerId: owners[0]?.ownerId || 0,
      purchaseDate: new Date().toISOString().split('T')[0]
    });
    setIsModalOpen(true);
  };

  const openEdit = (a) => {
    setEditingId(a.assetId);
    setForm({
      deptId: a.deptId || 0, assetCode: a.assetCode || '', assetName: a.assetName || '',
      typeId: a.typeId || 0, subTypeId: a.subTypeId || 0,
      makeId: a.makeId || 0, modelId: a.modelId || 0, ownerId: a.ownerId || 0,
      registrationNo: a.registrationNo || '', chassisNo: a.chassisNo || '',
      engineNo: a.engineNo || '', serialNo: a.serialNo || '',
      meterType: a.meterType || 'Hours', currentMeterReading: a.currentMeterReading || 0,
      fuelType: a.fuelType || 'Diesel', fuelTankCapacity: a.fuelTankCapacity || '',
      purchaseDate: a.purchaseDate || '', purchaseCost: a.purchaseCost || '',
      supplierName: a.supplierName || '', invoiceNo: a.invoiceNo || '',
      assetStatus: a.assetStatus || 'Active', remarks: a.remarks || ''
    });
    setIsModalOpen(true);
  };

  /* ── Submit ── */
  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!form.deptId || !form.typeId || !form.subTypeId || !form.makeId || !form.modelId || !form.ownerId) {
      alert('Please select all required fields: Department, Type, SubType, Make, Model and Owner before saving.');
      return;
    }
    setSaving(true);
    try {
      const url    = editingId ? `${API_BASE}/${editingId}` : API_BASE;
      const method = editingId ? 'PUT' : 'POST';
      const payload = {
        ...form,
        currentMeterReading: parseFloat(form.currentMeterReading) || 0,
        fuelTankCapacity:    form.fuelTankCapacity ? parseFloat(form.fuelTankCapacity) : null,
        purchaseCost:        form.purchaseCost     ? parseFloat(form.purchaseCost)     : null,
        purchaseDate:        form.purchaseDate     || null,
        registrationNo: form.registrationNo || null,
        chassisNo:      form.chassisNo      || null,
        engineNo:       form.engineNo       || null,
        serialNo:       form.serialNo       || null,
        supplierName:   form.supplierName   || null,
        invoiceNo:      form.invoiceNo      || null,
        remarks:        form.remarks        || null,
      };
      const res = await fetch(url, {
        method,
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
      });
      if (!res.ok) {
        const errJson = await res.json().catch(() => null);
        throw new Error(errJson?.message || 'Failed to save asset.');
      }
      setIsModalOpen(false);
      fetchAssets();
    } catch (err) {
      alert(err.message);
    } finally {
      setSaving(false);
    }
  };

  /* ── Delete ── */
  const handleDelete = async (id) => {
    if (!confirm('Are you sure you want to delete this asset?')) return;
    try {
      const res = await fetch(`${API_BASE}/${id}`, { method: 'DELETE' });
      if (!res.ok) throw new Error('Failed to delete asset.');
      fetchAssets();
    } catch (err) {
      alert(err.message);
    }
  };

  /* ── Filtered rows ── */
  const filteredAssets = assets.filter(a => {
    const q = searchTerm.toLowerCase();
    const matchSearch =
      a.assetName?.toLowerCase().includes(q) ||
      a.assetCode?.toLowerCase().includes(q) ||
      a.serialNo?.toLowerCase().includes(q) ||
      a.registrationNo?.toLowerCase().includes(q);
    const matchStatus = statusFilter === 'All' || a.assetStatus === statusFilter;
    const matchDept   = deptFilter   === 'All' || a.deptId?.toString() === deptFilter;
    return matchSearch && matchStatus && matchDept;
  });

  /* ══════════════════════════════════════════ RENDER ══════════════════════════════════════════ */
  return (
    <div className="animate-fade">
      {/* ── Page Title ── */}
      <div className="row mb-3">
        <div className="col-md-12">
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <div>
              <h2 style={{ fontSize: '24px', fontWeight: 600, color: 'var(--text-primary)', marginBottom: '2px' }}>
                Assets Management
              </h2>
              <p style={{ color: 'var(--text-secondary)', fontSize: '13px', margin: 0 }}>
                Register and manage all plant &amp; machinery assets
              </p>
            </div>
            {/* Summary badges */}
            <div style={{ display: 'flex', gap: '10px' }}>
              {['Active', 'Breakdown', 'Maintenance'].map(s => {
                const count = assets.filter(a => a.assetStatus === s).length;
                return (
                  <div key={s} style={{
                    background: 'var(--card-bg)', border: '1px solid var(--border-color)',
                    borderRadius: '8px', padding: '8px 16px', textAlign: 'center', minWidth: '90px'
                  }}>
                    <div style={{ fontSize: '20px', fontWeight: 700, color: s === 'Active' ? 'var(--success-color)' : s === 'Breakdown' ? 'var(--danger-color)' : 'var(--warning-color)' }}>
                      {count}
                    </div>
                    <div style={{ fontSize: '11px', color: 'var(--text-secondary)', fontWeight: 500 }}>{s}</div>
                  </div>
                );
              })}
            </div>
          </div>
        </div>
      </div>

      {/* ── Main Card ── */}
      <div className="card">
        <div className="card-header d-flex justify-content-between align-items-center"
          style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', width: '100%' }}>
          <div className="caption font-carolina" style={{ display: 'flex', alignItems: 'center' }}>
            <i className="ti-truck mr-2" style={{ marginRight: '8px' }}></i>
            <span className="caption-subject bold uppercase">Assets List</span>
            <span className="badge badge-pill badge-carolina" style={{ marginLeft: '10px', fontSize: '11px' }}>
              {filteredAssets.length}
            </span>
          </div>
          <div className="actions">
            <button onClick={openAdd} className="btn btn-carolina btn-sm">
              <i className="ti-plus" style={{ marginRight: '5px' }}></i> Add Asset
            </button>
          </div>
        </div>

        <div className="card-body">
          {/* ── Filter Bar ── */}
          <div className="row mb-4">
            <div className="col-md-6">
              <div className="input-group">
                <div className="input-group-prepend">
                  <span className="input-group-text"><i className="ti-search"></i></span>
                </div>
                <input
                  type="text"
                  className="form-control"
                  placeholder="Search by name, code, serial no. or reg. no..."
                  value={searchTerm}
                  onChange={e => setSearchTerm(e.target.value)}
                />
              </div>
            </div>
            <div className="col-md-3">
              <select className="form-control" value={deptFilter} onChange={e => setDeptFilter(e.target.value)}>
                <option value="All">All Departments</option>
                {departments.map(d => (
                  <option key={d.deptId} value={d.deptId}>{d.deptName}</option>
                ))}
              </select>
            </div>
            <div className="col-md-3">
              <select className="form-control" value={statusFilter} onChange={e => setStatusFilter(e.target.value)}>
                <option value="All">All Statuses</option>
                <option value="Active">Active</option>
                <option value="Breakdown">Breakdown</option>
                <option value="Maintenance">Maintenance</option>
                <option value="Inactive">Inactive</option>
              </select>
            </div>
          </div>

          {/* ── Table / States ── */}
          {loading ? (
            <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', minHeight: '220px' }}>
              <Loader2 size={32} className="spin" style={{ color: 'var(--primary-color)' }} />
            </div>
          ) : error ? (
            <div className="alert alert-danger" role="alert">
              <p className="mb-0">{error}</p>
              <button onClick={fetchAssets} className="btn btn-danger btn-sm mt-2">
                <i className="ti-reload" style={{ marginRight: '4px' }}></i> Retry
              </button>
            </div>
          ) : filteredAssets.length === 0 ? (
            <div style={{ textAlign: 'center', padding: '50px 20px', border: '1px dashed var(--border-color)', borderRadius: '8px' }}>
              <i className="ti-truck" style={{ fontSize: '36px', color: 'var(--text-muted)', display: 'block', marginBottom: '12px' }}></i>
              <p style={{ color: 'var(--text-secondary)', margin: 0 }}>
                {searchTerm || statusFilter !== 'All' || deptFilter !== 'All'
                  ? 'No assets matched your search criteria.'
                  : 'No assets registered yet. Click "Add Asset" to begin.'}
              </p>
            </div>
          ) : (
            <div className="table-responsive">
              <table className="table table-hover table-striped">
                <thead>
                  <tr>
                    <th>#</th>
                    <th>Code</th>
                    <th>Asset Name</th>
                    <th>Type / SubType</th>
                    <th>Make / Model</th>
                    <th>Department</th>
                    <th>Meter</th>
                    <th>Reg. No.</th>
                    <th>Status</th>
                    <th className="text-right" style={{ textAlign: 'right' }}>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  {filteredAssets.map((a, idx) => (
                    <tr key={a.assetId}>
                      <td style={{ color: 'var(--text-muted)', fontSize: '12px' }}>{idx + 1}</td>
                      <td>
                        <strong className="text-carolina">{a.assetCode}</strong>
                      </td>
                      <td>
                        <span style={{ fontWeight: 500 }}>{a.assetName}</span>
                      </td>
                      <td>
                        <span style={{ fontSize: '12px', color: 'var(--text-secondary)' }}>
                          {a.typeName || '—'}&nbsp;›&nbsp;{a.subTypeName || '—'}
                        </span>
                      </td>
                      <td>
                        <span style={{ fontSize: '12px', color: 'var(--text-secondary)' }}>
                          {a.makeName || '—'}&nbsp;/&nbsp;{a.modelNo || '—'}
                        </span>
                      </td>
                      <td>{a.deptName || '—'}</td>
                      <td>
                        <span style={{ fontWeight: 500 }}>{a.currentMeterReading ?? '—'}</span>
                        {a.meterType && (
                          <small style={{ color: 'var(--text-muted)', marginLeft: '3px' }}>{a.meterType}</small>
                        )}
                      </td>
                      <td>{a.registrationNo || '—'}</td>
                      <td>
                        <span className={`badge badge-pill badge-${STATUS_BADGE[a.assetStatus] || 'secondary'}`}>
                          {a.assetStatus}
                        </span>
                      </td>
                      <td className="text-right" style={{ textAlign: 'right', whiteSpace: 'nowrap' }}>
                        <button
                          className="btn btn-outline-secondary btn-sm mr-1"
                          style={{ marginRight: '4px' }}
                          title="Edit"
                          onClick={() => openEdit(a)}>
                          <i className="ti-pencil"></i>
                        </button>
                        <button
                          className="btn btn-outline-danger btn-sm"
                          title="Delete"
                          onClick={() => handleDelete(a.assetId)}>
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

      {/* ══════════════ ADD / EDIT MODAL ══════════════ */}
      {isModalOpen && createPortal(
        <div style={{
          position: 'fixed', inset: 0,
          background: 'rgba(5, 7, 12, 0.75)',
          backdropFilter: 'blur(4px)',
          display: 'flex', justifyContent: 'center', alignItems: 'center',
          zIndex: 9999
        }}>
          <div className="modal-dialog" style={{ width: '100%', maxWidth: '760px', margin: 0 }}>
            <div className="modal-content modal-content-custom">

              {/* Modal Header */}
              <div className="modal-header" style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <h5 className="modal-title font-carolina bold uppercase"
                  style={{ fontSize: '15px', fontWeight: 700, textTransform: 'uppercase', letterSpacing: '0.05em', display: 'flex', alignItems: 'center', gap: '8px' }}>
                  <i className="ti-truck"></i>
                  {editingId ? 'Edit Asset' : 'Add New Asset'}
                </h5>
                <button type="button" className="close" onClick={() => setIsModalOpen(false)}
                  style={{ color: 'var(--text-primary)', opacity: 0.8 }}>
                  <span aria-hidden="true">&times;</span>
                </button>
              </div>

              <form onSubmit={handleSubmit}>
                <div className="modal-body" style={{ maxHeight: '72vh', overflowY: 'auto', padding: '20px' }}>

                  {/* ── General Information ── */}
                  <SectionHeader label="General Information" />

                  <FormRow>
                    <FormGroup label="Asset Code" required>
                      <input type="text" name="assetCode" className="form-control" required
                        value={form.assetCode} onChange={handleInput} placeholder="e.g. AST-001" />
                    </FormGroup>
                    <FormGroup label="Asset Name" required>
                      <input type="text" name="assetName" className="form-control" required
                        value={form.assetName} onChange={handleInput} placeholder="e.g. Excavator 320D" />
                    </FormGroup>
                  </FormRow>

                  <FormRow>
                    <FormGroup label="Department" required>
                      <select name="deptId" className="form-control" required value={form.deptId} onChange={handleInput}>
                        <option value="">-- Select Department --</option>
                        {departments.map(d => (
                          <option key={d.deptId} value={d.deptId}>{d.deptName}</option>
                        ))}
                      </select>
                    </FormGroup>
                    <FormGroup label="Owner Type" required>
                      <select name="ownerId" className="form-control" required value={form.ownerId} onChange={handleInput}>
                        <option value="">-- Select Owner Type --</option>
                        {owners.map(o => (
                          <option key={o.ownerId} value={o.ownerId}>{o.ownerType}</option>
                        ))}
                      </select>
                    </FormGroup>
                    <FormGroup label="Status" required>
                      <select name="assetStatus" className="form-control" value={form.assetStatus} onChange={handleInput}>
                        <option value="Active">Active</option>
                        <option value="Breakdown">Breakdown</option>
                        <option value="Maintenance">Maintenance</option>
                        <option value="Inactive">Inactive</option>
                      </select>
                    </FormGroup>
                  </FormRow>

                  {/* ── Specifications ── */}
                  <SectionHeader label="Specifications &amp; Model" />

                  <FormRow>
                    <FormGroup label="Asset Type" required>
                      <select name="typeId" className="form-control" required value={form.typeId}
                        onChange={handleTypeChange}>
                        <option value="">-- Select Type --</option>
                        {filteredTypes.map(t => (
                          <option key={t.typeId} value={t.typeId}>{t.typeName}</option>
                        ))}
                      </select>
                    </FormGroup>
                  </FormRow>

                  <FormRow>
                    <FormGroup label="Sub Type" required>
                      <select name="subTypeId" className="form-control" required value={form.subTypeId}
                        onChange={handleSubTypeChange} disabled={!form.typeId}>
                        <option value="">-- Select SubType --</option>
                        {filteredSubTypes.map(s => (
                          <option key={s.subTypeId} value={s.subTypeId}>{s.subTypeName}</option>
                        ))}
                      </select>
                    </FormGroup>
                    <FormGroup label="Make (Manufacturer)" required>
                      <select name="makeId" className="form-control" required value={form.makeId}
                        onChange={handleMakeChange} disabled={!form.subTypeId}>
                        <option value="">-- Select Make --</option>
                        {filteredMakes.map(m => (
                          <option key={m.makeId} value={m.makeId}>{m.makeName}</option>
                        ))}
                      </select>
                    </FormGroup>
                    <FormGroup label="Model No." required>
                      <select name="modelId" className="form-control" required value={form.modelId}
                        onChange={handleInput} disabled={!form.makeId}>
                        <option value="">-- Select Model --</option>
                        {filteredModels.map(m => (
                          <option key={m.modelId} value={m.modelId}>{m.modelNo}</option>
                        ))}
                      </select>
                    </FormGroup>
                  </FormRow>

                  {/* ── Identifiers ── */}
                  <SectionHeader label="Identifiers &amp; Serial Numbers" />

                  <FormRow>
                    <FormGroup label="Registration No.">
                      <input type="text" name="registrationNo" className="form-control"
                        value={form.registrationNo} onChange={handleInput} placeholder="e.g. GJ-01-AB-1234" />
                    </FormGroup>
                    <FormGroup label="Serial No.">
                      <input type="text" name="serialNo" className="form-control"
                        value={form.serialNo} onChange={handleInput} />
                    </FormGroup>
                  </FormRow>

                  <FormRow>
                    <FormGroup label="Chassis No.">
                      <input type="text" name="chassisNo" className="form-control"
                        value={form.chassisNo} onChange={handleInput} />
                    </FormGroup>
                    <FormGroup label="Engine No.">
                      <input type="text" name="engineNo" className="form-control"
                        value={form.engineNo} onChange={handleInput} />
                    </FormGroup>
                  </FormRow>

                  {/* ── Meter & Fuel ── */}
                  <SectionHeader label="Meter &amp; Fuel Configuration" />

                  <FormRow>
                    <FormGroup label="Meter Type">
                      <select name="meterType" className="form-control" value={form.meterType} onChange={handleInput}>
                        <option value="Hours">Hours</option>
                        <option value="Kms">Kilometers (Kms)</option>
                        <option value="None">None</option>
                      </select>
                    </FormGroup>
                    <FormGroup label="Current Meter Reading">
                      <input type="number" step="0.01" name="currentMeterReading" className="form-control"
                        value={form.currentMeterReading} onChange={handleInput} />
                    </FormGroup>
                  </FormRow>

                  <FormRow>
                    <FormGroup label="Fuel Type">
                      <select name="fuelType" className="form-control" value={form.fuelType} onChange={handleInput}>
                        <option value="Diesel">Diesel</option>
                        <option value="Petrol">Petrol</option>
                        <option value="CNG">CNG</option>
                        <option value="Electric">Electric</option>
                        <option value="None">None</option>
                      </select>
                    </FormGroup>
                    <FormGroup label="Tank Capacity (Ltr)">
                      <input type="number" step="0.01" name="fuelTankCapacity" className="form-control"
                        value={form.fuelTankCapacity} onChange={handleInput} placeholder="e.g. 80.00" />
                    </FormGroup>
                  </FormRow>

                  {/* ── Purchase Details ── */}
                  <SectionHeader label="Purchase Details" />

                  <FormRow>
                    <FormGroup label="Purchase Date">
                      <input type="date" name="purchaseDate" className="form-control"
                        value={form.purchaseDate} onChange={handleInput} />
                    </FormGroup>
                    <FormGroup label="Purchase Cost">
                      <input type="number" step="0.01" name="purchaseCost" className="form-control"
                        value={form.purchaseCost} onChange={handleInput} placeholder="e.g. 4500000" />
                    </FormGroup>
                  </FormRow>

                  <FormRow>
                    <FormGroup label="Supplier Name">
                      <input type="text" name="supplierName" className="form-control"
                        value={form.supplierName} onChange={handleInput} />
                    </FormGroup>
                    <FormGroup label="Invoice No.">
                      <input type="text" name="invoiceNo" className="form-control"
                        value={form.invoiceNo} onChange={handleInput} />
                    </FormGroup>
                  </FormRow>

                  {/* ── Remarks ── */}
                  <div style={{ marginTop: '4px' }}>
                    <label style={{ display: 'block', color: 'var(--text-secondary)', fontSize: '12px', fontWeight: 600, marginBottom: '5px', textTransform: 'uppercase', letterSpacing: '0.04em' }}>
                      Remarks
                    </label>
                    <textarea name="remarks" className="form-control" rows="2"
                      value={form.remarks} onChange={handleInput}
                      placeholder="Any notes or descriptions..." />
                  </div>

                </div>

                {/* Modal Footer */}
                <div className="modal-footer"
                  style={{ borderTop: '1px solid var(--border-color)', padding: '14px 20px', display: 'flex', justifyContent: 'flex-end', gap: '10px' }}>
                  <button type="button" className="btn btn-secondary" onClick={() => setIsModalOpen(false)}>
                    Cancel
                  </button>
                  <button type="submit" className="btn btn-carolina" disabled={saving}>
                    {saving
                      ? <><Loader2 size={14} className="spin" style={{ marginRight: 6 }} />Saving…</>
                      : editingId ? 'Save Changes' : 'Create Asset'
                    }
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
