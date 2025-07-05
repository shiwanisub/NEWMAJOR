import React, { useState } from 'react';
import { BrowserRouter as Router, Routes, Route, Link, NavLink } from 'react-router-dom';
import { login, signup } from './api';
import { FaUser, FaEnvelope, FaPhone, FaLock, FaUserShield } from 'react-icons/fa';

function Navbar() {
  return (
    <nav className="w-full sticky top-0 z-20 bg-white/80 backdrop-blur shadow flex items-center justify-between px-8 py-4 mb-8">
      <div className="flex items-center gap-2">
        <img src="/favicon.png" alt="Swornim Logo" className="w-8 h-8 mr-2" />
        <span className="text-2xl font-bold text-primary tracking-tight">Swornim</span>
      </div>
      <div className="flex gap-6">
        <NavLink to="/" end className={({isActive}) => `font-medium text-lg transition-colors ${isActive ? 'text-primary underline underline-offset-4' : 'text-muted hover:text-primary'}`}>Home</NavLink>
        <NavLink to="/about" className={({isActive}) => `font-medium text-lg transition-colors ${isActive ? 'text-primary underline underline-offset-4' : 'text-muted hover:text-primary'}`}>About</NavLink>
        <NavLink to="/auth" className={({isActive}) => `font-medium text-lg transition-colors ${isActive ? 'text-primary underline underline-offset-4' : 'text-muted hover:text-primary'}`}>Login/Signup</NavLink>
      </div>
    </nav>
  );
}

function Home() {
  return (
    <section className="flex flex-col items-center justify-center min-h-[60vh] text-center">
      <div className="w-full max-w-4xl mx-auto flex flex-col md:flex-row items-center gap-12 py-12">
        <div className="flex-1 flex flex-col items-start md:items-start">
          <h1 className="text-5xl md:text-6xl font-extrabold text-primary mb-6 drop-shadow-lg leading-tight">
            Plan Events <span className="text-tertiary">Effortlessly</span>
          </h1>
          <p className="text-xl md:text-2xl text-muted mb-8 max-w-lg">
            Swornim is your one-stop platform for event management, bookings, and seamless collaboration between clients and service providers.
          </p>
          <Link to="/auth" className="px-8 py-3 bg-primary text-white rounded-lg shadow hover:bg-blue-700 transition font-semibold text-lg">Get Started</Link>
        </div>
        <div className="flex-1 flex justify-center">
          <img src="https://images.unsplash.com/photo-1515168833906-d2a3b82b3029?auto=format&fit=crop&w=600&q=80" alt="Event" className="rounded-2xl shadow-lg w-full max-w-md object-cover" />
        </div>
      </div>
      <div className="w-full max-w-5xl mx-auto grid grid-cols-1 md:grid-cols-3 gap-8 mt-12">
        <div className="bg-white rounded-xl shadow p-6 flex flex-col items-center">
          <span className="text-3xl text-primary mb-2">🎉</span>
          <h3 className="text-xl font-bold mb-2">Easy Bookings</h3>
          <p className="text-muted">Book venues, caterers, and more with just a few clicks.</p>
        </div>
        <div className="bg-white rounded-xl shadow p-6 flex flex-col items-center">
          <span className="text-3xl text-primary mb-2">🔒</span>
          <h3 className="text-xl font-bold mb-2">Secure Authentication</h3>
          <p className="text-muted">Your data and privacy are protected with industry standards.</p>
        </div>
        <div className="bg-white rounded-xl shadow p-6 flex flex-col items-center">
          <span className="text-3xl text-primary mb-2">💡</span>
          <h3 className="text-xl font-bold mb-2">Modern Design</h3>
          <p className="text-muted">Enjoy a beautiful, intuitive interface inspired by our mobile app.</p>
        </div>
      </div>
    </section>
  );
}

function About() {
  return (
    <section className="flex flex-col items-center justify-center min-h-[60vh] text-center py-12">
      <h2 className="text-4xl font-bold text-primary mb-4">About Swornim</h2>
      <p className="text-lg text-muted max-w-2xl mb-8">Swornim is designed to simplify event management for clients and service providers. Our platform offers secure authentication, easy bookings, and a modern, user-friendly interface inspired by our mobile app's theme.</p>
      <div className="w-full max-w-3xl mx-auto grid grid-cols-1 md:grid-cols-2 gap-8 mt-8">
        <div className="bg-white rounded-xl shadow p-6 flex flex-col items-center">
          <h4 className="text-xl font-bold mb-2 text-tertiary">Our Mission</h4>
          <p className="text-muted">To empower users to plan and manage events with confidence, ease, and joy.</p>
        </div>
        <div className="bg-white rounded-xl shadow p-6 flex flex-col items-center">
          <h4 className="text-xl font-bold mb-2 text-tertiary">Our Team</h4>
          <p className="text-muted">A passionate group of developers, designers, and event experts dedicated to your success.</p>
        </div>
      </div>
    </section>
  );
}

