const { User } = require('./models');
const bcrypt = require('bcryptjs');

async function resetAllDemoUsers() {
  try {
    const hashedPassword = await bcrypt.hash('password123', 10);
    const emails = ['admin@school.com', 'teacher@school.com', 'student@school.com'];
    
    for (const email of emails) {
      const [updated] = await User.update(
        { password: hashedPassword },
        { where: { email } }
      );
      if (updated) {
        console.log(`Password for ${email} has been reset to: password123`);
      } else {
        console.log(`User ${email} not found.`);
      }
    }
    
    process.exit(0);
  } catch (err) {
    console.error('Error resetting passwords:', err);
    process.exit(1);
  }
}

resetAllDemoUsers();
