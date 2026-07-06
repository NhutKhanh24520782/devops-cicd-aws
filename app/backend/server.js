const express = require('express');
const cors = require('cors');
const { connectDatabase } = require('./config/database');
const Item = require('./models/Item');

const app = express();
const port = process.env.PORT || 8080;

app.use(cors());
app.use(express.json());

let dbConnected = false;

async function initializeApp() {
  dbConnected = await connectDatabase();

  if (!dbConnected) {
    console.error('Database connection failed. Server will stay running but CRUD will be unavailable.');
  }

  app.listen(port, () => {
    console.log(`Backend listening on port ${port}`);
  });
}

app.get('/health', (req, res) => {
  res.json({ status: 'ok', message: 'Backend is running', db: dbConnected ? 'mongo' : 'disconnected' });
});

app.get('/api/items', async (req, res) => {
  if (!dbConnected) {
    return res.status(503).json({ error: 'Database not connected' });
  }

  const items = await Item.find({}).sort({ createdAt: -1 });
  res.json(items);
});

app.post('/api/items', async (req, res) => {
  const { name, description } = req.body;

  if (!name) {
    return res.status(400).json({ error: 'Name is required' });
  }

  if (!dbConnected) {
    return res.status(503).json({ error: 'Database not connected' });
  }

  const item = await Item.create({ name, description });
  return res.status(201).json(item);
});

app.put('/api/items/:id', async (req, res) => {
  const { name, description } = req.body;

  if (!dbConnected) {
    return res.status(503).json({ error: 'Database not connected' });
  }

  const updated = await Item.findByIdAndUpdate(req.params.id, { name, description }, { new: true });
  if (!updated) return res.status(404).json({ error: 'Item not found' });
  return res.json(updated);
});

app.delete('/api/items/:id', async (req, res) => {
  if (!dbConnected) {
    return res.status(503).json({ error: 'Database not connected' });
  }

  const deleted = await Item.findByIdAndDelete(req.params.id);
  if (!deleted) return res.status(404).json({ error: 'Item not found' });
  return res.status(204).send();
});

initializeApp();
