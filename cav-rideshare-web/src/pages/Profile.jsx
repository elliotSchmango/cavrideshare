import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { formatLocalDateTime, formatLocalDateTimeForInput, formatLocalDateTimeWithTimezone } from '../utils/dateTime'

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:4000'

function Profile() {
  const [trips, setTrips] = useState([])
  const [vehicles, setVehicles] = useState([])
  const [status, setStatus] = useState({ state: 'idle', message: '' })
  const [cancelingTripId, setCancelingTripId] = useState(null)
  const [deletingTripId, setDeletingTripId] = useState(null)
  const [editingTripId, setEditingTripId] = useState(null)
  const [editData, setEditData] = useState({})
  const [activeTab, setActiveTab] = useState('upcoming')
  const [isDriver, setIsDriver] = useState(false)
  const [showAddVehicle, setShowAddVehicle] = useState(false)
  const [editingVehiclePlate, setEditingVehiclePlate] = useState(null)
  const [vehicleData, setVehicleData] = useState({ licensePlate: '', make: '', model: '', mpg: '', maxPassengers: '' })
  const [deletingVehiclePlate, setDeletingVehiclePlate] = useState(null)
  const [reviews, setReviews] = useState({})
  const [reviewingTripId, setReviewingTripId] = useState(null)
  const [reviewData, setReviewData] = useState({ stars: 5, comment: '' })
  const [editingReviewId, setEditingReviewId] = useState(null)
  const [driverInfo, setDriverInfo] = useState({})
  const [driverRatings, setDriverRatings] = useState(null)
  const navigate = useNavigate()

  useEffect(() => {
    const fetchTripsAndVehicles = async () => {
      setStatus({ state: 'loading', message: 'Loading your profile...' })
      const token = localStorage.getItem('cavrideshare_token')
      if (!token) {
        setStatus({ state: 'error', message: 'You must be logged in to view your profile.' })
        return
      }

      try {
        // Fetch trips
        const tripsRes = await fetch(`${API_BASE_URL}/api/trips/mine`, {
          headers: { Authorization: `Bearer ${token}` },
        })
        if (!tripsRes.ok) {
          const body = await tripsRes.json().catch(() => ({}))
          throw new Error(body.message || 'Failed to fetch trips')
        }
        const tripsData = await tripsRes.json()
        setTrips(tripsData)

        // Check user role and fetch vehicles if driver
        const userStr = localStorage.getItem('cavrideshare_user')
        if (userStr) {
          const user = JSON.parse(userStr)
          if (user.role === 'driver') {
            setIsDriver(true)
            const vehiclesRes = await fetch(`${API_BASE_URL}/api/vehicles`, {
              headers: { Authorization: `Bearer ${token}` },
            })
            if (vehiclesRes.ok) {
              const vehiclesData = await vehiclesRes.json()
              setVehicles(vehiclesData)
            }

            // Fetch driver ratings
            const ratingsRes = await fetch(`${API_BASE_URL}/api/reviews/driver/${user.id}`, {
              headers: { Authorization: `Bearer ${token}` },
            })
            if (ratingsRes.ok) {
              const ratingsData = await ratingsRes.json()
              setDriverRatings(ratingsData)
            }
          }
        }

        setStatus({ state: 'success', message: '' })
      } catch (err) {
        setStatus({ state: 'error', message: err.message })
      }
    }

    fetchTripsAndVehicles()
  }, [])

  // Fetch reviews and driver info for past rider trips
  useEffect(() => {
    const fetchReviewsAndDriverInfo = async () => {
      const token = localStorage.getItem('cavrideshare_token')
      if (!token) return

      try {
        const pastRiderTrips = trips.filter((t) => t.role === 'rider' && new Date(t.departure_time) <= new Date())
        
        for (const trip of pastRiderTrips) {
          // Fetch reviews
          const res = await fetch(`${API_BASE_URL}/api/reviews/trip/${trip.trip_id}`, {
            headers: { Authorization: `Bearer ${token}` },
          })
          if (res.ok) {
            const reviewsData = await res.json()
            setReviews((prev) => ({
              ...prev,
              [trip.trip_id]: reviewsData,
            }))
          }

          // Fetch driver info if we have a driver_id
          if (trip.driver_id && !driverInfo[trip.driver_id]) {
            try {
              const driverRes = await fetch(`${API_BASE_URL}/api/auth/users/${trip.driver_id}`, {
                headers: { Authorization: `Bearer ${token}` },
              })
              if (driverRes.ok) {
                const driverData = await driverRes.json()
                setDriverInfo((prev) => ({
                  ...prev,
                  [trip.driver_id]: driverData,
                }))
              }
            } catch (err) {
              console.error('Error fetching driver info:', err)
            }
          }
        }
      } catch (err) {
        console.error('Error fetching reviews:', err)
      }
    }

    if (trips.length > 0) {
      fetchReviewsAndDriverInfo()
    }
  }, [trips, driverInfo])

  const cancelBooking = async (tripId) => {
    const token = localStorage.getItem('cavrideshare_token')
    if (!token) {
      setStatus({ state: 'error', message: 'You must be logged in to cancel a booking.' })
      return
    }

    if (!confirm('Are you sure you want to cancel this booking?')) return

    try {
      setCancelingTripId(tripId)
      setStatus({ state: 'loading', message: 'Cancelling booking...' })
      const res = await fetch(`${API_BASE_URL}/api/trips/${tripId}/book`, {
        method: 'DELETE',
        headers: { Authorization: `Bearer ${token}` },
      })

      if (!res.ok) {
        const body = await res.json().catch(() => ({}))
        throw new Error(body.message || 'Failed to cancel booking')
      }

      setTrips((prev) => prev.filter((t) => !(t.trip_id === tripId && t.role === 'rider')))
      setStatus({ state: 'success', message: 'Booking cancelled.' })
    } catch (err) {
      setStatus({ state: 'error', message: err.message })
    } finally {
      setCancelingTripId(null)
    }
  }

  const startEditing = (trip) => {
    setEditingTripId(trip.trip_id)
    setEditData({
      startLocationId: trip.start_location_id,
      arrivalLocationId: trip.arrival_location_id,
      seatsAvailable: trip.seats_available,
      notes: trip.notes || '',
      departureTime: formatLocalDateTimeForInput(trip.departure_time),
    })
  }

  const saveTrip = async (tripId) => {
    const token = localStorage.getItem('cavrideshare_token')
    if (!token) {
      setStatus({ state: 'error', message: 'You must be logged in to edit a trip.' })
      return
    }

    try {
      setStatus({ state: 'loading', message: 'Saving trip...' })
      const res = await fetch(`${API_BASE_URL}/api/trips/${tripId}`, {
        method: 'PUT',
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          startLocationId: editData.startLocationId,
          arrivalLocationId: editData.arrivalLocationId,
          seatsAvailable: editData.seatsAvailable,
          notes: editData.notes,
          departureTime: editData.departureTime,
        }),
      })

      if (!res.ok) {
        const body = await res.json().catch(() => ({}))
        throw new Error(body.message || 'Failed to save trip')
      }

      setTrips((prev) =>
        prev.map((t) =>
          t.trip_id === tripId
            ? {
                ...t,
                seats_available: editData.seatsAvailable,
                notes: editData.notes,
                departure_time: editData.departureTime,
              }
            : t,
        ),
      )
      setEditingTripId(null)
      setStatus({ state: 'success', message: 'Trip updated successfully.' })
    } catch (err) {
      setStatus({ state: 'error', message: err.message })
    }
  }

  const deleteTrip = async (tripId) => {
    const token = localStorage.getItem('cavrideshare_token')
    if (!token) {
      setStatus({ state: 'error', message: 'You must be logged in to delete a trip.' })
      return
    }

    if (!window.confirm('Are you sure you want to delete this trip?')) return

    try {
      setDeletingTripId(tripId)
      setStatus({ state: 'loading', message: 'Deleting trip...' })
      const res = await fetch(`${API_BASE_URL}/api/trips/${tripId}`, {
        method: 'DELETE',
        headers: { Authorization: `Bearer ${token}` },
      })

      if (!res.ok) {
        const body = await res.json().catch(() => ({}))
        throw new Error(body.message || 'Failed to delete trip')
      }

      setTrips((prev) => prev.filter((t) => t.trip_id !== tripId))
      setStatus({ state: 'success', message: 'Trip deleted successfully.' })
    } catch (err) {
      setStatus({ state: 'error', message: err.message })
    } finally {
      setDeletingTripId(null)
    }
  }

  const addVehicle = async (e) => {
    e.preventDefault()
    const token = localStorage.getItem('cavrideshare_token')
    if (!token) {
      setStatus({ state: 'error', message: 'You must be logged in to add a vehicle.' })
      return
    }

    if (!vehicleData.licensePlate || !vehicleData.make || !vehicleData.model || vehicleData.maxPassengers === '') {
      setStatus({ state: 'error', message: 'Missing required fields' })
      return
    }

    try {
      setStatus({ state: 'loading', message: 'Adding vehicle...' })
      const res = await fetch(`${API_BASE_URL}/api/vehicles`, {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          licensePlate: vehicleData.licensePlate,
          make: vehicleData.make,
          model: vehicleData.model,
          mpg: vehicleData.mpg || null,
          maxPassengers: parseInt(vehicleData.maxPassengers, 10),
        }),
      })

      if (!res.ok) {
        const body = await res.json().catch(() => ({}))
        throw new Error(body.message || 'Failed to add vehicle')
      }

      const newVehicle = await res.json()
      setVehicles([...vehicles, newVehicle])
      setVehicleData({ licensePlate: '', make: '', model: '', mpg: '', maxPassengers: '' })
      setShowAddVehicle(false)
      setStatus({ state: 'success', message: 'Vehicle added successfully!' })
    } catch (err) {
      setStatus({ state: 'error', message: err.message })
    }
  }

  const updateVehicle = async (e) => {
    e.preventDefault()
    const token = localStorage.getItem('cavrideshare_token')
    if (!token) {
      setStatus({ state: 'error', message: 'You must be logged in to edit a vehicle.' })
      return
    }

    try {
      setStatus({ state: 'loading', message: 'Updating vehicle...' })
      const res = await fetch(`${API_BASE_URL}/api/vehicles/${editingVehiclePlate}`, {
        method: 'PUT',
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          make: vehicleData.make,
          model: vehicleData.model,
          mpg: vehicleData.mpg || null,
          maxPassengers: parseInt(vehicleData.maxPassengers, 10),
        }),
      })

      if (!res.ok) {
        const body = await res.json().catch(() => ({}))
        throw new Error(body.message || 'Failed to update vehicle')
      }

      setVehicles(
        vehicles.map((v) =>
          v.license_plate === editingVehiclePlate
            ? {
                ...v,
                make: vehicleData.make,
                model: vehicleData.model,
                mpg: vehicleData.mpg,
                max_passengers: vehicleData.maxPassengers,
              }
            : v,
        ),
      )
      setEditingVehiclePlate(null)
      setVehicleData({ licensePlate: '', make: '', model: '', mpg: '', maxPassengers: '' })
      setStatus({ state: 'success', message: 'Vehicle updated successfully!' })
    } catch (err) {
      setStatus({ state: 'error', message: err.message })
    }
  }

  const deleteVehicle = async (licensePlate) => {
    const token = localStorage.getItem('cavrideshare_token')
    if (!token) {
      setStatus({ state: 'error', message: 'You must be logged in to delete a vehicle.' })
      return
    }

    if (!window.confirm('Are you sure you want to delete this vehicle?')) return

    try {
      setDeletingVehiclePlate(licensePlate)
      setStatus({ state: 'loading', message: 'Deleting vehicle...' })
      const res = await fetch(`${API_BASE_URL}/api/vehicles/${licensePlate}`, {
        method: 'DELETE',
        headers: { Authorization: `Bearer ${token}` },
      })

      if (!res.ok) {
        const body = await res.json().catch(() => ({}))
        throw new Error(body.message || 'Failed to delete vehicle')
      }

      setVehicles(vehicles.filter((v) => v.license_plate !== licensePlate))
      setStatus({ state: 'success', message: 'Vehicle deleted successfully!' })
    } catch (err) {
      setStatus({ state: 'error', message: err.message })
    } finally {
      setDeletingVehiclePlate(null)
    }
  }

  const submitReview = async (e, tripId, driverId) => {
    e.preventDefault()
    const token = localStorage.getItem('cavrideshare_token')
    if (!token) {
      setStatus({ state: 'error', message: 'You must be logged in to submit a review.' })
      return
    }

    try {
      setStatus({ state: 'loading', message: 'Submitting review...' })
      const res = await fetch(`${API_BASE_URL}/api/reviews`, {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          tripId,
          stars: parseInt(reviewData.stars, 10),
          comment: reviewData.comment,
          revieweeId: driverId,
        }),
      })

      if (!res.ok) {
        const body = await res.json().catch(() => ({}))
        throw new Error(body.message || 'Failed to submit review')
      }

      const newReview = await res.json()
      setReviews((prev) => ({
        ...prev,
        [tripId]: [...(prev[tripId] || []), newReview],
      }))
      setReviewingTripId(null)
      setReviewData({ stars: 5, comment: '' })
      setStatus({ state: 'success', message: 'Review submitted successfully!' })
    } catch (err) {
      setStatus({ state: 'error', message: err.message })
    }
  }

  const deleteReview = async (reviewId, tripId) => {
    const token = localStorage.getItem('cavrideshare_token')
    if (!token) {
      setStatus({ state: 'error', message: 'You must be logged in to delete a review.' })
      return
    }

    if (!window.confirm('Are you sure you want to delete this review?')) return

    try {
      setStatus({ state: 'loading', message: 'Deleting review...' })
      const res = await fetch(`${API_BASE_URL}/api/reviews/${reviewId}`, {
        method: 'DELETE',
        headers: { Authorization: `Bearer ${token}` },
      })

      if (!res.ok) {
        const body = await res.json().catch(() => ({}))
        throw new Error(body.message || 'Failed to delete review')
      }

      setReviews((prev) => ({
        ...prev,
        [tripId]: prev[tripId].filter((r) => r.review_id !== reviewId),
      }))
      setStatus({ state: 'success', message: 'Review deleted successfully!' })
    } catch (err) {
      setStatus({ state: 'error', message: err.message })
    }
  }

  const upcomingTrips = trips.filter((t) => new Date(t.departure_time) > new Date())
  const pastTrips = trips.filter((t) => new Date(t.departure_time) <= new Date())

  return (
    <section className="profile-page">
      <div className="card">
        <h1>Your Profile</h1>
        
        <div className="tabs">
          <button
            className={`tab-button ${activeTab === 'upcoming' ? 'active' : ''}`}
            onClick={() => setActiveTab('upcoming')}
          >
            Upcoming Trips ({upcomingTrips.length})
          </button>
          <button
            className={`tab-button ${activeTab === 'past' ? 'active' : ''}`}
            onClick={() => setActiveTab('past')}
          >
            Past Trips ({pastTrips.length})
          </button>
        </div>

        {status.state === 'loading' && <p className="status loading">{status.message}</p>}
        {status.state === 'error' && <p className="status error">{status.message}</p>}

        {activeTab === 'upcoming' && (
          <>
            {status.state === 'success' && upcomingTrips.length === 0 && (
              <p>You have no upcoming trips.</p>
            )}

            {upcomingTrips.length > 0 && (
              <ul className="trip-list">
                {upcomingTrips.map((t) => {
                  const driver = driverInfo[t.driver_id]
                  const driverName = t.role === 'rider' && driver ? `${driver.fname} ${driver.lname}` : null
                  
                  return (
              <li key={t.trip_id} className="trip-item">
                <div className="trip-header">
                  <strong>{t.role.toUpperCase()}</strong>
                  <span className="trip-time">{formatLocalDateTimeWithTimezone(t.departure_time)}</span>
                  <div style={{ marginLeft: '1rem', display: 'flex', gap: '0.5rem' }}>
                    {t.role === 'rider' && (
                      <button
                        className="secondary-btn"
                        type="button"
                        onClick={() => cancelBooking(t.trip_id)}
                        disabled={cancelingTripId === t.trip_id}
                      >
                        {cancelingTripId === t.trip_id ? 'Cancelling...' : 'Cancel'}
                      </button>
                    )}
                    {t.role === 'driver' && !editingTripId && (
                      <>
                        <button
                          className="secondary-btn"
                          type="button"
                          onClick={() => startEditing(t)}
                        >
                          Edit
                        </button>
                        <button
                          className="secondary-btn danger"
                          type="button"
                          onClick={() => deleteTrip(t.trip_id)}
                          disabled={deletingTripId === t.trip_id}
                        >
                          {deletingTripId === t.trip_id ? 'Deleting...' : 'Delete'}
                        </button>
                      </>
                    )}
                  </div>
                </div>
                {editingTripId === t.trip_id ? (
                  <div className="trip-body edit-form">
                    <div>
                      <label>
                        <strong>Departure Time:</strong>
                        <input
                          type="datetime-local"
                          value={editData.departureTime || ''}
                          onChange={(e) =>
                            setEditData({ ...editData, departureTime: e.target.value })
                          }
                        />
                      </label>
                    </div>
                    <div>
                      <label>
                        <strong>Seats Available:</strong>
                        <input
                          type="number"
                          min="1"
                          value={editData.seatsAvailable || 0}
                          onChange={(e) =>
                            setEditData({
                              ...editData,
                              seatsAvailable: parseInt(e.target.value, 10),
                            })
                          }
                        />
                      </label>
                    </div>
                    <div>
                      <label>
                        <strong>Notes:</strong>
                        <textarea
                          value={editData.notes || ''}
                          onChange={(e) => setEditData({ ...editData, notes: e.target.value })}
                        />
                      </label>
                    </div>
                    <div style={{ display: 'flex', gap: '0.5rem', marginTop: '1rem' }}>
                      <button
                        className="primary-btn"
                        type="button"
                        onClick={() => saveTrip(t.trip_id)}
                      >
                        Save
                      </button>
                      <button
                        className="secondary-btn"
                        type="button"
                        onClick={() => setEditingTripId(null)}
                      >
                        Cancel
                      </button>
                    </div>
                  </div>
                ) : (
                  <div className="trip-body">
                    {driverName && (
                      <div style={{ marginBottom: '0.75rem', fontSize: '0.9rem', color: '#666' }}>
                        Driver: <strong>{driverName}</strong>
                      </div>
                    )}
                    <div>
                      <strong>From:</strong> {t.start_location_name || 'Unknown'}
                    </div>
                    <div>
                      <strong>To:</strong> {t.arrival_location_name || 'Unknown'}
                    </div>
                    <div>
                      <strong>Seats available:</strong> {t.seats_available}
                    </div>
                    {t.notes && (
                      <div>
                        <strong>Notes:</strong> {t.notes}
                      </div>
                    )}
                  </div>
                )}
              </li>
            )})}
          </ul>
            )}
          </>
        )}

        {activeTab === 'past' && (
          <>
            {status.state === 'success' && pastTrips.length === 0 && (
              <p>You have no past trips.</p>
            )}

            {pastTrips.length > 0 && (
              <ul className="trip-list">
                {pastTrips.map((t) => {
                  const tripReviews = reviews[t.trip_id] || []
                  const currentUser = JSON.parse(localStorage.getItem('cavrideshare_user') || '{}')
                  const currentUserReview = tripReviews.length > 0 ? tripReviews.find((r) => r.reviewer_id === currentUser.id) : null
                  const isRider = t.role === 'rider'
                  const driver = driverInfo[t.driver_id]
                  const driverName = driver ? `${driver.fname} ${driver.lname}` : 'Unknown Driver'
                  const hasReview = isRider && !!currentUserReview

                  return (
                    <li key={t.trip_id} className="trip-item">
                      <div className="trip-header">
                        <strong>{t.role.toUpperCase()}</strong>
                        <span className="trip-time">{formatLocalDateTimeWithTimezone(t.departure_time)}</span>
                        {hasReview && (
                          <span style={{ marginLeft: '1rem', fontSize: '1.2rem', title: 'You have reviewed this trip' }}>
                            ✓ Reviewed
                          </span>
                        )}
                      </div>
                      <div className="trip-body">
                        <div>
                          <strong>From:</strong> {t.start_location_name || 'Unknown'}
                        </div>
                        <div>
                          <strong>To:</strong> {t.arrival_location_name || 'Unknown'}
                        </div>
                        <div>
                          <strong>Seats available:</strong> {t.seats_available}
                        </div>
                        {t.notes && (
                          <div>
                            <strong>Notes:</strong> {t.notes}
                          </div>
                        )}

                        {isRider && (
                          <div style={{ marginTop: '1.5rem', paddingTop: '1rem', borderTop: '1px solid #ddd' }}>
                            <div style={{ marginBottom: '0.75rem', fontSize: '0.9rem', color: '#666' }}>
                              Driver: <strong>{driverName}</strong>
                            </div>
                            <strong style={{ display: 'block', marginBottom: '0.5rem' }}>Driver Rating</strong>

                            {currentUserReview ? (
                              <div style={{ backgroundColor: '#f5f5f5', padding: '1rem', borderRadius: '4px', marginBottom: '0.5rem' }}>
                                <div style={{ marginBottom: '0.5rem' }}>
                                  <strong>Your Rating:</strong> {'⭐'.repeat(currentUserReview.stars)} ({currentUserReview.stars}/5 stars)
                                </div>
                                {currentUserReview.comment && (
                                  <div style={{ marginBottom: '0.5rem', fontStyle: 'italic' }}>
                                    <strong>Your Comment:</strong> {currentUserReview.comment}
                                  </div>
                                )}
                                <button
                                  className="secondary-btn"
                                  type="button"
                                  onClick={() => deleteReview(currentUserReview.review_id, t.trip_id)}
                                  style={{ marginTop: '0.5rem' }}
                                >
                                  Delete Review
                                </button>
                              </div>
                            ) : reviewingTripId === t.trip_id ? (
                              <form onSubmit={(e) => submitReview(e, t.trip_id, t.driver_id)} style={{ marginBottom: '1rem' }}>
                                <div>
                                  <label>
                                    <strong>Stars:</strong>
                                    <select
                                      value={reviewData.stars}
                                      onChange={(e) => setReviewData({ ...reviewData, stars: e.target.value })}
                                    >
                                      <option value="5">5 Stars - Excellent</option>
                                      <option value="4">4 Stars - Good</option>
                                      <option value="3">3 Stars - Okay</option>
                                      <option value="2">2 Stars - Poor</option>
                                      <option value="1">1 Star - Terrible</option>
                                    </select>
                                  </label>
                                </div>
                                <div>
                                  <label>
                                    <strong>Comment (optional):</strong>
                                    <textarea
                                      value={reviewData.comment}
                                      onChange={(e) => setReviewData({ ...reviewData, comment: e.target.value })}
                                      placeholder="Share your experience..."
                                      rows="3"
                                    />
                                  </label>
                                </div>
                                <div style={{ display: 'flex', gap: '0.5rem', marginTop: '0.5rem' }}>
                                  <button className="primary-btn" type="submit">
                                    Submit Review
                                  </button>
                                  <button
                                    className="secondary-btn"
                                    type="button"
                                    onClick={() => {
                                      setReviewingTripId(null)
                                      setReviewData({ stars: 5, comment: '' })
                                    }}
                                  >
                                    Cancel
                                  </button>
                                </div>
                              </form>
                            ) : (
                              <button
                                className="primary-btn"
                                type="button"
                                onClick={() => setReviewingTripId(t.trip_id)}
                              >
                                Add Review
                              </button>
                            )}
                          </div>
                        )}
                      </div>
                    </li>
                  )
                })}
              </ul>
            )}
          </>
        )}
      </div>

      {isDriver && (
        <div className="card">
          <h2>Your Vehicles</h2>
          <p>Manage the vehicles you use for driving.</p>

          {vehicles.length === 0 && !showAddVehicle && (
            <p>You haven't added any vehicles yet.</p>
          )}

          {vehicles.length > 0 && (
            <ul className="trip-list">
              {vehicles.map((vehicle) => (
                <li key={vehicle.license_plate} className="trip-item">
                  <div className="trip-header">
                    <strong>
                      {vehicle.make} {vehicle.model}
                    </strong>
                    <span className="trip-time">{vehicle.license_plate}</span>
                    <div style={{ marginLeft: '1rem', display: 'flex', gap: '0.5rem' }}>
                      {editingVehiclePlate !== vehicle.license_plate && (
                        <>
                          <button
                            className="secondary-btn"
                            type="button"
                            onClick={() => {
                              setEditingVehiclePlate(vehicle.license_plate)
                              setVehicleData({
                                licensePlate: vehicle.license_plate,
                                make: vehicle.make,
                                model: vehicle.model,
                                mpg: vehicle.mpg || '',
                                maxPassengers: vehicle.max_passengers,
                              })
                            }}
                          >
                            Edit
                          </button>
                          <button
                            className="secondary-btn danger"
                            type="button"
                            onClick={() => deleteVehicle(vehicle.license_plate)}
                            disabled={deletingVehiclePlate === vehicle.license_plate}
                          >
                            {deletingVehiclePlate === vehicle.license_plate ? 'Deleting...' : 'Delete'}
                          </button>
                        </>
                      )}
                    </div>
                  </div>
                  {editingVehiclePlate === vehicle.license_plate ? (
                    <form className="trip-body" onSubmit={updateVehicle}>
                      <div>
                        <label>
                          <strong>Make:</strong>
                          <input
                            type="text"
                            value={vehicleData.make}
                            onChange={(e) => setVehicleData({ ...vehicleData, make: e.target.value })}
                            required
                          />
                        </label>
                      </div>
                      <div>
                        <label>
                          <strong>Model:</strong>
                          <input
                            type="text"
                            value={vehicleData.model}
                            onChange={(e) => setVehicleData({ ...vehicleData, model: e.target.value })}
                            required
                          />
                        </label>
                      </div>
                      <div>
                        <label>
                          <strong>MPG:</strong>
                          <input
                            type="number"
                            step="0.1"
                            value={vehicleData.mpg}
                            onChange={(e) => setVehicleData({ ...vehicleData, mpg: e.target.value })}
                          />
                        </label>
                      </div>
                      <div>
                        <label>
                          <strong>Max Passengers:</strong>
                          <input
                            type="number"
                            min="1"
                            value={vehicleData.maxPassengers}
                            onChange={(e) => setVehicleData({ ...vehicleData, maxPassengers: e.target.value })}
                            required
                          />
                        </label>
                      </div>
                      <div style={{ display: 'flex', gap: '0.5rem', marginTop: '1rem' }}>
                        <button className="primary-btn" type="submit">
                          Save
                        </button>
                        <button
                          className="secondary-btn"
                          type="button"
                          onClick={() => {
                            setEditingVehiclePlate(null)
                            setVehicleData({ licensePlate: '', make: '', model: '', mpg: '', maxPassengers: '' })
                          }}
                        >
                          Cancel
                        </button>
                      </div>
                    </form>
                  ) : (
                    <div className="trip-body">
                      <div>
                        <strong>License Plate:</strong> {vehicle.license_plate}
                      </div>
                      <div>
                        <strong>Make:</strong> {vehicle.make}
                      </div>
                      <div>
                        <strong>Model:</strong> {vehicle.model}
                      </div>
                      <div>
                        <strong>Max Passengers:</strong> {vehicle.max_passengers}
                      </div>
                      {vehicle.mpg && (
                        <div>
                          <strong>MPG:</strong> {vehicle.mpg}
                        </div>
                      )}
                    </div>
                  )}
                </li>
              ))}
            </ul>
          )}

          {showAddVehicle ? (
            <form className="trip-body" onSubmit={addVehicle} style={{ marginTop: '1rem' }}>
              <h3>Add New Vehicle</h3>
              <div>
                <label>
                  <strong>License Plate:</strong>
                  <input
                    type="text"
                    value={vehicleData.licensePlate}
                    onChange={(e) => setVehicleData({ ...vehicleData, licensePlate: e.target.value })}
                    required
                  />
                </label>
              </div>
              <div>
                <label>
                  <strong>Make:</strong>
                  <input
                    type="text"
                    value={vehicleData.make}
                    onChange={(e) => setVehicleData({ ...vehicleData, make: e.target.value })}
                    required
                  />
                </label>
              </div>
              <div>
                <label>
                  <strong>Model:</strong>
                  <input
                    type="text"
                    value={vehicleData.model}
                    onChange={(e) => setVehicleData({ ...vehicleData, model: e.target.value })}
                    required
                  />
                </label>
              </div>
              <div>
                <label>
                  <strong>MPG:</strong>
                  <input
                    type="number"
                    step="0.1"
                    value={vehicleData.mpg}
                    onChange={(e) => setVehicleData({ ...vehicleData, mpg: e.target.value })}
                  />
                </label>
              </div>
              <div>
                <label>
                  <strong>Max Passengers:</strong>
                  <input
                    type="number"
                    min="1"
                    value={vehicleData.maxPassengers}
                    onChange={(e) => setVehicleData({ ...vehicleData, maxPassengers: e.target.value })}
                    required
                  />
                </label>
              </div>
              <div style={{ display: 'flex', gap: '0.5rem', marginTop: '1rem' }}>
                <button className="primary-btn" type="submit">
                  Add Vehicle
                </button>
                <button
                  className="secondary-btn"
                  type="button"
                  onClick={() => {
                    setShowAddVehicle(false)
                    setVehicleData({ licensePlate: '', make: '', model: '', mpg: '', maxPassengers: '' })
                  }}
                >
                  Cancel
                </button>
              </div>
            </form>
          ) : (
            <button className="primary-btn" type="button" onClick={() => setShowAddVehicle(true)}>
              Add Vehicle
            </button>
          )}
        </div>
      )}

      {isDriver && driverRatings && (
        <div className="card">
          <h2>Your Driver Ratings</h2>
          <p>Here's what riders think about your service.</p>

          {driverRatings.totalReviews === 0 ? (
            <p>You don't have any ratings yet. Complete trips and ask riders to leave reviews!</p>
          ) : (
            <>
              <div style={{ marginBottom: '1.5rem', padding: '1rem', backgroundColor: '#f9f9f9', borderRadius: '4px' }}>
                <div style={{ fontSize: '1.2rem', marginBottom: '0.5rem' }}>
                  <strong>Average Rating:</strong> {'⭐'.repeat(Math.round(driverRatings.averageRating))} {driverRatings.averageRating}/5
                </div>
                <div>
                  <strong>Total Reviews:</strong> {driverRatings.totalReviews}
                </div>
              </div>

              {driverRatings.reviews.length > 0 && (
                <div>
                  <h3 style={{ marginTop: '1.5rem', marginBottom: '1rem' }}>Rider Reviews</h3>
                  <ul className="trip-list">
                    {driverRatings.reviews.map((review) => (
                      <li key={review.review_id} className="trip-item">
                        <div className="trip-header">
                          <strong>{review.fname} {review.lname}</strong>
                          <span style={{ marginLeft: '1rem', fontSize: '1rem' }}>
                            {'⭐'.repeat(review.stars)}
                          </span>
                        </div>
                        {review.comment && (
                          <div className="trip-body">
                            <div style={{ fontStyle: 'italic', color: '#666' }}>
                              "{review.comment}"
                            </div>
                          </div>
                        )}
                      </li>
                    ))}
                  </ul>
                </div>
              )}
            </>
          )}
        </div>
      )}
    </section>
  )
}

export default Profile

