import api from './api';

export const photographerService = {
  async searchPhotographers(params = {}) {
    // params can include search, page, limit, etc.
    const response = await api.get('/photographers/search', { params });
    return response.data.data;
  },
}; 