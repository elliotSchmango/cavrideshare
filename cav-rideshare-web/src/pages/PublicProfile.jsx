import { useEffect, useState } from 'react'
import { useParams } from 'react-router-dom'

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:4000'

function PublicProfile() {
  const { uvaId } = useParams()
  const [user, setUser] = useState(null)
  const [driverRatings, setDriverRatings] = useState(null)
  const [status, setStatus] = useState({ state: 'loading', message: 'Loading profile...' })

  useEffect(() => {
    const fetchProfile = async () => {
      try {
        // Fetch user info
        const userRes = await fetch(`${API_BASE_URL}/api/auth/users/${uvaId}`)
        if (!userRes.ok) {
          throw new Error('User not found')
        }
        const userData = await userRes.json()
        setUser(userData)

        // If driver, fetch ratings
        if (userData.isDriver) {
          const token = localStorage.getItem('cavrideshare_token')
          const ratingsRes = await fetch(`${API_BASE_URL}/api/reviews/driver/${uvaId}`, {
            headers: token ? { Authorization: `Bearer ${token}` } : {},
          })
          if (ratingsRes.ok) {
            const ratingsData = await ratingsRes.json()
            setDriverRatings(ratingsData)
          }
        }

        setStatus({ state: 'success', message: '' })
      } catch (err) {
        setStatus({ state: 'error', message: err.message })
      }
    }

    if (uvaId) {
      fetchProfile()
    }
  }, [uvaId])

  if (status.state === 'loading') {
    return (
      <section className="profile-page">
        <div className="card">
          <p className="status loading">{status.message}</p>
        </div>
      </section>
    )
  }

  if (status.state === 'error') {
    return (
      <section className="profile-page">
        <div className="card">
          <p className="status error">{status.message}</p>
        </div>
      </section>
    )
  }

  if (!user) {
    return (
      <section className="profile-page">
        <div className="card">
          <p className="status error">User not found</p>
        </div>
      </section>
    )
  }

  return (
    <section className="profile-page">
      <div className="card">
        <h1>
          {user.fname} {user.lname}
        </h1>

        <div style={{ marginBottom: '1.5rem', padding: '0.75rem 1rem', backgroundColor: '#e8f4f8', borderRadius: '4px', display: 'inline-block' }}>
          <strong>Role:</strong> {user.isDriver ? 'Driver' : 'Rider'}
        </div>

        {user.isDriver && driverRatings && (
          <div style={{ marginTop: '1.5rem', paddingTop: '1.5rem', borderTop: '1px solid #ddd' }}>
            <h2 style={{ marginBottom: '1rem' }}>Driver Information</h2>

            <div style={{ marginBottom: '1.5rem', padding: '1rem', backgroundColor: '#f9f9f9', borderRadius: '4px' }}>
              <div style={{ fontSize: '1.1rem', marginBottom: '0.5rem' }}>
                <strong>Average Rating:</strong> {'⭐'.repeat(Math.round(driverRatings.averageRating))} {driverRatings.averageRating}/5
              </div>
              <div>
                <strong>Total Reviews:</strong> {driverRatings.totalReviews}
              </div>
            </div>

            {driverRatings.reviews.length > 0 && (
              <div>
                <h3 style={{ marginBottom: '1rem' }}>Rider Reviews</h3>
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
          </div>
        )}
      </div>
    </section>
  )
}

export default PublicProfile
