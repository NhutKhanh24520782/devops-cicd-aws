const mongoose = require('mongoose');
const Item = require('../models/Item');

async function seed() {
  const mongoUri = process.env.MONGO_URI || 'mongodb://mongodb:27017/devopsdb';
  await mongoose.connect(mongoUri);

  const count = await Item.countDocuments();
  if (count === 0) {
    await Item.create([
      { name: 'Sample item', description: 'Seeded from Docker init' },
      { name: 'Portfolio task', description: 'MongoDB-backed demo' }
    ]);
  }

  console.log('Seed completed');
  await mongoose.disconnect();
}

seed().catch((error) => {
  console.error(error);
  process.exit(1);
});
