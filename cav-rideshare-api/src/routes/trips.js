const express = require('express')
const pool = require('../db/pool')
const { authenticate, authorizeRoles } = require('../middleware/auth')

const router = express.Router()

router.get('/', authenticate, async (req, res) => {
  const { startLocationId, arrivalLocationId, after, before, minSeats } = req.query
  const conditions = []
  const params = []

  if (startLocationId) {
    conditions.push('t.start_location = ?')
    params.push(startLocationId)
  }
  if (arrivalLocationId) {
    conditions.push('t.arrival_location = ?')
    params.push(arrivalLocationId)
  }
  if (after) {
    conditions.push('t.departure_time >= ?')
    params.push(after)
  }
  if (before) {
    conditions.push('t.departure_time <= ?')
    params.push(before)
  }
  if (minSeats) {
    conditions.push('t.seats_available >= ?')
    params.push(minSeats)
  }

  const whereClause = conditions.length ? `WHERE ${conditions.join(' AND ')}` : ''

  try {
    const [rows] = await pool.execute(
      `SELECT t.trip_id, t.departure_time, t.arrival_time, t.trip_duration,
              t.seats_available, t.notes,
              l1.location_id as start_location_id, l1.name as start_location_name,
              l2.location_id as arrival_location_id, l2.name as arrival_location_name,
              d.uva_id as driver_id
       FROM Trips t
       LEFT JOIN Location l1 ON t.start_location = l1.location_id
       LEFT JOIN Location l2 ON t.arrival_location = l2.location_id
       LEFT JOIN Drives d ON t.trip_id = d.trip_id
       ${whereClause}
       ORDER BY t.departure_time ASC`,
      params,
    )
    res.json(rows)
  } catch (error) {
    console.error('Failed to load trips', error)
    res.status(500).json({ message: 'Unable to load trips from MySQL' })
  }
})

router.post(
  '/',
  authenticate,
  authorizeRoles('driver', 'admin'),
  async (req, res) => {
    const { startLocationId, arrivalLocationId, departureTime, seatsAvailable, notes } = req.body

    if (!startLocationId || !arrivalLocationId || !departureTime || seatsAvailable === undefined) {
      return res.status(400).json({ message: 'Missing required trip fields: startLocationId, arrivalLocationId, departureTime, seatsAvailable' })
    }

    try {
      if (req.user.role !== 'admin') {
        const [driverCheck] = await pool.execute(
          'SELECT uva_id FROM Driver WHERE uva_id = ?',
          [req.user.sub],
        )

        if (driverCheck.length === 0) {
          return res.status(403).json({ message: 'User is not registered as a driver' })
        }
      }

      const [startLoc] = await pool.execute(
        'SELECT location_id FROM Location WHERE location_id = ?',
        [startLocationId],
      )
      const [arrivalLoc] = await pool.execute(
        'SELECT location_id FROM Location WHERE location_id = ?',
        [arrivalLocationId],
      )

      if (startLoc.length === 0 || arrivalLoc.length === 0) {
        return res.status(400).json({ message: 'Start location or arrival location does not exist' })
      }

      const [result] = await pool.execute(
        `INSERT INTO Trips (departure_time, arrival_location, seats_available, notes, start_location)
         VALUES (?, ?, ?, ?, ?)`,
        [
          departureTime,
          arrivalLocationId,
          seatsAvailable,
          notes || null,
          startLocationId,
        ],
      )

      await pool.execute(
        'INSERT INTO Drives (uva_id, trip_id) VALUES (?, ?)',
        [req.user.sub, result.insertId],
      )

      res.status(201).json({
        trip_id: result.insertId,
        driver_id: req.user.sub,
        start_location_id: startLocationId,
        arrival_location_id: arrivalLocationId,
        departure_time: departureTime,
        seats_available: seatsAvailable,
        notes: notes || null,
      })
    } catch (error) {
      console.error('Failed to create trip', error)
      res.status(500).json({ message: 'Unable to create trip. Confirm DB user permissions.' })
    }
  },
)

router.post(
  '/:tripId/book',
  authenticate,
  async (req, res) => {
    const { tripId } = req.params

    try {
      const [tripCheck] = await pool.execute(
        'SELECT trip_id, seats_available FROM Trips WHERE trip_id = ?',
        [tripId],
      )

      if (tripCheck.length === 0) {
        return res.status(404).json({ message: 'Trip not found' })
      }

      const trip = tripCheck[0]


      if (trip.seats_available <= 0) {
        return res.status(400).json({ message: 'No seats available on this trip' })
      }

      const [existingBooking] = await pool.execute(
        'SELECT uva_id FROM Rides_In WHERE uva_id = ? AND trip_id = ?',
        [req.user.sub, tripId],
      )

      if (existingBooking.length > 0) {
        return res.status(409).json({ message: 'Already booked on this trip' })
      }

      await pool.execute(
        'INSERT INTO Rides_In (uva_id, trip_id) VALUES (?, ?)',
        [req.user.sub, tripId],
      )

      await pool.execute(
        'UPDATE Trips SET seats_available = seats_available - 1 WHERE trip_id = ?',
        [tripId],
      )

      res.status(201).json({ message: 'Successfully booked trip' })
    } catch (error) {
      console.error('Failed to book trip', error)
      res.status(500).json({ message: 'Unable to book trip' })
    }
  },
)

