const express = require('express')
const pool = require('../db/pool')
const { authenticate } = require('../middleware/auth')

const router = express.Router()

router.get('/', authenticate, async (req, res) => {
  try {
    const [rows] = await pool.execute(
      'SELECT location_id, name, address, lat, lng FROM Location ORDER BY name ASC',
    )
    res.json(rows)
  } catch (error) {
    console.error('Failed to load locations', error)
    res.status(500).json({ message: 'Unable to load locations' })
  }
})

module.exports = router
