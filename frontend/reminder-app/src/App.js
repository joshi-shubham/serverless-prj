import React, { useState } from 'react';
import axios from 'axios';

function App() {
  const [formData, setFormData] = useState({
    Id: '',
    userId: '',
    TimeToLive: '',
    message: ''
  });

  const handleChange = (e) => {
    setFormData({ 
      ...formData, 
      [e.target.name]: e.target.value 
    });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    try {
      const response = await axios.post('https://wdw10qr7cj.execute-api.ca-central-1.amazonaws.com/dev/putReminder', {
        Id: Number(formData.Id),
        userId: formData.userId,
        TimeToLive: formData.TimeToLive,
        message: formData.message
      });

      alert('Record created successfully!');
      console.log(response.data);
    } catch (error) {
  alert('Error submitting form');
  console.error('Error details:', error.response?.data || error.message);
}

  };

  return (
    <div className="App">
      <h2>Create Reminder</h2>
      <form onSubmit={handleSubmit}>
        <input 
          name="Id" 
          type="number" 
          placeholder="Reminder ID" 
          value={formData.Id}
          onChange={handleChange} 
          required 
        />
        <input 
          name="userId" 
          type="text" 
          placeholder="User ID" 
          value={formData.userId}
          onChange={handleChange} 
          required 
        />
        <input 
          name="TimeToLive" 
          type="datetime-local" 
          placeholder="Expiration Time" 
          value={formData.TimeToLive}
          onChange={handleChange} 
          required 
        />
        <textarea 
          name="message" 
          placeholder="Your Message" 
          value={formData.message}
          onChange={handleChange} 
          required 
        />
        <button type="submit">Save Reminder</button>
      </form>
    </div>
  );
}

export default App;
