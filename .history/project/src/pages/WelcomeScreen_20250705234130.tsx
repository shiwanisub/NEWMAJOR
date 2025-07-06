import React, { useState, useEffect } from 'react';
import { 
  Camera, Calendar, MapPin, Palette, Users, ArrowRight, Star, CheckCircle, 
  Menu, X, Sparkles, Phone, Info, FileText, Home, Play, Shield, 
  Zap, Award, TrendingUp, Heart, ChevronRight, Quote, Clock, 
  Globe, BadgeCheck, Headphones, ArrowUp
} from 'lucide-react';

const WelcomeScreen = () => {
  const [isScrolled, setIsScrolled] = useState(false);
  const [activeTestimonial, setActiveTestimonial] = useState(0);
  const [showScrollTop, setShowScrollTop] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      setIsScrolled(window.scrollY > 50);
      setShowScrollTop(window.scrollY > 300);
    };

    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  useEffect(() => {
    const interval = setInterval(() => {
      setActiveTestimonial((prev) => (prev + 1) % testimonials.length);
    }, 5000);

    return () => clearInterval(interval);
  }, []);

  const navigate = (path: string) => {
    console.log(`Navigating to: ${path}`);
  };

  const features = [
    {
      icon: <Camera className="w-8 h-8 text-blue-600" />,
      title: "Professional Photography",
      description: "Connect with certified photographers and videographers for stunning captures that last forever",
      color: "from-blue-500 to-indigo-600",
      stats: "500+ Photographers",
      delay: "0ms"
    },
    {
      icon: <MapPin className="w-8 h-8 text-emerald-600" />,
      title: "Premium Venues",
      description: "Discover and book breathtaking venues perfect for your memorable events and celebrations",
      color: "from-emerald-500 to-teal-600",
      stats: "200+ Venues",
      delay: "100ms"
    },
    {
      icon: <Palette className="w-8 h-8 text-purple-600" />,
      title: "Beauty & Makeup",
      description: "Professional makeup artists and stylists to make you look absolutely stunning",
      color: "from-purple-500 to-pink-600",
      stats: "150+ Artists",
      delay: "200ms"
    },
    {
      icon: <Calendar className="w-8 h-8 text-orange-600" />,
      title: "Event Management",
      description: "Seamlessly plan, coordinate, and manage your entire event journey from start to finish",
      color: "from-orange-500 to-red-600",
      stats: "Full Service",
      delay: "300ms"
    }
  ];

  const stats = [
    { number: "2,500+", label: "Happy Clients", icon: <Heart className="w-5 h-5" />, color: "text-red-500" },
    { number: "800+", label: "Professional Vendors", icon: <Award className="w-5 h-5" />, color: "text-yellow-500" },
    { number: "5,000+", label: "Successful Events", icon: <TrendingUp className="w-5 h-5" />, color: "text-green-500" },
    { number: "75+", label: "Cities Covered", icon: <MapPin className="w-5 h-5" />, color: "text-blue-500" }
  ];

  const testimonials = [
    {
      name: "Priyansh Sharma",
      role: "Groom",
      content: "Swornim made our wedding planning effortless. The photographers captured every precious moment, and the venue was absolutely perfect. Highly recommended!",
      rating: 5,
      image: "https://images.pexels.com/photos/1040880/pexels-photo-1040880.jpeg?auto=compress&cs=tinysrgb&w=80&h=80&dpr=2",
      event: "Wedding Ceremony"
    },
    {
      name: "Raj Patel",
      role: "Event Organizer",
      content: "Best platform for finding reliable vendors. The coordination was seamless, and every detail was handled professionally. Five stars!",
      rating: 5,
      image: "https://images.pexels.com/photos/1040881/pexels-photo-1040881.jpeg?auto=compress&cs=tinysrgb&w=80&h=80&dpr=2",
      event: "Corporate Event"
    },
    {
      name: "Maya Singh",
      role: "Bride",
      content: "Professional service and excellent coordination. The makeup artist was incredible, and the venue looked like a fairy tale. Perfect experience!",
      rating: 5,
      image: "https://images.pexels.com/photos/1040882/pexels-photo-1040882.jpeg?auto=compress&cs=tinysrgb&w=80&h=80&dpr=2",
      event: "Wedding Reception"
    }
  ];

  const howItWorks = [
    {
      step: "1",
      title: "Browse & Compare",
      description: "Explore our curated selection of verified professionals and venues",
      icon: <Globe className="w-6 h-6" />
    },
    {
      step: "2",
      title: "Book & Plan",
      description: "Choose your favorites and plan your event with our intuitive tools",
      icon: <Calendar className="w-6 h-6" />
    },
    {
      step: "3",
      title: "Celebrate",
      description: "Enjoy your perfect event while we handle all the coordination",
      icon: <Sparkles className="w-6 h-6" />
    }
  ];

  const scrollToTop = () => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 via-white to-blue-50 overflow-hidden">
      {/* Fixed Navigation */}
      <nav className={`fixed top-0 left-0 right-0 z-40 transition-all duration-300 ${
        isScrolled ? 'bg-white/95 backdrop-blur-md shadow-lg' : 'bg-transparent'
      }`}>
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <div className="flex items-center space-x-3">
              <div className="w-10 h-10 bg-gradient-to-br from-blue-600 to-purple-600 rounded-xl flex items-center justify-center">
                <Camera className="w-5 h-5 text-white" />
              </div>
              <span className={`text-2xl font-bold transition-colors ${
                isScrolled ? 'text-slate-900' : 'text-white'
              }`}>Swornim</span>
            </div>
            <div className="hidden md:flex items-center space-x-8">
              <button className={`transition-colors ${
                isScrolled ? 'text-slate-600 hover:text-slate-900' : 'text-white/90 hover:text-white'
              }`}>Services</button>
              <button className={`transition-colors ${
                isScrolled ? 'text-slate-600 hover:text-slate-900' : 'text-white/90 hover:text-white'
              }`}>About</button>
              <button className={`transition-colors ${
                isScrolled ? 'text-slate-600 hover:text-slate-900' : 'text-white/90 hover:text-white'
              }`}>Contact</button>
              <button 
                onClick={() => navigate('/auth')}
                className="px-6 py-2 bg-gradient-to-r from-blue-600 to-purple-600 text-white rounded-lg font-semibold hover:shadow-lg transition-all duration-300"
              >
                Get Started
              </button>
            </div>
          </div>
        </div>
      </nav>

      {/* Hero Section */}
      <section className="pt-24 pb-20 px-4 sm:px-6 lg:px-8 relative overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-r from-blue-600/5 to-purple-600/5" />
        <div className="max-w-7xl mx-auto relative z-10">
          <div className="grid lg:grid-cols-2 gap-16 items-center">
            <div className="space-y-8">
              <div className="space-y-6">
                <div className="inline-flex items-center space-x-2 bg-gradient-to-r from-blue-50 to-purple-50 text-blue-600 px-4 py-2 rounded-full text-sm font-medium border border-blue-100">
                  <Sparkles className="w-4 h-4" />
                  <span>Nepal's #1 Event Platform</span>
                  <BadgeCheck className="w-4 h-4 text-green-500" />
                </div>
                
                <h1 className="text-4xl sm:text-5xl lg:text-6xl font-bold text-slate-900 leading-tight">
                  Your Perfect Event
                  <span className="block bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
                    Starts Here
                  </span>
                </h1>
                
                <p className="text-lg text-slate-600 max-w-lg leading-relaxed">
                  Connect with Nepal's finest photographers, venues, and event professionals. 
                  Transform your special moments into unforgettable memories with Swornim.
                </p>
              </div>
              
              <div className="flex flex-col sm:flex-row gap-4">
                <button 
                  onClick={() => navigate('/auth')}
                  className="group relative px-8 py-4 bg-gradient-to-r from-blue-600 to-purple-600 text-white rounded-xl shadow-lg hover:shadow-xl transition-all duration-300 hover:scale-105 overflow-hidden"
                >
                  <span className="relative z-10 flex items-center justify-center space-x-2 text-lg font-semibold">
                    <span>Start Planning</span>
                    <ArrowRight className="w-5 h-5 group-hover:translate-x-1 transition-transform" />
                  </span>
                  <div className="absolute inset-0 bg-gradient-to-r from-blue-700 to-purple-700 opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
                </button>
                
                <button className="group px-8 py-4 bg-white text-slate-600 rounded-xl border-2 border-slate-200 hover:border-blue-600 hover:text-blue-600 transition-all duration-300 flex items-center space-x-2">
                  <Play className="w-5 h-5 group-hover:scale-110 transition-transform" />
                  <span>Watch Demo</span>
                </button>
              </div>

              <div className="flex items-center space-x-6 pt-4">
                <div className="flex -space-x-2">
                  {testimonials.map((testimonial, i) => (
                    <img
                      key={i}
                      src={testimonial.image}
                      alt={testimonial.name}
                      className="w-10 h-10 rounded-full border-2 border-white shadow-md hover:scale-110 transition-transform duration-200"
                    />
                  ))}
                </div>
                <div>
                  <div className="flex items-center space-x-1">
                    {[1, 2, 3, 4, 5].map((star) => (
                      <Star key={star} className="w-4 h-4 fill-yellow-400 text-yellow-400" />
                    ))}
                    <span className="text-sm font-medium ml-2">4.9/5</span>
                  </div>
                  <p className="text-sm text-slate-500">Trusted by 2,500+ clients</p>
                </div>
              </div>
            </div>

            <div className="relative">
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-4">
                  <div className="relative rounded-xl overflow-hidden shadow-lg group">
                    <img
                      src="https://images.pexels.com/photos/1444442/pexels-photo-1444442.jpeg?auto=compress&cs=tinysrgb&w=400&h=300&dpr=2"
                      alt="Wedding Photography"
                      className="w-full h-48 object-cover group-hover:scale-105 transition-transform duration-300"
                    />
                    <div className="absolute inset-0 bg-gradient-to-t from-black/30 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
                    <div className="absolute bottom-4 left-4 text-white opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                      <p className="font-semibold">Wedding Photography</p>
                    </div>
                  </div>
                  <div className="relative rounded-xl overflow-hidden shadow-lg group">
                    <img
                      src="https://images.pexels.com/photos/587741/pexels-photo-587741.jpeg?auto=compress&cs=tinysrgb&w=400&h=200&dpr=2"
                      alt="Event Venue"
                      className="w-full h-32 object-cover group-hover:scale-105 transition-transform duration-300"
                    />
                    <div className="absolute inset-0 bg-gradient-to-t from-black/30 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
                    <div className="absolute bottom-2 left-4 text-white opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                      <p className="text-sm font-semibold">Premium Venues</p>
                    </div>
                  </div>
                </div>
                <div className="space-y-4 pt-8">
                  <div className="relative rounded-xl overflow-hidden shadow-lg group">
                    <img
                      src="https://images.pexels.com/photos/2959192/pexels-photo-2959192.jpeg?auto=compress&cs=tinysrgb&w=400&h=200&dpr=2"
                      alt="Makeup Artist"
                      className="w-full h-32 object-cover group-hover:scale-105 transition-transform duration-300"
                    />
                    <div className="absolute inset-0 bg-gradient-to-t from-black/30 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
                    <div className="absolute bottom-2 left-4 text-white opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                      <p className="text-sm font-semibold">Beauty & Makeup</p>
                    </div>
                  </div>
                  <div className="relative rounded-xl overflow-hidden shadow-lg group">
                    <img
                      src="https://images.pexels.com/photos/1666021/pexels-photo-1666021.jpeg?auto=compress&cs=tinysrgb&w=400&h=300&dpr=2"
                      alt="Event Management"
                      className="w-full h-48 object-cover group-hover:scale-105 transition-transform duration-300"
                    />
                    <div className="absolute inset-0 bg-gradient-to-t from-black/30 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
                    <div className="absolute bottom-4 left-4 text-white opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                      <p className="font-semibold">Event Management</p>
                    </div>
                  </div>
                </div>
              </div>
              
              <div className="absolute -bottom-6 -left-6 bg-white rounded-2xl p-6 shadow-2xl">
                <div className="flex items-center space-x-4">
                  <div className="w-12 h-12 bg-gradient-to-br from-green-400 to-emerald-500 rounded-xl flex items-center justify-center">
                    <CheckCircle className="w-6 h-6 text-white" />
                  </div>
                  <div>
                    <div className="text-2xl font-bold text-slate-900">5,000+</div>
                    <div className="text-sm text-slate-500">Events Completed</div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* How It Works */}
      <section className="py-20 px-4 sm:px-6 lg:px-8 bg-white">
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-16">
            <h2 className="text-3xl sm:text-4xl font-bold text-slate-900 mb-4">How It Works</h2>
            <p className="text-lg text-slate-600 max-w-2xl mx-auto">
              Getting started with Swornim is simple. Follow these three easy steps to plan your perfect event.
            </p>
          </div>

          <div className="grid md:grid-cols-3 gap-12">
            {howItWorks.map((item, index) => (
              <div key={index} className="text-center group relative">
                <div className="relative mb-8">
                  <div className="w-16 h-16 bg-gradient-to-br from-blue-600 to-purple-600 rounded-2xl flex items-center justify-center mx-auto mb-4 group-hover:scale-110 transition-transform duration-300 relative z-10">
                    <span className="text-white font-bold text-lg">{item.step}</span>
                  </div>
                  {index < howItWorks.length - 1 && (
                    <div className="hidden md:block absolute top-8 left-full transform -translate-y-1/2 w-12 h-0.5 bg-gradient-to-r from-blue-600 to-purple-600 z-0">
                      <div className="absolute right-0 top-1/2 transform -translate-y-1/2 w-0 h-0 border-l-4 border-l-blue-600 border-t-2 border-t-transparent border-b-2 border-b-transparent"></div>
                    </div>
                  )}
                </div>
                <h3 className="text-xl font-semibold text-slate-900 mb-4">{item.title}</h3>
                <p className="text-slate-600">{item.description}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section className="py-20 px-4 sm:px-6 lg:px-8">
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-16">
            <h2 className="text-3xl sm:text-4xl font-bold text-slate-900 mb-4">Everything You Need</h2>
            <p className="text-lg text-slate-600 max-w-2xl mx-auto">
              From photography to venues, we connect you with verified professionals 
              to make your event extraordinary.
            </p>
          </div>

          <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-8">
            {features.map((feature, index) => (
              <div 
                key={index} 
                className="group relative bg-white rounded-xl p-8 shadow-lg hover:shadow-xl transition-all duration-300 hover:-translate-y-2 border border-slate-100"
              >
                <div className={`absolute inset-0 bg-gradient-to-r ${feature.color} opacity-0 group-hover:opacity-5 rounded-xl transition-opacity duration-300`} />
                <div className="relative z-10">
                  <div className="flex justify-center mb-6">
                    <div className="w-16 h-16 bg-slate-50 rounded-xl flex items-center justify-center group-hover:scale-110 transition-transform duration-300">
                      {feature.icon}
                    </div>
                  </div>
                  <h3 className="text-xl font-semibold text-slate-900 mb-3 text-center">{feature.title}</h3>
                  <p className="text-slate-600 text-center mb-4">{feature.description}</p>
                  <div className="text-center">
                    <span className="inline-block bg-blue-50 text-blue-600 px-3 py-1 rounded-full text-sm font-medium">{feature.stats}</span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Stats Section */}
      <section className="py-20 bg-gradient-to-r from-blue-600 to-purple-600 text-white relative overflow-hidden">
        <div className="absolute inset-0 bg-black/10" />
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
          <div className="text-center mb-12">
            <h2 className="text-3xl sm:text-4xl font-bold text-white mb-4">Trusted by Thousands</h2>
            <p className="text-lg text-blue-100">Our numbers speak for themselves</p>
          </div>
          <div className="grid grid-cols-2 lg:grid-cols-4 gap-8">
            {stats.map((stat, index) => (
              <div key={index} className="text-center group">
                <div className="flex justify-center mb-4">
                  <div className="w-12 h-12 bg-white/10 rounded-xl flex items-center justify-center group-hover:bg-white/20 transition-colors duration-300">
                    <span className={stat.color}>{stat.icon}</span>
                  </div>
                </div>
                <div className="text-3xl lg:text-4xl font-bold mb-2">{stat.number}</div>
                <div className="text-blue-100 font-medium">{stat.label}</div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Enhanced Testimonials Section */}
      <section className="py-20 px-4 sm:px-6 lg:px-8 bg-slate-50">
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-16">
            <h2 className="text-3xl sm:text-4xl font-bold text-slate-900 mb-4">What Our Clients Say</h2>
            <p className="text-lg text-slate-600">Don't just take our word for it - hear from our satisfied clients</p>
          </div>

          <div className="max-w-4xl mx-auto">
            <div className="relative">
              <div className="bg-white rounded-2xl p-8 shadow-xl">
                <div className="flex items-center justify-center mb-6">
                  <Quote className="w-8 h-8 text-blue-600" />
                </div>
                <div className="text-center">
                  <div className="flex items-center justify-center space-x-1 mb-6">
                    {[1, 2, 3, 4, 5].map((star) => (
                      <Star key={star} className="w-5 h-5 fill-yellow-400 text-yellow-400" />
                    ))}
                  </div>
                  <p className="text-lg italic text-slate-600 mb-8 leading-relaxed">
                    "{testimonials[activeTestimonial].content}"
                  </p>
                  <div className="flex items-center justify-center space-x-4">
                    <img
                      src={testimonials[activeTestimonial].image}
                      alt={testimonials[activeTestimonial].name}
                      className="w-16 h-16 rounded-full border-2 border-blue-100"
                    />
                    <div className="text-left">
                      <div className="font-semibold text-slate-900">{testimonials[activeTestimonial].name}</div>
                      <div className="text-sm text-slate-500">{testimonials[activeTestimonial].role}</div>
                      <div className="inline-block bg-blue-50 text-blue-600 px-3 py-1 rounded-full text-sm font-medium mt-2">{testimonials[activeTestimonial].event}</div>
                    </div>
                  </div>
                </div>
              </div>
              
              <div className="flex justify-center space-x-2 mt-8">
                {testimonials.map((_, index) => (
                  <button
                    key={index}
                    onClick={() => setActiveTestimonial(index)}
                    className={`w-3 h-3 rounded-full transition-all duration-300 ${
                      index === activeTestimonial ? 'bg-blue-600' : 'bg-slate-300'
                    }`}
                  />
                ))}
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Enhanced CTA Section */}
      <section className="py-20 px-4 sm:px-6 lg:px-8">
        <div className="max-w-4xl mx-auto text-center">
          <div className="bg-gradient-to-r from-blue-600 to-purple-600 rounded-3xl p-12 text-white relative overflow-hidden shadow-2xl">
            <div className="absolute inset-0 bg-black/10" />
            <div className="absolute top-0 right-0 w-32 h-32 bg-white/10 rounded-full -translate-y-16 translate-x-16" />
            <div className="absolute bottom-0 left-0 w-24 h-24 bg-white/10 rounded-full translate-y-12 -translate-x-12" />
            <div className="relative z-10">
              <div className="flex justify-center mb-6">
                <div className="w-16 h-16 bg-white/20 rounded-2xl flex items-center justify-center">
                  <Zap className="w-8 h-8 text-white" />
                </div>
              </div>
              <h2 className="text-3xl sm:text-4xl font-bold text-white mb-6">Ready to Get Started?</h2>
              <p className="text-lg text-blue-100 mb-8 max-w-2xl mx-auto">
                Join thousands of satisfied clients who trust Swornim for their special events.
                Start planning your perfect event today and make memories that last forever.
              </p>
              <div className="flex flex-col sm:flex-row gap-4 justify-center">
                <button 
                  onClick={() => navigate('/auth')}
                  className="px-8 py-4 bg-white text-blue-600 rounded-xl font-semibold hover:bg-blue-50 transition-colors duration-300 shadow-lg hover:shadow-xl"
                >
                  Create Free Account
                </button>
                <button 
                  onClick={() => navigate('/auth')}
                  className="px-8 py-4 bg-transparent border-2 border-white text-white rounded-xl font-semibold hover:bg-white hover:text-blue-600 transition-all duration-300"
                >
                  Sign In
                </button>
              </div>
              <div className="flex items-center justify-center space-x-6 mt-8 text-blue-100">
                <div className="flex items-center space-x-2">
                  <CheckCircle className="w-4 h-4" />
                  <span className="text-sm">No Setup Fees</span>
                </div>
                <div className="flex items-center space-x-2">
                  <CheckCircle className="w-4 h-4" />
                  <span className="text-sm">24/7 Support</span>
                </div>
                <div className="flex items-center space-x-2">
                  <CheckCircle className="w-4 h-4" />
                  <span className="text-sm">Verified Professionals</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Enhanced Footer */}
      <footer className="bg-slate-900 text-white py-16">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid md:grid-cols-4 gap-8">
            <div className="space-y-6">
              <div className="flex items-center space-x-3">
                <div className="w-10 h-10 bg-gradient-to-br from-blue-600 to-purple-600 rounded-xl flex items-center justify-center">
                  <Camera className="w-5 h-5 text-white" />
                </div>
                <span className="text-2xl font-bold">Swornim</span>
              </div>
              <p className="text-slate-400 leading-relaxed">
                Nepal's premier event management platform connecting clients with verified professionals for unforgettable experiences.
              </p>
              <div className="flex items-center space-x-2 text-slate-400">
                <Headphones className="w-4 h-4" />
                <span className="text-sm">24/7 Customer Support</span>
              </div>
            </div>
            
            <div>
              <h4 className="text-lg font-semibold text-white mb-6">Services</h4>
              <ul className="space-y-3">
                <li><a href="#" className="text-slate-400 hover:text-white transition-colors flex items-center space-x-2"><ChevronRight className="w-4 h-4" /><span>Photography</span></a></li>
                <li><a href="#" className="text-slate-400 hover:text-white transition-colors flex items-center space-x-2"><ChevronRight className="w-4 h-4" /><span>Videography</span></a></li>
                <li><a href="#" className="text-slate-400 hover:text-white transition-colors flex items-center space-x-2"><ChevronRight className="w-4 h-4" /><span>Venues</span></a></li>
                <li><a href="#" className="text-slate-400 hover:text-white transition-colors flex items-center space-x-2"><ChevronRight className="w-4 h-4" /><span>Makeup & Beauty</span></a></li>
                <li><a href="#" className="text-slate-400 hover:text-white transition-colors flex items-center space-x-2"><ChevronRight className="w-4 h-4" /><span>Event Decoration</span></a></li>
                <li><a href="#" className="text-slate-400 hover:text-white transition-colors flex items-center space-x-2"><ChevronRight className="w-4 h-4" /><span>Catering Services</span></a></li>
              </ul>
            </div>
            
            <div>
              <h4 className="text-lg font-semibold text-white mb-6">Company</h4>
              <ul className="space-y-3">
                <li><a href="#" className="text-slate-400 hover:text-white transition-colors flex items-center space-x-2"><ChevronRight className="w-4 h-4" /><span>About Us</span></a></li>
                <li><a href="#" className="text-slate-400 hover:text-white transition-colors flex items-center space-x-2"><ChevronRight className="w-4 h-4" /><span>Our Team</span></a></li>
                <li><a href="#" className="text-slate-400 hover:text-white transition-colors flex items-center space-x-2"><ChevronRight className="w-4 h-4" /><span>Careers</span></a></li>
                <li><a href="#" className="text-slate-400 hover:text-white transition-colors flex items-center space-x-2"><ChevronRight className="w-4 h-4" /><span>Contact</span></a></li>
                <li><a href="#" className="text-slate-400 hover:text-white transition-colors flex items-center space-x-2"><ChevronRight className="w-4 h-4" /><span>Blog</span></a></li>
              </ul>
            </div>
            
            <div>
              <h4 className="text-lg font-semibold text-white mb-6">Support</h4>
              <ul className="space-y-3">
                <li><a href="#" className="text-slate-400 hover:text-white transition-colors flex items-center space-x-2"><ChevronRight className="w-4 h-4" /><span>Help Center</span></a></li>
                <li><a href="#" className="text-slate-400 hover:text-white transition-colors flex items-center space-x-2"><ChevronRight className="w-4 h-4" /><span>Contact Support</span></a></li>
                <li><a href="#" className="text-slate-400 hover:text-white transition-colors flex items-center space-x-2"><ChevronRight className="w-4 h-4" /><span>Privacy Policy</span></a></li>
                <li><a href="#" className="text-slate-400 hover:text-white transition-colors flex items-center space-x-2"><ChevronRight className="w-4 h-4" /><span>Terms of Service</span></a></li>
                <li><a href="#" className="text-slate-400 hover:text-white transition-colors flex items-center space-x-2"><ChevronRight className="w-4 h-4" /><span>Cookie Policy</span></a></li>
              </ul>
            </div>
          </div>
          
          <div className="border-t border-slate-800 mt-12 pt-8">
            <div className="flex flex-col md:flex-row justify-between items-center">
              <div className="flex items-center space-x-4 mb-4 md:mb-0">
                <p className="text-slate-400">
                  © 2024 Swornim. All rights reserved.
                </p>
                <div className="flex items-center space-x-2">
                  <span className="text-slate-400">•</span>
                  <span className="text-slate-400">Made with ❤️ in Nepal</span>
                </div>
              </div>
              <div className="flex items-center space-x-6">
                <span className="text-slate-400 text-sm">Follow us:</span>
                <div className="flex space-x-4">
                  <a href="#" className="w-8 h-8 bg-slate-800 rounded-lg flex items-center justify-center hover:bg-blue-600 transition-colors">
                    <Users className="w-4 h-4 text-slate-400 hover:text-white" />
                  </a>
                  <a href="#" className="w-8 h-8 bg-slate-800 rounded-lg flex items-center justify-center hover:bg-blue-600 transition-colors">
                    <Camera className="w-4 h-4 text-slate-400 hover:text-white" />
                  </a>
                  <a href="#" className="w-8 h-8 bg-slate-800 rounded-lg flex items-center justify-center hover:bg-blue-600 transition-colors">
                    <Shield className="w-4 h-4 text-slate-400 hover:text-white" />
                  </a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </footer>

      {/* Scroll to Top Button */}
      {showScrollTop && (
        <button
          onClick={scrollToTop}
          className="fixed bottom-8 right-8 w-12 h-12 bg-gradient-to-r from-blue-600 to-purple-600 text-white rounded-full shadow-lg hover:shadow-xl transition-all duration-300 hover:scale-110 z-50 flex items-center justify-center"
        >
          <ArrowUp className="w-5 h-5" />
        </button>
      )}
    </div>
  );
};

export default WelcomeScreen;