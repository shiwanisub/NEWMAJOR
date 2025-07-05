const Joi = require("joi");

const CreateMakeupArtistDTO = Joi.object({
  businessName: Joi.string().min(2).max(255).required(),
  description: Joi.string().max(1000).optional(),
  specializations: Joi.array().items(Joi.string()).min(1).required(),
  brands: Joi.array().items(Joi.string()).optional(),
  sessionRate: Joi.number().positive().required(),
  bridalPackageRate: Joi.number().positive().required(),
  portfolio: Joi.array().items(Joi.string().uri()).optional(),
  experienceYears: Joi.number().integer().min(0).optional(),
  offersHairServices: Joi.boolean().optional(),
  travelsToClient: Joi.boolean().optional(),
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

const UpdateMakeupArtistDTO = Joi.object({
  businessName: Joi.string().min(2).max(255).optional(),
  description: Joi.string().max(1000).optional(),
  specializations: Joi.array().items(Joi.string()).optional(),
  brands: Joi.array().items(Joi.string()).optional(),
  sessionRate: Joi.number().positive().optional(),
  bridalPackageRate: Joi.number().positive().optional(),
  portfolio: Joi.array().items(Joi.string().uri()).optional(),
  experienceYears: Joi.number().integer().min(0).optional(),
  offersHairServices: Joi.boolean().optional(),
  travelsToClient: Joi.boolean().optional(),
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

const UpdateAvailabilityDTO = Joi.object({
  isAvailable: Joi.boolean().required(),
});

const AddPortfolioImageDTO = Joi.object({
  imageUrl: Joi.string().uri().optional(),
}).or('imageUrl').messages({
  'object.missing': 'Either imageUrl or portfolioImage file is required',
});

const RemovePortfolioImageDTO = Joi.object({
  imageUrl: Joi.string().uri().required(),
});

const SearchMakeupArtistsDTO = Joi.object({
  search: Joi.string().optional(),
  specializations: Joi.array().items(Joi.string()).optional(),
  minRating: Joi.number().min(0).max(5).optional(),
  maxPrice: Joi.number().positive().optional(),
  minPrice: Joi.number().positive().optional(),
  location: Joi.string().optional(),
  isAvailable: Joi.boolean().optional(),
  page: Joi.number().integer().min(1).optional(),
  limit: Joi.number().integer().min(1).max(100).optional(),
  sortBy: Joi.string().valid("rating", "sessionRate", "createdAt", "businessName").optional(),
  sortOrder: Joi.string().valid("ASC", "DESC").optional(),
});

module.exports = {
  CreateMakeupArtistDTO,
  UpdateMakeupArtistDTO,
  UpdateAvailabilityDTO,
  AddPortfolioImageDTO,
  RemovePortfolioImageDTO,
  SearchMakeupArtistsDTO,
}; 