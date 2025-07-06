import api from './api';

export const authService = {
  // Login user
  login: async (credentials) => {
    try {
      const response = await api.post('/auth/login', credentials);
      const { user, tokens } = response.data.data;
      
      // Store token and user data
      localStorage.setItem('swornim_token', tokens.accessToken);
      localStorage.setItem('swornim_user', JSON.stringify(user));
      
      return { token: tokens.accessToken, user };
    } catch (error) {
      const errorMessage = error.response?.data?.message || 'Login failed';
      throw new Error(errorMessage);
    }
  },

  // Register user
  signup: async (userData) => {
    try {
      // Transform frontend data to match backend expectations
      const backendData = {
        name: `${userData.firstName} ${userData.lastName}`.trim(),
        email: userData.email,
        phone: userData.phone,
        password: userData.password,
        confirmPassword: userData.confirmPassword,
        userType: userData.role // Map role to userType
      };

      const response = await api.post('/auth/register', backendData);
      
      // Registration successful but user needs to verify email
      return { 
        success: true, 
        message: response.data.message,
        email: userData.email
      };
    } catch (error) {
      const errorMessage = error.response?.data?.message || 'Registration failed';
      throw new Error(errorMessage);
    }
  },

  // Verify email
  verifyEmail: async (token) => {
    try {
      const response = await api.post('/auth/verify-email', { token });
      return response.data;
    } catch (error) {
      const errorMessage = error.response?.data?.message || 'Email verification failed';
      throw new Error(errorMessage);
    }
  },

  // Resend verification email
  resendVerification: async (email) => {
    try {
      const response = await api.post('/auth/resend-verification', { email });
      return response.data;
    } catch (error) {
      const errorMessage = error.response?.data?.message || 'Failed to resend verification email';
      throw new Error(errorMessage);
    }
  },

  // Logout user
  logout: async () => {
    try {
      const token = localStorage.getItem('swornim_token');
      if (token) {
        await api.post('/auth/logout');
      }
    } catch (error) {
      console.error('Logout error:', error);
    } finally {
      localStorage.removeItem('swornim_token');
      localStorage.removeItem('swornim_user');
    }
  },

  // Get current user
  getCurrentUser: () => {
    const token = localStorage.getItem('swornim_token');
    const userData = localStorage.getItem('swornim_user');
    
    if (token && userData) {
      try {
        return {
          token,
          user: JSON.parse(userData)
        };
      } catch (error) {
        console.error('Error parsing user data:', error);
        localStorage.removeItem('swornim_token');
        localStorage.removeItem('swornim_user');
      }
    }
    return null;
  },

  // Verify token
  verifyToken: async () => {
    try {
      const response = await api.get('/auth/profile');
      return response.data.data;
    } catch (error) {
      throw new Error('Token verification failed');
    }
  },

  // Forgot password
  forgotPassword: async (email) => {
    try {
      const response = await api.post('/auth/forgot-password', { email });
      return response.data;
    } catch (error) {
      const errorMessage = error.response?.data?.message || 'Failed to send reset email';
      throw new Error(errorMessage);
    }
  },

  // Reset password
  resetPassword: async (token, password, confirmPassword) => {
    try {
      const response = await api.post('/auth/reset-password', {
        token,
        password,
        confirmPassword
      });
      return response.data;
    } catch (error) {
      const errorMessage = error.response?.data?.message || 'Password reset failed';
      throw new Error(errorMessage);
    }
  }
};