import React, { useState, useEffect } from 'react';
import {
  LayoutDashboard, FolderClosed, FileText, Fuel,
  Truck, CalendarCheck, ShieldAlert, UserCheck,
  Loader2, Menu, LogOut, ChevronRight
} from 'lucide-react';
import './App.css';
import './siqtheme.css';
import ProjectModule from './components/ProjectModule';
import PermissionManager from './components/PermissionManager';
import MenuManager from './components/MenuManager';
import AssetMasters from './components/AssetMasters';
import AssetModule from './components/AssetModule';
import OperatorModule from './components/OperatorModule';
import ProjectMachineModule from './components/ProjectMachineModule';
import ProjectOperatorModule from './components/ProjectOperatorModule';
import MachineOperatorModule from './components/MachineOperatorModule';
import { Settings, Sliders, Sun, Moon } from 'lucide-react';

// Mapping strings to Lucide icon components dynamically
const ICON_MAP = {
  LayoutDashboard: LayoutDashboard,
  FolderClosed: FolderClosed,
  FileText: FileText,
  Fuel: Fuel,
  Truck: Truck,
  CalendarCheck: CalendarCheck,
  ShieldAlert: ShieldAlert,
  Settings: Settings
};

const USERS = [
  { id: 1, name: "Alexander Vance", role: "Administrator", roleId: 1 },
  { id: 5, name: "Sarah Jenkins", role: "Site Incharge", roleId: 5 },
  { id: 6, name: "Ramesh Kumar", role: "Operator", roleId: 6 }
];

