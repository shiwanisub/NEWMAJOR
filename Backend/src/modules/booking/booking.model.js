const { DataTypes } = require('sequelize');
const sequelize = require('../../config/database.config');

const Booking = sequelize.define('Booking', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true,
  },
  clientId: {
    type: DataTypes.UUID,
    allowNull: false,
  },
  serviceProviderId: {
    type: DataTypes.UUID,
    allowNull: false,
  },
  packageId: {
    type: DataTypes.UUID,
    allowNull: false,
  },
  serviceType: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  eventDate: {
    type: DataTypes.DATEONLY,
    allowNull: false,
  },
  eventTime: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  eventLocation: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  eventType: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  totalAmount: {
    type: DataTypes.FLOAT,
    allowNull: false,
  },
  status: {
    type: DataTypes.ENUM('pending', 'confirmed', 'completed', 'cancelled', 'inProgress', 'rejected'),
    defaultValue: 'pending',
  },
  specialRequests: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
  paymentStatus: {
    type: DataTypes.ENUM('pending', 'paid', 'refunded', 'failed', 'partiallyPaid'),
    defaultValue: 'pending',
  },
  packageSnapshot: {
    type: DataTypes.JSONB,
    allowNull: true,
  },
}, {
  timestamps: true, // adds createdAt and updatedAt
  tableName: 'bookings',
});

// --- Associations ---
const User = require('../user/user.model');
const ServicePackage = require('../package/package.model');

Booking.belongsTo(User, { as: 'client', foreignKey: 'clientId' });
Booking.belongsTo(User, { as: 'serviceProvider', foreignKey: 'serviceProviderId' });
Booking.belongsTo(ServicePackage, { as: 'package', foreignKey: 'packageId' });

module.exports = Booking; 