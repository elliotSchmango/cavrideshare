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

// CORS configuration - supports multiple origins for development and production
const getAllowedOrigins = () => {
  const origins = []
  
  // Add localhost for local development
  if (process.env.NODE_ENV !== 'production') {
    origins.push('http://localhost:5173')
  }
  
  // Add origins from environment variable (comma-separated)
  if (process.env.FRONTEND_ORIGIN) {
    const envOrigins = process.env.FRONTEND_ORIGIN.split(',').map(origin => origin.trim()).filter(Boolean)
    origins.push(...envOrigins)
  }
  
  return origins.length > 0 ? origins : ['http://localhost:5173']
}

app.use(
  cors({
    origin: (origin, callback) => {
      try {
        // Allow requests with no origin (like mobile apps or curl requests)
        if (!origin) {
          return callback(null, true)
        }
        
        const allowedOrigins = getAllowedOrigins()
        
        // Check if the origin is in the allowed list
        if (allowedOrigins.includes(origin)) {
          return callback(null, true)
        }
        
        // In production, if FRONTEND_ORIGIN is not set, allow Vercel domains as fallback
        // This is a temporary workaround - you should set FRONTEND_ORIGIN properly
        if (!process.env.FRONTEND_ORIGIN) {
          if (origin.includes('.vercel.app') || origin.includes('.vercel.sh')) {
            console.warn(`⚠️  Allowing Vercel origin ${origin} - set FRONTEND_ORIGIN for better security`)
            return callback(null, true)
          }
        }
        
        // Reject the request
        callback(null, false)
      } catch (error) {
        console.error('CORS error:', error)
        callback(null, false)
      }
    },
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization'],
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
