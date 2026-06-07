const { SystemSetting } = require('./models');

async function seedSettings() {
  try {
    await SystemSetting.findOrCreate({
      where: { key: 'marquee_message' },
      defaults: { value: 'Chào mừng bạn đến với OpenClass! Hiện tại hệ thống đang có các khóa học về: Toán học, Tin học, Vật lý... Chúc bạn có những giờ học bổ ích!' }
    });
    console.log('Settings seeded successfully');
    process.exit(0);
  } catch (err) {
    console.error('Error seeding settings:', err);
    process.exit(1);
  }
}

seedSettings();
