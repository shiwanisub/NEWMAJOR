const Joi = require("joi");

const CreateVenueDTO = Joi.object({
  businessName: Joi.string().min(2).max(255).required(),
  image: Joi.string().uri().optional(),
  description: Joi.string().max(1000).optional(),
  capacity: Joi.number().integer().min(0).required(),
  pricePerHour: Joi.number().positive().required(),
  amenities: Joi.array().items(Joi.string()).optional(),
  images: Joi.array().items(Joi.string().uri()).optional(),
  venueTypes: Joi.array().items(Joi.string().valid('wedding', 'conference', 'party', 'exhibition', 'other')).min(1).required(),
  location: Joi.object({
    name: Joi.string().required(),
    latitude: Joi.number().min(-90).max(90).required(),
    longitude: Joi.number().min(-180).max(180).required(),
    address: Joi.string().required(),
    city: Joi.string().required(),
    state: Joi.string().optional(),
    country: Joi.string().required(),
  }).required(),
});

const UpdateVenueDTO = Joi.object({
  businessName: Joi.string().min(2).max(255).optional(),
  image: Joi.string().uri().optional(),
  description: Joi.string().max(1000).optional(),
  capacity: Joi.number().integer().min(0).optional(),
  pricePerHour: Joi.number().positive().optional(),
  amenities: Joi.array().items(Joi.string()).optional(),
  images: Joi.array().items(Joi.string().uri()).optional(),
  venueTypes: Joi.array().items(Joi.string().valid('wedding', 'conference', 'party', 'exhibition', 'other')).min(1).optional(),
  location: Joi.object({
    name: Joi.string().optional(),
    latitude: Joi.number().min(-90).max(90).optional(),
    longitude: Joi.number().min(-180).max(180).optional(),
    address: Joi.string().optional(),
    city: Joi.string().optional(),
    state: Joi.string().optional(),
    country: Joi.string().optional(),
  }).optional(),
  isAvailable: Joi.boolean().optional(),
});

const SearchVenuesDTO = Joi.object({
  search: Joi.string().optional(),
  amenities: Joi.array().items(Joi.string()).optional(),
  minRating: Joi.number().min(0).max(5).optional(),
  maxPrice: Joi.number().positive().optional(),
  minPrice: Joi.number().positive().optional(),
  location: Joi.string().optional(),
  isAvailable: Joi.boolean().optional(),
  page: Joi.number().integer().min(1).optional(),
  limit: Joi.number().integer().min(1).max(100).optional(),
  sortBy: Joi.string().valid("rating", "pricePerHour", "createdAt", "businessName").optional(),
  sortOrder: Joi.string().valid("ASC", "DESC").optional(),
});

module.exports = {
  CreateVenueDTO,
  UpdateVenueDTO,
  SearchVenuesDTO,
}; 