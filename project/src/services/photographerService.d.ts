export interface PhotographerUser {
  id: string;
  name: string;
  email: string;
  phone?: string;
  profileImage?: string;
  userType?: string;
}

export interface Photographer {
  id: string;
  businessName?: string;
  user?: PhotographerUser;
  profileImage?: string;
  rating?: number;
  totalReviews?: number;
  hourlyRate?: number;
  specializations?: string[];
  experience?: string;
}

export interface PhotographerSearchResult {
  photographers: Photographer[];
  totalCount: number;
  currentPage: number;
  totalPages: number;
  hasNextPage: boolean;
  hasPrevPage: boolean;
}

export const photographerService: {
  searchPhotographers: (params?: Record<string, any>) => Promise<PhotographerSearchResult>;
}; 