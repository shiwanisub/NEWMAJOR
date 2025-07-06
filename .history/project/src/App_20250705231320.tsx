import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import LoginPage from './pages/auth/LoginPage';
import SignupPage from './pages/auth/SignupPage';
import EmailVerificationPage from './pages/auth/EmailVerificationPage';
import AuthPage from './pages/auth/AuthPage';
import RoleBasedDashboard from './components/RoleBasedDashboard';
import ClientDashboard from './pages/client/ClientDashboard';
import ServiceProviderDashboard from './pages/service_provider/service_provider_dashboard';
import ProtectedRoute from './components/ProtectedRoute';
import WelcomeScreen from './pages/WelcomeScreen';
import { AuthProvider, useAuth } from './context/AuthContext';
import AboutUs from './pages/AboutUs';
import Contact from './pages/Contact';
import TermsAndPrivacy from './pages/TermsAndPrivacy';
import Navbar from './components/Navbar';

function AppRoutes() {
  const { user, loading } = useAuth();

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  if (!user) {
    return (
      <>
        <Navbar />
        <Routes>
          <Route path="/welcome" element={<WelcomeScreen />} />
          <Route path="/auth" element={<AuthPage />} />
          <Route path="/login" element={<LoginPage />} />
          <Route path="/signup" element={<SignupPage />} />
          <Route path="/verify-email" element={<EmailVerificationPage />} />
          <Route path="/about" element={<AboutUs />} />
          <Route path="/contact" element={<Contact />} />
          <Route path="/terms" element={<TermsAndPrivacy />} />
          <Route path="*" element={<Navigate to="/welcome" replace />} />
        </Routes>
      </>
    );
  }

  return (
    <>
      <Routes>
        {/* Main dashboard route - automatically shows correct dashboard based on role */}
        <Route 
          path="/dashboard" 
          element={
            <ProtectedRoute>
              <RoleBasedDashboard />
            </ProtectedRoute>
          } 
        />
        
        {/* Direct dashboard routes for testing (optional) */}
        <Route 
          path="/client-dashboard" 
          element={
            <ProtectedRoute allowedRoles={['client']}>
              <ClientDashboard />
            </ProtectedRoute>
          } 
        />
        <Route 
          path="/service-provider-dashboard" 
          element={
            <ProtectedRoute allowedRoles={['photographer', 'makeupArtist', 'decorator', 'venue', 'caterer']}>
              <ServiceProviderDashboard />
            </ProtectedRoute>
          } 
        />
        
        {/* Public routes */}
        <Route path="/about" element={<><Navbar /><AboutUs /></>} />
        <Route path="/contact" element={<><Navbar /><Contact /></>} />
        <Route path="/terms" element={<><Navbar /><TermsAndPrivacy /></>} />
        <Route path="*" element={<Navigate to="/dashboard" replace />} />
      </Routes>
    </>
  );
}

function App() {
  return (
    <AuthProvider>
      <Router>
        <div className="min-h-screen bg-gray-50">
          <AppRoutes />
        </div>
      </Router>
    </AuthProvider>
  );
}

export default App;