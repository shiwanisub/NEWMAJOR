const UserModel = require("./user.model");
const { safeUserData } = require("../../utilities/helpers");

class UserService {
  async createUser(data) {
    try {
      const user = await UserModel.create(data);
      return user;
    } catch (exception) {
      throw exception;
    }
  }

  async getSingleRowByFilter(filter) {
    try {
      const user = await UserModel.findOne({ where: filter });
      return user;
    } catch (exception) {
      throw exception;
    }
  }

  async updateSingleRowByFilter(updateData, filter) {
    try {
      const [updatedRowsCount, updatedRows] = await UserModel.update(
        updateData,
        {
          where: filter,
          returning: true,
        }
      );
      return updatedRows[0];
    } catch (exception) {
      throw exception;
    }
  }

  async getAllUsers(filter = {}, options = {}) {
    try {
      const {
        page = 1,
        limit = 10,
        orderBy = "createdAt",
        orderDirection = "DESC",
      } = options;

      const offset = (page - 1) * limit;

      const users = await UserModel.findAndCountAll({
        where: filter,
        limit: parseInt(limit),
        offset: parseInt(offset),
        order: [[orderBy, orderDirection]],
        attributes: {
          exclude: ["password", "resetToken", "emailVerificationToken"],
        },
      });

      return {
        users: users.rows,
        total: users.count,
        totalPages: Math.ceil(users.count / limit),
        currentPage: parseInt(page),
      };
    } catch (exception) {
      throw exception;
    }
  }

  async deleteUser(id) {
    try {
      const result = await UserModel.destroy({
        where: { id },
      });
      return result > 0;
    } catch (exception) {
      throw exception;
    }
  }

  getUserPublicProfile(user) {
    if (!user) return null;
    // TEMP: Include emailVerificationToken for debugging
    const publicData = safeUserData(user);
    publicData.emailVerificationToken = user.emailVerificationToken;
    return publicData;
  }

  async getUserDashboardData(userId) {
    try {
      const user = await this.getSingleRowByFilter({ id: userId });
      if (!user) return null;

      return {
        user: this.getUserPublicProfile(user),
        canAccessServiceProviderFeatures:
          user.canAccessServiceProviderFeatures(),
        userRoleDisplay: user.getUserRoleDisplayName(),
        accountStatus: {
          isActive: user.isActive,
          isEmailVerified: user.isEmailVerified,
          userStatus: user.userStatus,
        },
      };
    } catch (exception) {
      throw exception;
    }
  }
}

const userSvc = new UserService();
module.exports = userSvc;
