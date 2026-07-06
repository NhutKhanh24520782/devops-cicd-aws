import { useEffect, useState } from 'react';

const apiBase = import.meta.env.VITE_API_URL || 'http://localhost:5000';

function App() {
  const [items, setItems] = useState([]);
  const [name, setName] = useState('');
  const [description, setDescription] = useState('');
  const [status, setStatus] = useState('Loading...');

  const loadItems = async () => {
    try {
      const response = await fetch(`${apiBase}/api/items`);
      const data = await response.json();
      setItems(data);
      setStatus('Connected to backend');
    } catch (error) {
      setStatus('Unable to reach backend');
    }
  };

  useEffect(() => {
    loadItems();
  }, []);

  const createItem = async (event) => {
    event.preventDefault();
    try {
      await fetch(`${apiBase}/api/items`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name, description })
      });
      setName('');
      setDescription('');
      loadItems();
    } catch (error) {
      setStatus('Create failed');
    }
  };

  return (
    <div className="app">
      <h1>DevOps Portfolio Demo</h1>
      <p>{status}</p>
      <form onSubmit={createItem}>
        <input value={name} onChange={(e) => setName(e.target.value)} placeholder="Item name" required />
        <input value={description} onChange={(e) => setDescription(e.target.value)} placeholder="Description" />
        <button type="submit">Add item</button>
      </form>

      <div className="list">
        {items.map((item) => (
          <div key={item.id || item._id} className="card">
            <h3>{item.name}</h3>
            <p>{item.description}</p>
          </div>
        ))}
      </div>
    </div>
  );
}

export default App;
