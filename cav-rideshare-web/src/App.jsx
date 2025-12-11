import { useEffect, useState } from 'react'
import { NavLink, Route, Routes, useNavigate } from 'react-router-dom'
import Home from './pages/Home.jsx'
import Login from './pages/Login.jsx'
import Signup from './pages/Signup.jsx'
import Profile from './pages/Profile.jsx'
import PublicProfile from './pages/PublicProfile.jsx'
import './App.css'

const navLinks = [
  { path: '/', label: 'Home' },
  { path: '/profile', label: 'Profile' },
  { path: '/login', label: 'Login' },
  { path: '/signup', label: 'Sign Up' },
]

function App() {
  const [isAuthenticated, setIsAuthenticated] = useState(
    Boolean(localStorage.getItem('cavrideshare_token')),
  )
  const navigate = useNavigate()

  useEffect(() => {
    const onStorage = () => setIsAuthenticated(Boolean(localStorage.getItem('cavrideshare_token')))
    const onLogin = () => setIsAuthenticated(Boolean(localStorage.getItem('cavrideshare_token')))
    window.addEventListener('storage', onStorage)
    window.addEventListener('login', onLogin)
    return () => {
      window.removeEventListener('storage', onStorage)
      window.removeEventListener('login', onLogin)
    }
  }, [])

  const handleLogout = () => {
    localStorage.removeItem('cavrideshare_token')
    localStorage.removeItem('cavrideshare_user')
    setIsAuthenticated(false)
    window.dispatchEvent(new Event('logout'))
    navigate('/')
  }

  return (
    <div className="app-shell">
      <header className="app-header">
        <div className="brand">
          <div>
            <p className="brand-title">CavRideShare</p>
          </div>
        </div>
        <nav className="app-nav">
          <NavLink to="/" className={({ isActive }) => (isActive ? 'active' : undefined)}>
            Home
          </NavLink>
          {isAuthenticated ? (
            <>
              <NavLink to="/profile" className={({ isActive }) => (isActive ? 'active' : undefined)}>
                Profile
              </NavLink>
              <button className="secondary-btn" onClick={handleLogout} type="button">
                Logout
              </button>
            </>
          ) : (
            <>
              <NavLink to="/login" className={({ isActive }) => (isActive ? 'active' : undefined)}>
                Login
              </NavLink>
              <NavLink to="/signup" className={({ isActive }) => (isActive ? 'active' : undefined)}>
                Sign Up
              </NavLink>
            </>
          )}
        </nav>
      </header>
      <main className="app-main">
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/login" element={<Login />} />
          <Route path="/signup" element={<Signup />} />
          <Route path="/profile" element={<Profile />} />
          <Route path="/user/:uvaId" element={<PublicProfile />} />
        </Routes>
      </main>
      <footer className="app-footer">
        <small>© CavRideShare. Elliot, Ivy, Thomas. Built with React JS, Express, MySQL</small>
      </footer>
    </div>
  )
}

export default App
