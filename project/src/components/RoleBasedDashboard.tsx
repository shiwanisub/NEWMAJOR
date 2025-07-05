import React from 'react';
import { useAuth } from '../context/AuthContext';
import ClientDashboard from '../pages/client/ClientDashboard';
import ServiceProviderDashboard from '../pages/service_provider/service_provider_dashboard';

const RoleBasedDashboard: React.FC = () => {
  const { user } = useAuth();

  if (!user) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-lg text-gray-600">Loading...</div>
      </div>
    );
  }

  // Map backend userType to frontend role
  const userRole = user.userType || user.role;
  
  switch (userRole) {
    case 'client':
      return <ClientDashboard />;
    case 'photographer':
    case 'makeupArtist':
    case 'decorator':
    case 'venue':
    case 'caterer':
      return <ServiceProviderDashboard />;
    default:
      // Fallback to client dashboard for unknown roles
      console.warn(`Unknown user role: ${userRole}, falling back to client dashboard`);
      return <ClientDashboard />;
  }
};

export default RoleBasedDashboard; 