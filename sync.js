const { sequelize } = require('./models');

async function syncDB() {
  try {
    await sequelize.sync({ alter: true });
    console.log('Database synced successfully');
    process.exit(0);
  } catch (err) {
    console.error('Error syncing database:', err);
    process.exit(1);
  }
}

syncDB();
