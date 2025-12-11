import { useState } from 'react'
import { useNavigate } from 'react-router-dom'

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:4000'

const initialCredentials = { uvaId: '', password: '' }

function Login() {
  const [credentials, setCredentials] = useState(initialCredentials)
  const [status, setStatus] = useState({ state: 'idle', message: '' })
  const [tokenPreview, setTokenPreview] = useState('')
  const navigate = useNavigate()

  const handleChange = (event) => {
    const { name, value } = event.target
    setCredentials((prev) => ({ ...prev, [name]: value }))
  }

  const handleSubmit = async (event) => {
    event.preventDefault()
    setStatus({ state: 'loading', message: 'Verifying credentials...' })

    try {
      const response = await fetch(`${API_BASE_URL}/api/auth/login`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          uvaId: credentials.uvaId,
          password: credentials.password,
        }),
      })

      if (!response.ok) {
        const errorBody = await response.json().catch(() => ({}))
        throw new Error(errorBody.message || 'Invalid UVA ID or password.')
      }

      const payload = await response.json()
      if (payload.token) {
        localStorage.setItem('cavrideshare_token', payload.token)
        if (payload.user || payload.role) {
          const userMeta = {
            id: payload.user?.uvaId || payload.user?.uva_id || payload.user?.id,
            role: payload.role,
          }
          localStorage.setItem('cavrideshare_user', JSON.stringify(userMeta))
        }
        setTokenPreview(payload.token)
        // Dispatch a custom event to notify the App component of the login
        window.dispatchEvent(new Event('login'))
      } else {
        setTokenPreview('Token will be returned by the backend.')
      }
      setStatus({ state: 'success', message: 'Logged in! Redirecting to home...' })
      setCredentials(initialCredentials)
      // Redirect to home page after a short delay
      setTimeout(() => navigate('/'), 500)
    } catch (error) {
      setStatus({ state: 'error', message: error.message })
      setTokenPreview('')
    }
  }

  return (
    <section className="login-page">
      <div className="card">
        <h1>Log in</h1>
        <p>
          Enter your UVA ID and password to log in to CavRideShare and access your account.
        </p>
        <form onSubmit={handleSubmit} className="login-form">
          <label>
            UVA ID
            <input
              type="text"
              name="uvaId"
              placeholder="ab1234c"
              required
              value={credentials.uvaId}
              onChange={handleChange}
            />
          </label>
          <label>
            Password
            <input
              type="password"
              name="password"
              placeholder="••••••••"
              required
              value={credentials.password}
              onChange={handleChange}
            />
          </label>
          <button className="primary-btn" type="submit" disabled={status.state === 'loading'}>
            {status.state === 'loading' ? 'Connecting...' : 'Sign in'}
          </button>
          {status.state !== 'idle' && (
            <p className={`status ${status.state}`}>{status.message}</p>
          )}
        </form>
      </div>

      {tokenPreview && (
        <div className="card token-card">
          <h2>JWT preview</h2>
          <p>
            Store this token in <code>localStorage</code> or a secure cookie, then send it via the{' '}
            <code>Authorization</code> header so the backend can authorize routes.
          </p>
          <code className="token-preview">{tokenPreview}</code>
        </div>
      )}
    </section>
  )
}

export default Login
