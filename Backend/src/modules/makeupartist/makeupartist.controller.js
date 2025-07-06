const makeupArtistSvc = require("./makeupartist.service");
const userSvc = require("../user/user.service");
const { deleteFile, safeUserData } = require("../../utilities/helpers");
const { UserType } = require("../../config/constants");

class MakeupArtistController {
  async createMakeupArtist(req, res, next) {
    try {
      const existing = await makeupArtistSvc.getSingleRowByFilter({
        userId: req.loggedInUser.id,
      });
      if (existing) {
        if (req.file) deleteFile(req.file.path);
        throw {
          code: 409,
          status: "MAKEUPARTIST_PROFILE_EXISTS",
          message: "Makeup artist profile already exists for this user",
        };
      }
      if (req.loggedInUser.userType !== UserType.MAKEUP_ARTIST) {
        if (req.file) deleteFile(req.file.path);
        throw {
          code: 403,
          status: "INVALID_USER_TYPE",
          message: "Only makeup artists can create makeup artist profiles",
        };
      }
      const data = {
        ...req.body,
        userId: req.loggedInUser.id,
      };
      if (req.file) data.profileImage = req.file;
      const makeupArtist = await makeupArtistSvc.createMakeupArtist(data);
      const withUser = await makeupArtistSvc.getMakeupArtistWithUser(makeupArtist.id);
      res.status(201).json({
        data: withUser,
        message: "Makeup artist profile created successfully",
        status: "CREATED",
        options: null,
      });
    } catch (exception) {
      if (req.file) deleteFile(req.file.path);
      next(exception);
    }
  }

  async getMakeupArtistProfile(req, res, next) {
    try {
      const { makeupArtistId } = req.params;
      const makeupArtist = await makeupArtistSvc.getMakeupArtistWithUser(makeupArtistId);
      if (!makeupArtist) {
        throw {
          code: 404,
          status: "MAKEUPARTIST_NOT_FOUND",
          message: "Makeup artist not found",
        };
      }
      res.json({
        data: makeupArtist,
        message: "Makeup artist profile retrieved successfully",
        status: "OK",
        options: null,
      });
    } catch (exception) {
      next(exception);
    }
  }

  async getMyMakeupArtistProfile(req, res, next) {
    try {
      const makeupArtist = await makeupArtistSvc.getSingleRowByFilter({
        userId: req.loggedInUser.id,
      });
      if (!makeupArtist) {
        throw {
          code: 404,
          status: "MAKEUPARTIST_PROFILE_NOT_FOUND",
          message: "Makeup artist profile not found",
        };
      }
      const withUser = await makeupArtistSvc.getMakeupArtistWithUser(makeupArtist.id);
      res.json({
        data: withUser,
        message: "Makeup artist profile retrieved successfully",
        status: "OK",
        options: null,
      });
    } catch (exception) {
      next(exception);
    }
  }

  async updateMakeupArtistProfile(req, res, next) {
    try {
      const makeupArtist = await makeupArtistSvc.getSingleRowByFilter({
        userId: req.loggedInUser.id,
      });
      if (!makeupArtist) {
        if (req.file) deleteFile(req.file.path);
        throw {
          code: 404,
          status: "MAKEUPARTIST_PROFILE_NOT_FOUND",
          message: "Makeup artist profile not found",
        };
      }
      if (req.file) req.body.profileImage = req.file;
      const updated = await makeupArtistSvc.updateMakeupArtistProfile(
        makeupArtist.id,
        req.body
      );
      const withUser = await makeupArtistSvc.getMakeupArtistWithUser(updated.id);
      res.json({
        data: withUser,
        message: "Makeup artist profile updated successfully",
        status: "OK",
        options: null,
      });
    } catch (exception) {
      if (req.file) deleteFile(req.file.path);
      next(exception);
    }
  }

  async searchMakeupArtists(req, res, next) {
    try {
      const searchOptions = {
        page: parseInt(req.query.page) || 1,
        limit: parseInt(req.query.limit) || 10,
        search: req.query.search || "",
        specializations: req.query.specializations ? req.query.specializations.split(",") : [],
        minRating: parseFloat(req.query.minRating) || 0,
        maxPrice: req.query.maxPrice ? parseFloat(req.query.maxPrice) : null,
        minPrice: req.query.minPrice ? parseFloat(req.query.minPrice) : null,
        location: req.query.location || "",
        isAvailable: req.query.isAvailable !== undefined ? req.query.isAvailable === "true" : null,
        sortBy: req.query.sortBy || "rating",
        sortOrder: req.query.sortOrder || "DESC",
      };
      const result = await makeupArtistSvc.getAllRowsByFilter({}, searchOptions);
      res.json({
        data: result,
        message: "Makeup artists retrieved successfully",
        status: "OK",
        options: null,
      });
    } catch (exception) {
      next(exception);
    }
  }

  async getTopRatedMakeupArtists(req, res, next) {
    try {
      const limit = parseInt(req.query.limit) || 10;
      const makeupArtists = await makeupArtistSvc.getTopRatedMakeupArtists(limit);
      res.json({
        data: makeupArtists,
        message: "Top rated makeup artists retrieved successfully",
        status: "OK",
        options: null,
      });
    } catch (exception) {
      next(exception);
    }
  }

  async getAvailableMakeupArtists(req, res, next) {
    try {
      const makeupArtists = await makeupArtistSvc.getAvailableMakeupArtists();
      res.json({
        data: makeupArtists,
        message: "Available makeup artists retrieved successfully",
        status: "OK",
        options: null,
      });
    } catch (exception) {
      next(exception);
    }
  }
}

module.exports = new MakeupArtistController(); 