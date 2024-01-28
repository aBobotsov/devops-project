import React, { useState } from 'react';
import './App.css';

function App() {
  const [inputValue, setInputValue] = useState('');
  const [validationResult, setValidationResult] = useState('');

  const handleInputChange = (e) => {
    // Allow only numeric input
    const value = e.target.value.replace(/[^0-9]/g, '');
    setInputValue(value);
  };

  const handleValidateClick = async () => {
    try {
      // Send input to backend for validation
      const response = await fetch('http://be-service:5000/validate', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ input: inputValue }),
      });

      if (!response.ok) {
        throw new Error(`Validation failed: ${response.statusText}`);
      }

      const data = await response.json();

      // Update validation result based on backend response
      setValidationResult(data.isValid ? 'Valid' : 'Invalid');
    } catch (error) {
      console.error('Error validating input:', error);
    }
  };

  return (
    <div className="App">
      <label>
        Numeric Input:
        <input type="text" value={inputValue} onChange={handleInputChange} />
      </label>
      <button onClick={handleValidateClick}>Validate</button>
      <div>Validation Result: {validationResult}</div>
    </div>
  );
}

export default App;
