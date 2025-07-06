const venueRouter = require("express").Router();
const venueCtrl = require("./venue.controller");
const auth = require("../../middlewares/auth.middleware");
const bodyValidator = require("../../middlewares/validator.middleware");
const uploader = require("../../middlewares/uploader.middleware");
const { UserType } = require("../../config/constants");
const {
  CreateVenueDTO,
  UpdateVenueDTO,
  SearchVenuesDTO,
} = require("./venue.validator");

// Public routes
venueRouter.get("/search", bodyValidator(SearchVenuesDTO, "query"), venueCtrl.searchVenues);
venueRouter.get("/top-rated", venueCtrl.getTopRatedVenues);
venueRouter.get("/available", venueCtrl.getAvailableVenues);
venueRouter.get("/:venueId", venueCtrl.getVenueProfile);

// Protected routes - Venue only
venueRouter.post(
  "/profile",
  auth([UserType.VENUE]),
  uploader.single("image"),
  bodyValidator(CreateVenueDTO),
  venueCtrl.createVenue
);

venueRouter.get(
  "/profile/me",
  auth([UserType.VENUE]),
  venueCtrl.getMyVenueProfile
);

venueRouter.put(
  "/profile",
  auth([UserType.VENUE]),
  uploader.single("image"),
  bodyValidator(UpdateVenueDTO),
  venueCtrl.updateVenueProfile
);

module.exports = venueRouter; 