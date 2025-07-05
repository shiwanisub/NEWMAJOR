export interface AuthCredentials {
  email: string;
  password: string;
}

export interface UserData {
  username: string;
  email: string;
  password: string;
  role: string;
  firstName?: string;
  lastName?: string;
  phone?: string;
}

export interface AuthResponse {
  token: string;
  user: any;
}

export interface CurrentUser {
  token: string;
  user: any;
}

export const authService: {
  login: (credentials: AuthCredentials) => Promise<AuthResponse>;
  signup: (userData: UserData) => Promise<AuthResponse>;
  logout: () => void;
  getCurrentUser: () => CurrentUser | null;
  verifyToken: () => Promise<any>;
}; 