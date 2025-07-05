const { Sequelize } = require("sequelize");
const { DatabaseConfig } = require("./config");

const sequelize = new Sequelize(
  DatabaseConfig.database,
  DatabaseConfig.username,
  DatabaseConfig.password,
  {
    host: DatabaseConfig.host,
    port: DatabaseConfig.port,
    dialect: DatabaseConfig.dialect,
    logging: false,
    define: {
      timestamps: true,
      underscored: true,
    },
    pool: {
      max: 5,
      min: 0,
      acquire: 30000,
      idle: 10000,
    },
  }
);

module.exports = sequelize;

// Import model associations AFTER exporting sequelize to avoid circular dependency
require("./model.associations");

const initializeDatabase = async () => {
  try {
    await sequelize.authenticate();
    console.log("PostgreSQL server connected successfully.");

    // Sync models with database
    await sequelize.sync({ alter: true });
    console.log("Database synchronized successfully.");
  } catch (exception) {
    console.log("********Error establishing DB connection ********");
    console.log(exception);
    process.exit(1);
  }
};

initializeDatabase();