router.get('/mine', authenticate, async (req, res) => {
  const uvaId = req.user.sub

  try {
    const [rows] = await pool.execute(
      `
      SELECT t.trip_id, t.departure_time, t.arrival_time, t.trip_duration,
             t.seats_available, t.notes,
             l1.location_id as start_location_id, l1.name as start_location_name,
             l2.location_id as arrival_location_id, l2.name as arrival_location_name,
             'driver' as role, NULL as driver_id
      FROM Trips t
      JOIN Drives d ON t.trip_id = d.trip_id
      LEFT JOIN Location l1 ON t.start_location = l1.location_id
      LEFT JOIN Location l2 ON t.arrival_location = l2.location_id
      WHERE d.uva_id = ?

      UNION ALL

      SELECT t.trip_id, t.departure_time, t.arrival_time, t.trip_duration,
             t.seats_available, t.notes,
             l1.location_id as start_location_id, l1.name as start_location_name,
             l2.location_id as arrival_location_id, l2.name as arrival_location_name,
             'rider' as role, d.uva_id as driver_id
      FROM Trips t
      JOIN Rides_In r ON t.trip_id = r.trip_id
      LEFT JOIN Drives d ON t.trip_id = d.trip_id
      LEFT JOIN Location l1 ON t.start_location = l1.location_id
      LEFT JOIN Location l2 ON t.arrival_location = l2.location_id
      WHERE r.uva_id = ?

      ORDER BY departure_time DESC
      `,
      [uvaId, uvaId],
    )

    res.json(rows)
  } catch (error) {
    console.error('Failed to load user trips', error)
    res.status(500).json({ message: 'Unable to load user trips' })
  }
})

router.delete('/:tripId/book', authenticate, async (req, res) => {
  const { tripId } = req.params
  const uvaId = req.user.sub

  try {
    const [delResult] = await pool.execute(
      'DELETE FROM Rides_In WHERE uva_id = ? AND trip_id = ?',
      [uvaId, tripId],
    )

    if (!delResult.affectedRows) {
      return res.status(404).json({ message: 'Booking not found' })
    }

    await pool.execute('UPDATE Trips SET seats_available = seats_available + 1 WHERE trip_id = ?', [tripId])

    return res.json({ message: 'Booking cancelled' })
  } catch (error) {
    console.error('Failed to cancel booking', error)
    return res.status(500).json({ message: 'Unable to cancel booking' })
  }
})

router.put(
  '/:tripId',
  authenticate,
  authorizeRoles('driver', 'admin'),
  async (req, res) => {
    const { tripId } = req.params
    const { startLocationId, arrivalLocationId, departureTime, seatsAvailable, notes } = req.body

    if (!startLocationId || !arrivalLocationId || !departureTime || seatsAvailable === undefined) {
      return res
        .status(400)
        .json({ message: 'Missing required trip fields: startLocationId, arrivalLocationId, departureTime, seatsAvailable' })
    }

    try {
      const [tripRows] = await pool.execute(
        'SELECT d.uva_id FROM Trips t JOIN Drives d ON t.trip_id = d.trip_id WHERE t.trip_id = ? LIMIT 1',
        [tripId],
      )

      if (tripRows.length === 0) {
        return res.status(404).json({ message: 'Trip not found' })
      }

      const driverId = tripRows[0].uva_id
      const isOwner = driverId === req.user.sub
      const isAdmin = req.user.role === 'admin'

      if (!isOwner && !isAdmin) {
        return res.status(403).json({ message: 'You cannot edit this trip' })
      }

      const [startLoc] = await pool.execute(
        'SELECT location_id FROM Location WHERE location_id = ?',
        [startLocationId],
      )
      const [arrivalLoc] = await pool.execute(
        'SELECT location_id FROM Location WHERE location_id = ?',
        [arrivalLocationId],
      )

      if (startLoc.length === 0 || arrivalLoc.length === 0) {
        return res.status(400).json({ message: 'Start location or arrival location does not exist' })
      }

      await pool.execute(
        `UPDATE Trips
         SET departure_time = ?, arrival_location = ?, seats_available = ?, notes = ?, start_location = ?
         WHERE trip_id = ?`,
        [departureTime, arrivalLocationId, seatsAvailable, notes || null, startLocationId, tripId],
      )

      res.json({
        trip_id: Number(tripId),
        driver_id: driverId,
        start_location_id: startLocationId,
        arrival_location_id: arrivalLocationId,
        departure_time: departureTime,
        seats_available: seatsAvailable,
        notes: notes || null,
      })
    } catch (error) {
      console.error('Failed to update trip', error)
      res.status(500).json({ message: 'Unable to update trip' })
    }
  },
)

router.delete(
  '/:tripId',
  authenticate,
  authorizeRoles('driver', 'admin'),
  async (req, res) => {
    const { tripId } = req.params

    try {
      const [tripRows] = await pool.execute(
        'SELECT d.uva_id FROM Trips t JOIN Drives d ON t.trip_id = d.trip_id WHERE t.trip_id = ? LIMIT 1',
        [tripId],
      )

      if (tripRows.length === 0) {
        return res.status(404).json({ message: 'Trip not found' })
      }

      const driverId = tripRows[0].uva_id
      const isOwner = driverId === req.user.sub
      const isAdmin = req.user.role === 'admin'

      if (!isOwner && !isAdmin) {
        return res.status(403).json({ message: 'You cannot delete this trip' })
      }

      await pool.execute('DELETE FROM Rides_In WHERE trip_id = ?', [tripId])
      await pool.execute('DELETE FROM Drives WHERE trip_id = ?', [tripId])
      await pool.execute('DELETE FROM Trips WHERE trip_id = ?', [tripId])

      res.json({ message: 'Trip deleted', id: Number(tripId) })
    } catch (error) {
      console.error('Failed to delete trip', error)
      res.status(500).json({ message: 'Unable to delete trip' })
    }
  },
)

module.exports = router
