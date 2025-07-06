const decoratorRouter = require("express").Router();
const decoratorCtrl = require("./decorator.controller");
const auth = require("../../middlewares/auth.middleware");
const bodyValidator = require("../../middlewares/validator.middleware");
const uploader = require("../../middlewares/uploader.middleware");
const { UserType } = require("../../config/constants");
const {
  CreateDecoratorDTO,
  UpdateDecoratorDTO,
  SearchDecoratorsDTO,
} = require("./decorator.validator");

// Public routes
decoratorRouter.get("/search", bodyValidator(SearchDecoratorsDTO, "query"), decoratorCtrl.searchDecorators);
decoratorRouter.get("/top-rated", decoratorCtrl.getTopRatedDecorators);
decoratorRouter.get("/available", decoratorCtrl.getAvailableDecorators);
decoratorRouter.get("/:decoratorId", decoratorCtrl.getDecoratorProfile);

// Protected routes - Decorator only
decoratorRouter.post(
  "/profile",
  auth([UserType.DECORATOR]),
  uploader.single("profileImage"),
  bodyValidator(CreateDecoratorDTO),
  decoratorCtrl.createDecorator
);

decoratorRouter.get(
  "/profile/me",
  auth([UserType.DECORATOR]),
  decoratorCtrl.getMyDecoratorProfile
);

decoratorRouter.put(
  "/profile",
  auth([UserType.DECORATOR]),
  uploader.single("profileImage"),
  bodyValidator(UpdateDecoratorDTO),
  decoratorCtrl.updateDecoratorProfile
);

module.exports = decoratorRouter; 