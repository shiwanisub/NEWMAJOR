import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Camera, ArrowRight, Sparkles, Shield, Users } from 'lucide-react';
import LoginPage from './LoginPage';
import SignupPage from './SignupPage';

const AuthPage = () => {
  const [authMode, setAuthMode] = useState<'choice' | 'login' | 'signup'>('choice');
  const navigate = useNavigate();

  const handleModeSelect = (mode: 'login' | 'signup') => {
    setAuthMode(mode);
  };

  const handleBackToChoice = () => {
    setAuthMode('choice');
  };

  if (authMode === 'login') {
    return <LoginPage />;
  }

  if (authMode === 'signup') {
    return <SignupPage />;
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 via-white to-blue-50">
      <div className="flex min-h-screen">
        {/* Left Side - Auth Options */}
        <div className="flex-1 flex items-center justify-center px-4 sm:px-6 lg:px-8">
          <div className="max-w-md w-full space-y-8">
            <div className="text-center">
              <div className="flex justify-center mb-6">
                <div className="w-16 h-16 bg-gradient-to-br from-blue-600 to-purple-600 rounded-2xl flex items-center justify-center">
                  <Camera className="w-8 h-8 text-white" />
                </div>
              </div>
              <h2 className="text-3xl font-bold text-slate-900 mb-2">
                Welcome to Swornim
              </h2>
              <p className="text-slate-600 mb-8">
                Nepal's premier event management platform
              </p>
            </div>

            <div className="space-y-4">
              <button
                onClick={() => handleModeSelect('signup')}
                className="group relative w-full px-6 py-4 bg-gradient-to-r from-blue-600 to-purple-600 text-white rounded-xl shadow-lg hover:shadow-xl transition-all duration-300 hover:scale-105 overflow-hidden"
              >
                <span className="relative z-10 flex items-center justify-center space-x-3 text-lg font-semibold">
                  <span>Create Account</span>
                  <ArrowRight className="w-5 h-5 group-hover:translate-x-1 transition-transform" />
                </span>
                <div className="absolute inset-0 bg-gradient-to-r from-blue-700 to-purple-700 opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
              </button>

              <button
                onClick={() => handleModeSelect('login')}
                className="w-full px-6 py-4 bg-white border-2 border-slate-200 text-slate-700 rounded-xl hover:bg-slate-50 hover:border-slate-300 transition-all duration-300 font-semibold"
              >
                Sign In
              </button>
            </div>

            <div className="text-center">
              <button
                onClick={() => navigate('/welcome')}
                className="text-slate-500 hover:text-slate-700 transition-colors text-sm"
              >
                ← Back to Home
              </button>
            </div>

            <div className="mt-8 p-6 bg-blue-50 rounded-xl">
              <div className="flex items-center space-x-3 mb-4">
                <Sparkles className="w-5 h-5 text-blue-600" />
                <h3 className="font-semibold text-slate-900">Why Choose Swornim?</h3>
              </div>
              <div className="space-y-3 text-sm text-slate-600">
                <div className="flex items-center space-x-2">
                  <Shield className="w-4 h-4 text-green-500" />
                  <span>Verified professionals</span>
                </div>
                <div className="flex items-center space-x-2">
                  <Users className="w-4 h-4 text-blue-500" />
                  <span>2,500+ happy clients</span>
                </div>
                <div className="flex items-center space-x-2">
                  <Camera className="w-4 h-4 text-purple-500" />
                  <span>5,000+ successful events</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Right Side - Image/Info */}
        <div className="hidden lg:flex flex-1 bg-gradient-to-br from-blue-600 to-purple-600 relative overflow-hidden">
          <div className="absolute inset-0 bg-black/20" />
          <div className="relative z-10 flex items-center justify-center p-12">
            <div className="text-center text-white max-w-lg">
              <h1 className="text-4xl font-bold mb-6">
                Your Perfect Event Starts Here
              </h1>
              <p className="text-xl text-blue-100 mb-8 leading-relaxed">
                Connect with Nepal's finest photographers, venues, and event professionals. 
                Transform your special moments into unforgettable memories.
              </p>
              <div className="grid grid-cols-2 gap-6">
                <div className="text-center">
                  <div className="text-3xl font-bold mb-2">2,500+</div>
                  <div className="text-blue-100">Happy Clients</div>
                </div>
                <div className="text-center">
                  <div className="text-3xl font-bold mb-2">5,000+</div>
                  <div className="text-blue-100">Events Completed</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default AuthPage; 