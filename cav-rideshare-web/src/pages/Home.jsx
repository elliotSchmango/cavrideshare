import { useEffect, useMemo, useState } from 'react'
import { useNavigate, Link } from 'react-router-dom'
import { formatLocalDateTime, formatLocalDateTimeForInput } from '../utils/dateTime'

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:4000'

const initialTripPayload = {
  startLocationId: '',
  arrivalLocationId: '',
  departureTime: '',
  seatsAvailable: 1,
  notes: '',
}

function Home() {
  const [isFormVisible, setFormVisible] = useState(false)
  const [tripPayload, setTripPayload] = useState(initialTripPayload)
  const [tripStatus, setTripStatus] = useState({ state: 'idle', message: '' })
  const [trips, setTrips] = useState([])
  const [locations, setLocations] = useState([])
  const [editingTripId, setEditingTripId] = useState(null)
  const [loadingTrips, setLoadingTrips] = useState(false)
  const [joinedTrips, setJoinedTrips] = useState(new Set())
  const [joiningTripId, setJoiningTripId] = useState(null)
  const [isAuthenticated, setIsAuthenticated] = useState(
    Boolean(localStorage.getItem('cavrideshare_token')),
  )
  const [filters, setFilters] = useState({
    startLocationId: '',
    arrivalLocationId: '',
    minSeats: '',
    after: '',
    before: '',
  })
  const navigate = useNavigate()

  const storedUser = useMemo(() => {
    try {
      const userJson = JSON.parse(localStorage.getItem('cavrideshare_user') || '{}')
      if (userJson.id && userJson.role) return userJson

      const token = localStorage.getItem('cavrideshare_token')
      if (!token) return {}
      const [, payloadB64] = token.split('.')
      if (!payloadB64) return userJson
      const payload = JSON.parse(atob(payloadB64))
      return {
        id: payload.sub || userJson.id,
        role: payload.role || userJson.role,
      }
    } catch {
      return {}
    }
  }, [])

  const heroCTA = useMemo(
    () => {
      const actions = []
      if (isAuthenticated && storedUser.role === 'driver') {
        actions.push({ label: 'New Trip', primary: true })
      }
      if (!isAuthenticated) {
        actions.push(
          { label: 'Log In', href: '/login', primary: false },
          { label: 'Sign Up', href: '/signup', primary: false },
        )
      }
      return {
        title: 'Share the ride, cut the cost.',
        subtitle:
          'Post a trip, pick up classmates, and get to Grounds faster with CavRideShare.',
        actions,
      }
    },
    [isAuthenticated, storedUser.role],
  )

  const locationMap = useMemo(() => {
    const map = new Map()
    locations.forEach((loc) => map.set(loc.location_id, loc))
    return map
  }, [locations])

  const futureTrips = useMemo(() => {
    const now = new Date()
    return trips.filter((trip) => {
      const departureTime = new Date(trip.departure_time)
      return departureTime > now
    })
  }, [trips])

  const canManageTrip = (trip) => {
    if (!storedUser?.role) return false
    if (storedUser.role === 'admin') return true
    return storedUser.role === 'driver' && trip.driver_id === storedUser.id
  }

  const fetchWithAuth = async (path, options = {}) => {
    const token = localStorage.getItem('cavrideshare_token')
    if (!token) {
      throw new Error('Log in to continue')
    }
    return fetch(`${API_BASE_URL}${path}`, {
      ...options,
      headers: {
        ...(options.headers || {}),
        Authorization: `Bearer ${token}`,
        'Content-Type': 'application/json',
      },
    })
  }

  const loadLocations = async () => {
    try {
      const response = await fetchWithAuth('/api/locations')
      if (!response.ok) throw new Error('Failed to load locations')
      const data = await response.json()
      setLocations(data)
    } catch (error) {
      console.error(error)
      setLocations([])
    }
  }

  const loadTrips = async (appliedFilters = filters) => {
    setLoadingTrips(true)
    try {
      const params = new URLSearchParams()
      if (appliedFilters.startLocationId) params.set('startLocationId', appliedFilters.startLocationId)
      if (appliedFilters.arrivalLocationId) params.set('arrivalLocationId', appliedFilters.arrivalLocationId)
      if (appliedFilters.minSeats) params.set('minSeats', appliedFilters.minSeats)
      if (appliedFilters.after) params.set('after', appliedFilters.after)
      if (appliedFilters.before) params.set('before', appliedFilters.before)

      const query = params.toString() ? `?${params.toString()}` : ''
      const response = await fetchWithAuth(`/api/trips${query}`)
      if (!response.ok) throw new Error('Unable to load trips')
      const data = await response.json()
      setTrips(data)
    } catch (error) {
      console.error(error)
      setTripStatus({ state: 'error', message: error.message })
    } finally {
      setLoadingTrips(false)
    }
  }

  const loadUserJoinedTrips = async () => {
    try {
      const response = await fetchWithAuth('/api/trips/mine')
      if (!response.ok) throw new Error('Unable to load your trips')
      const data = await response.json()
      const joined = new Set(
        data.filter((trip) => trip.role === 'rider').map((trip) => trip.trip_id),
      )
      setJoinedTrips(joined)
    } catch (error) {
      console.error('Failed to load joined trips', error)
    }
  }

  useEffect(() => {
    loadLocations()
    loadTrips()
    if (isAuthenticated) {
      loadUserJoinedTrips()
    }
  }, [])

  useEffect(() => {
    const onAuthChange = () => {
      const authenticated = Boolean(localStorage.getItem('cavrideshare_token'))
      setIsAuthenticated(authenticated)
      if (authenticated) {
        loadUserJoinedTrips()
      } else {
        setJoinedTrips(new Set())
      }
    }
    window.addEventListener('storage', onAuthChange)
    window.addEventListener('login', onAuthChange)
    window.addEventListener('logout', onAuthChange)
    return () => {
      window.removeEventListener('storage', onAuthChange)
      window.removeEventListener('login', onAuthChange)
      window.removeEventListener('logout', onAuthChange)
    }
  }, [])

  const handleFilterChange = (event) => {
    const { name, value } = event.target
    setFilters((prev) => ({ ...prev, [name]: value }))
  }

  const applyFilters = () => {
    loadTrips(filters)
  }

  const clearFilters = () => {
    const cleared = {
      startLocationId: '',
      arrivalLocationId: '',
      minSeats: '',
      after: '',
      before: '',
    }
    setFilters(cleared)
    loadTrips(cleared)
  }

  const handleChange = (event) => {
    const { name, value } = event.target
    setTripPayload((prev) => ({
      ...prev,
      [name]: name === 'seatsAvailable' ? Number(value) : value,
    }))
  }

  const handleSubmit = async (event) => {
    event.preventDefault()
    setTripStatus({
      state: 'loading',
      message: editingTripId ? 'Updating trip...' : 'Creating trip...',
    })

    try {
      const endpoint = editingTripId ? `/api/trips/${editingTripId}` : '/api/trips'
      const method = editingTripId ? 'PUT' : 'POST'

      const response = await fetchWithAuth(endpoint, {
        method,
        body: JSON.stringify(tripPayload),
      })

      if (!response.ok) {
        const errorBody = await response.json().catch(() => ({}))
        throw new Error(errorBody.message || 'Unable to save trip')
      }

      setTripPayload(initialTripPayload)
      setEditingTripId(null)
      setTripStatus({
        state: 'success',
        message: editingTripId ? 'Trip updated' : 'Trip created',
      })
      setFormVisible(false)
      await loadTrips()
    } catch (error) {
      setTripStatus({
        state: 'error',
        message: error.message || 'Unexpected error',
      })
    }
  }

  const handleEdit = (trip) => {
    setEditingTripId(trip.trip_id)
    setTripPayload({
      startLocationId: trip.start_location_id,
      arrivalLocationId: trip.arrival_location_id,
      departureTime: formatLocalDateTimeForInput(trip.departure_time),
      seatsAvailable: trip.seats_available,
      notes: trip.notes || '',
    })
    setFormVisible(true)
    setTripStatus({ state: 'idle', message: '' })
  }

  const handleDelete = async (tripId) => {
    if (!window.confirm('Delete this trip?')) return
    try {
      const response = await fetchWithAuth(`/api/trips/${tripId}`, { method: 'DELETE' })
      if (!response.ok) {
        const errorBody = await response.json().catch(() => ({}))
        throw new Error(errorBody.message || 'Unable to delete trip')
      }
      await loadTrips()
    } catch (error) {
      setTripStatus({ state: 'error', message: error.message })
    }
  }

  const handleJoinTrip = async (tripId) => {
    setJoiningTripId(tripId)
    try {
      const response = await fetchWithAuth(`/api/trips/${tripId}/book`, { method: 'POST' })
      if (!response.ok) {
        const errorBody = await response.json().catch(() => ({}))
        throw new Error(errorBody.message || 'Unable to join trip')
      }
      setJoinedTrips((prev) => new Set([...prev, tripId]))
      setTripStatus({ state: 'success', message: 'Successfully joined trip!' })
      await loadTrips()
    } catch (error) {
      setTripStatus({ state: 'error', message: error.message })
    } finally {
      setJoiningTripId(null)
    }
  }

  return (
    <section className="home">
      <div className="hero-card">
        <p className="hero-kicker">Ride smarter</p>
        <h1>{heroCTA.title}</h1>
        <p className="hero-subtitle">{heroCTA.subtitle}</p>
        <div className="hero-actions">
          {heroCTA.actions[0]?.label === 'New Trip' && (
            <button
              className="primary-btn"
              onClick={() => {
                setFormVisible((prev) => !prev)
                setEditingTripId(null)
                setTripPayload(initialTripPayload)
              }}
            >
              {isFormVisible ? 'Close Trip Form' : 'New Trip'}
            </button>
          )}
          {heroCTA.actions[0]?.label === 'Log In' && (
            <a className="primary-btn" href={heroCTA.actions[0].href}>
              {heroCTA.actions[0].label}
            </a>
          )}
          {heroCTA.actions[1] && (
            <a className="secondary-btn" href={heroCTA.actions[1].href}>
              {heroCTA.actions[1].label}
            </a>
          )}
          {heroCTA.actions[2] && (
            <a className="secondary-btn" href={heroCTA.actions[2].href}>
              {heroCTA.actions[2].label}
            </a>
          )}
        </div>
      </div>

      {isFormVisible && (
        <form className="trip-form" onSubmit={handleSubmit}>
          <h2>{editingTripId ? 'Edit Trip' : 'New Trip'}</h2>
          <label>
            Start Location
            <select
              name="startLocationId"
              required
              value={tripPayload.startLocationId}
              onChange={handleChange}
            >
              <option value="">Select a location</option>
              {locations.map((loc) => (
                <option key={loc.location_id} value={loc.location_id}>
                  {loc.name}
                </option>
              ))}
            </select>
          </label>
          <label>
            Destination
            <select
              name="arrivalLocationId"
              required
              value={tripPayload.arrivalLocationId}
              onChange={handleChange}
            >
              <option value="">Select a destination</option>
              {locations.map((loc) => (
                <option key={loc.location_id} value={loc.location_id}>
                  {loc.name}
                </option>
              ))}
            </select>
          </label>
          <label>
            Departure Time
            <input
              type="datetime-local"
              name="departureTime"
              required
              value={tripPayload.departureTime}
              onChange={handleChange}
            />
          </label>
          <label>
            Seats Available
            <input
              type="number"
              min="1"
              max="8"
              name="seatsAvailable"
              required
              value={tripPayload.seatsAvailable}
              onChange={handleChange}
            />
          </label>
          <label>
            Notes
            <textarea
              name="notes"
              placeholder="Detour? Parking info? Playlist requests?"
              rows="3"
              value={tripPayload.notes}
              onChange={handleChange}
            />
          </label>

          <button
            className="primary-btn"
            type="submit"
            disabled={tripStatus.state === 'loading'}
          >
            {tripStatus.state === 'loading'
              ? 'Submitting...'
              : editingTripId
                ? 'Update Trip'
                : 'Launch Trip'}
          </button>

          {tripStatus.state !== 'idle' && (
            <p className={`status ${tripStatus.state}`}>{tripStatus.message}</p>
          )}
        </form>
      )}

      <div className="card">
        <div className="filter-bar">
          <div className="filter-row">
            <label>
              Start
              <select name="startLocationId" value={filters.startLocationId} onChange={handleFilterChange}>
                <option value="">Any</option>
                {locations.map((loc) => (
                  <option key={loc.location_id} value={loc.location_id}>
                    {loc.name}
                  </option>
                ))}
              </select>
            </label>
            <label>
              Destination
              <select name="arrivalLocationId" value={filters.arrivalLocationId} onChange={handleFilterChange}>
                <option value="">Any</option>
                {locations.map((loc) => (
                  <option key={loc.location_id} value={loc.location_id}>
                    {loc.name}
                  </option>
                ))}
              </select>
            </label>
            <label>
              Min seats
              <input
                type="number"
                name="minSeats"
                min="1"
                value={filters.minSeats}
                onChange={handleFilterChange}
              />
            </label>
            <label>
              Earliest
              <input type="datetime-local" name="after" value={filters.after} onChange={handleFilterChange} />
            </label>
            <label>
              Latest
              <input type="datetime-local" name="before" value={filters.before} onChange={handleFilterChange} />
            </label>
          </div>
          <div className="filter-actions">
            <button type="button" className="primary-btn" onClick={applyFilters}>
              Apply filters
            </button>
            <button type="button" className="ghost-btn" onClick={clearFilters}>
              Reset
            </button>
          </div>
        </div>

        <div className="trip-list-header">
          <h2>Available Trips</h2>
          {loadingTrips && <span className="muted">Loading...</span>}
        </div>
        <div className="trip-table-wrapper">
          <table className="trip-table">
            <thead>
              <tr>
                <th>Start</th>
                <th>Destination</th>
                <th>Depart</th>
                <th>Seats</th>
                <th>Driver</th>
                <th>Notes</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {futureTrips.map((trip) => {
                const start = locationMap.get(trip.start_location_id)
                const dest = locationMap.get(trip.arrival_location_id)
                return (
                  <tr key={trip.trip_id}>
                    <td>{start?.name || trip.start_location_id}</td>
                    <td>{dest?.name || trip.arrival_location_id}</td>
                    <td>{formatLocalDateTime(trip.departure_time)}</td>
                    <td>{trip.seats_available}</td>
                    <td>
                      {trip.driver_id ? (
                        <Link to={`/user/${trip.driver_id}`} style={{ color: '#0066cc', textDecoration: 'none' }}>
                          {trip.driver_id}
                        </Link>
                      ) : (
                        '—'
                      )}
                    </td>
                    <td>{trip.notes || '—'}</td>
                    <td className="row-actions">
                      {canManageTrip(trip) ? (
                        <>
                          <button
                            type="button"
                            className="ghost-btn"
                            onClick={() => handleEdit(trip)}
                          >
                            Edit
                          </button>
                          <button
                            type="button"
                            className="ghost-btn danger"
                            onClick={() => handleDelete(trip.trip_id)}
                          >
                            Delete
                          </button>
                        </>
                      ) : (
                        <>
                          {isAuthenticated && joinedTrips.has(trip.trip_id) && (
                            <span className="muted">Joined</span>
                          )}
                          {isAuthenticated && !joinedTrips.has(trip.trip_id) && (
                            <button
                              type="button"
                              className="ghost-btn"
                              onClick={() => handleJoinTrip(trip.trip_id)}
                              disabled={joiningTripId === trip.trip_id}
                            >
                              {joiningTripId === trip.trip_id ? 'Joining...' : 'Join'}
                            </button>
                          )}
                          {!isAuthenticated && (
                            <span className="muted">View</span>
                          )}
                        </>
                      )}
                    </td>
                  </tr>
                )
              })}
              {futureTrips.length === 0 && (
                <tr>
                  <td colSpan="7" className="muted">
                    {isAuthenticated
                      ? 'No upcoming trips. Be the first to post.'
                      : 'Log in to see upcoming trips'}
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>
    </section>
  )
}

export default Home
