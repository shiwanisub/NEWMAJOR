import React, { useState, useEffect } from 'react';
import { useNavigate, useSearchParams, Link } from 'react-router-dom';
import { CheckCircle, AlertCircle, Mail, ArrowLeft } from 'lucide-react';
import { useAuth } from '../../context/AuthContext';

const EmailVerificationPage = () => {
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const { verifyEmail, resendVerification, loading } = useAuth();
  
  const [verificationStatus, setVerificationStatus] = useState<'pending' | 'success' | 'error'>('pending');
  const [message, setMessage] = useState('');
  const [email, setEmail] = useState('');
  const [resendLoading, setResendLoading] = useState(false);

  useEffect(() => {
    const token = searchParams.get('token');
    const emailParam = searchParams.get('email');
    
    if (emailParam) {
      setEmail(emailParam);
    }

    if (token) {
      handleVerification(token);
    }
  }, [searchParams]);

  const handleVerification = async (token: string) => {
    try {
      await verifyEmail(token);
      setVerificationStatus('success');
      setMessage('Email verified successfully! You can now log in to your account.');
    } catch (error: any) {
      setVerificationStatus('error');
      setMessage(error.message || 'Email verification failed. Please try again.');
    }
  };

  const handleResendVerification = async () => {
    if (!email) {
      setMessage('Please enter your email address to resend verification.');
      return;
    }

    try {
      setResendLoading(true);
      await resendVerification(email);
      setMessage('Verification email sent successfully! Please check your inbox.');
    } catch (error: any) {
      setMessage(error.message || 'Failed to resend verification email.');
    } finally {
      setResendLoading(false);
    }
  };

  const getStatusIcon = () => {
    switch (verificationStatus) {
      case 'success':
        return <CheckCircle className="w-16 h-16 text-green-500" />;
      case 'error':
        return <AlertCircle className="w-16 h-16 text-red-500" />;
      default:
        return <Mail className="w-16 h-16 text-blue-500" />;
    }
  };

  const getStatusTitle = () => {
    switch (verificationStatus) {
      case 'success':
        return 'Email Verified!';
      case 'error':
        return 'Verification Failed';
      default:
        return 'Email Verification';
    }
  };

  const getStatusDescription = () => {
    switch (verificationStatus) {
      case 'success':
        return 'Your email has been verified successfully. You can now log in to your account.';
      case 'error':
        return 'There was an issue verifying your email. Please try again or contact support.';
      default:
        return 'Please check your email and click the verification link to activate your account.';
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 to-blue-50 flex items-center justify-center p-4">
      <div className="w-full max-w-md">
        {/* Back Button */}
        <button
          onClick={() => navigate('/login')}
          className="flex items-center space-x-2 text-slate-600 hover:text-slate-800 mb-8 transition-colors"
        >
          <ArrowLeft className="w-4 h-4" />
          <span className="body-medium">Back to Login</span>
        </button>

        {/* Verification Card */}
        <div className="card p-8 text-center">
          {/* Status Icon */}
          <div className="flex justify-center mb-6">
            {getStatusIcon()}
          </div>

          {/* Title */}
          <h1 className="headline-large mb-4">{getStatusTitle()}</h1>

          {/* Description */}
          <p className="body-medium text-slate-600 mb-6">
            {getStatusDescription()}
          </p>

          {/* Message */}
          {message && (
            <div className={`mb-6 p-4 rounded-lg ${
              verificationStatus === 'success' 
                ? 'bg-green-50 border border-green-200 text-green-700'
                : verificationStatus === 'error'
                ? 'bg-red-50 border border-red-200 text-red-700'
                : 'bg-blue-50 border border-blue-200 text-blue-700'
            }`}>
              {message}
            </div>
          )}

          {/* Actions */}
          <div className="space-y-4">
            {verificationStatus === 'success' && (
              <Link
                to="/login"
                className="btn btn-primary w-full"
              >
                Go to Login
              </Link>
            )}

            {verificationStatus === 'error' && (
              <div className="space-y-4">
                <button
                  onClick={() => window.location.reload()}
                  className="btn btn-secondary w-full"
                >
                  Try Again
                </button>
                
                <div className="border-t pt-4">
                  <p className="body-small text-slate-600 mb-4">
                    Didn't receive the verification email?
                  </p>
                  
                  <div className="space-y-3">
                    <input
                      type="email"
                      value={email}
                      onChange={(e) => setEmail(e.target.value)}
                      placeholder="Enter your email"
                      className="input w-full"
                    />
                    
                    <button
                      onClick={handleResendVerification}
                      disabled={resendLoading}
                      className="btn btn-outline w-full"
                    >
                      {resendLoading ? 'Sending...' : 'Resend Verification Email'}
                    </button>
                  </div>
                </div>
              </div>
            )}

            {verificationStatus === 'pending' && (
              <div className="space-y-4">
                <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto"></div>
                <p className="body-small text-slate-600">
                  Verifying your email...
                </p>
              </div>
            )}
          </div>

          {/* Additional Help */}
          <div className="mt-8 pt-6 border-t border-slate-200">
            <p className="body-small text-slate-600">
              Need help?{' '}
              <Link to="/contact" className="text-blue-600 hover:text-blue-700 font-medium">
                Contact Support
              </Link>
            </p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default EmailVerificationPage; 