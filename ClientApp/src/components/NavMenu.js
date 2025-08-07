import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import './NavMenu.css';

export function NavMenu() {
  const [collapsed, setCollapsed] = useState(true);

  const toggleNavbar = () => {
    setCollapsed(!collapsed);
  };

  return (
    <header>
      <nav className="navbar navbar-expand-sm navbar-light bg-white border-bottom box-shadow mb-3">
        <div className="container">
          <Link className="navbar-brand" to="/">SecureBankPayment</Link>
          <button 
            className="navbar-toggler" 
            type="button" 
            onClick={toggleNavbar}
            aria-controls="navbarNav"
            aria-expanded={!collapsed}
            aria-label="Toggle navigation"
          >
            <span className="navbar-toggler-icon"></span>
          </button>
          <div className={`collapse navbar-collapse ${!collapsed ? 'show' : ''}`} id="navbarNav">
            <ul className="navbar-nav ms-auto">
              <li className="nav-item">
                <Link className="nav-link text-dark" to="/">Home</Link>
              </li>
              <li className="nav-item">
                <Link className="nav-link text-dark" to="/counter">Counter</Link>
              </li>
              <li className="nav-item">
                <Link className="nav-link text-dark" to="/fetch-data">Fetch data</Link>
              </li>
            </ul>
          </div>
        </div>
      </nav>
    </header>
  );
}

NavMenu.displayName = NavMenu.name;
