const bcrypt = require('bcryptjs');
const { sequelize, User, Role } = require('./models');
require('dotenv').config();

const seedUsers = async () => {
  try {
    // Connect to database
    await sequelize.authenticate();
    console.log('Database connected successfully.');

    // Ensure roles exist
    const roles = ['admin', 'teacher', 'student'];
    const roleRecords = {};
    for (const roleName of roles) {
      const [role] = await Role.findOrCreate({ where: { name: roleName } });
      roleRecords[roleName] = role.id;
    }
    console.log('Roles verified.');

    // Hash a common password
    const password = 'password123';
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Define users to seed
    const usersData = [
      {
        name: 'System Admin',
        email: 'admin@school.com',
        password: hashedPassword,
        role_id: roleRecords['admin'],
        teacher_status: null
      },
      {
        name: 'Teacher John',
        email: 'teacher@school.com',
        password: hashedPassword,
        role_id: roleRecords['teacher'],
        teacher_status: 'approved' // Approve the teacher so they can create classes
      },
      {
        name: 'Student Alice',
        email: 'student1@school.com',
        password: hashedPassword,
        role_id: roleRecords['student'],
        teacher_status: null
      },
      {
        name: 'Student Bob',
        email: 'student2@school.com',
        password: hashedPassword,
        role_id: roleRecords['student'],
        teacher_status: null
      }
    ];

    // Insert users
    for (const userData of usersData) {
      const [user, created] = await User.findOrCreate({
        where: { email: userData.email },
        defaults: userData
      });
      if (created) {
        console.log(`Created user: ${user.email} (${roles.find(r => roleRecords[r] === user.role_id)})`);
      } else {
        console.log(`User already exists: ${user.email}`);
      }
    }

    console.log('Seeding completed successfully.');
    process.exit(0);
  } catch (error) {
    console.error('Seeding failed:', error);
    process.exit(1);
  }
};

seedUsers();
