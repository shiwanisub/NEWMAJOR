const Joi = require('joi');

const CreateBookingDTO = Joi.object({
  serviceProviderId: Joi.string().uuid().required(),
  packageId: Joi.string().uuid().required(),
  serviceType: Joi.string().required(),
  eventDate: Joi.date().required(),
  eventTime: Joi.string().required(),
  eventLocation: Joi.string().required(),
  eventType: Joi.string().required(),
  totalAmount: Joi.number().positive().required(),
  status: Joi.string().valid('pending', 'confirmed', 'completed', 'cancelled', 'inProgress', 'rejected').optional(),
  specialRequests: Joi.string().allow('', null).optional(),
  paymentStatus: Joi.string().valid('pending', 'paid', 'refunded', 'failed', 'partiallyPaid').optional(),
  packageSnapshot: Joi.object().optional(),
});

const UpdateBookingDTO = Joi.object({
  serviceType: Joi.string().optional(),
  eventDate: Joi.date().optional(),
  eventTime: Joi.string().optional(),
  eventLocation: Joi.string().optional(),
  eventType: Joi.string().optional(),
  totalAmount: Joi.number().positive().optional(),
  status: Joi.string().valid('pending', 'confirmed', 'completed', 'cancelled', 'inProgress', 'rejected').optional(),
  specialRequests: Joi.string().allow('', null).optional(),
  paymentStatus: Joi.string().valid('pending', 'paid', 'refunded', 'failed', 'partiallyPaid').optional(),
  packageSnapshot: Joi.object().optional(),
});

const UpdateBookingStatusDTO = Joi.object({
  status: Joi.string().valid('pending', 'confirmed', 'completed', 'cancelled', 'inProgress', 'rejected').required(),
});

module.exports = {
  CreateBookingDTO,
  UpdateBookingDTO,
  UpdateBookingStatusDTO,
}; 