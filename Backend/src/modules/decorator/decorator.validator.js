const Joi = require("joi");

const CreateDecoratorDTO = Joi.object({
  businessName: Joi.string().min(2).max(255).required(),
  image: Joi.string().uri().optional(),
  description: Joi.string().max(1000).optional(),
  specializations: Joi.array().items(Joi.string()).min(1).required(),
  themes: Joi.array().items(Joi.string()).optional(),
  packageStartingPrice: Joi.number().positive().required(),
  hourlyRate: Joi.number().positive().required(),
  portfolio: Joi.array().items(Joi.string().uri()).optional(),
  experienceYears: Joi.number().integer().min(0).optional(),
  offersFlowerArrangements: Joi.boolean().optional(),
  offersLighting: Joi.boolean().optional(),
  offersRentals: Joi.boolean().optional(),
  availableItems: Joi.array().items(Joi.string()).optional(),
  availableDates: Joi.array().items(Joi.string()).optional(),
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

const UpdateDecoratorDTO = Joi.object({
  businessName: Joi.string().min(2).max(255).optional(),
  image: Joi.string().uri().optional(),
  description: Joi.string().max(1000).optional(),
  specializations: Joi.array().items(Joi.string()).optional(),
  themes: Joi.array().items(Joi.string()).optional(),
  packageStartingPrice: Joi.number().positive().optional(),
  hourlyRate: Joi.number().positive().optional(),
  portfolio: Joi.array().items(Joi.string().uri()).optional(),
  experienceYears: Joi.number().integer().min(0).optional(),
  offersFlowerArrangements: Joi.boolean().optional(),
  offersLighting: Joi.boolean().optional(),
  offersRentals: Joi.boolean().optional(),
  availableItems: Joi.array().items(Joi.string()).optional(),
  availableDates: Joi.array().items(Joi.string()).optional(),
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

const SearchDecoratorsDTO = Joi.object({
  search: Joi.string().optional(),
  specializations: Joi.array().items(Joi.string()).optional(),
  minRating: Joi.number().min(0).max(5).optional(),
  maxPrice: Joi.number().positive().optional(),
  minPrice: Joi.number().positive().optional(),
  location: Joi.string().optional(),
  isAvailable: Joi.boolean().optional(),
  page: Joi.number().integer().min(1).optional(),
  limit: Joi.number().integer().min(1).max(100).optional(),
  sortBy: Joi.string().valid("rating", "packageStartingPrice", "createdAt", "businessName").optional(),
  sortOrder: Joi.string().valid("ASC", "DESC").optional(),
});

module.exports = {
  CreateDecoratorDTO,
  UpdateDecoratorDTO,
  SearchDecoratorsDTO,
}; 