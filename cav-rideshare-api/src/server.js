require('dotenv').config()
const express = require('express')
const cors = require('cors')
const authRouter = require('./routes/auth')
const tripRouter = require('./routes/trips')
const locationRouter = require('./routes/locations')
const vehicleRouter = require('./routes/vehicles')
const reviewRouter = require('./routes/reviews')

const app = express()
const PORT = process.env.PORT || 4000

app.use(
  cors({
    origin: process.env.FRONTEND_ORIGIN?.split(',') || ['http://localhost:5173'],
    credentials: true,
  }),
)
app.use(express.json())

app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() })
})

app.use('/api/auth', authRouter)
app.use('/api/trips', tripRouter)
app.use('/api/locations', locationRouter)
app.use('/api/vehicles', vehicleRouter)
app.use('/api/reviews', reviewRouter)

app.use((_, res) => {
  res.status(404).json({ message: 'Route not found' })
})

app.listen(PORT, () => {
  console.log(`CavRideShare API listening on http://localhost:${PORT}`)
})
