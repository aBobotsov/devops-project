import { render, screen } from '@testing-library/react';
import App from './App';

test('renders input element', () => {
  render(<App />);
  const inputElement = screen.getByLabelText(/Numeric Input:/i);
  expect(inputElement).toBeInTheDocument();
});
