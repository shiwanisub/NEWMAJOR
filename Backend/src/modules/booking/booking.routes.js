console.log('Booking router loaded');
const express = require('express');
const router = express.Router();
const bookingController = require('./booking.controller');
const { requireClient, requireUserType } = require('../../middlewares/auth.middleware');
const { checkBookingOwnership } = require('./booking.middleware');
const { UserType } = require('../../config/constants');

// Add logging middleware for booking routes
router.use((req, res, next) => {
  console.log('=== BOOKING ROUTES ===');
  console.log('Method:', req.method);
  console.log('URL:', req.url);
  console.log('Path:', req.path);
  console.log('Headers:', req.headers);
  console.log('=====================');
  next();
});

const ALL_RELEVANT_USER_TYPES = [
  UserType.CLIENT,
  UserType.PHOTOGRAPHER,
  UserType.MAKEUP_ARTIST,
  UserType.DECORATOR,
  UserType.VENUE,
  UserType.CATERER
];

// Allow relevant users to view their list of bookings
router.get('/', requireUserType(...ALL_RELEVANT_USER_TYPES), bookingController.getBookings);

// Routes for specific booking require ownership check
router.get(
  '/:id',
  requireUserType(...ALL_RELEVANT_USER_TYPES),
  checkBookingOwnership,
  bookingController.getBookingById
);

// POST booking: only clients can create
router.post('/', requireClient(), bookingController.createBooking);

// PUT and DELETE: requires ownership
router.put(
  '/:id',
  requireUserType(...ALL_RELEVANT_USER_TYPES),
  checkBookingOwnership,
  bookingController.updateBooking
);

router.delete(
  '/:id',
  requireUserType(...ALL_RELEVANT_USER_TYPES),
  checkBookingOwnership,
  bookingController.deleteBooking
);

// Update booking status: requires ownership
router.patch(
  '/:id/status',
  requireUserType(...ALL_RELEVANT_USER_TYPES),
  checkBookingOwnership,
  bookingController.updateBookingStatus
);

module.exports = router; 