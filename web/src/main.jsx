import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.jsx'

import '@mantine/core/styles.css';

import { MantineProvider } from '@mantine/core';

const isEnvBrowser = () => !window.invokeNative;
if (isEnvBrowser()) {
  const root = document.getElementById('root');

  root.style.backgroundImage = 'url("https://i.ibb.co/8g0cX1wP/3pz-Rj9n.png")';
  root.style.backgroundSize = 'cover';
  root.style.backgroundRepeat = 'no-repeat';
  root.style.backgroundPosition = 'center';
  root.style.height = '100vh';
}

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <MantineProvider defaultColorScheme="dark">
      <App />
    </MantineProvider>
  </StrictMode>,
)
