import React, { useState, useEffect } from 'react';
import { 
  Camera, Calendar, MapPin, Palette, User, Search, Bell, Menu, X,
  Heart, Star, Filter, Grid, List, Plus, ChevronRight, Award,
  Clock, CheckCircle, MessageSquare, Settings, LogOut, TrendingUp,
  Shield, Bookmark, Phone, Mail, Globe, ChevronDown, ArrowRight,
  Package, CreditCard, Activity, Users, Eye, Download, Share2
} from 'lucide-react';
import { useAuth } from '../../context/AuthContext';
import { useNavigate } from 'react-router-dom';
import { photographerService } from '../../services/photographerService';

const getFirstAndLastName = (name: string | undefined) => {
  if (!name) return { firstName: '', lastName: '' };
  const parts = name.split(' ');
  return {
    firstName: parts[0] || '',
    lastName: parts.slice(1).join(' ') || ''
  };
};

const ClientDashboard = () => {
  const { user, logout } = useAuth();
  const navigate = useNavigate();

  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [viewMode, setViewMode] = useState('grid');
  const [activeTab, setActiveTab] = useState('dashboard');
  const [selectedCategory, setSelectedCategory] = useState('all');
  const [searchQuery, setSearchQuery] = useState('');
  const [showFilters, setShowFilters] = useState(false);
  const [logoutModal, setLogoutModal] = useState(false);
  const [logoutError, setLogoutError] = useState('');
  const [loading, setLoading] = useState(false);
  const [photographers, setPhotographers] = useState<any[]>([]);
  const [photographersLoading, setPhotographersLoading] = useState(false);
  const [photographersError, setPhotographersError] = useState('');

  if (!user) {
    return <div className="flex min-h-screen items-center justify-center text-lg text-slate-500">Loading...</div>;
  }

  const { firstName, lastName } = getFirstAndLastName(user?.name);
  const profileImage = user?.profileImage || '/default-avatar.png';

  const categories = [
    { id: 'all', name: 'All Services', icon: <Grid className="w-5 h-5" />, count: 362 },
    { id: 'photographer', name: 'Photography', icon: <Camera className="w-5 h-5" />, count: 156 },
    { id: 'venue', name: 'Venues', icon: <MapPin className="w-5 h-5" />, count: 89 },
    { id: 'makeup', name: 'Makeup & Beauty', icon: <Palette className="w-5 h-5" />, count: 72 },
    { id: 'catering', name: 'Catering', icon: <Package className="w-5 h-5" />, count: 45 }
  ];

  const featuredServices = [
    {
      id: 1,
      name: "Royal Photography Studio",
      category: "Wedding Photography",
      rating: 4.9,
      reviews: 127,
      price: "Rs. 50,000",
      originalPrice: "Rs. 65,000",
      image: "https://images.unsplash.com/photo-1606216794074-735e91aa2c92?w=400&h=300&fit=crop",
      verified: true,
      featured: true,
      discount: 23,
      tags: ['Premium', 'Same Day Delivery'],
      photographer: 'Rajesh Kumar',
      experience: '8+ years'
    },
    {
      id: 2,
      name: "Himalayan Grand Venue",
      category: "Wedding Venue",
      rating: 4.8,
      reviews: 89,
      price: "Rs. 200,000",
      originalPrice: "Rs. 250,000",
      image: "https://images.unsplash.com/photo-1519167758481-83f550bb49b3?w=400&h=300&fit=crop",
      verified: true,
      featured: false,
      discount: 20,
      tags: ['Luxury', 'Garden View'],
      capacity: '500 guests',
      location: 'Kathmandu'
    },
    {
      id: 3,
      name: "Glam Beauty Studio",
      category: "Bridal Makeup",
      rating: 4.7,
      reviews: 156,
      price: "Rs. 15,000",
      originalPrice: "Rs. 20,000",
      image: "https://images.unsplash.com/photo-1487412947147-5cebf100ffc2?w=400&h=300&fit=crop",
      verified: true,
      featured: true,
      discount: 25,
      tags: ['Trending', 'Home Service'],
      artist: 'Sunita Thapa',
      speciality: 'Bridal Makeup'
    },
    {
      id: 4,
      name: "Everest Catering Services",
      category: "Premium Catering",
      rating: 4.6,
      reviews: 78,
      price: "Rs. 800/plate",
      originalPrice: "Rs. 1,000/plate",
      image: "https://images.unsplash.com/photo-1555244162-803834f70033?w=400&h=300&fit=crop",
      verified: true,
      featured: false,
      discount: 20,
      tags: ['Authentic', 'Multi-cuisine'],
      minOrder: '50 plates',
      chef: 'Ram Bahadur'
    }
  ];

  const upcomingBookings = [
    {
      id: 1,
      service: "Royal Photography Studio",
      date: "2024-01-15",
      time: "10:00 AM",
      status: "confirmed",
      amount: "Rs. 50,000",
      location: "Kathmandu",
      contact: "+977-9801234567"
    },
    {
      id: 2,
      service: "Himalayan Grand Venue",
      date: "2024-01-20",
      time: "6:00 PM",
      status: "pending",
      amount: "Rs. 200,000",
      location: "Bhaktapur",
      contact: "+977-9801234568"
    },
    {
      id: 3,
      service: "Glam Beauty Studio",
      date: "2024-01-25",
      time: "2:00 PM",
      status: "confirmed",
      amount: "Rs. 15,000",
      location: "Home Service",
      contact: "+977-9801234569"
    }
  ];

  const dashboardStats = [
    { label: 'Total Bookings', value: '12', change: '+2', trend: 'up', icon: Calendar },
    { label: 'Total Spent', value: 'Rs. 485K', change: '+15%', trend: 'up', icon: CreditCard },
    { label: 'Saved Services', value: '8', change: '+3', trend: 'up', icon: Heart },
    { label: 'Active Chats', value: '4', change: '-1', trend: 'down', icon: MessageSquare }
  ];

  const recentActivity = [
    { type: 'booking', message: 'Booking confirmed with Royal Photography Studio', time: '2 hours ago' },
    { type: 'message', message: 'New message from Himalayan Grand Venue', time: '4 hours ago' },
    { type: 'favorite', message: 'Added "Everest Catering" to favorites', time: '1 day ago' },
    { type: 'review', message: 'Review posted for Glam Beauty Studio', time: '2 days ago' }
  ];

  const navigationItems = [
    { id: 'dashboard', name: 'Dashboard', icon: <Activity className="w-5 h-5" /> },
    { id: 'browse', name: 'Browse Services', icon: <Search className="w-5 h-5" /> },
    { id: 'bookings', name: 'My Bookings', icon: <Calendar className="w-5 h-5" /> },
    { id: 'favorites', name: 'Favorites', icon: <Heart className="w-5 h-5" /> },
    { id: 'messages', name: 'Messages', icon: <MessageSquare className="w-5 h-5" /> },
    { id: 'profile', name: 'Profile', icon: <User className="w-5 h-5" /> }
  ];

  const favoriteServices = [
    { id: 1, name: "Royal Photography Studio", category: "Photography", rating: 4.9, price: "Rs. 50,000" },
    { id: 2, name: "Himalayan Grand Venue", category: "Venue", rating: 4.8, price: "Rs. 200,000" },
    { id: 3, name: "Glam Beauty Studio", category: "Makeup", rating: 4.7, price: "Rs. 15,000" },
    { id: 4, name: "Everest Catering Services", category: "Catering", rating: 4.6, price: "Rs. 800/plate" }
  ];

  const messages = [
    { id: 1, sender: "Royal Photography Studio", message: "Your booking is confirmed for Jan 15th", time: "2 hours ago", unread: true },
    { id: 2, sender: "Himalayan Grand Venue", message: "Thank you for your interest. We'd love to discuss...", time: "4 hours ago", unread: true },
    { id: 3, sender: "Glam Beauty Studio", message: "Your makeup trial is scheduled for tomorrow", time: "1 day ago", unread: false },
    { id: 4, sender: "Support Team", message: "How was your experience with our service?", time: "2 days ago", unread: false }
  ];

  const DashboardTab = () => (
    <div className="space-y-6">
      <div className="bg-gradient-to-r from-blue-600 to-purple-600 rounded-xl p-6 text-white">
        <div className="flex items-center justify-between">
          <div>
            <h2 className="text-2xl font-bold mb-2">Welcome back, {firstName}! </h2>
            <p className="text-blue-100">Ready to plan your perfect event?</p>
          </div>
          <div className="hidden md:block">
            <Calendar className="w-16 h-16 text-blue-200" />
          </div>
        </div>
      </div>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        {dashboardStats.map((stat, index) => {
          const Icon = stat.icon;
          return (
            <div key={index} className="bg-white rounded-lg shadow-sm p-6 hover:shadow-lg transition-shadow">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-slate-500 mb-1">{stat.label}</p>
                  <p className="text-lg font-bold text-slate-800">{stat.value}</p>
                </div>
                <div className="p-3 bg-blue-50 rounded-lg">
                  <Icon className="w-6 h-6 text-blue-600" />
                </div>
              </div>
              <div className="flex items-center mt-4">
                <TrendingUp className={`w-4 h-4 mr-1 ${stat.trend === 'up' ? 'text-green-500' : 'text-red-500'}`} />
                <span className={`text-sm font-medium ${stat.trend === 'up' ? 'text-green-600' : 'text-red-600'}`}>{stat.change}</span>
                <span className="text-slate-500 text-sm ml-1">from last month</span>
              </div>
            </div>
          );
        })}
      </div>
      <div className="grid md:grid-cols-2 gap-6">
        <div className="bg-white rounded-lg shadow-sm p-6">
          <h3 className="text-lg font-semibold mb-4 text-slate-800">Quick Actions</h3>
          <div className="space-y-3">
            <button className="w-full flex items-center justify-between p-3 bg-blue-50 rounded-lg hover:bg-blue-100 transition-colors">
              <div className="flex items-center space-x-3">
                <Plus className="w-5 h-5 text-blue-600" />
                <span className="font-medium text-slate-800">New Booking</span>
              </div>
              <ArrowRight className="w-4 h-4 text-blue-600" />
            </button>
            <button className="w-full flex items-center justify-between p-3 bg-purple-50 rounded-lg hover:bg-purple-100 transition-colors">
              <div className="flex items-center space-x-3">
                <Search className="w-5 h-5 text-purple-600" />
                <span className="font-medium text-slate-800">Browse Services</span>
              </div>
              <ArrowRight className="w-4 h-4 text-purple-600" />
            </button>
            <button className="w-full flex items-center justify-between p-3 bg-green-50 rounded-lg hover:bg-green-100 transition-colors">
              <div className="flex items-center space-x-3">
                <MessageSquare className="w-5 h-5 text-green-600" />
                <span className="font-medium text-slate-800">Contact Support</span>
              </div>
              <ArrowRight className="w-4 h-4 text-green-600" />
            </button>
          </div>
        </div>
        <div className="bg-white rounded-lg shadow-sm p-6">
          <h3 className="text-lg font-semibold mb-4 text-slate-800">Recent Activity</h3>
          <div className="space-y-4">
            {recentActivity.map((activity, index) => (
              <div key={index} className="flex items-start space-x-3">
                <div className="w-2 h-2 bg-blue-600 rounded-full mt-2 flex-shrink-0"></div>
                <div>
                  <p className="text-sm text-slate-700">{activity.message}</p>
                  <p className="text-sm text-slate-500">{activity.time}</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
      <div className="bg-white rounded-lg shadow-sm p-6">
        <div className="flex items-center justify-between mb-4">
          <h3 className="text-lg font-semibold text-slate-800">Upcoming Bookings</h3>
          <button className="text-blue-600">View All</button>
        </div>
        <div className="space-y-4">
          {upcomingBookings.slice(0, 2).map((booking) => (
            <div key={booking.id} className="flex items-center justify-between p-4 bg-slate-50 rounded-lg">
              <div className="flex items-center space-x-4">
                <div className={`w-4 h-4 rounded-full ${booking.status === 'confirmed' ? 'bg-green-500' : 'bg-yellow-500'}`} />
                <div>
                  <div className="font-medium text-slate-800">{booking.service}</div>
                  <div className="text-sm text-slate-600">{booking.date} at {booking.time}</div>
                </div>
              </div>
              <div className="text-right">
                <div className="font-semibold text-slate-800">{booking.amount}</div>
                <span className={`px-3 py-1 rounded-full text-xs font-medium ${booking.status === 'confirmed' ? 'bg-green-100 text-green-800' : 'bg-yellow-100 text-yellow-800'}`}>{booking.status}</span>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );

  const BrowseTab = () => (
    <div className="space-y-6">
      <div className="bg-white rounded-lg shadow-sm p-6">
        <div className="flex flex-col lg:flex-row gap-4">
          <div className="flex-1 relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-slate-400" />
            <input
              type="text"
              placeholder="Search photographers, venues, makeup artists..."
              className="pl-10 pr-4 py-2 border border-slate-300 rounded-lg w-full"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
            />
          </div>
          <div className="flex items-center space-x-4">
            <button onClick={() => setShowFilters(!showFilters)} className="flex items-center space-x-2 px-4 py-2 border border-slate-300 rounded-lg">
              <Filter className="w-4 h-4" />
              <span>Filters</span>
              <ChevronDown className={`w-4 h-4 transition-transform ${showFilters ? 'rotate-180' : ''}`} />
            </button>
            <div className="flex items-center space-x-2">
              <button onClick={() => setViewMode('grid')} className={`p-2 rounded-lg ${viewMode === 'grid' ? 'bg-blue-100 text-blue-600' : 'text-slate-500 hover:bg-slate-100'}`}>
                <Grid className="w-4 h-4" />
              </button>
              <button onClick={() => setViewMode('list')} className={`p-2 rounded-lg ${viewMode === 'list' ? 'bg-blue-100 text-blue-600' : 'text-slate-500 hover:bg-slate-100'}`}>
                <List className="w-4 h-4" />
              </button>
            </div>
          </div>
        </div>
        {showFilters && (
          <div className="mt-6 p-4 bg-slate-50 rounded-lg">
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-2">Price Range</label>
                <select className="w-full p-2 border border-slate-300 rounded-lg">
                  <option>All Prices</option>
                  <option>Under Rs. 25,000</option>
                  <option>Rs. 25,000 - Rs. 50,000</option>
                  <option>Rs. 50,000 - Rs. 100,000</option>
                  <option>Above Rs. 100,000</option>
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-2">Rating</label>
                <select className="w-full p-2 border border-slate-300 rounded-lg">
                  <option>All Ratings</option>
                  <option>4.5+ Stars</option>
                  <option>4.0+ Stars</option>
                  <option>3.5+ Stars</option>
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-2">Location</label>
                <select className="w-full p-2 border border-slate-300 rounded-lg">
                  <option>All Locations</option>
                  <option>Kathmandu</option>
                  <option>Lalitpur</option>
                  <option>Bhaktapur</option>
                </select>
              </div>
            </div>
          </div>
        )}
      </div>
      <div className="grid grid-cols-2 lg:grid-cols-5 gap-4">
        {categories.map((category) => (
          <button
            key={category.id}
            onClick={() => setSelectedCategory(category.id)}
            className={`bg-white rounded-lg shadow-sm p-4 text-center hover:shadow-md transition-all duration-200 ${selectedCategory === category.id ? 'ring-2 ring-blue-500 bg-blue-50' : ''}`}
          >
            <div className={`flex justify-center mb-2 ${selectedCategory === category.id ? 'text-blue-600' : 'text-slate-600'}`}>{category.icon}</div>
            <div className="font-medium mb-1">{category.name}</div>
            <div className="text-sm text-slate-500">{category.count} available</div>
          </button>
        ))}
      </div>
      <div>
        <div className="flex items-center justify-between mb-6">
          <h2 className="text-lg font-semibold text-slate-800">
            {selectedCategory === 'photographer' ? 'Photographers' : 'Featured Services'}
          </h2>
          <button className="text-blue-600 flex items-center space-x-1">
            <span>View All</span>
            <ChevronRight className="w-4 h-4" />
          </button>
        </div>
        {selectedCategory === 'photographer' ? (
          photographersLoading ? (
            <div className="flex justify-center items-center py-12">
              <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
            </div>
          ) : photographersError ? (
            <div className="text-center text-red-500 py-8">{photographersError}</div>
          ) : photographers.length === 0 ? (
            <div className="text-center text-slate-500 py-8">No photographers found.</div>
          ) : (
            <div className={`grid gap-6 ${viewMode === 'grid' ? 'md:grid-cols-2 lg:grid-cols-3' : 'grid-cols-1'}`}> 
              {photographers.map((photographer: any) => (
                <ServiceCard
                  key={photographer.id}
                  service={{
                    id: photographer.id,
                    name: photographer.businessName || photographer.user?.name,
                    category: 'Photography',
                    rating: photographer.rating,
                    reviews: photographer.totalReviews,
                    price: photographer.hourlyRate ? `Rs. ${photographer.hourlyRate}` : undefined,
                    image: photographer.profileImage || photographer.user?.profileImage || '/default-avatar.png',
                    verified: photographer.user?.userType === 'photographer',
                    tags: photographer.specializations,
                    photographer: photographer.user?.name,
                    experience: photographer.experience,
                  }}
                />
              ))}
            </div>
          )
        ) : (
          <div className={`grid gap-6 ${viewMode === 'grid' ? 'md:grid-cols-2 lg:grid-cols-3' : 'grid-cols-1'}`}>
            {featuredServices.map((service) => (
              <ServiceCard key={service.id} service={service} />
            ))}
          </div>
        )}
      </div>
    </div>
  );

  const BookingsTab = () => (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h2 className="text-2xl font-bold text-slate-800">My Bookings</h2>
        <button className="bg-gradient-to-r from-blue-600 to-purple-600 text-white px-4 py-2 rounded-lg flex items-center space-x-2 hover:shadow-md transition-shadow">
          <Plus className="w-4 h-4" />
          <span>New Booking</span>
        </button>
      </div>

      {/* Booking Status Filter */}
      <div className="flex flex-wrap gap-2">
        {['All', 'Confirmed', 'Pending', 'Completed', 'Cancelled'].map((status) => (
          <button
            key={status}
            className={`px-4 py-2 rounded-full text-sm font-medium transition-colors ${
              status === 'All' 
                ? 'bg-blue-600 text-white' 
                : 'bg-slate-100 text-slate-700 hover:bg-slate-200'
            }`}
          >
            {status}
          </button>
        ))}
      </div>

      <div className="grid gap-6">
        {upcomingBookings.map((booking) => (
          <div key={booking.id} className="bg-white rounded-lg shadow-sm border border-slate-200 p-6 hover:shadow-lg transition-shadow">
            <div className="flex items-start justify-between">
              <div className="flex items-start space-x-4">
                <div className={`w-4 h-4 rounded-full mt-1 ${
                  booking.status === 'confirmed' ? 'bg-green-500' : 'bg-yellow-500'
                }`} />
                <div>
                  <div className="text-lg font-semibold text-slate-800 mb-2">{booking.service}</div>
                  <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
                    <div className="flex items-center space-x-2">
                      <Clock className="w-4 h-4 text-slate-500" />
                      <span className="text-slate-600">{booking.date} at {booking.time}</span>
                    </div>
                    <div className="flex items-center space-x-2">
                      <MapPin className="w-4 h-4 text-slate-500" />
                      <span className="text-slate-600">{booking.location}</span>
                    </div>
                    <div className="flex items-center space-x-2">
                      <Phone className="w-4 h-4 text-slate-500" />
                      <span className="text-slate-600">{booking.contact}</span>
                    </div>
                  </div>
                </div>
              </div>
              <div className="text-right">
                <div className="text-lg font-bold text-slate-800 mb-2">{booking.amount}</div>
                <span className={`px-3 py-1 rounded-full text-xs font-medium ${
                  booking.status === 'confirmed' 
                    ? 'bg-green-100 text-green-800' 
                    : 'bg-yellow-100 text-yellow-800'
                }`}>
                  {booking.status}
                </span>
              </div>
            </div>
            
            <div className="flex items-center justify-between mt-4 pt-4 border-t border-slate-200">
              <div className="flex items-center space-x-4">
                <button className="flex items-center space-x-2 text-blue-600 hover:text-blue-700">
                  <MessageSquare className="w-4 h-4" />
                  <span>Message</span>
                </button>
                <button className="flex items-center space-x-2 text-slate-600 hover:text-slate-700">
                  <Download className="w-4 h-4" />
                  <span>Download</span>
                </button>
              </div>
              <div className="flex items-center space-x-2">
                <button className="px-4 py-2 text-sm border border-slate-300 rounded-lg hover:bg-slate-50">
                  Reschedule
                </button>
                <button className="px-4 py-2 text-sm bg-red-600 text-white rounded-lg hover:bg-red-700">
                  Cancel
                </button>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );

  const FavoritesTab = () => (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h2 className="text-2xl font-bold text-slate-800">My Favorites</h2>
        <span className="text-slate-500">{favoriteServices.length} saved services</span>
      </div>

      <div className="grid gap-4">
        {favoriteServices.map((service) => (
          <div key={service.id} className="bg-white rounded-lg shadow-sm border border-slate-200 p-6 hover:shadow-lg transition-shadow">
            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-4">
                <Heart className="w-5 h-5 text-red-500 fill-red-500" />
                <div>
                  <div className="text-lg font-semibold text-slate-800">{service.name}</div>
                  <div className="text-sm text-slate-600">{service.category}</div>
                </div>
              </div>
              <div className="flex items-center space-x-4">
                <div className="text-right">
                  <div className="flex items-center space-x-1">
                    <Star className="w-4 h-4 fill-yellow-400 text-yellow-400" />
                    <span className="text-sm font-medium">{service.rating}</span>
                  </div>
                  <div className="text-lg font-bold text-blue-600">{service.price}</div>
                </div>
                <div className="flex items-center space-x-2">
                  <button className="px-4 py-2 text-sm bg-gradient-to-r from-blue-600 to-purple-600 text-white rounded-lg hover:shadow-md transition-shadow">
                    Book Now
                  </button>
                  <button className="p-2 text-slate-500 hover:text-red-500">
                    <X className="w-4 h-4" />
                  </button>
                </div>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );

  const MessagesTab = () => (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h2 className="text-2xl font-bold text-slate-800">Messages</h2>
        <div className="flex items-center space-x-2">
          <Bell className="w-5 h-5 text-slate-500" />
          <span className="text-sm text-slate-600">2 unread messages</span>
        </div>
      </div>

      <div className="grid gap-4">
        {messages.map((message) => (
          <div key={message.id} className={`bg-white rounded-lg shadow-sm border border-slate-200 p-6 hover:shadow-lg transition-shadow ${
            message.unread ? 'border-l-4 border-l-blue-500' : ''
          }`}>
            <div className="flex items-start justify-between">
              <div className="flex items-start space-x-4">
                <div className={`w-3 h-3 rounded-full mt-2 ${message.unread ? 'bg-blue-500' : 'bg-slate-300'}`} />
                <div>
                  <div className="text-lg font-semibold text-slate-800 mb-1">{message.sender}</div>
                  <div className="text-slate-600 mb-2">{message.message}</div>
                  <div className="text-sm text-slate-500">{message.time}</div>
                </div>
              </div>
              <button className="text-blue-600 hover:text-blue-700">
                <ChevronRight className="w-5 h-5" />
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );

  const ProfileTab = () => (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h2 className="text-2xl font-bold text-slate-800">Profile Settings</h2>
        <button className="bg-gradient-to-r from-blue-600 to-purple-600 text-white px-4 py-2 rounded-lg hover:shadow-md transition-shadow">
          Save Changes
        </button>
      </div>

      <div className="grid md:grid-cols-2 gap-6">
        <div className="bg-white rounded-lg shadow-sm border border-slate-200 p-6">
          <h3 className="text-lg font-semibold text-slate-800 mb-4">Personal Information</h3>
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-slate-700 mb-2">First Name</label>
              <input type="text" className="w-full p-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500" defaultValue={firstName} />
            </div>
            <div>
              <label className="block text-sm font-medium text-slate-700 mb-2">Last Name</label>
              <input type="text" className="w-full p-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500" defaultValue={lastName} />
            </div>
            <div>
              <label className="block text-sm font-medium text-slate-700 mb-2">Email</label>
              <input type="email" className="w-full p-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500" defaultValue={user?.email} />
            </div>
            <div>
              <label className="block text-sm font-medium text-slate-700 mb-2">Phone</label>
              <input type="tel" className="w-full p-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500" defaultValue={user?.phone} />
            </div>
          </div>
        </div>

        <div className="bg-white rounded-lg shadow-sm border border-slate-200 p-6">
          <h3 className="text-lg font-semibold text-slate-800 mb-4">Preferences</h3>
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-slate-700 mb-2">Preferred Location</label>
              <select className="w-full p-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                <option>Kathmandu</option>
                <option>Lalitpur</option>
                <option>Bhaktapur</option>
              </select>
            </div>
            <div>
              <label className="block text-sm font-medium text-slate-700 mb-2">Budget Range</label>
              <select className="w-full p-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                <option>Rs. 25,000 - Rs. 50,000</option>
                <option>Rs. 50,000 - Rs. 100,000</option>
                <option>Rs. 100,000+</option>
              </select>
            </div>
            <div className="space-y-2">
              <label className="block text-sm font-medium text-slate-700">Notifications</label>
              <div className="space-y-2">
                <label className="flex items-center">
                  <input type="checkbox" className="mr-2" defaultChecked />
                  <span className="text-sm text-slate-600">Email notifications</span>
                </label>
                <label className="flex items-center">
                  <input type="checkbox" className="mr-2" defaultChecked />
                  <span className="text-sm text-slate-600">SMS notifications</span>
                </label>
                <label className="flex items-center">
                  <input type="checkbox" className="mr-2" />
                  <span className="text-sm text-slate-600">Marketing emails</span>
                </label>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );

  const Sidebar = () => (
    <div className={`fixed inset-y-0 left-0 z-50 w-64 bg-white transform ${sidebarOpen ? 'translate-x-0' : '-translate-x-full'} transition-transform duration-300 ease-in-out lg:translate-x-0 lg:static lg:inset-0 border-r border-slate-200`}>
      <div className="flex items-center justify-between h-16 px-6 border-b border-slate-200">
        <div className="flex items-center space-x-3">
          <div className="w-8 h-8 bg-gradient-to-br from-blue-600 to-purple-600 rounded-lg flex items-center justify-center">
            <Camera className="w-5 h-5 text-white" />
          </div>
          <span className="text-xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">Swornim</span>
        </div>
        <button
          onClick={() => setSidebarOpen(false)}
          className="lg:hidden text-slate-500 hover:text-slate-700 p-1 rounded"
        >
          <X className="w-5 h-5" />
        </button>
      </div>

      <div className="p-6">
        <div className="flex items-center space-x-3 mb-6 p-3 bg-gradient-to-r from-blue-50 to-purple-50 rounded-lg">
          <img
            src={profileImage}
            alt={user?.username}
            className="w-12 h-12 rounded-full border-2 border-white shadow-sm"
          />
          <div>
            <div className="text-sm font-semibold text-slate-800">{firstName} {lastName}</div>
            <div className="text-xs text-slate-600 capitalize flex items-center gap-1">
              <Shield className="w-3 h-3" />
              {user?.role} account
            </div>
          </div>
        </div>

        <nav className="space-y-1">
          {navigationItems.map((item) => (
            <button
              key={item.id}
              onClick={() => setActiveTab(item.id)}
              className={`w-full flex items-center px-4 py-3 rounded-lg transition-colors ${
                activeTab === item.id 
                  ? 'bg-blue-50 text-blue-600 border-r-2 border-blue-600' 
                  : 'text-slate-600 hover:bg-slate-50'
              }`}
            >
              {item.icon}
              <span className="ml-3 font-medium">{item.name}</span>
              {activeTab === item.id && (
                <ChevronRight className="w-4 h-4 ml-auto" />
              )}
            </button>
          ))}
        </nav>

        <div className="mt-8 pt-6 border-t border-slate-200">
          <div className="bg-gradient-to-r from-blue-50 to-purple-50 rounded-lg p-4 mb-4">
            <div className="flex items-center justify-between mb-2">
              <h4 className="font-semibold text-slate-800">Premium Member</h4>
              <Award className="w-5 h-5 text-yellow-500" />
            </div>
            <p className="text-sm text-slate-600 mb-3">Get 20% off on all premium services</p>
            <button className="w-full bg-gradient-to-r from-blue-600 to-purple-600 text-white py-2 px-4 rounded-lg text-sm font-medium hover:shadow-md transition-shadow">
              Upgrade Now
            </button>
          </div>

          <button className="w-full flex items-center px-4 py-3 rounded-lg text-slate-600 hover:bg-slate-50 transition-colors">
            <Settings className="w-5 h-5" />
            <span className="ml-3">Settings</span>
          </button>
          <button
            className="w-full flex items-center px-4 py-3 rounded-lg text-red-600 hover:bg-red-50 transition-colors mt-2"
            onClick={() => setLogoutModal(true)}
            disabled={loading}
          >
            <LogOut className="w-5 h-5" />
            <span className="ml-3">Sign Out</span>
          </button>
        </div>
      </div>
      {/* Logout Modal */}
      {logoutModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40">
          <div className="bg-white rounded-lg shadow-lg p-8 max-w-sm w-full">
            <h2 className="text-xl font-bold mb-4 text-slate-800">Confirm Logout</h2>
            <p className="mb-6 text-slate-600">Are you sure you want to log out?</p>
            {logoutError && <div className="mb-4 text-red-600">{logoutError}</div>}
            <div className="flex justify-end gap-4">
              <button
                className="px-4 py-2 rounded-lg bg-slate-100 text-slate-700 hover:bg-slate-200"
                onClick={() => setLogoutModal(false)}
                disabled={loading}
              >
                Cancel
              </button>
              <button
                className="px-4 py-2 rounded-lg bg-red-600 text-white hover:bg-red-700"
                onClick={handleLogout}
                disabled={loading}
              >
                {loading ? 'Logging out...' : 'Logout'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );

  const ServiceCard = ({ service }: { service: any }) => (
    <div className="bg-white rounded-lg shadow-sm border border-slate-200 hover:shadow-xl transition-all duration-300 overflow-hidden group">
      <div className="relative">
        <img
          src={service.image}
          alt={service.name}
          className="w-full h-48 object-cover group-hover:scale-105 transition-transform duration-300"
        />
        <div className="absolute inset-0 bg-gradient-to-t from-black/20 to-transparent" />
        {service.featured && (
          <div className="absolute top-3 left-3">
            <span className="bg-blue-600 text-white px-2 py-1 rounded-full text-xs font-medium backdrop-blur-sm">⭐ Featured</span>
          </div>
        )}
        {service.discount && (
          <div className="absolute top-3 right-3">
            <span className="bg-red-500 text-white px-2 py-1 rounded-full text-xs font-bold">
              {service.discount}% OFF
            </span>
          </div>
        )}
        <button className="absolute bottom-3 right-3 w-10 h-10 bg-white/90 backdrop-blur-sm rounded-full flex items-center justify-center shadow-md hover:shadow-lg transition-all hover:bg-white">
          <Heart className="w-5 h-5 text-slate-600 hover:text-red-500 transition-colors" />
        </button>
      </div>
      <div className="p-6">
        <div className="flex items-start justify-between mb-3">
          <div className="flex-1">
            <h3 className="text-lg font-semibold mb-1 text-slate-800">{service.name}</h3>
            <p className="text-sm text-slate-500 mb-2">{service.category}</p>
            <div className="flex flex-wrap gap-1">
              {service.tags?.map((tag: string, index: number) => (
                <span key={index} className="bg-slate-100 text-slate-700 px-2 py-1 rounded-full text-xs">{tag}</span>
              ))}
            </div>
          </div>
          {service.verified && (
            <div className="bg-green-100 p-1 rounded-full">
              <Award className="w-4 h-4 text-green-600" />
            </div>
          )}
        </div>
        <div className="flex items-center space-x-4 mb-4">
          <div className="flex items-center space-x-1">
            <Star className="w-4 h-4 fill-yellow-400 text-yellow-400" />
            <span className="text-sm font-semibold text-slate-700">{service.rating}</span>
            <span className="text-sm text-slate-500">({service.reviews})</span>
          </div>
          <div className="flex items-center space-x-1 text-slate-500">
            <Eye className="w-4 h-4" />
            <span className="text-sm">{Math.floor(Math.random() * 50) + 10} views</span>
          </div>
        </div>
        <div className="flex items-center justify-between mb-4">
          <div className="flex items-center space-x-2">
            <div className="text-lg font-bold text-blue-600">{service.price}</div>
            {service.originalPrice && (
              <div className="text-sm text-slate-400 line-through">{service.originalPrice}</div>
            )}
          </div>
        </div>
        <div className="flex items-center space-x-2">
          <button className="flex-1 bg-gradient-to-r from-blue-600 to-purple-600 text-white py-2 px-4 rounded-lg text-sm font-medium hover:shadow-md transition-shadow">
            Book Now
          </button>
          <button className="p-2 text-slate-500 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors">
            <Share2 className="w-4 h-4" />
          </button>
          <button className="p-2 text-slate-500 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors">
            <MessageSquare className="w-4 h-4" />
          </button>
        </div>
      </div>
    </div>
  );

  const handleLogout = async () => {
    setLoading(true);
    setLogoutError('');
    try {
      await logout();
      navigate('/login');
    } catch (err: any) {
      setLogoutError('Logout failed. Please try again.');
    } finally {
      setLoading(false);
      setLogoutModal(false);
    }
  };

  useEffect(() => {
    if (selectedCategory === 'photographer') {
      setPhotographersLoading(true);
      setPhotographersError('');
      photographerService
        .searchPhotographers()
        .then((data) => {
          setPhotographers(data.photographers || []);
        })
        .catch((err) => {
          setPhotographersError(err.message || 'Failed to load photographers');
        })
        .finally(() => setPhotographersLoading(false));
    }
  }, [selectedCategory]);

  return (
    <div className="flex min-h-screen bg-slate-50">
      <Sidebar />
      <main className="flex-1 p-8 overflow-y-auto">
        {activeTab === 'dashboard' && <DashboardTab />}
        {activeTab === 'browse' && <BrowseTab />}
        {activeTab === 'bookings' && <BookingsTab />}
        {activeTab === 'favorites' && <FavoritesTab />}
        {activeTab === 'messages' && <MessagesTab />}
        {activeTab === 'profile' && <ProfileTab />}
      </main>
    </div>
  );
};

export default ClientDashboard;