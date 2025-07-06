const decoratorSvc = require("./decorator.service");
const userSvc = require("../user/user.service");
const { deleteFile, safeUserData } = require("../../utilities/helpers");
const { UserType } = require("../../config/constants");

class DecoratorController {
  async createDecorator(req, res, next) {
    try {
      const existing = await decoratorSvc.getSingleRowByFilter({
        userId: req.loggedInUser.id,
      });
      if (existing) {
        if (req.file) deleteFile(req.file.path);
        throw {
          code: 409,
          status: "DECORATOR_PROFILE_EXISTS",
          message: "Decorator profile already exists for this user",
        };
      }
      if (req.loggedInUser.userType !== UserType.DECORATOR) {
        if (req.file) deleteFile(req.file.path);
        throw {
          code: 403,
          status: "INVALID_USER_TYPE",
          message: "Only decorators can create decorator profiles",
        };
      }
      const data = {
        ...req.body,
        userId: req.loggedInUser.id,
      };
      if (req.file) data.profileImage = req.file;
      const decorator = await decoratorSvc.createDecorator(data);
      const withUser = await decoratorSvc.getDecoratorWithUser(decorator.id);
      res.status(201).json({
        data: withUser,
        message: "Decorator profile created successfully",
        status: "CREATED",
        options: null,
      });
    } catch (exception) {
      if (req.file) deleteFile(req.file.path);
      next(exception);
    }
  }

  async getDecoratorProfile(req, res, next) {
    try {
      const { decoratorId } = req.params;
      const decorator = await decoratorSvc.getDecoratorWithUser(decoratorId);
      if (!decorator) {
        throw {
          code: 404,
          status: "DECORATOR_NOT_FOUND",
          message: "Decorator not found",
        };
      }
      res.json({
        data: decorator,
        message: "Decorator profile retrieved successfully",
        status: "OK",
        options: null,
      });
    } catch (exception) {
      next(exception);
    }
  }

  async getMyDecoratorProfile(req, res, next) {
    try {
      const decorator = await decoratorSvc.getSingleRowByFilter({
        userId: req.loggedInUser.id,
      });
      if (!decorator) {
        throw {
          code: 404,
          status: "DECORATOR_PROFILE_NOT_FOUND",
          message: "Decorator profile not found",
        };
      }
      const withUser = await decoratorSvc.getDecoratorWithUser(decorator.id);
      res.json({
        data: withUser,
        message: "Decorator profile retrieved successfully",
        status: "OK",
        options: null,
      });
    } catch (exception) {
      next(exception);
    }
  }

  async updateDecoratorProfile(req, res, next) {
    try {
      const decorator = await decoratorSvc.getSingleRowByFilter({
        userId: req.loggedInUser.id,
      });
      if (!decorator) {
        if (req.file) deleteFile(req.file.path);
        throw {
          code: 404,
          status: "DECORATOR_PROFILE_NOT_FOUND",
          message: "Decorator profile not found",
        };
      }
      if (req.file) req.body.profileImage = req.file;
      const updated = await decoratorSvc.updateDecoratorProfile(
        decorator.id,
        req.body
      );
      const withUser = await decoratorSvc.getDecoratorWithUser(updated.id);
      res.json({
        data: withUser,
        message: "Decorator profile updated successfully",
        status: "OK",
        options: null,
      });
    } catch (exception) {
      if (req.file) deleteFile(req.file.path);
      next(exception);
    }
  }

  async searchDecorators(req, res, next) {
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
      const result = await decoratorSvc.getAllRowsByFilter({}, searchOptions);
      res.json({
        data: result,
        message: "Decorators retrieved successfully",
        status: "OK",
        options: null,
      });
    } catch (exception) {
      next(exception);
    }
  }

  async getTopRatedDecorators(req, res, next) {
    try {
      const limit = parseInt(req.query.limit) || 10;
      const decorators = await decoratorSvc.getTopRatedDecorators(limit);
      res.json({
        data: decorators,
        message: "Top rated decorators retrieved successfully",
        status: "OK",
        options: null,
      });
    } catch (exception) {
      next(exception);
    }
  }

  async getAvailableDecorators(req, res, next) {
    try {
      const decorators = await decoratorSvc.getAvailableDecorators();
      res.json({
        data: decorators,
        message: "Available decorators retrieved successfully",
        status: "OK",
        options: null,
      });
    } catch (exception) {
      next(exception);
    }
  }
}

module.exports = new DecoratorController(); 