export default function App() {
  const [currentUser, setCurrentUser] = useState(USERS[0]);
  const [sidebarItems, setSidebarItems] = useState([]);
  const [loadingMenu, setLoadingMenu] = useState(true);
  const [activeTab, setActiveTab] = useState("Dashboard");

  const [isDarkMode, setIsDarkMode] = useState(true);
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [isSidebarCollapsed, setIsSidebarCollapsed] = useState(false);

  useEffect(() => {
    fetchUserMenu();
  }, [currentUser]);

  useEffect(() => {
    if (isDarkMode) {
      document.body.classList.add("theme-dark");
      document.body.classList.remove("theme-default");
    } else {
      document.body.classList.add("theme-default");
      document.body.classList.remove("theme-dark");
    }
  }, [isDarkMode]);

  const fetchUserMenu = async () => {
    setLoadingMenu(true);
    try {
      const res = await fetch(`http://localhost:5167/api/Permission/user/${currentUser.id}`);
      if (!res.ok) throw new Error("Failed to fetch menu permissions.");
      const json = await res.json();

      // Filter out only visible menu items
      const items = (json.data || []).filter(x => x.isVisible);
      setSidebarItems(items);

      // Auto-fallback active tab if current tab is no longer allowed/visible
      const isAllowed = items.some(x => x.viewName === activeTab) || activeTab === "Dashboard" || activeTab === "RoleMapping" || activeTab === "MenuManagement" || activeTab === "AssetSpecs";
      if (!isAllowed && items.length > 0) {
        setActiveTab(items[0].viewName || "Dashboard");
      }
    } catch (err) {
      console.error("Using fallback navigation items.");
      // Standard fallback menus for offline testing
      setSidebarItems([
        { id: 1, menuName: "Dashboard", viewName: "Dashboard", iconClass: "LayoutDashboard" },
        { id: 2, menuName: "Projects", viewName: "Projects", iconClass: "FolderClosed" },
        { id: 3, menuName: "Assets", viewName: "Assets", iconClass: "Truck" },
        { id: 7, menuName: "Permissions", viewName: "RoleMapping", iconClass: "ShieldAlert" }
      ]);
    } finally {
      setLoadingMenu(false);
    }
  };

  const renderActiveContent = () => {
    switch (activeTab?.toLowerCase()) {
      case "project":
      case "projects":
        return <ProjectModule />;
      case "rolemapping":
      case "permissionmanager":
      case "permissions":
        return <PermissionManager />;
      case "menumanagement":
      case "menumanager":
        return <MenuManager />;
      case "asset":
      case "assets":
      case "assetmaster":
        return <AssetModule />;
      case "operator":
      case "operators":
      case "operatormaster":
        return <OperatorModule />;
      case "assetspecs":
      case "assetmasters":
        return <AssetMasters />;
      case "projassetallocation":
      case "projectmachine":
      case "projectasset":
      case "machinetoproject":
        return <ProjectMachineModule />;
      case "projopallocation":
      case "projectoperator":
      case "projectop":
      case "projectoperatorallocation":
        return <ProjectOperatorModule />;
      case "assetopallocation":
      case "machineoperator":
      case "assetop":
      case "machinetooperator":
        return <MachineOperatorModule />;
      case "dashboard":
      default:
        return (
          <div className="animate-fade">
            <div style={{ marginBottom: '28px' }}>
              <h2 style={{ fontSize: '26px', fontWeight: 600 }}>Welcome Back, {currentUser.name}!</h2>
              <p style={{ color: 'var(--text-secondary)', fontSize: '15px', marginTop: '4px' }}>Overview of fleet maintenance, logging statuses, and pending tasks.</p>
            </div>

            {/* Metric Cards */}
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(240px, 1fr))', gap: '20px', marginBottom: '40px' }}>
              <div style={{ background: 'var(--card-bg)', border: '1px solid var(--border-color)', borderRadius: '12px', padding: '24px' }}>
                <span style={{ fontSize: '13px', color: 'var(--text-secondary)', fontWeight: 500 }}>ACTIVE PROJECTS</span>
                <h3 style={{ fontSize: '32px', fontWeight: 700, margin: '8px 0 4px 0', color: 'var(--primary-color)' }}>12</h3>
                <span style={{ fontSize: '12px', color: 'var(--success-color)' }}>+2 added this week</span>
              </div>
              <div style={{ background: 'var(--card-bg)', border: '1px solid var(--border-color)', borderRadius: '12px', padding: '24px' }}>
                <span style={{ fontSize: '13px', color: 'var(--text-secondary)', fontWeight: 500 }}>EQUIPMENT COUNT</span>
                <h3 style={{ fontSize: '32px', fontWeight: 700, margin: '8px 0 4px 0', color: '#fff' }}>48</h3>
                <span style={{ fontSize: '12px', color: 'var(--text-muted)' }}>42 Operational, 6 Breakdown</span>
              </div>
              <div style={{ background: 'var(--card-bg)', border: '1px solid var(--border-color)', borderRadius: '12px', padding: '24px' }}>
                <span style={{ fontSize: '13px', color: 'var(--text-secondary)', fontWeight: 500 }}>PENDING DAILY LOGS</span>
                <h3 style={{ fontSize: '32px', fontWeight: 700, margin: '8px 0 4px 0', color: 'var(--warning-color)' }}>7</h3>
                <span style={{ fontSize: '12px', color: 'var(--text-secondary)' }}>Requires review</span>
              </div>
            </div>

            {/* Quick Actions / Activity Feed */}
            <div style={{ display: 'grid', gridTemplateColumns: '2fr 1fr', gap: '24px' }}>
              <div style={{ background: 'var(--card-bg)', border: '1px solid var(--border-color)', borderRadius: '12px', padding: '24px' }}>
                <h3 style={{ fontSize: '18px', fontWeight: 600, marginBottom: '16px' }}>Performance Overview</h3>
                <div style={{ height: '200px', display: 'flex', alignItems: 'center', justifyContent: 'center', border: '1px dashed var(--border-color)', borderRadius: '8px', color: 'var(--text-muted)' }}>
                  Interactive Fleet Analytics Panel
                </div>
              </div>
              <div style={{ background: 'var(--card-bg)', border: '1px solid var(--border-color)', borderRadius: '12px', padding: '24px' }}>
                <h3 style={{ fontSize: '18px', fontWeight: 600, marginBottom: '16px' }}>System Status</h3>
                <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '13px' }}>
                    <span style={{ color: 'var(--text-secondary)' }}>Database connection</span>
                    <span style={{ color: 'var(--success-color)', fontWeight: 600 }}>ONLINE</span>
                  </div>
                  <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '13px' }}>
                    <span style={{ color: 'var(--text-secondary)' }}>Logsheet API</span>
                    <span style={{ color: 'var(--success-color)', fontWeight: 600 }}>STABLE</span>
                  </div>
                  <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '13px' }}>
                    <span style={{ color: 'var(--text-secondary)' }}>Active User Role</span>
                    <span style={{ color: 'var(--primary-color)', fontWeight: 600 }}>{currentUser.role}</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        );
    }
  };

  return (
    <div className={`grid-wrapper sidebar-bg bg1 ${isSidebarCollapsed ? 'collapsed sidebar-collapsed' : ''}`} style={{ position: 'relative' }}>
      {/* Sidebar toggle edge button */}
      <button 
        className="sidebar-toggle-edge"
        onClick={() => setIsSidebarCollapsed(!isSidebarCollapsed)}
        style={{
          position: 'absolute',
          top: '75px',
          left: isSidebarCollapsed ? '38px' : '228px',
          width: '24px',
          height: '24px',
          background: 'var(--primary-color)',
          border: 'none',
          borderRadius: '4px',
          color: '#fff',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          cursor: 'pointer',
          zIndex: 100,
          boxShadow: '0 2px 8px rgba(0,0,0,0.15)',
          transition: 'left 0.3s cubic-bezier(0.4, 0, 0.2, 1)'
        }}
      >
        {isSidebarCollapsed ? <ChevronRight size={14} /> : <ChevronRight size={14} style={{ transform: 'rotate(180deg)' }} />}
      </button>
      {/* Header bar */}
      <div className="header" style={{ position: 'sticky', top: 0, zIndex: 10 }}>
        <div className="header-bar">
          <div className="brand">
            <a href="#" className="logo" onClick={(e) => { e.preventDefault(); setActiveTab("Dashboard"); setSidebarOpen(false); }} style={{ display: isSidebarCollapsed ? 'none' : 'inline-block' }}>
              <span className="text-carolina">SIQ</span>THEME
            </a>
            <a href="#" className="logo-sm text-carolina" onClick={(e) => { e.preventDefault(); setActiveTab("Dashboard"); setSidebarOpen(false); }} style={{ display: isSidebarCollapsed ? 'inline-block' : 'none' }}>
              SIQ
            </a>
          </div>

          <div className="btn-toggle">
            <a href="#" className="toggle-sidebar-btn" onClick={(e) => { e.preventDefault(); setIsSidebarCollapsed(!isSidebarCollapsed); }}>
              <i className="ti-menu"></i>
            </a>
            <a href="#" className="slide-sidebar-btn" onClick={(e) => { e.preventDefault(); setSidebarOpen(!sidebarOpen); }}>
              <i className="ti-menu"></i>
            </a>
          </div>

          <div className="navigation d-flex" style={{ flex: 1, alignItems: 'center', justifyContent: 'space-between', paddingLeft: '24px', paddingRight: '20px', height: '50px' }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: '8px', color: '#9ca3af', fontSize: '14px' }}>
              <UserCheck size={18} />
              <span style={{ fontWeight: 500 }}>Simulate Role:</span>
              <select
                value={currentUser.id}
                onChange={(e) => {
                  const user = USERS.find(u => u.id === parseInt(e.target.value));
                  if (user) setCurrentUser(user);
                }}
                style={{
                  background: 'rgba(255, 255, 255, 0.05)',
                  border: '1px solid var(--border-color)',
                  color: '#fff',
                  borderRadius: '6px',
                  padding: '4px 10px',
                  fontSize: '13px',
                  fontWeight: 500,
                  outline: 'none',
                  cursor: 'pointer'
                }}
              >
                {USERS.map(u => (
                  <option key={u.id} value={u.id} style={{ background: '#131824' }}>
                    {u.name} ({u.role})
                  </option>
                ))}
              </select>
            </div>

            {/* Template Header Search */}
            <form className="navbar-search" onSubmit={(e) => e.preventDefault()} style={{ margin: '0 16px 0 auto', maxWidth: '240px' }}>
              <div className="input-group">
                <div className="input-group-prepend">
                  <div className="input-group-text"><i className="ti-search"></i></div>
                </div>
                <input
                  type="text"
                  placeholder="Search for keywords"
                  className="form-control"
                  name="top-search"
                  id="top-search"
                />
              </div>
            </form>

            <div className="navbar-menu d-flex" style={{ alignItems: 'center', gap: '0px', height: '50px' }}>
              {/* Dark/Light mode toggle */}
              <div className="menu-item">
                <a href="#" className="btn" onClick={(e) => { e.preventDefault(); setIsDarkMode(!isDarkMode); }} title="Toggle Dark/Light Mode" style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', height: '50px', width: '50px' }}>
                  {isDarkMode ? <Sun size={18} style={{ color: '#f59e0b' }} /> : <Moon size={18} style={{ color: '#9ca3af' }} />}
                </a>
              </div>

              <div className="menu-item">
                <a href="#" className="btn" onClick={(e) => e.preventDefault()} style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', height: '50px', width: '50px' }}>
                  <i className="ti-bell"></i>
                  <span className="badge badge-pill badge-danger" style={{ top: '8px', right: '8px' }}>3</span>
                </a>
              </div>
              <div className="menu-item">
                <a href="#" className="btn" onClick={(e) => e.preventDefault()} style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', height: '50px', width: '50px' }}>
                  <i className="ti-email"></i>
                  <span className="badge badge-pill badge-success" style={{ top: '8px', right: '8px' }}>7</span>
                </a>
              </div>
              <div className="menu-item user-profile-item d-flex align-items-center" style={{ padding: '0 20px', height: '50px', borderLeft: '1px solid var(--border-color)' }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                  <div style={{ width: '32px', height: '32px', borderRadius: '50%', background: 'var(--primary-color)', display: 'flex', alignItems: 'center', justifyContent: 'center', fontWeight: 600, color: '#fff', fontSize: '13px' }}>
                    {currentUser.name[0]}
                  </div>
                  <div style={{ textAlign: 'left', lineHeight: 1.1, whiteSpace: 'nowrap' }}>
                    <div style={{ fontSize: '13px', fontWeight: 600, color: '#fff' }}>{currentUser.name}</div>
                    <small style={{ fontSize: '11px', color: 'var(--text-secondary)' }}>{currentUser.role}</small>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Left Sidebar */}
      <div id="sidebar" className={`sidebar ${sidebarOpen ? "open" : ""}`}>
        <div className="sidebar-content">
          <div className="sidebar-menu">
            <ul>
              <li className={activeTab === "Dashboard" ? "active" : ""}>
                <a href="#" onClick={(e) => { e.preventDefault(); setActiveTab("Dashboard"); setSidebarOpen(false); }}>
                  <i className="ti-dashboard"></i>
                  <span className="menu-text">Dashboard</span>
                </a>
              </li>

              {/* Dynamic navigation links */}
              {sidebarItems.map(item => {
                const viewName = item.viewName || item.menuName;
                if (viewName === "Dashboard") return null;

                let iconClass = item.iconClass || "ti-folder";
                if (iconClass === "FolderClosed" || iconClass === "Folder") iconClass = "ti-folder";
                else if (iconClass === "FileText" || iconClass === "File") iconClass = "ti-files";
                else if (iconClass === "Fuel") iconClass = "ti-bolt";
                else if (iconClass === "Truck") iconClass = "ti-truck";
                else if (iconClass === "CalendarCheck") iconClass = "ti-calendar";
                else if (iconClass === "ShieldAlert") iconClass = "ti-shield";

                return (
                  <li key={item.id} className={activeTab === viewName ? "active" : ""}>
                    <a href="#" onClick={(e) => { e.preventDefault(); setActiveTab(viewName); setSidebarOpen(false); }}>
                      <i className={iconClass}></i>
                      <span className="menu-text">{item.menuName}</span>
                    </a>
                  </li>
                );
              })}

              {/* Admin configuration views */}
              {currentUser.roleId === 1 && (
                <>
                  <li className="header-menu">
                    <span>ADMIN SETTINGS</span>
                  </li>
                  <li className={activeTab === "MenuManagement" ? "active" : ""}>
                    <a href="#" onClick={(e) => { e.preventDefault(); setActiveTab("MenuManagement"); setSidebarOpen(false); }}>
                      <i className="ti-settings"></i>
                      <span className="menu-text">Menu Manager</span>
                    </a>
                  </li>
                  <li className={activeTab === "AssetSpecs" ? "active" : ""}>
                    <a href="#" onClick={(e) => { e.preventDefault(); setActiveTab("AssetSpecs"); setSidebarOpen(false); }}>
                      <i className="ti-layout-grid2"></i>
                      <span className="menu-text">Asset Specs</span>
                    </a>
                  </li>
                  <li className={activeTab === "RoleMapping" ? "active" : ""}>
                    <a href="#" onClick={(e) => { e.preventDefault(); setActiveTab("RoleMapping"); setSidebarOpen(false); }}>
                      <i className="ti-lock"></i>
                      <span className="menu-text">Role Mapping (Test)</span>
                    </a>
                  </li>
                </>
              )}
            </ul>
          </div>
        </div>
      </div>

      {/* Main Content Area */}
      <div className="main" style={{ padding: '20px', overflowY: 'auto' }} onClick={() => setSidebarOpen(false)}>
        {renderActiveContent()}
      </div>
    </div>
  );
}
