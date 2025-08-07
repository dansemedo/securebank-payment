import React from 'react';
import { NavMenu } from './NavMenu';

export function Layout({ children }) {
  return (
    <div>
      <NavMenu />
      <div className="container">
        {children}
      </div>
    </div>
  );
}

Layout.displayName = Layout.name;
