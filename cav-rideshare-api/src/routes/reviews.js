const express = require('express')
const pool = require('../db/pool')
const { authenticate } = require('../middleware/auth')

const router = express.Router()

router.get('/trip/:tripId', authenticate, async (req, res) => {
  const { tripId } = req.params

  try {
    const [rows] = await pool.execute(
      `SELECT r.review_id, r.trip_id, r.comment, r.stars, ru.reviewer_id, ru.reviewee_id,
              u.fname, u.lname
       FROM Reviews r
       LEFT JOIN Review_Users ru ON r.review_id = ru.review_id
       LEFT JOIN User u ON ru.reviewee_id = u.uva_id
       WHERE r.trip_id = ?`,
      [tripId],
    )
    res.json(rows)
  } catch (error) {
    console.error('Failed to fetch reviews', error)
    res.status(500).json({ message: 'Unable to fetch reviews' })
  }
})

router.post('/', authenticate, async (req, res) => {
  const reviewerId = req.user.sub
  const { tripId, stars, comment, revieweeId } = req.body

  if (!tripId || stars === undefined || !revieweeId) {
    return res
      .status(400)
      .json({ message: 'Missing required fields: tripId, stars, revieweeId' })
  }

  if (stars < 1 || stars > 5) {
    return res.status(400).json({ message: 'Stars must be between 1 and 5' })
  }

  try {
    // Check if review already exists for this trip
    const [existing] = await pool.execute(
      `SELECT review_id FROM Review_Users 
       WHERE reviewer_id = ? AND reviewee_id = ? AND review_id IN (
         SELECT review_id FROM Reviews WHERE trip_id = ?
       )`,
      [reviewerId, revieweeId, tripId],
    )

    if (existing.length > 0) {
      return res.status(409).json({ message: 'You have already reviewed this trip' })
    }

    // Insert review
    const [result] = await pool.execute(
      'INSERT INTO Reviews (trip_id, comment, stars) VALUES (?, ?, ?)',
      [tripId, comment || null, stars],
    )

    const reviewId = result.insertId

    // Insert review users
    await pool.execute(
      'INSERT INTO Review_Users (review_id, reviewer_id, reviewee_id) VALUES (?, ?, ?)',
      [reviewId, reviewerId, revieweeId],
    )

    // Fetch driver info
    const [driverInfo] = await pool.execute(
      'SELECT fname, lname FROM User WHERE uva_id = ?',
      [revieweeId],
    )

    res.status(201).json({
      review_id: reviewId,
      trip_id: tripId,
      stars,
      comment: comment || null,
      reviewer_id: reviewerId,
      reviewee_id: revieweeId,
      fname: driverInfo[0]?.fname || null,
      lname: driverInfo[0]?.lname || null,
    })
  } catch (error) {
    console.error('Failed to create review', error)
    res.status(500).json({ message: 'Unable to create review' })
  }
})

router.put('/:reviewId', authenticate, async (req, res) => {
  const { reviewId } = req.params
  const userId = req.user.sub
  const { stars, comment } = req.body

  if (stars === undefined) {
    return res.status(400).json({ message: 'Stars is required' })
  }

  if (stars < 1 || stars > 5) {
    return res.status(400).json({ message: 'Stars must be between 1 and 5' })
  }

  try {
    // Verify user is the reviewer
    const [review] = await pool.execute(
      'SELECT reviewer_id FROM Review_Users WHERE review_id = ?',
      [reviewId],
    )

    if (review.length === 0 || review[0].reviewer_id !== userId) {
      return res.status(403).json({ message: 'You can only edit your own reviews' })
    }

    await pool.execute(
      'UPDATE Reviews SET stars = ?, comment = ? WHERE review_id = ?',
      [stars, comment || null, reviewId],
    )

    res.json({ review_id: reviewId, stars, comment: comment || null })
  } catch (error) {
    console.error('Failed to update review', error)
    res.status(500).json({ message: 'Unable to update review' })
  }
})

router.delete('/:reviewId', authenticate, async (req, res) => {
  const { reviewId } = req.params
  const userId = req.user.sub

  try {
    // Verify user is the reviewer
    const [review] = await pool.execute(
      'SELECT reviewer_id FROM Review_Users WHERE review_id = ?',
      [reviewId],
    )

    if (review.length === 0 || review[0].reviewer_id !== userId) {
      return res.status(403).json({ message: 'You can only delete your own reviews' })
    }

    await pool.execute('DELETE FROM Review_Users WHERE review_id = ?', [reviewId])
    await pool.execute('DELETE FROM Reviews WHERE review_id = ?', [reviewId])

    res.json({ message: 'Review deleted successfully' })
  } catch (error) {
    console.error('Failed to delete review', error)
    res.status(500).json({ message: 'Unable to delete review' })
  }
})

router.get('/driver/:driverId', authenticate, async (req, res) => {
  const { driverId } = req.params

  try {
    const [rows] = await pool.execute(
      `SELECT r.review_id, r.trip_id, r.comment, r.stars, ru.reviewer_id, ru.reviewee_id,
              u.fname, u.lname
       FROM Reviews r
       LEFT JOIN Review_Users ru ON r.review_id = ru.review_id
       LEFT JOIN User u ON ru.reviewer_id = u.uva_id
       WHERE ru.reviewee_id = ?
       ORDER BY r.review_id DESC`,
      [driverId],
    )
    
    // Calculate average rating
    const avgRating = rows.length > 0 ? (rows.reduce((sum, r) => sum + r.stars, 0) / rows.length).toFixed(1) : 0
    
    res.json({
      reviews: rows,
      averageRating: parseFloat(avgRating),
      totalReviews: rows.length,
    })
  } catch (error) {
    console.error('Failed to fetch driver reviews', error)
    res.status(500).json({ message: 'Unable to fetch driver reviews' })
  }
})

module.exports = router