function AuthPage() {
  const [tab, setTab] = useState('login');
  // Login state
  const [loginEmail, setLoginEmail] = useState('');
  const [loginPassword, setLoginPassword] = useState('');
  const [loginError, setLoginError] = useState('');
  const [loginLoading, setLoginLoading] = useState(false);
  // Signup state
  const [signupUsername, setSignupUsername] = useState('');
  const [signupEmail, setSignupEmail] = useState('');
  const [signupPhone, setSignupPhone] = useState('');
  const [signupPassword, setSignupPassword] = useState('');
  const [signupConfirm, setSignupConfirm] = useState('');
  const [signupRole, setSignupRole] = useState('client');
  const [signupError, setSignupError] = useState('');
  const [signupSuccess, setSignupSuccess] = useState('');
  const [signupLoading, setSignupLoading] = useState(false);

  // Validation helpers
  const validateEmail = (email) => /^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$/.test(email);
  const validateUsername = (u) => /^[a-zA-Z0-9_]{3,20}$/.test(u);
  const validatePhone = (p) => /^\d{10}$/.test(p);
  const validatePassword = (pw) => /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/.test(pw);

  // Login handler
  async function handleLogin(e) {
    e.preventDefault();
    setLoginError('');
    if (!validateEmail(loginEmail)) return setLoginError('Enter a valid email.');
    if (!loginPassword) return setLoginError('Password is required.');
    setLoginLoading(true);
    try {
      const res = await login({ email: loginEmail, password: loginPassword });
      // Store token (localStorage/sessionStorage as needed)
      localStorage.setItem('swornim_token', res.data.tokens?.accessToken || '');
      // Optionally store user info
      localStorage.setItem('swornim_user', JSON.stringify(res.data.user));
      setLoginError('');
      window.location.href = '/'; // Redirect to home or dashboard
    } catch (err) {
      setLoginError(err.message);
    } finally {
      setLoginLoading(false);
    }
  }

  // Signup handler
  async function handleSignup(e) {
    e.preventDefault();
    setSignupError('');
    setSignupSuccess('');
    if (!validateUsername(signupUsername)) return setSignupError('Username: 3-20 chars, letters/numbers/_');
    if (!validateEmail(signupEmail)) return setSignupError('Enter a valid email.');
    if (!validatePhone(signupPhone)) return setSignupError('Phone: 10 digits.');
    if (!validatePassword(signupPassword)) return setSignupError('Password: 8+ chars, upper, lower, number.');
    if (signupPassword !== signupConfirm) return setSignupError('Passwords do not match.');
    setSignupLoading(true);
    try {
      await signup({ username: signupUsername, email: signupEmail, phone: signupPhone, password: signupPassword, role: signupRole });
      setSignupSuccess('Registration successful! Please check your email to verify your account.');
      setSignupError('');
      setSignupUsername(''); setSignupEmail(''); setSignupPhone(''); setSignupPassword(''); setSignupConfirm('');
    } catch (err) {
      setSignupError(err.message);
    } finally {
      setSignupLoading(false);
    }
  }

  return (
    <div className="min-h-[80vh] flex flex-col items-center justify-center bg-gradient-to-br from-blue-100 via-white to-blue-200 py-12">
      <h2 className="text-3xl font-extrabold text-primary mb-8 drop-shadow-lg">Login or Signup</h2>
      <div className="w-full max-w-md bg-white/70 backdrop-blur-lg rounded-2xl shadow-2xl p-8 border border-blue-100 relative">
        <div className="flex mb-8 rounded-lg overflow-hidden border border-blue-200">
          <button onClick={() => setTab('login')} className={`flex-1 py-2 font-semibold text-lg transition-colors ${tab==='login' ? 'bg-primary text-white shadow' : 'bg-transparent text-primary hover:bg-blue-50'}`}>Login</button>
          <button onClick={() => setTab('signup')} className={`flex-1 py-2 font-semibold text-lg transition-colors ${tab==='signup' ? 'bg-primary text-white shadow' : 'bg-transparent text-primary hover:bg-blue-50'}`}>Signup</button>
        </div>
        {tab === 'login' && (
          <form onSubmit={handleLogin} className="flex flex-col gap-5 text-left animate-fade-in">
            <label className="font-medium flex items-center gap-2"><FaEnvelope className="text-primary" />
              <input type="email" placeholder="Email" className="mt-1 w-full px-3 py-2 border rounded focus:outline-none focus:ring-2 focus:ring-primary bg-white/80" value={loginEmail} onChange={e=>setLoginEmail(e.target.value)} autoComplete="email" required />
            </label>
            <label className="font-medium flex items-center gap-2"><FaLock className="text-primary" />
              <input type="password" placeholder="Password" className="mt-1 w-full px-3 py-2 border rounded focus:outline-none focus:ring-2 focus:ring-primary bg-white/80" value={loginPassword} onChange={e=>setLoginPassword(e.target.value)} autoComplete="current-password" required />
            </label>
            {loginError && <div className="text-error text-sm font-medium mt-1 flex items-center gap-1"><FaUserShield className="text-error" />{loginError}</div>}
            <button type="submit" className="mt-2 w-full bg-primary text-white py-2 rounded-lg font-semibold hover:bg-blue-700 transition shadow-lg" disabled={loginLoading}>{loginLoading ? 'Logging in...' : 'Login'}</button>
          </form>
        )}
        {tab === 'signup' && (
          <form onSubmit={handleSignup} className="flex flex-col gap-5 text-left animate-fade-in">
            <label className="font-medium flex items-center gap-2"><FaUser className="text-primary" />
              <input type="text" placeholder="Username" className="mt-1 w-full px-3 py-2 border rounded focus:outline-none focus:ring-2 focus:ring-primary bg-white/80" value={signupUsername} onChange={e=>setSignupUsername(e.target.value)} autoComplete="username" required />
            </label>
            <label className="font-medium flex items-center gap-2"><FaEnvelope className="text-primary" />
              <input type="email" placeholder="Email" className="mt-1 w-full px-3 py-2 border rounded focus:outline-none focus:ring-2 focus:ring-primary bg-white/80" value={signupEmail} onChange={e=>setSignupEmail(e.target.value)} autoComplete="email" required />
            </label>
            <label className="font-medium flex items-center gap-2"><FaPhone className="text-primary" />
              <input type="tel" placeholder="Phone (10 digits)" className="mt-1 w-full px-3 py-2 border rounded focus:outline-none focus:ring-2 focus:ring-primary bg-white/80" value={signupPhone} onChange={e=>setSignupPhone(e.target.value.replace(/\D/g, ''))} maxLength={10} required />
            </label>
            <label className="font-medium flex items-center gap-2"><FaLock className="text-primary" />
              <input type="password" placeholder="Password" className="mt-1 w-full px-3 py-2 border rounded focus:outline-none focus:ring-2 focus:ring-primary bg-white/80" value={signupPassword} onChange={e=>setSignupPassword(e.target.value)} autoComplete="new-password" required />
            </label>
            <label className="font-medium flex items-center gap-2"><FaLock className="text-primary" />
              <input type="password" placeholder="Confirm Password" className="mt-1 w-full px-3 py-2 border rounded focus:outline-none focus:ring-2 focus:ring-primary bg-white/80" value={signupConfirm} onChange={e=>setSignupConfirm(e.target.value)} autoComplete="new-password" required />
            </label>
            <label className="font-medium flex items-center gap-2"><FaUserShield className="text-primary" />
              <select className="mt-1 w-full px-3 py-2 border rounded focus:outline-none focus:ring-2 focus:ring-primary bg-white/80" value={signupRole} onChange={e=>setSignupRole(e.target.value)} required>
                <option value="client">Client</option>
                <option value="cameraman">Cameraman</option>
                <option value="venue">Venue</option>
                <option value="makeup_artist">Makeup Artist</option>
              </select>
            </label>
            {signupError && <div className="text-error text-sm font-medium mt-1 flex items-center gap-1"><FaUserShield className="text-error" />{signupError}</div>}
            {signupSuccess && <div className="text-green-600 text-sm font-medium mt-1 flex items-center gap-1"><FaUserShield className="text-green-600" />{signupSuccess}</div>}
            <button type="submit" className="mt-2 w-full bg-primary text-white py-2 rounded-lg font-semibold hover:bg-blue-700 transition shadow-lg" disabled={signupLoading}>{signupLoading ? 'Signing up...' : 'Signup'}</button>
          </form>
        )}
      </div>
    </div>
  );
}

function App() {
  return (
    <Router>
      <div className="min-h-screen bg-background text-text font-sans">
        <Navbar />
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/about" element={<About />} />
          <Route path="/auth" element={<AuthPage />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;
