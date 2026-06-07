const { User } = require('./models');
const bcrypt = require('bcryptjs');

async function resetAdmin() {
  try {
    const hashedPassword = await bcrypt.hash('password123', 10);
    const [updated] = await User.update(
      { password: hashedPassword },
      { where: { email: 'admin@school.com' } }
    );
    
    if (updated) {
      console.log('Password for admin@school.com has been reset to: password123');
    } else {
      console.log('Admin user not found.');
    }
    process.exit(0);
  } catch (err) {
    console.error('Error resetting password:', err);
    process.exit(1);
  }
}

resetAdmin();
