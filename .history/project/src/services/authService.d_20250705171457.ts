export interface AuthCredentials {
  email: string;
  password: string;
}

export interface UserData {
  username: string;
  email: string;
  password: string;
  confirmPassword: string;
  role: string;
  firstName?: string;
  lastName?: string;
  phone?: string;
}

export interface AuthResponse {
  token: string;
  user: any;
}

export interface SignupResponse {
  success: boolean;
  message: string;
  email: string;
}

export interface CurrentUser {
  token: string;
  user: any;
}

export const authService: {
  login: (credentials: AuthCredentials) => Promise<AuthResponse>;
  signup: (userData: UserData) => Promise<SignupResponse>;
  logout: () => Promise<void>;
  getCurrentUser: () => CurrentUser | null;
  verifyToken: () => Promise<any>;
  verifyEmail: (token: string) => Promise<any>;
  resendVerification: (email: string) => Promise<any>;
  forgotPassword: (email: string) => Promise<any>;
  resetPassword: (token: string, password: string, confirmPassword: string) => Promise<any>;
}; 