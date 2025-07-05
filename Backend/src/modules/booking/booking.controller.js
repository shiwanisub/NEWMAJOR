const Booking = require('./booking.model');
const { CreateBookingDTO, UpdateBookingDTO, UpdateBookingStatusDTO } = require('./booking.validator');
const User = require('../user/user.model');
const ServicePackage = require('../package/package.model');
const { UserType } = require('../../config/constants');

// Create a new booking
async function createBooking(req, res, next) {
  try {
    console.log('=== CREATE BOOKING CONTROLLER ===');
    console.log('Headers:', req.headers);
    console.log('Body:', req.body);
    console.log('User:', req.loggedInUser?.id);
    console.log('==============================');
    
    const { error, value } = CreateBookingDTO.validate(req.body);
    if (error) return res.status(400).json({ error: error.details[0].message });
    
    // Extract clientId from authenticated user
    const clientId = req.user?.id || req.loggedInUser?.id;
    
    if (!clientId) {
      console.error('No user ID found in request');
      return res.status(401).json({ error: 'User not authenticated' });
    }
    
    // Fetch the package and create a snapshot
    const packageId = value.packageId;
    const servicePackage = await ServicePackage.findByPk(packageId);
    if (!servicePackage) {
      return res.status(404).json({ error: 'Selected package not found' });
    }
    const packageSnapshot = {
      id: servicePackage.id,
      name: servicePackage.name,
      basePrice: servicePackage.basePrice,
      durationHours: servicePackage.durationHours,
      features: servicePackage.features,
      description: servicePackage.description,
      serviceType: servicePackage.serviceType,
      isActive: servicePackage.isActive,
    };
    const bookingData = {
      ...value,
      clientId: clientId,
      packageSnapshot,
    };
    console.log('Booking creation debug:');
    console.log('  clientId:', clientId);
    console.log('  serviceProviderId:', bookingData.serviceProviderId);
    console.log('  bookingData:', bookingData);
    const booking = await Booking.create(bookingData);
    console.log('Booking created successfully:', booking.id);
    return res.status(201).json(booking);
  } catch (err) {
    console.error('Error creating booking:', err);
    next(err);
  }
}

// Get all bookings (filtered by authenticated user)
async function getBookings(req, res, next) {
  try {
    console.log('=== GET BOOKINGS CONTROLLER ===');
    console.log('Headers:', req.headers);
    console.log('Authorization header:', req.headers['authorization']);
    console.log('User:', req.user);
    const user = req.user;
    const where = {};
    if (user.userType === UserType.CLIENT) {
      where.clientId = user.id;
    } else if ([
      UserType.PHOTOGRAPHER,
      UserType.MAKEUP_ARTIST,
      UserType.DECORATOR,
      UserType.VENUE,
      UserType.CATERER
    ].includes(user.userType)) {
      where.serviceProviderId = user.id;
    } else {
      return res.status(403).json({ error: 'Not authorized to view bookings' });
    }
    console.log('Bookings WHERE clause:', where);
    const bookings = await Booking.findAll({
      where,
      include: [
        { model: User, as: 'client', attributes: ['id', 'name', 'email', 'phone'] },
        { model: User, as: 'serviceProvider', attributes: ['id', 'name', 'email', 'phone'] },
        { model: ServicePackage, as: 'package', attributes: ['id', 'name', 'basePrice'] }
      ]
    });
    return res.json(bookings);
  } catch (err) {
    next(err);
  }
}

// Get a single booking by ID
async function getBookingById(req, res, next) {
  try {
    // The booking is attached to the request by the checkBookingOwnership middleware
    return res.json(req.booking);
  } catch (err) {
    next(err);
  }
}

// Update a booking
async function updateBooking(req, res, next) {
  try {
    const { error, value } = UpdateBookingDTO.validate(req.body);
    if (error) return res.status(400).json({ error: error.details[0].message });
    
    // The booking is attached to the request by the checkBookingOwnership middleware
    const booking = req.booking;
    await booking.update(value);
    return res.json(booking);
  } catch (err) {
    next(err);
  }
}

// Delete a booking
async function deleteBooking(req, res, next) {
  try {
    // The booking is attached to the request by the checkBookingOwnership middleware
    const booking = req.booking;
    await booking.destroy();
    return res.status(204).send();
  } catch (err) {
    next(err);
  }
}

// Update a booking's status
async function updateBookingStatus(req, res, next) {
  try {
    const { error, value } = UpdateBookingStatusDTO.validate(req.body);
    if (error) return res.status(400).json({ error: error.details[0].message });

    const { booking, user } = req; // from middleware
    const { status: newStatus } = value;
    const currentStatus = booking.status;
    const isClient = user.id === booking.clientId;
    const isServiceProvider = user.id === booking.serviceProviderId;

    if (currentStatus === newStatus) {
      return res.status(400).json({ message: `Booking is already in '${currentStatus}' status.` });
    }

    // Define the state machine
    const allowedTransitions = {
      pending: {
        confirmed: isServiceProvider,
        rejected: isServiceProvider,
        cancelled: isClient,
      },
      confirmed: {
        inProgress: isServiceProvider,
        cancelled: isClient || isServiceProvider,
      },
      inProgress: {
        completed: isServiceProvider,
      },
      // Final states
      completed: {},
      cancelled: {},
      rejected: {},
    };

    // Check if the transition is allowed
    const canTransition = allowedTransitions[currentStatus]?.[newStatus];

    if (canTransition) {
      booking.status = newStatus;
      await booking.save();
      return res.json(booking);
    } else {
      // If the transition is not defined, it's invalid.
      return res.status(400).json({
        message: `Cannot change status from '${currentStatus}' to '${newStatus}'. Invalid transition or insufficient permissions.`
      });
    }
  } catch (err) {
    next(err);
  }
}

module.exports = {
  createBooking,
  getBookings,
  getBookingById,
  updateBooking,
  deleteBooking,
  updateBookingStatus,
}; 