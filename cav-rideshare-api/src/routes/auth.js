const express = require('express')
const bcrypt = require('bcryptjs')
const jwt = require('jsonwebtoken')
const pool = require('../db/pool')

const router = express.Router()
const ALLOWED_ROLES = ['rider', 'driver']

router.post('/signup', async (req, res) => {
  const { uvaId, password, fname, lname, phoneNumber, role = 'rider' } = req.body

  if (!uvaId || !password || !fname || !lname || !phoneNumber) {
    return res.status(400).json({ message: 'UVA ID, password, first name, last name, and phone number are required' })
  }

  if (!ALLOWED_ROLES.includes(role)) {
    return res.status(400).json({ message: 'Role must be rider or driver' })
  }

  try {
    const [existing] = await pool.execute('SELECT uva_id FROM User WHERE uva_id = ? LIMIT 1', [
      uvaId,
    ])

    if (existing.length > 0) {
      return res.status(409).json({ message: 'Account already exists for this UVA ID' })
    }

    const passwordHash = await bcrypt.hash(password, 10)

    await pool.execute(
      `INSERT INTO User (uva_id, fname, lname, phone_number, password_hash)
       VALUES (?, ?, ?, ?, ?)`,
      [uvaId, fname, lname, phoneNumber, passwordHash],
    )

    if (role === 'driver') {
      const { licensePlate, carMake, carModel, carMpg, carMaxPassengers } = req.body
      if (!licensePlate || !carMake || !carModel || !carMaxPassengers) {
        await pool.execute('DELETE FROM User WHERE uva_id = ?', [uvaId])
        return res.status(400).json({ message: 'License plate, car make, car model, and max passengers are required for driver accounts' })
      }
      await pool.execute(
        `INSERT INTO Driver (uva_id, license_plate)
         VALUES (?, ?)`,
        [uvaId, licensePlate],
      )
      // Insert car record immediately
      await pool.execute(
        `INSERT INTO Car (license_plate, user_id, make, model, mpg, max_passengers)
         VALUES (?, ?, ?, ?, ?, ?)`,
        [licensePlate, uvaId, carMake, carModel, carMpg || null, carMaxPassengers],
      )
    }

    const token = jwt.sign(
      { sub: uvaId, role, fname, lname },
      process.env.JWT_SECRET || 'dev-secret',
      { expiresIn: '12h' },
    )

    return res.status(201).json({
      token,
      role,
      user: {
        uvaId,
        fname,
        lname,
        phoneNumber,
      },
    })
  } catch (error) {
    console.error('Failed to sign up user', error)
    return res.status(500).json({ message: 'Unable to create account. Check DB config.' })
  }
})

router.post('/login', async (req, res) => {
  const { uvaId, password } = req.body

  if (!uvaId || !password) {
    return res.status(400).json({ message: 'UVA ID and password are required' })
  }

  try {
    const [rows] = await pool.execute(
      'SELECT uva_id, fname, lname, phone_number, password_hash FROM User WHERE uva_id = ? LIMIT 1',
      [uvaId],
    )

    if (rows.length === 0) {
      return res.status(401).json({ message: 'Invalid UVA ID or password' })
    }

    const user = rows[0]
    const isValidPassword = await bcrypt.compare(password, user.password_hash || '')

    if (!isValidPassword) {
      return res.status(401).json({ message: 'Invalid UVA ID or password' })
    }

    const [driverRows] = await pool.execute(
      'SELECT uva_id FROM Driver WHERE uva_id = ? LIMIT 1',
      [uvaId],
    )
    const role = driverRows.length > 0 ? 'driver' : 'rider'

    const token = jwt.sign(
      { sub: user.uva_id, role, fname: user.fname, lname: user.lname },
      process.env.JWT_SECRET || 'dev-secret',
      { expiresIn: '12h' },
    )

    return res.json({
      token,
      role,
      user: {
        uvaId: user.uva_id,
        fname: user.fname,
        lname: user.lname,
        phoneNumber: user.phone_number,
      },
    })
  } catch (error) {
    console.error('Failed to log in', error)
    return res
      .status(500)
      .json({ message: 'Database unavailable. Check your MySQL config.' })
  }
})

router.get('/users/:uvaId', async (req, res) => {
  const { uvaId } = req.params

  try {
    const [rows] = await pool.execute(
      'SELECT uva_id, fname, lname FROM User WHERE uva_id = ? LIMIT 1',
      [uvaId],
    )

    if (rows.length === 0) {
      return res.status(404).json({ message: 'User not found' })
    }

    const user = rows[0]
    
    // Check if user is a driver
    const [driverRows] = await pool.execute(
      'SELECT uva_id FROM Driver WHERE uva_id = ? LIMIT 1',
      [uvaId],
    )
    const isDriver = driverRows.length > 0

    return res.json({
      uvaId: user.uva_id,
      fname: user.fname,
      lname: user.lname,
      isDriver,
    })
  } catch (error) {
    console.error('Failed to fetch user', error)
    return res.status(500).json({ message: 'Unable to fetch user information' })
  }
})

module.exports = router
