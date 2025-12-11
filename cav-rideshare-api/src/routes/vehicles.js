const express = require('express')
const pool = require('../db/pool')
const { authenticate } = require('../middleware/auth')

const router = express.Router()

router.get('/', authenticate, async (req, res) => {
  const uvaId = req.user.sub

  try {
    const [rows] = await pool.execute(
      'SELECT license_plate, make, model, mpg, max_passengers FROM Car WHERE user_id = ?',
      [uvaId],
    )
    res.json(rows)
  } catch (error) {
    console.error('Failed to fetch vehicles', error)
    res.status(500).json({ message: 'Unable to fetch vehicles' })
  }
})

router.post('/', authenticate, async (req, res) => {
  const uvaId = req.user.sub
  const { licensePlate, make, model, mpg, maxPassengers } = req.body

  if (!licensePlate || !make || !model || maxPassengers === undefined) {
    return res.status(400).json({
      message: 'Missing required vehicle fields: licensePlate, make, model, maxPassengers',
    })
  }

  try {
    await pool.execute(
      'INSERT INTO Car (license_plate, user_id, make, model, mpg, max_passengers) VALUES (?, ?, ?, ?, ?, ?)',
      [licensePlate, uvaId, make, model, mpg || null, maxPassengers],
    )
    res.status(201).json({
      licensePlate,
      make,
      model,
      mpg,
      maxPassengers,
    })
  } catch (error) {
    if (error.code === 'ER_DUP_ENTRY') {
      return res.status(409).json({ message: 'Vehicle with this license plate already exists' })
    }
    console.error('Failed to add vehicle', error)
    res.status(500).json({ message: 'Unable to add vehicle' })
  }
})

router.put('/:licensePlate', authenticate, async (req, res) => {
  const uvaId = req.user.sub
  const { licensePlate } = req.params
  const { make, model, mpg, maxPassengers } = req.body

  if (!make || !model || maxPassengers === undefined) {
    return res.status(400).json({
      message: 'Missing required vehicle fields: make, model, maxPassengers',
    })
  }

  try {
    const [result] = await pool.execute(
      'UPDATE Car SET make = ?, model = ?, mpg = ?, max_passengers = ? WHERE license_plate = ? AND user_id = ?',
      [make, model, mpg || null, maxPassengers, licensePlate, uvaId],
    )

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Vehicle not found' })
    }

    res.json({
      licensePlate,
      make,
      model,
      mpg,
      maxPassengers,
    })
  } catch (error) {
    console.error('Failed to update vehicle', error)
    res.status(500).json({ message: 'Unable to update vehicle' })
  }
})

router.delete('/:licensePlate', authenticate, async (req, res) => {
  const uvaId = req.user.sub
  const { licensePlate } = req.params

  try {
    const [result] = await pool.execute(
      'DELETE FROM Car WHERE license_plate = ? AND user_id = ?',
      [licensePlate, uvaId],
    )

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Vehicle not found' })
    }

    res.json({ message: 'Vehicle deleted successfully' })
  } catch (error) {
    console.error('Failed to delete vehicle', error)
    res.status(500).json({ message: 'Unable to delete vehicle' })
  }
})

module.exports = router
