import { useState } from 'react'

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:4000'

const initialForm = {
  uvaId: '',
  fname: '',
  lname: '',
  phoneNumber: '',
  licensePlate: '',
  carMake: '',
  carModel: '',
  carMpg: '',
  carMaxPassengers: '',
  password: '',
  confirmPassword: '',
  role: 'rider',
}

function Signup() {
  const [form, setForm] = useState(initialForm)
  const [status, setStatus] = useState({ state: 'idle', message: '' })
  const [tokenPreview, setTokenPreview] = useState('')

  const handleChange = (event) => {
    const { name, value } = event.target
    setForm((prev) => ({ ...prev, [name]: value }))
  }

  const handleSubmit = async (event) => {
    event.preventDefault()

    if (form.password !== form.confirmPassword) {
      setStatus({ state: 'error', message: 'Passwords do not match.' })
      return
    }

    if (form.role === 'driver' && !form.licensePlate) {
      setStatus({ state: 'error', message: 'License plate is required for drivers.' })
      return
    }

    if (form.role === 'driver' && (!form.carMake || !form.carModel || !form.carMaxPassengers)) {
      setStatus({ state: 'error', message: 'Car make, model, and max passengers are required for drivers.' })
      return
    }

    setStatus({ state: 'loading', message: 'Creating your account...' })

    try {
      const payload = {
        uvaId: form.uvaId,
        fname: form.fname,
        lname: form.lname,
        phoneNumber: form.phoneNumber,
        password: form.password,
        role: form.role,
      }

      if (form.role === 'driver') {
        payload.licensePlate = form.licensePlate
        payload.carMake = form.carMake
        payload.carModel = form.carModel
        payload.carMpg = form.carMpg ? parseFloat(form.carMpg) : null
        payload.carMaxPassengers = parseInt(form.carMaxPassengers, 10)
      }

      const response = await fetch(`${API_BASE_URL}/api/auth/signup`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload),
      })

      if (!response.ok) {
        const errorBody = await response.json().catch(() => ({}))
        throw new Error(errorBody.message || 'Unable to sign up.')
      }

      const responsePayload = await response.json()
      if (responsePayload.token) {
        localStorage.setItem('cavrideshare_token', responsePayload.token)
        const userMeta = {
          id:
            responsePayload.user?.uvaId ||
            responsePayload.user?.uva_id ||
            responsePayload.user?.id ||
            responsePayload.user?.email ||
            form.uvaId,
          role: responsePayload.role || form.role,
        }
        localStorage.setItem('cavrideshare_user', JSON.stringify(userMeta))
        setTokenPreview(responsePayload.token)
      }

      setStatus({
        state: 'success',
        message: 'Account created! You are logged in—head to Home or Login to continue.',
      })
      setForm(initialForm)
    } catch (error) {
      setStatus({ state: 'error', message: error.message })
      setTokenPreview('')
    }
  }

  return (
    <section className="login-page">
      <div className="card">
        <h1>Create an account</h1>
        <p>
          Sign up with your UVA ID, provide your information, and we&apos;ll return a JWT so you can start using CavRideShare right away.
        </p>
        <form onSubmit={handleSubmit} className="login-form">
          <label>
            UVA ID
            <input
              type="text"
              name="uvaId"
              placeholder="ab1234c"
              required
              value={form.uvaId}
              onChange={handleChange}
            />
          </label>
          <label>
            First Name
            <input
              type="text"
              name="fname"
              placeholder="John"
              required
              value={form.fname}
              onChange={handleChange}
            />
          </label>
          <label>
            Last Name
            <input
              type="text"
              name="lname"
              placeholder="Doe"
              required
              value={form.lname}
              onChange={handleChange}
            />
          </label>
          <label>
            Phone Number
            <input
              type="tel"
              name="phoneNumber"
              placeholder="(434) 555-1234"
              required
              value={form.phoneNumber}
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
              value={form.password}
              onChange={handleChange}
            />
          </label>
          <label>
            Confirm Password
            <input
              type="password"
              name="confirmPassword"
              placeholder="••••••••"
              required
              value={form.confirmPassword}
              onChange={handleChange}
            />
          </label>
          <label>
            Role
            <select name="role" value={form.role} onChange={handleChange}>
              <option value="rider">Rider</option>
              <option value="driver">Driver (I have a car)</option>
            </select>
          </label>
          {form.role === 'driver' && (
            <>
              <label>
                License Plate
                <input
                  type="text"
                  name="licensePlate"
                  placeholder="AB-1234"
                  required
                  value={form.licensePlate}
                  onChange={handleChange}
                />
              </label>
              <label>
                Car Make
                <input
                  type="text"
                  name="carMake"
                  placeholder="Toyota"
                  required
                  value={form.carMake}
                  onChange={handleChange}
                />
              </label>
              <label>
                Car Model
                <input
                  type="text"
                  name="carModel"
                  placeholder="Camry"
                  required
                  value={form.carModel}
                  onChange={handleChange}
                />
              </label>
              <label>
                MPG (optional)
                <input
                  type="number"
                  name="carMpg"
                  placeholder="25.5"
                  step="0.1"
                  value={form.carMpg}
                  onChange={handleChange}
                />
              </label>
              <label>
                Max Passengers
                <input
                  type="number"
                  name="carMaxPassengers"
                  placeholder="5"
                  min="1"
                  required
                  value={form.carMaxPassengers}
                  onChange={handleChange}
                />
              </label>
            </>
          )}
          <button className="primary-btn" type="submit" disabled={status.state === 'loading'}>
            {status.state === 'loading' ? 'Submitting...' : 'Sign up'}
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
            We saved this token in <code>localStorage</code>. Use it immediately or just log in
            again—the credentials are stored in MySQL now.
          </p>
          <code className="token-preview">{tokenPreview}</code>
        </div>
      )}
    </section>
  )
}

export default Signup
