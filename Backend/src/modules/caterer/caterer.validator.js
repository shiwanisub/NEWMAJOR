const Joi = require("joi");

const CreateCatererDTO = Joi.object({
  businessName: Joi.string().min(2).max(255).required(),
  image: Joi.string().uri().optional(),
  description: Joi.string().max(1000).optional(),
  cuisineTypes: Joi.array().items(Joi.string()).min(1).required(),
  serviceTypes: Joi.array().items(Joi.string()).min(1).required(),
  pricePerPerson: Joi.number().positive().required(),
  minGuests: Joi.number().integer().min(1).optional(),
  maxGuests: Joi.number().integer().min(1).optional(),
  menuItems: Joi.array().items(Joi.string()).optional(),
  dietaryOptions: Joi.array().items(Joi.string()).optional(),
  offersEquipment: Joi.boolean().optional(),
  offersWaiters: Joi.boolean().optional(),
  availableDates: Joi.array().items(Joi.string()).optional(),
  experienceYears: Joi.number().integer().min(0).optional(),
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

const UpdateCatererDTO = Joi.object({
  businessName: Joi.string().min(2).max(255).optional(),
  image: Joi.string().uri().optional(),
  description: Joi.string().max(1000).optional(),
  cuisineTypes: Joi.array().items(Joi.string()).optional(),
  serviceTypes: Joi.array().items(Joi.string()).optional(),
  pricePerPerson: Joi.number().positive().optional(),
  minGuests: Joi.number().integer().min(1).optional(),
  maxGuests: Joi.number().integer().min(1).optional(),
  menuItems: Joi.array().items(Joi.string()).optional(),
  dietaryOptions: Joi.array().items(Joi.string()).optional(),
  offersEquipment: Joi.boolean().optional(),
  offersWaiters: Joi.boolean().optional(),
  availableDates: Joi.array().items(Joi.string()).optional(),
  experienceYears: Joi.number().integer().min(0).optional(),
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

const SearchCaterersDTO = Joi.object({
  search: Joi.string().optional(),
  cuisineTypes: Joi.array().items(Joi.string()).optional(),
  minRating: Joi.number().min(0).max(5).optional(),
  maxPrice: Joi.number().positive().optional(),
  minPrice: Joi.number().positive().optional(),
  location: Joi.string().optional(),
  isAvailable: Joi.boolean().optional(),
  page: Joi.number().integer().min(1).optional(),
  limit: Joi.number().integer().min(1).max(100).optional(),
  sortBy: Joi.string().valid("rating", "pricePerPerson", "createdAt", "businessName").optional(),
  sortOrder: Joi.string().valid("ASC", "DESC").optional(),
});

module.exports = {
  CreateCatererDTO,
  UpdateCatererDTO,
  SearchCaterersDTO,
}; 